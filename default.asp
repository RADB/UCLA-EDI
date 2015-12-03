<!-- #include file="shared/dbase.asp" -->
<!-- #include file="shared/browser_check.asp" -->
<!-- #include file="shared/configuration.asp" -->
<%
on error resume next
'-----------------------
' check values will only check if they have already been here
'-----------------------
' 0 - first time to page
' 1 - incorrect password
' 2 - username not found
' 3 - correct

'-----------------------
' will not be available if they just got to the page
if ( Request.form("check").count > 0 ) then 
	strEmail = Request.form("email")
	strPass = Request.form("password")
	strLanguage = Request.Cookies("UCLAEDI")("Language")
	if strLanguage = "" then 
		strLanguage = "English"
	end if
				
	call open_adodb(conn,"UCLAEDI")
    
    '************************************************************
	' Load the config data	
	'************************************************************
	set rstConfig = server.CreateObject ("adodb.recordset")	
	strQuery = "SELECT * FROM [system_configuration]"  
	rstConfig.Open strQuery, conn
	if conn.errors.count <> 0 then 						
		strError = "<font class=""regTextRed"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & strSql & "<br/><br/></font>"
		response.write strError
	end if 
	
	session("config_smtpServer") = rstConfig("SMTPServer")
	session("config_FromAddress") = rstConfig("FromAddress")
	session("config_EDIYear") = rstConfig("EDIYear")
	session("config_PasswordExpiryDays") = rstConfig("PasswordExpiryDays")	
    call close_adodb(rstConfig)
    
    EDIYear = session("config_EDIYear")
	'************************************************************
	' End Loading the config data	
	'************************************************************

	set rstUser = server.CreateObject ("adodb.recordset")	
	'strQuery = "SELECT personID,teacherID, Email, dbo.Decrypt('" & encrytionkey & "',Password) as Password,LastPasswordChangedDate, consentGiven,consentDate, FirstName,LastName FROM [teacher] WHERE EDIYear = " & EDIYear & " AND Email='" & strEmail & "'" 
	'strQuery = "SELECT t.personID,t.teacherID, p.Email, dbo.Decrypt('" & encrytionkey & "',p.Password) as Password,p.LastPasswordChangedDate, t.consentGiven,t.consentDate, p.FirstName,p.LastName FROM Person p LEFT JOIN Teacher t ON p.personID = t.personID WHERE t.EDIYear = " & EDIYear & " AND p.Email='" & replace(strEmail,"'","''") & "'" 
	strQuery = "SELECT t.personID,t.teacherID, p.Email, dbo.Decrypt(p.passwordsalt,p.Password) as Password,p.LastPasswordChangedDate, t.consentGiven,t.consentDate, p.FirstName,p.LastName, p.isactive FROM Person p LEFT JOIN Teacher t ON p.personID = t.personID WHERE t.EDIYear = " & EDIYear & " AND p.Email='" & replace(strEmail,"'","''") & "'" 
	'response.write strQuery
	rstUser.Open strQuery, conn		
				
	if rstUser.bof and rstUser.eof then 
		' if username is not found 
		call close_adodb(rstUser)
		intCheck = 2	
	else				
		strEmail = rstUser("Email")
		
		' correct email and password
		if  strPass = rstUser("Password") then	
			' account not active
			if not rstuser("isActive") then 
				' not active
				intCheck = 4
				call close_adodb(rstUser)
			else
				intCheck = 3
			
				session("user") = true
				session("id") = strEmail
				session("TeacherID") = rstUser("teacherID")
				session("browser") = intVersion
				session("language") = Request.Form("Language")
				session("consent") = rstUser("consentGiven")
				session("consentDate") = rstUser("consentDate")
				session("name") = rstUser("FirstName")& " " & rstUser("LastName")
				session("LastPwdChange") = rstUser("LastPasswordChangedDate")
				session("Password") = "False"
				session("PersonID") = rstUser("PersonID")
				
				set rstDistrict = server.CreateObject("adodb.recordset")
					' check the district ID of the teacher
					rstDistrict = conn.execute("GetPersonDistrictID  " & session("personID") & "," & EDIYear)	
					session("districtID") = rstDistrict(0)
				call close_adodb(rstDistrict)
										
				if Request.Form("saveCookie") = "on" then 
					Response.Cookies("UCLAEDI")("Language") = Request.Form("Language")
					Response.Cookies("UCLAEDI")("Email") = Request.Form("Email")
					Response.Cookies("UCLAEDI")("SaveSettings") = Request.Form("saveCookie")
					Response.Cookies("UCLAEDI").path = "/"
					Response.Cookies("UCLAEDI").expires = dateadd("m",1,now())
				else
					' expires the cookie immediately
					Response.Cookies("UCLAEDI").expires = dateadd("d",-1,now())
				end if												
			end if 
		else
			' incorrect password
			intCheck = 1			
		end if 				
		' close and kill the recordset and connection object
		call close_adodb(rstUser)	
	end if	
    
    ' audit the login attempt
	select case intCheck
	    case 1 ' incorrect pwd
	        strSql = "INSERT INTO [dbo].[AuditLogin] ([EDIYear],[SessionID],[Email],[LoginCode]) VALUES(" & EDIYear & ",'" & session.SessionID & "','" & replace(strEmail,"'","''") & "'," & intCheck & ")"
	    case 2 ' incorrect email 
	        strSql = "INSERT INTO [dbo].[AuditLogin] ([EDIYear],[SessionID],[Email],[LoginCode]) VALUES(" & EDIYear & ",'" & session.SessionID & "','" & replace(strEmail,"'","''") & "'," & intCheck & ")"
	    case 3 ' successful
            strSql = "INSERT INTO [dbo].[AuditLogin] ([EDIYear],[SessionID],[Email],[LoginCode]) VALUES(" & EDIYear & ",'" & session.SessionID & "','" & replace(strEmail,"'","''") & "'," & intCheck & ")"
		case 4 ' not active
			strSql = "INSERT INTO [dbo].[AuditLogin] ([EDIYear],[SessionID],[Email],[LoginCode]) VALUES(" & EDIYear & ",'" & session.SessionID & "','" & replace(strEmail,"'","''") & "'," & intCheck & ")"
	end select 
    'response.write strSql
	conn.execute strSql
	call close_adodb(conn)
	
	if intCheck = 3 then        
        if session("consent") = True then
            if isnull(session("LastPwdChange")) then 
                Server.transfer ("teacher_passwordchange.asp")
            elseif session("LastPwdChange") + session("config_PasswordExpiryDays") < now then 
                ' transfer to pwd change
                'response.write session("LastPwdChange") + session("config_PasswordExpiryDays")
                Server.transfer ("teacher_passwordchange.asp")
            else 
                session("Password") = "True"    
                response.redirect("teacher.asp")
            end if             
        else 
            Server.transfer ("teacher_consent.asp")
        end if
    end if	
else
	' log the user out 
	if Request.QueryString("status") = "logout" then 
		' kill the session
		session.Abandon 
	end if 
	
	intCheck = 0
	' gets language from cookie
	strLanguage = Request.Cookies("UCLAEDI")("Language")
	' sets default to english
	if strLanguage = "" then 
		strLanguage = "English"
	end if
	
	if request.querystring("email").count > 0 then 
	    strEmail = Request.querystring("Email")
	else
	    ' gets email from cookie    
	    strEmail = Request.Cookies("UCLAEDI")("Email")
	end if
	
	strSave = Request.Cookies("UCLAEDI")("SaveSettings") 
	if strSave = "" then 
		strSave = "on"
	end if 
end if 
%>	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 	
<html>
	<!-- #include file="shared/head.asp" -->	
	<body
	<% 
		if intVersion = 0 then 
			if strEmail <> "" then 
				Response.Write " onload=""javascript:checkFocus(2);"""
			else
				Response.Write " onload=""javascript:checkFocus(1);"""
			end if 
		end if  
	%>
	>
	<form name="login" method="post" action="default.asp" onsubmit="javascript:return checkForm();">
		<input type="hidden" name="check" value="0">
		<input type="hidden" id="language" name="language" value="English" />
		<table width="760"  cellpadding="0" cellspacing="0">
		<tr>
			<td align="left" width="520">
			    <table width="520">
			        <tr>
			            <td rowspan="2">
			                <font class="UCLAHeader">US e-EDI</font>
			            </td>
			            <td>			                
			                <font class="UCLAHeader2">EARLY DEVELOPMENT INSTRUMENT</font>			            
			            </td>
			        </tr>
			        <tr>
			            <td>			                
			                <font class="UCLASubHeader">A Population Based Measure for Communities</font>			            
			            </td>
			        </tr>
			    </table>			
				<!--<a href="http://www.ucla.edu"><img src="images/US EDI Logo.png" border="0" alt="US e-EDI" name="US EDI Logo" width="550" /></a>-->
			</td>
			<td align="right">
			    <table width="200" class="tableBorder" cellpadding="1" cellspacing="1">
				<%
				'-----------------------
				' check values 
				'-----------------------
				' 0 - first time to page - will not enter here
				' 1 - incorrect password
				' 2 - username not found
				' 3 - correct - already redirected
				' 4 - inactive account
				'-----------------------
				if ( Request.form("check").count > 0 ) then 
					Response.Write "<script language=""javascript"">"
					Response.Write "document.login.check.value =" & intCheck & ";"
					Response.Write "</script>"
					
					Response.Write "<tr><td colspan=""3"" align=""center"">"
					select case intCheck
						case 1
							Response.Write "<font class=""boldtextred"">Incorrect password... </font>&nbsp;<a class=""regLinkRed"" onMouseOver=""javascript:window.status='Email my forgotten password to " & replace(strEmail,"'","\'") & ".'; return true;"" onMouseOut=""javascript:window.status=''; return true;"" href=""javascript:window.location='teacher_mailPwd.asp?email=" & replace(strEmail,"'","\'") & "';"">Click Here</a><font class=""boldtextred"">&nbsp;if you forget your password</font><br /><br />"
						case 2
							Response.Write "<font class=""boldtextred"">Email not found... Please double check your email address.</font><br /><br />"						
						case 4
							Response.Write "<font class=""boldTextRed"">This account is not currently active.</font><br /><br />"						
					end select
					Response.Write "</td></tr>"
				end if 
				%>
				<tr valign="top">
					<td width="100" align="right" nowrap> 
						<font class="smallTextBlack">Email :&nbsp;&nbsp;</font>
					</td>
					<td width="175" align="right">
						<input type="text" title="Email address" name="email" value="<%=strEmail%>" size="20" class="smallTextGray">						
					</td>			
				</tr>
				<tr>
				    <td width="100" align="right">
						<font class="smallTextBlack">Password :&nbsp;&nbsp;</font>
					</td>
					<td width="175" align="right">
						<input type="password" name="password" value="" size="20" class="smallTextGray">												
					</td>
				</tr>
				<tr>
					<td colspan="2" align="right">					    
						<INPUT type="checkbox" id="savecookie" name="savecookie" checked>
						<font class="smallTextBlack">Save my settings</font>
						<input type="submit" name="Login" value="Login" class="smallTextBlack">                        
					</td>					
				</tr>
				</table>
			</td>			
		</tr>
		</table>

		<br />

		<table width="760" border="0" cellpadding="0" cellspacing="0" class="tableBorder">		
		<tr>
		    <td width="760" colspan="2" align="center">
			    <a href="http://www.ucla.edu"><img src="images/TECCS Logo.jpg" border="0" alt="TECCS" name="TECCS Logo" width="360" /></a>
			</td>
		</tr>
		<tr>
		    <td width="380" align="center"><a href="http://www.healthychild.ucla.edu"><img src="images/CHCFC Logo.jpg" border="0" alt="CHCFC" name="CHCFC Logo" width="90" /></a></td>
		    <td width="380" align="center"><a href="http://www.ucla.edu"><img src="images/EDI Logo.jpg" border="0" alt="EDI" name="EDI Logo" width="90" /></a></td>		    
		</tr>
		</table>
		<br />
        <!-- #include file="shared/page_footer.asp" -->
        <!--<table  width="760" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center">
              <font class="smallTextGray">The UCLA Center for Healthier Children, Families and Communities, under license from McMaster University, is implementing the Early Development Instrument with its sub licensees in the US.  The EDI is the copyright of McMaster University and must not be copied, distributed or used in any way without the prior consent of UCLA or McMaster</font>
              <br />
              <font class="smallTextGray">For questions regarding licensing, email: <a href="mailto:USEDI@mednet.ucla.edu" class="smalllinkMaroon">USEDI@mednet.ucla.edu</a></font>      
              <br />     
              <font class="smallTextGray">&copy; McMaster University, The Offord Centre for Child Studies</font>
              <font class="regTextMaroon">The EDI has been provided under license from McMaster University and must not be copied, distributed or used in any way without the prior written consent of McMaster University. Contact the Offord Center for Child Studies for licensing details, email: <a href="mailto:walshci@mcmaster.ca" class="reglinkMaroon">walshci@mcmaster.ca</a></font>
            </td>
          </tr>
        </table>-->
		
	</form>
	</body>
</html>


<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/configuration.asp" -->
<%
' if the user has not logged in they will not be able to see the page
if blnSecurity then
    if session("consent") = True then
        if session("Password") = "False" then 
            if isnull(session("LastPwdChange")) then 
                Server.transfer ("teacher_passwordchange.asp")
            elseif session("LastPwdChange") + session("config_PasswordExpiryDays") < now then 
                ' transfer to pwd change
                'response.write session("LastPwdChange") + session("config_PasswordExpiryDays")
                Server.transfer ("teacher_passwordchange.asp")
            else 
                session("Password") = "True"                    
            end if             
        end if 
    else 
        Server.transfer ("teacher_consent.asp")
    end if

	' open edi connection
	call open_adodb(conn, "UCLAEDI")
	set rstEmail = server.CreateObject("adodb.recordset")
	
	' get the change date and time
    changeDate = now 
	
	' update the profile
	if Request.Form("firstName").Count > 0 then 
		strSql = "UPDATE [person] SET firstname = " & checknull(Request.form("firstName")) & ", lastname = " & checknull(Request.form("lastName")) & ", email = " & checknull(Request.Form("strEmail")) & ", Password = dbo.Encrypt(passwordsalt, " & checknull(Request.Form("strPassword")) & "), LastPasswordChangedDate = '" & changeDate & "' WHERE personID = '" & session("personid") & "'"
		
		'response.write strsql
		conn.execute strSql 
		
		if conn.errors.count > 0 AND conn.errors(0).number <> 0 then
			strError = "<font class=""regTextRed"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
		else
			strError = "<font class=""regTextGreen"">"
		    strError = strError & "Changes made successfully.<br /><br /></font>"
		end if 
		
		htmltext ="<html><head><title>Password</title></head><body><center><br><a href=""https://usedi.ucla.edu"">https://usedi.ucla.edu</a><br /><br /><font color=""black"">Your username at e-EDI is: <b>" & Request.Form("strEmail") & "</b><br /><br /><font color=""black"">Your password at e-EDI is: <b>" & Request.Form("strPassword") & "</b></font></center></body></html>"
		on error resume next 		
		Set objMail = Server.CreateObject("CDO.Message")
		 with objMail
			.From = session("config_FromAddress")
		    .To = session("id")
		    .Subject = "US EDI Password"
			
		    .Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		    .Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = session("config_smtpServer")
		    .Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		    .Configuration.Fields.Update
			
			.HTMLBody = htmlText
			.Send			
			
			if err.number<>0 then 
				strError = strError & "<font class=""boldTextRed"">Error sending to " & .To & ": " & err.description & "</font><br />"
				err.Clear()
			else
				' set the message		
				strMessage = "<font class=""boldTextBlack"">Your reminder has been sent to " & .To & ".</font><br /><br />"
			end if  
		end with 
		set objmail = nothing		

		
        'response.write "<tr><td colspan=""3"" align=""center"">" & strError & "</td></tr>"
		
	end if 
	
	' find the record with the email address in it	
	'strSql = "SELECT firstName,lastName, Email,  dbo.decrypt('" & encrytionkey & "',Password) as password FROM [person] WHERE personID ='" & session("personid") & "'"	
	strSql = "SELECT firstName,lastName, Email,  dbo.decrypt(passwordsalt,Password) as password FROM [person] WHERE personID ='" & session("personid") & "'"	
	
	' open the recordset
	rstEmail.Open strSql, conn
	if not rstEmail.EOF then 
		strFirstName = rstEmail("FirstName")
		strLastName = rstEmail("LastName")
		strEmail = rstEmail("Email")
		strPassword = rstEmail("Password")
	end if 	
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();">
	<!-- #include file="shared/page_header.asp" -->
	<form name="Passwords" method="POST" action="teacher_account.asp">
		<a class="reglinkMaroon" href="teacher.asp"><%=strHome%></a>&nbsp;<font class="regTextBlack">></font>&nbsp;<font class="boldTextBlack"><%=lblPass%></font>
		<table border="1" bordercolor="006600" cellpadding="0" cellspacing="0" width="760">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="760">
					<tr>
						<td align="right" width="470">
							<font class="headerBlue"><%=lblPass%></font>
						</td>
						<td align="right">
							<input type="submit" name="<%=strSave%>" value="<%=strSave%>">
							<input type="button" value="<%=strExit%>" name="<%=strExit%>" title="EXIT Screen" onClick="javascript:window.location='teacher.asp';">
							&nbsp;
						</td>
					</tr>
					<tr><td><br/></td></tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="760" align="center">
					<tr><td colspan="2"><%=strError%></td></tr>
					<tr><td colspan="2" align="center"><font class="subHeaderBlue"><%=strMsg%></font><br /><br /></td></tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblFirstName%>: &nbsp;</font>
						</td>
						<td align="left">
							<input type="text" name="firstName" size="25" value="<%=strFirstName%>">
						</td>
					</tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblLastName%>: &nbsp;</font>
						</td>
						<td align="left">
							<input type="text" name="lastName" size="25" value="<%=strLastName%>">
						</td>
					</tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblEmail%>: &nbsp;</font>
						</td>
						<td align="left">
							<input type="text" name="strEmail" size="25" value="<%=strEmail%>" readonly >
						</td>
					</tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblPassword%>: &nbsp;</font>
						</td>
						<td  align="left">
							<input type="text" name="strPassword" size="25" value="<%=strPassword%>">
						</td>
					</tr>
					<tr><td><br/></td></tr>
				</table>
			</td>			
		</tr>
		</table>	
		<br/> 
	
	</form>
	
	<!-- #include file="shared/page_footer.asp" -->
</body>
</html>
<%
	' close and kill the connection and recordset
	call close_adodb(rstEmail)
	call close_adodb(conn)
end if
%>

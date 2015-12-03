<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/configuration.asp" -->
<%
on error resume next
' if the user has not logged in they will not be able to see the page
if blnSecurity then

  if session("consent") = True then       
    
    ' only allow those that are required to change their pwd here.   
    if session("password") = "False" then 
	    ' open edi connection
	    call open_adodb(conn, "UCLAEDI")
	    set rstEmail = server.CreateObject("adodb.recordset")
    	
    	' get the change date and time
    	changeDate = now 
    	
	        ' update the password
	        if Request.Form("strPassword").Count > 0 then 
		        strSql = "UPDATE [person] SET Password = dbo.Encrypt(passwordsalt, " & checknull(Request.Form("strPassword")) & "), LastPasswordChangedDate = '" & changeDate & "' WHERE personID = '" & session("personid") & "'"		    
		        response.write strsql
		        conn.execute strSql 
        		
		        if conn.errors.count > 0 and conn.errors(0).number <>0 then
			        strError = "<font class=""regTextRed"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
		        else
			        strError = "<font class=""regTextGreen"">"
		            strError = strError & "Changes made successfully.<br /><br /></font>"
		        end if 
        		
		        htmltext ="<html><head><title>Password</title></head><body><center><img width=""200"" src=""https://usedi.ucla.edu/images/CHCFC Logo.jpg"" alt=""e-EDI"" name=""e-edi.gif""><br><a href=""https://usedi.ucla.edu/"">https://usedi.ucla.edu</a><br /><br /><font color=""black"">Your username at e-EDI is: <b>" & session("id") & "</b><br /><br /><font color=""black"">Your password at e-EDI is: <b>" & Request.Form("strPassword") & "</b></font></center></body></html>"
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
				        strError = strError & "<font class=""boldTextRed"">Error sending to " &  .To & ": " & err.description & "</font><br />"
				        				        
				        if err.number = "-2147220977" then 
				            session("password") = "True"
                            session("LastPwdChange") = changeDate                                             
                            err.Clear()			
                            response.redirect("teacher.asp")
                        else 
                            err.Clear()			
				        end if 
			        else
				        ' set the message		
				        strMessage = "<font class=""boldTextBlack"">Your reminder has been sent to " & .To & ".</font><br /><br />"
				        session("password") = "True"
                        		session("LastPwdChange") = changeDate                                             
		                        response.redirect("teacher.asp")
			        end if  
			        
		        end with 
		        set objmail = nothing				
             end if 
	
            ' find the record with the email address in it	
            strSql = "SELECT firstName,lastName, Email,  dbo.decrypt(passwordsalt,Password) as Password FROM [person] WHERE personID ='" & session("personid") & "'"	
        	
            ' open the recordset
            rstEmail.Open strSql, conn
            
            if not rstEmail.EOF then 
	            strFirstName = rstEmail("FirstName")
	            strLastName = rstEmail("LastName")
	            strEmail = rstEmail("Email")
	            strPassword = rstEmail("Password")
            end if
            
            ' close and kill the connection and recordset		
            call close_adodb(rstEmail) 	
            call close_adodb(conn)
        

        else
            response.redirect("teacher.asp")
            'response.write "Pwd = " & session("password")
        end if 
    else 
        response.redirect("teacher_consent.asp")
    end if 
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();document.Passwords.strPassword.focus();">
	<!-- #include file="shared/page_header.asp" -->
	<form name="Passwords" method="POST" action="teacher_passwordchange.asp" onsubmit="javascript:return passwordChange();">
		<font class="boldTextBlack">Password Change</font>
		<table border="1" bordercolor="006600" cellpadding="0" cellspacing="0" width="760">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="760">
					<tr>
						<td align="right" width="470">
							<font class="headerBlue">Password Change</font>
						</td>
						<td align="right">
							<input type="submit" name="Save" value="Save" />
							&nbsp;
						</td>
					</tr>
					<tr><td><br/></td></tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="760" align="center">
					<tr><td colspan="2"><%=strError%></td></tr>
					<tr><td colspan="2" align="center"><font class="subHeaderBlue">Your password must be changed to something you can remember before entering the e-EDI.  If you notice any errors in your name you can correct them by clicking profile after your password has been changed.</font><br /><br /></td></tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblFirstName%>: &nbsp;</font>
						</td>
						<td align="left">
							<input type="text" name="firstName" size="25" value="<%=strFirstName%>" readonly disabled="disabled">
						</td>
					</tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblLastName%>: &nbsp;</font>
						</td>
						<td align="left">
							<input type="text" name="lastName" size="25" value="<%=strLastName%>" readonly disabled="disabled" >
						</td>
					</tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblEmail%>: &nbsp;</font>
						</td>
						<td align="left">
							<input type="text" name="strEmail" size="25" value="<%=strEmail%>" readonly disabled="disabled">
						</td>
					</tr>
					<tr>
						<td align="right">
							<font class="boldTextBlack"><%=lblPassword%>: &nbsp;</font>
						</td>
						<td  align="left">
							<input type="text" name="strPassword" size="25" value="">
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
end if
%>

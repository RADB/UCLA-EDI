<!-- #include file="shared/dbase.asp" -->
<!-- #include file="shared/configuration.asp" -->
<% 
stremail= Request.QueryString("email")
call open_adodb(conn,"UCLAEDI")
set	rstPassword = server.createobject("ADODB.recordset") 
strQuery = "SELECT dbo.decrypt(passwordsalt,Password) as Password FROM [person] WHERE Email ='"& replace(strEmail,"'","''") &"'"

rstPassword.Open strQuery, conn

if not (rstPassword.eof and rstPassword.bof) then 
on error resume next 
	htmltext ="<html><head><title>Password</title></head><body><center><br><a href=""https://usedi.ucla.edu"">https://usedi.ucla.edu/</a><br /><br /><font color=""black"">Your password at e-EDI is: <b>" & rstPassword("Password") & "</b></font></center></body></html>"
	'set objmail = server.CreateObject("CDONTS.NewMail")
	'	objmail.From = "webmaster@e-edi.ca"
	'	objmail.To = strEmail
	'	objmail.Subject = "e-EDI Password"
	'	objmail.BodyFormat = 0
	'	objmail.MailFormat = 0
	'	objmail.Body = htmlText
	'	objmail.Send 
	'set objmail = nothing
	strerror = ""
	Set objMail = Server.CreateObject("CDO.Message")
	 with objMail
		 .From = session("config_FromAddress")
	    .To = strEmail
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
	
	on error goto 0
else 
	Response.write "<tr><td colspan=""3"" align=""center""><font class=""boldTextBlack"">The specified email """ & strEmail & """ does not exist in the system. <br><Br>Please contact the <a href=""mailto:webmaster@e-edi.ca"" class=""reglink"">Webmaster</a>.</font><br><br></td></tr>"
end if 

call close_adodb(rstPassword)
call close_adodb(conn)	

strTopBar = "<table width=""760"" border=""1"" cellpadding=""1"" cellspacing=""0"" style=""border-color:#006600;background-color:#dcdcdc"">"
' bgcolor=""Gainsboro"" = dcdcdc 
strTopBar = strTopBar & "<tr><td><table width=""750"" border=""0"" cellpadding=""3"" cellspacing=""0""><tr><td align=""left""><font class=""boldTextBlack"">&nbsp;&nbsp;"
strTopBar = strTopBar & "Password Reminder"
strTopBar = strTopBar & "</td><td align=""right""><div class=""boldTextBlack"" id=""datetime""></div></td></tr></table>"	
strTopBar = strTopBar &	"</td></tr></table>"
'strTopBar = strTopBar &	"<br />"
%>

<html>
	<!-- #include file="shared/head.asp" -->			
	<body>    	
	    <!-- #include file="shared/page_header.asp" -->			    
	    <br />
		<table width="760" class="tableBorder" cellpadding="0" cellspacing="0">
		    <tr>
			    <td align="middle">			
				    <table width="750" border="0" cellpadding="0" cellspacing="0">
				        <tr>	
					        <td valign="middle">
        				         <a href="http://www.ucla.edu"><img src="images/CHCFC Logo.jpg" border="0" alt="CHCFC" name="CHCFC Logo" width="90" /></a>		    						
					        </td>
					        <td align="middle" colspan="3" valign="Middle">
        						<%
        							if strError = "" then 
		                                response.write "<font class=""regText"">Your password has been sent to&nbsp;</font><font class=""boldTextBlack"">" & strEmail & "!</font>&nbsp;&nbsp;<input type=""button"" value=""Login"" onclick=""javascript:window.location='default.asp?email=" & replace(strEmail,"'","\'") & "';"" name=""Login"">"			
	                                else
		                                response.write  strError 
	                                end if 
        						 %>
					        </td>
					        <td  valign="middle">						
						        <a href="http://www.ucla.edu"><img src="images/EDI Logo.jpg" border="0" alt="EDI" name="EDI Logo" width="90" /></a>
					        </td>
				        </tr>    				
				    </table>
				    <br />
			    </td>
		    </tr>
		</table>
		<!-- #include file="shared/page_footer.asp" -->
	</body>
</html>
<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/configuration.asp" -->
<%
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
        response.redirect("teacher_consent.asp")
    end if  
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();">
	<!-- #include file="shared/page_header.asp" -->	
		<a class="reglinkMaroon" href="teacher.asp">Home</a>&nbsp;<font class="regTextBlack">></font>&nbsp;<font class="boldTextBlack">Contact Information</font>
		<table border="1" bordercolor="006600" cellpadding="0" cellspacing="0" width="760">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="760">
					<tr>
						<td align="right" width="450">
							<font class="headerBlue">Contact Information</font>
						</td>
						<td align="right">							
							<input type="button" value="<%=strExit%>" name="<%=strExit%>" title="EXIT Screen" onClick="javascript:window.location='teacher.asp';">
							&nbsp;
						</td>
					</tr>
					<tr><td><br/></td></tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="500" align="center">
					<tr><td><%=strError%></td></tr>					
					<tr><td align="left">
					    <a href="http://www.healthychild.ucla.edu"><img src="images/CHCFC Logo.jpg" border="0" alt="CHCFC" name="CHCFC Logo" /></a>
					    <div class="regTextBlack">
					    UCLA Center for Healthier Children, Families and Communities
					    <br />
                        TECCS-EDI Project
                        <br />
                        10990 Wilshire Blvd., Suite 900
                        <br />
                        Los Angeles, CA 90024
                        <br />
                        <a href="http://www.healthychild.ucla.edu" class="reglinkMaroon">http://www.healthychild.ucla.edu</a>
                        <br />
                        email: <a href="mailto:USEDI@mednet.ucla.edu" class="reglinkMaroon">USEDI@mednet.ucla.edu</a>
                        </div>
					</td></tr>
					<tr><td><br/></td></tr>
				</table>
			</td>			
		</tr>
		</table>	
		<br/> 	
	
	<!-- #include file="shared/page_footer.asp" -->
</body>
</html>
<%

end if
%>

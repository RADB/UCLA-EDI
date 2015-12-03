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
  
  ' open edi connection
	call open_adodb(conn, "UCLAEDI")
	set rstData = server.CreateObject("adodb.recordset")				
	
	' find the record with the email address in it	
	strSql = "SELECT question,answer FROM [FAQ] WHERE IsTeacherFAQ = 1 ORDER BY Sequence"
	
	rstData.open strSql, conn
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();">
	<!-- #include file="shared/page_header.asp" -->	
		<a class="reglinkMaroon" href="teacher.asp">Home</a>&nbsp;<font class="regTextBlack">></font>&nbsp;<font class="boldTextBlack">FAQ</font>
		<table border="1" bordercolor="006600" cellpadding="0" cellspacing="0" width="760">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="760">
					<tr>
						<td align="right" width="500">
							<font class="headerBlue">Frequently Asked Questions</font>
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
					<tr><td align=""left"">
					    <ul>
                        <%
					    if not rstData.eof then   
					        do while not rstData.eof
					            Response.Write "<li><font class=""regTextBlack"">" & rstData("Question") & "</font></li>"
					            Response.Write "<font class=""regTextBlack"">&nbsp;&nbsp;&nbsp;" & rstData("Answer") & "</font>"
    					        
					            rstData.movenext
					        loop
					    end if 
					    %>
					  </ul>
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
	set rstData = Nothing
	set conn = nothing
end if
%>

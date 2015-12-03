<!-- #include file="dbase.asp" -->
<!-- #include file="browser_check.asp" -->

<%
if NOT session("user") then
%>
<html>
	<head>
		<title>e-EDI Security</title>
		<script language="javascript" type="text/javascript" src="js/login.js"></script>
		<link rel="stylesheet" type="text/css" href="Styles/ucla.css">
	</head>
	<%	
	Response.Write "<body "
	if intVersion = 0 then 
		Response.Write "onload=""javascript:checkFocus(login.check.value);"""
	end if
	Response.Write ">"

	strTopBar = "<table width=""760"" border=""1"" cellpadding=""1"" cellspacing=""0"" style=""border-color:#dcdcdc;background-color:#dcdcdc"">"
	' bgcolor=""Gainsboro"" = dcdcdc 
	strTopBar = strTopBar & "<tr><td><table width=""750"" border=""0"" cellpadding=""3"" cellspacing=""0""><tr><td align=""left""><font class=""boldTextBlack"">&nbsp;&nbsp;"
	strTopBar = strTopBar & "Session expired/Not logged on"
	strTopBar = strTopBar & "</td><td align=""right""><div class=""boldTextBlack"" id=""datetime""></div></td></tr></table>"	
	strTopBar = strTopBar &	"</td></tr></table>"
	'strTopBar = strTopBar &	"<br />"
	%>
	
	<!-- #include file="page_header.asp" -->
	<form name="login" method="post" action="default.asp">
	<input type="hidden" name="check" value="0">
	<INPUT type="hidden" id="language" name="language" value="English">
	<br />
	<table width="760" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">				
				<font class="boldTextBlack">Your session has either expired or you do not have permission to be here!</font>
			</td>
		</tr>
	</table>
	<br />
	<br />
	<table width="760" border="1" cellpadding="0" cellspacing="0">
		<tr>
			<td align="middle">			
				<table width="750" border="0" cellpadding="0" cellspacing="0">
				<tr>	
					<td rowspan="5" valign="middle">
        				 <a href="http://www.ucla.edu"><img src="images/CHCFC Logo.jpg" border="0" alt="CHCFC" name="CHCFC Logo" width="90" /></a>		    						
					</td>
					<td align="middle" colspan="3" valign="Middle">
						<br />
						<font class="headerBlack">Account Sign On</font>
						<br />						
						<br />
					</td>
					<td rowspan="5" valign="middle">						
						<a href="http://www.ucla.edu"><img src="images/EDI Logo.jpg" border="0" alt="EDI" name="EDI Logo" width="90" /></a>
					</td>
				</tr>
				<tr valign="top">
					<td width="100" align="right" nowrap="nowrap"> 
						<font class="boldtextblack">Email :&nbsp;&nbsp;</font>
					</td>
					<td width="175" align="left">
						<input type="text" name="email" value="<%=strEmail%>" size="25">						
					</td>
					<td width="275">				        						
					</td>
				</tr>
				<tr>
				    <td width="100" align="right">
						<font class="boldtextblack" nowrap="nowrap">Password :&nbsp;&nbsp;</font>
					</td>
					<td width="175" align="left">
						<input type="password" name="password" value="" size="25">						
					</td>
					<td width="275">
						&nbsp;
						<input type="submit" name="Login" value="Login">
					</td>
				</tr>
				<tr>
					<td></td>
					<td colspan="2">
						<INPUT type="checkbox" id="savecookie" name="savecookie" checked>
						<font class="regTextBlack" nowrap="nowrap">Save my settings</font>
					</td>
				</tr>
				</table>
				<br />
			</td>
		</tr>
		</table>
		<!-- #include file="page_footer.asp" -->
	</form>
	</body>
</html>
<%
	blnSecurity = false
else
	blnSecurity = true
	' style=""border-color:#006600;background-color:#dcdcdc"
	strTopBar = "<table width=""760"" border=""1"" cellpadding=""1"" cellspacing=""0"" style=""border-color:#006600;background-color:#dcdcdc"">"
	strTopBar = strTopBar & "<tr><td><table width=""750"" border=""0"" cellpadding=""3"" cellspacing=""0""><tr><td align=""left""><font class=""boldTextBlack"">&nbsp;&nbsp;"		
	strTopBar = strTopBar & session("name") & "</font></td><td align=""right""><font class=""boldTextBlack"">" 
	strTopBar = strTopBar & "<span class=""boldTextBlack"" id=""logouttime""></span>&nbsp;&nbsp;<span class=""boldTextBlack"" id=""savetime""></span>&nbsp;&nbsp;<span class=""boldTextBlack"" id=""datetime""></span></td></tr></table>"
	strTopBar = strTopBar &	"</td></tr></table>"
	strTopBar = strTopBar &	"<br />"
end if 	
%>
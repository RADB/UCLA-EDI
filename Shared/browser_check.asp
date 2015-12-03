<%
' gets the clients IP address
strClient = Request.ServerVariables("REMOTE_ADDR")
	
' removes "mozilla/" from the strBrowser specs
strBrowser = replace(Request.ServerVariables("HTTP_USER_AGENT"), "Mozilla/", "")
	
'determines Netscape or Internet Explorer or Unknown
if instr(1,strBrowser,"MSIE",1) then 	
	'EXPLORER : VERSION
	intNumber = Mid(strBrowser,instr(1,strBrowser,"MSIE ",1)+5,3)
	strVersion = "Internet Explorer " & intNumber
	intVersion = 0
elseif instr(1,strBrowser,"nav",1) then 	
	'NETSCAPE : VERSION
	intNumber = left(strBrowser,4)
	strVersion = "Netscape " & intNumber
	intVersion = 1
else 
	'UNKNOWN : VERSION
	intNumber = left(strBrowser,4)
	strVersion = "Unknown " & intNumber
	intVersion = 2
end if 	
	
' returns:
'		strClient - IP address
'		strBrowser - full browser string
'		intNumber - browser version
'		strVersion - version of browser
'		intVersion - (0) IE (1) NETSCAPE (2) OTHER
%>
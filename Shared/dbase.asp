<%
' allows redirects to function properly
' causes pages not to cache
Response.Buffer = true
Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"

sub open_adodb(ByRef conn,strDB)
	set conn = Server.CreateObject("ADODB.Connection")
	
	select case strDB
		case "UCLAEDI"
		    conn.Open "Provider=SQLOLEDB;Data Source=ri-rennera-lt1;Initial Catalog=USEDI;User Id=uclawebagent;Password=tr2003B$"           
	end select
end sub

sub close_adodb(strName)
on error resume next
	strName.Close
	set strName = nothing
end sub


	
%>

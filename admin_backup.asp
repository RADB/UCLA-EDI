<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/configuration.asp" -->
<%
if  session("id")="lesliefarago@hotmail.com" then
	dim blnExists 
	dim blnLicensed 
    ' if the user has not logged in they will not be able to see the page
	if Request.QueryString("zip").Count = 0 then 
		dim eZip
		dim strFilename, strFiletozip
		call open_adodb(conn, "UCLAEDI")
        'set rstBackup = server.CreateObject("adodb.recordset")
	
        dim filename 
        dim datetime 
        datetime = now()
        filename = year(datetime) & "_"& right("0" & month(datetime),2) & "_"& right("0" & day(datetime),2)& "_"&right("0" & hour(datetime),2)&right("0" & minute(datetime),2)&right("0" & second(datetime),2)
        strFileName = "c:\websites\usedi\www\backups\USEDI_Backup_" & filename & ".bak"
        strLocation = replace(replace(strFileName,"c:\websites\usedi\www\",""),"\","/")      
        response.write strLocation
	    strSql = "Exec dbo.BackupDataBase '" & filename & "'"

        conn.execute strsql
        call close_adodb(conn)

		' kill the object
		set eZip = nothing		
		
		Response.Write "<br>"
		
		' set the header
		strHeader = "Data Backup"
		' set the subheader
		strSub = "<font class=""subHeaderBlue"">Your file will be ready momentarily...</font><br /><font class=""subHeaderBlue"">Thank you for your patience.</font>"
		
		'set exists = false
		blnExists = false
	else
		
		blnExists = IsFileExists(Request.QueryString("zip"))
		' check to be sure the file exists
		If  blnExists = True  Then
			' set the header
			strHeader = "Data Backup Complete"
			' set the subheader
			strSub = "<font class=""subHeaderBlue"">Your file is now ready...</font><br /><br /><a href=""" & Request.QueryString("zip") & """ class=""bigLinkRed""><img alt=""Download File Here"" src=""images/sql_backup.png"" alt=""SQL Backup"" title=""Download File Here"" name=""sql_backup.png"" Border=""0""/>&nbsp;" & Request.QueryString("zip")  & "</a>"
		Else
			' does not exist - run for another 5 seconds
			strLocation = Request.QueryString("zip")
			' set the header
			strHeader = "Data Backup"          

			' set the subheader
			strSub = "<font class=""subHeaderBlue"">Your file will be ready momentarily...</font><br /><font class=""subHeaderBlue"">Thank you for your patience.</font>"
		End If
	end if
	%>
<html>
<!-- #include file="shared/head.asp" -->
<body>
	<table  width="480" border="0" cellpadding="0" cellspacing="0">			
		<tr>
			<td width="160"></td>
			<td valign="middle" align="center" width="160">
				<!--<img src="images/sql_backup.png" alt="SQL Backup" name="sql_backup.png">-->
				<br/><br/>
			</td>
			<td align="right" valign="top">
				<%
				if blnExists then 
				%>
					<a href="javascript:window.close();" class="bigLinkBlue">Close Window</a>
				<%
				end if 
				%>
				&nbsp;&nbsp;
			</td>
		</tr>
	</table>
	<table  width="480" border="0" cellpadding="0" cellspacing="0">		
		<tr>
			<td align="center">
				<%
				if not blnExists then 
				%>
					<img alt="Please Wait" src="images/hourglass.gif" name="Hourglass" title="Please be patient... your file will be ready soon." />
				<%
				end if 
				%>
			</td>
			<td align="center" valign="top">
				<font class="headerBlue"><%=strHeader%></font>
				<br />
				<%=strSub%>
			</td>
			<td>
				<%
				if not blnExists then 
				%>
				<img alt="Please Wait" src="images/hourglass.gif" name="Hourglass" title="Please be patient... your file will be ready soon." />
				<%
				end if 
				%>
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" width="480" align="center">
	<tr>
		<td align="left">
			
			<%
				if strError <> "" then 
					Response.Write strError & "<br /><br />"
				end if 
			%>
		</td>
	</tr>
	</table>
	<!-- #include file="shared/page_footer.asp" -->
    
    <%'javascript:goWindow('edi_admin_zip.asp','Map','490','240','top=0,left=125')
	if strLocation <> "" then 
		Response.Write "<SCRIPT LANGUAGE=""JavaScript"">"			
			Response.write "NewUrl = 'admin_Backup.asp?zip=" & strLocation & "','Backup','0','0','top=0,left=0';"
			Response.write "setTimeout('top.location.href = NewUrl',3000);"
		Response.Write "</SCRIPT>"
	end if 
	%>	
</body>
</html>
<%
else
	Response.Write "<SCRIPT LANGUAGE=""JavaScript"">"            
	    Response.write "document.location = 'teacher.asp';"		
	Response.Write "</SCRIPT>"
end if

' **********************************
' Function to check file Existance
' **********************************
Function IsFileExists(byVal FileName)
	 
	If FileName = ""  Then
		IsFileExists = False
		Exit Function
	End If
	 
	Dim objFSO
	    
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	    
	filename = "C:\websites\usedi\www\" & filename   
	
	If objFSO.FileExists( FileName ) = True  Then
		IsFileExists = True
	Else
		IsFileExists = False
	End If
	  
	Set objFSO = Nothing   
End Function
%>
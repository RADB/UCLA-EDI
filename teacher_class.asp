<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/configuration.asp" -->
<%
if blnSecurity then
on error resume next
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
	
	if request.form("classID").count > 0 and len(request.form("classID")) > 0 then 
	    'strSql = "Exec [dbo].[AddChild] " & EDIYear & "," & request.form("classID") & "," & right(request.form("ediid"),2) & ",'" & request.form("localID") & "'"	    
		strSql = "Exec [dbo].[AddChild] " & EDIYear & "," & request.form("classID") & ",'" & request.form("localID") & "'"	    
	    conn.execute strSql
			    
	     if conn.errors.count = 0 then 					
            strError = "<font class=""regTextGreen"">" & request.form("localID") & " added successfully.</font><br/><br/>"
        else
            strError = "<font class=""regTextRed"">The system has encountered an error while attempting to add your child to the system.  Please ensure that you have specified a unique local ID.  <br /><br />If you require additional assistace please send the following information to the administrators. <br /><br />Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & strSql & "<br/><br/></font>"
        end if 
	end if 
	
	if request.form("childID").count > 0 then 
	    strSql = "Exec [dbo].[LockChild] " & request.form("childID") 
	    conn.execute strSql
	    
	     if conn.errors.count = 0 then 					
            strError = "<font class=""regTextGreen"">Child Locked successfully.</font><br/><br/>"
        else
            strError = "<font class=""regtextred"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
        end if 
	end if 
	
	' delete child ID - add column to table (bit) change select to only select active children (not deleted) - build table of deleted children with restore icon (restore.png)
	if request.form("DeleteChildID").count > 0 and len(request.form("DeleteChildID")) > 0 then 
		strSql = "Exec [dbo].[DeleteChild] " & request.form("DeleteChildID") 
	    conn.execute strSql
	    
	    if conn.errors.count = 0 then 					
            strError = "<font class=""regTextGreen"">Child deleted successfully.</font><br/><br/>"
        else
            strError = "<font class=""regtextred"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
        end if 
		
	end if 
	' restore child ID
	if request.form("RestoreChildID").count > 0 and len(request.form("RestoreChildID")) > 0 then 
		strSql = "Exec [dbo].[RestoreChild] " & request.form("RestoreChildID") 
	    conn.execute strSql
	    
	    if conn.errors.count = 0 then 					
            strError = "<font class=""regTextGreen"">Child restored successfully.</font><br/><br/>"
        else
            strError = "<font class=""regtextred"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
        end if
		
	end if 
	
	set rstClasses = server.CreateObject("adodb.recordset")
	set rstChildren = server.CreateObject("adodb.recordset")
	set rstDeletedChildren = server.CreateObject("adodb.recordset")
	strSql = "exec dbo.GetTeacherClasses " & session("PersonID") & "," & EDIYear
	
    ' get a list of classes
    rstClasses.Open strSql, conn
    
    ' No Classes
    if not rstClasses.eof then
        ' build the list of classes
        aClasses = rstClasses.getrows
        blnClasses = True		
    else 
        strError = "<font class=""regTextRed"">You are not currently associated with any classes. <br /> If you believe this is an error please contact the EDI Administrator.<br/><br/></font>"
		blnClasses = False
	end if 
	call close_adodb(rstClasses)
		
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();">
	<!-- #include file="shared/page_header.asp" -->	
		<a class="reglinkMaroon" href="teacher.asp">Home</a>&nbsp;<font class="regTextBlack">></font>&nbsp;<font class="boldTextBlack">Teacher Classes</font>
		<table border="1" bordercolor="006600" cellpadding="0" cellspacing="0" width="760">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="760">
					<tr>
						<td align="right" width="450">
							<font class="headerBlue">Teacher Classes</font>
						</td>
						<td align="right">							
							<input type="button" value="<%=strExit%>" name="<%=strExit%>" title="EXIT Screen" onClick="javascript:window.location='teacher.asp';" />
							&nbsp;
						</td>
					</tr>
					<tr><td><br/></td></tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="500" align="center">
					<tr><td><%=strError%></td></tr>					
					<tr>
					    <td align="left">
					            <form name="Children" method="POST" action="">
						            <input type="hidden" name="childID" value="" />						            						            	
					            </form>
		                        
					            <!-- start class information -->
					            <%
					            if blnClasses then 
					                ' build a new table for each class
					                for intRow = 0 to ubound(aClasses,2)
					                    classID = aClasses(0,intRow)
					                    
					                    response.write "<form name=""Class" & classID & """ method=""POST"" action="""">" 	
					                    response.write "<input type=""hidden"" name=""classID"" value="""" />"
										response.write "<input type=""hidden"" name=""DeleteChildID"" value="""" />"
										response.write "<input type=""hidden"" name=""RestoreChildID"" value="""" />"
					                    
                                        response.write "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"" class=""tableBorder"">"					        
								        Response.Write "<tr><td colspan=""7""><font class=""UCLAHeader2"">&nbsp;ClassID:&nbsp;&nbsp;" & aClasses(3,intRow) & " - " & aClasses(2,intRow) & "</font></td></tr>"
        							    
    							        
    							        ' get a list of children in the class
							            strSql = "exec dbo.GetClassChildren " & classID	 & "," & EDIYear							         						        											
                                        rstChildren.Open strSql, conn    
										strSql = "exec dbo.GetDeletedClassChildren " & classID	 & "," & EDIYear	
                                        rstDeletedChildren.Open strSql, conn    
										
                                        
                                        previousEDIID = aClasses(1,intRow) & "00"
                                        ' No Children
                                        call childHeader()
                                        if not rstChildren.eof then                                            
                                            do while not rstChildren.eof
                                                if rstChildren("IsLocked") then 
											        strStatus = "<img border=""0"" src=""images\UCLALock.png"" alt=""Locked"" name=""Locked"" height=""25""/>" & rstChildren("completionDate") 								            										            
											        strImgStatus = "<img border=""0"" src=""images\edi-Complete.png"" alt=""Locked"" name=""Locked"" height=""25""/>"
											    else                                                    
                                                    ' 2010 Change - Check for in progress
                                                    if isnull(rstChildren("SavedDate")) then 											            
                                                        strStatus = ""
											            strImgStatus = "<img border=""0"" src=""images\edi-InComplete.png"" alt=""Locked"" name=""Locked"" height=""25""/>"                                                        
                                                    else
                                                        strStatus = "<img border=""0"" src=""images\UCLAQuestionnaire.png"" alt=""InProgress"" name=""InProgress"" height=""25""/>" & rstChildren("SavedDate") 								            										            
                                                        strImgStatus = "<img border=""0"" src=""images\edi-InProgress.png"" alt=""InProgress"" name=""InProgress"" height=""25""/>"                                                        
                                                    end if 
										        end if 
                                                response.write "<tr>"			                                    
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & strImgStatus & "</font></td>"
			                                    'response.write "<td align=""left""><font class=""regTextBlack"">" & rstChildren("EDIChildID") & "</font></td>"
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & rstChildren("SchoolChildID")& "</font></td>"
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & rstChildren("Sex")& "</font></td>"
			                                    response.write "<td align=""center""><font class=""regTextBlack"">" & rstChildren("Birthdate")& "</font></td>"
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & rstChildren("ZipCode") &"</font></td>"			                                    		                                    
			                                    Response.Write "<td align=""left""><font class=""regtextblack"">" & strStatus & "</font></td>"
									            'if rstChildren("IsLocked") then 
											    '    Response.Write "<img border=""0"" src=""images\UCLALock.png"" alt=""Locked"" name=""Locked"" height=""20""/>" & rstChildren("completionDate") 								            										            
										        'end if 
										        
										        
			                                    response.write "<td align=""left"" nowrap><img src=""images/blinkingarrow.gif"" alt=""Blinking Arrow"" /><a title=""Edit EDI"" href=""javascript:GoToEDIQuestionnaire('teacher_questionnaire.asp','" & rstChildren("childID") & "');"" class=""boldLinkBlue"">&nbsp;" & lblEDI & "&nbsp;<img border=""0"" src=""images\UCLAQuestionnaire.png"" alt=""Questionnaire"" name=""Questionnaire"" height=""25"" /></a>&nbsp;<a href=""javascript:DeleteChild('" & classID & "','" & rstChildren("childID") & "')"" title=""Delete EDI"" class=""boldLinkBlue""><img border=""0"" src=""images\delete.png"" alt=""Delete"" name=""Delete"" height=""25"" />Delete</a></td>"
		                                        response.write "</tr>"
    		                                    
		                                        previousEDIID = rstChildren("EDIChildID")
                                                rstChildren.movenext
                                            loop                                              
                                        else
                                            Response.Write "<tr><td colspan=""7"">&nbsp;<font class=""regTextMaroon"">There are no children in this class.</font></td></tr>"						
                                        end if                                     
                                        rstChildren.close 
                                        call AddChild(classID)
                                        
										' 2013 - restore child										
										if not rstDeletedChildren.eof then                                            
											response.write "<tr><td colspan=""7""><font class=""UCLASubHeader"">&nbsp;&nbsp;&nbsp;Deleted Children</font></td></tr>"
											call childHeader()
                                            do while not rstDeletedChildren.eof
                                                if rstDeletedChildren("IsLocked") then 
											        strStatus = "<img border=""0"" src=""images\UCLALock.png"" alt=""Locked"" name=""Locked"" height=""25""/>" & rstDeletedChildren("completionDate") 								            										            
											        strImgStatus = "<img border=""0"" src=""images\edi-Complete.png"" alt=""Locked"" name=""Locked"" height=""25""/>"
											    else                                                    
                                                    ' 2010 Change - Check for in progress
                                                    if isnull(rstDeletedChildren("SavedDate")) then 											            
                                                        strStatus = ""
											            strImgStatus = "<img border=""0"" src=""images\edi-InComplete.png"" alt=""Locked"" name=""Locked"" height=""25""/>"                                                        
                                                    else
                                                        strStatus = "<img border=""0"" src=""images\UCLAQuestionnaire.png"" alt=""InProgress"" name=""InProgress"" height=""25""/>" & rstDeletedChildren("SavedDate") 								            										            
                                                        strImgStatus = "<img border=""0"" src=""images\edi-InProgress.png"" alt=""InProgress"" name=""InProgress"" height=""25""/>"                                                        
                                                    end if 
										        end if 
                                                response.write "<tr>"			                                    
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & strImgStatus & "</font></td>"
			                                    'response.write "<td align=""left""><font class=""regTextBlack"">" & rstDeletedChildren("EDIChildID") & "</font></td>"
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & rstDeletedChildren("SchoolChildID")& "</font></td>"
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & rstDeletedChildren("Sex")& "</font></td>"
			                                    response.write "<td align=""center""><font class=""regTextBlack"">" & rstDeletedChildren("Birthdate")& "</font></td>"
			                                    response.write "<td align=""left""><font class=""regTextBlack"">" & rstDeletedChildren("ZipCode") &"</font></td>"			                                    		                                    
			                                    Response.Write "<td align=""left""><font class=""regtextblack"">" & strStatus & "</font></td>"
									            'if rstChildren("IsLocked") then 
											    '    Response.Write "<img border=""0"" src=""images\UCLALock.png"" alt=""Locked"" name=""Locked"" height=""20""/>" & rstDeletedChildren("completionDate") 								            										            
										        'end if 
										        
										        
			                                    response.write "<td align=""left"" nowrap><a href=""javascript:RestoreChild('" & classID & "','" & rstDeletedChildren("childID") & "')"" title=""Restore EDI"" class=""boldLinkBlue""><img border=""0"" src=""images\restore.png"" alt=""Restore"" name=""Restore"" height=""25"" /> Restore</a></td>"
		                                        response.write "</tr>"
    		                                    
		                                        previousEDIID = rstDeletedChildren("EDIChildID")
                                                rstDeletedChildren.movenext
                                            loop
										end if 
                
								        response.write "</table>"
								        response.write "</form><br />"								        
							        next
							    end if 
						        %>
					            <!-- end class information -->
					    </td>
					</tr>
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
    call close_adodb(rstChildren)
	call close_adodb(rstDeletedChildren)
    call close_adodb(conn)
end if

sub childHeader
		response.write "<tr>"			
			response.write "<td align=""center"" width=""25""><font class=""boldTextBlack"">&nbsp;</font></td>"
			'response.write "<td align=""center"" width=""150""><font class=""boldTextBlack"">" & lblEDIID& "</font></td>"
			response.write "<td align=""center"" width=""125""><font class=""boldTextBlack"">" & lblLocal& "</font></td>"
			response.write "<td align=""center"" width=""50""><font class=""boldTextBlack"">" & lblSex& "</font></td>"
			response.write "<td align=""center"" width=""100""><font class=""boldTextBlack"">" & lblDOB& "</font></td>"
			response.write "<td align=""center"" width=""100""><font class=""boldTextBlack"">Zip</font></td>"
			response.write "<td align=""center"" width=""150""><font class=""boldTextBlack"">" & lblStatus& "</font></td>"
			response.write "<td align=""center"" width=""50""><font class=""boldTextBlack"">" & lblEDI& "</font></td>"
		response.write "</tr>"
end sub
 
sub AddChild(ClassID)
	nextediid = left(previousEDIID,15) & right("0" & right(previousEDIID,2)+1,2) 
	response.write "<tr>"	
	response.write "<td colspan=""1""><input type=""hidden"" value=""" & nextediid & """ class=""regTextBlack"" name=""ediid"" /></td>"
	'response.write "<td colspan=""1""><input type=""text"" value=""" & nextediid & """ size=""14"" class=""regTextBlack"" name=""ediid"" readonly /></td>"
	response.write "<td colspan=""1""><input type=""text"" size=""10"" name=""localid"" /></td>"
	response.write "<td colspan=""5""><input type=""button"" class=""regTextBlack"" value=""Add Child"" name=""Add"" onClick=""javascript:AddEDIChild('" & ClassID & "');""></td>"
	response.write "</tr>"	
end Sub
%>

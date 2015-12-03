<!-- #include file="shared/security.asp" -->
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
    
    call open_adodb(conn,"UCLAEDI")
    set rstData = Server.CreateObject("ADODB.Recordset")
	    
	if session("childID") > 0 then     
	    strSql = "exec dbo.CompletionCheck " & session("childID")		
        		        
        rstData.Open strSql, conn                                                                                
	else
	    response.redirect "teacher_class.asp"
	end if 
	
	' get child lock status
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();">

    <!-- #include file="shared/page_header.asp" -->	
	<form name="Children" method="post" action="teacher_questionnaire.asp"> 	
		<a class="reglinkMaroon" href="teacher.asp">Home</a>&nbsp;<font class="regTextBlack">></font>&nbsp;<a class="reglinkMaroon" href="teacher_class.asp">Teacher Classes</a>&nbsp;<font class="regTextBlack">></font>&nbsp;<font class="boldTextBlack">EDI Questionnaire Completion Check</font>
		<table border="1" style="border-color:#006600;" cellpadding="0" cellspacing="0" width="760">
			<tr>
				<td>				    
					<table border="0" cellpadding="0" cellspacing="0" width="750" align="center">
						<tr>
							<td align="right" width="540"><font class="headerBlue">Questionnaire Completion Check(<%=rstData("localID")%>)</font></td>
							<td align="right">
								<input type="button" value="Exit" name="Exit" onclick="javascript:document.forms.Children.showStatus.value='False';GoToEDIQuestionnaire('teacher_questionnaire.asp','<%=session("childID")%>');" id="Exit" />
								&nbsp;
							</td>	
						</tr>
						<tr>
						    <td colspan="2">
						        <br/>
						        <%=strDataUpdateStatus%>
						    </td>
						</tr>
					</table>
					<input type="hidden" name="GoToSection" value="" />							
					<input type="hidden" name="childID" value="" />		
					<input type="hidden" name="showStatus" value="True" />	
		
					<table border="0" cellpadding="0" cellspacing="0" width="750" align="center">
						<tr>
                            <% ' Change 2010 3.2.1-2 a - Checklist to Demographics %>	
						    <td align="right" width="200"><font class="boldTextBlack">Demographics:&nbsp;</font></td>	                            				  
						    <td width = "200"><%=statusLink(rstData("checklist"),"Demographics") %></td>
						    <td width="350" rowspan="2"><a class="boldLinkBlue" href="javascript:confirmLock('<%=session("childID") &"','" & rstData("checklist") & "','" & rstData("SectionA") & "','" & rstData("SectionB") & "','" & rstData("SectionC") & "','" & rstData("SectionD") & "','" & rstData("SectionE") %>','teacher_class.asp');"><img border="0" src="images\UCLALocked.png" alt="Lock Child" title="Lock Child" name="LockChild" />&nbsp;Lock Child and Mark as Complete</a></td>
						</tr>
						<tr>
						    <td align="right" width="200"><font class="boldTextBlack">Section A:&nbsp;</font></td>						  
						    <td width = "200"><%=statusLink(rstData("SectionA"),"Section A") %></td>
						</tr>
						<tr>
						    <td align="right" width="200"><font class="boldTextBlack">Section B:&nbsp;</font></td>						  
						    <td width = "200"><%=statusLink(rstData("SectionB"),"Section B") %></td>
						</tr>
						<tr>
						    <td align="right"  width="200"><font class="boldTextBlack">Section C:&nbsp;</font></td>						  
						    <td width = "200"><%=statusLink(rstData("SectionC"),"Section C") %></td>
						</tr>
						<tr>
						    <td align="right"  width="200"><font class="boldTextBlack">Section D:&nbsp;</font></td>						  
						    <td width = "200"><%=statusLink(rstData("SectionD"),"Section D") %></td>
						</tr>
						<tr>
						    <td align="right"  width="200"><font class="boldTextBlack">Section E:&nbsp;</font></td>						  
						    <td width = "200"><%=statusLink(rstData("SectionE"),"Section E") %></td>
						</tr>
					</table>
					<br />					
				</td>
			</tr>
	    </table>		
    </form>
	<!-- #include file="shared/page_footer.asp" -->
</body>
</html>
<%
	call close_adodb(rstData)
	call close_adodb(conn)
end if

function StatusLink(Status,Section)    
	if Status then 
		StatusLink = "&nbsp;&nbsp;<img border=""0"" src=""images\UCLAOK.png"" alt=""Complete"" name=""Complete"" title=""Complete"" height=""20""/>&nbsp;&nbsp;<font class=""regTextGreen"">Complete<font>"			
	else
	    StatusLink = "&nbsp;&nbsp;<a class=""reglinkMaroon"" href=""javascript:GoToEDIQuestionnaireSection('teacher_questionnaire.asp','" & session("childID") & "','" & Section & "');""><img border=""0"" src=""images\UCLARequired.png"" alt=""Incomplete"" name=""Incomplete"" title=""Incomplete"" height=""20""/>&nbsp;&nbsp;Incomplete</a>"
	end if 
End Function
%>
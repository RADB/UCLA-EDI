<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/configuration.asp" -->
<!-- #include file="shared/UCLAQuestionnaireBuilder.asp" -->
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
    
	call open_adodb(conn, "UCLAEDI")
	set rstData = Server.CreateObject("ADODB.Recordset")
    set rstConfig = Server.CreateObject("ADODB.Recordset")	
'        response.write Request.Form("Action").Count 
    if Request.Form("Action").Count > 0  then     
	    If Request.Form("Action") = "Update" then 	     
	        strSQL = "UPDATE dbo.[Teacher] SET "			        
		   
		    for each item in Request.Form		        		 
		        if NOT (item = "QuestionnaireID" OR item = "Action" OR item = "frmSection" OR item = "frmNextChild" OR item = "BirthDateDay" OR item = "BirthDateYear" OR item = "BirthDateMonth" OR item = "CompletionDateDay" OR item = "CompletionDateYear" OR item = "CompletionDateMonth" OR item = "btnSave" OR item = "hdnLock" OR item = "Student" OR item ="EDIID" OR item ="XML" or item="CurrentSection" or item="GoToSection" or item="hdnCheckBoxes") then 
			        blnUpdate = true
			        if lcase(right(item,4)) = "date" then 
			            strSql = strSql & item & " = " & checkDate(Request.Form(item)) & ","
			        else
				        strSql = strSql & item & " = " & checkValue(Request.Form(item)) & ","
			        end if 
		        end if 
	        next		    
			
			' deal with the checkboxes
			for each item in split(request.form("hdnCheckBoxes"),",")
			    if request.form(item).count = 0 then 
			        strSql = strSql & item & " = 0,"
			    end if 
			next 
			
	        ' remove the last comma
	        strSql = left(strSql,len(strSql)-1) & " WHERE teacherID = '" & session("teacherID") & "'"			    
			
	        if blnUpdate then 
		        'Response.Write strSql
		        conn.execute strSql 
		        
		        strSQL = "INSERT INTO [AuditTeacher] (SessionID, TeacherID,QuestionnaireID) VALUES(" & session.SessionID & "," & session("TeacherID") & "," & request.form("QuestionnaireID") & ")"    			        		        
		        conn.execute strSql
	        end if 
						
	        ' if no errors then update other
	        if conn.errors.count = 0 then 					
	            strDataUpdateStatus = "<font class=""regTextGreen"">Teacher Feedback Data saved successfully.</font><br/><br/>"
	        else
	            strDataUpdateStatus = "<font class=""regTextRed"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
	        end if 
		end if 
	end if 
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();">
	<!-- #include file="shared/page_header.asp" -->		
		<br />
		<a class="reglinkMaroon" href="teacher.asp"><%=strHome%></a>&nbsp;<font class="regTextBlack"></font>&nbsp;<font class="boldTextBlack"><%=lblTrainingFeedback%></font>
		<table border="1"  bordercolor="006600" cellpadding="0" cellspacing="0" width="760">
		    <tr><td>
			    <form name="TeacherFeedback" method="post" action="teacher_feedback.asp"> 
			    <input type="hidden" name="CurrentSection" value="Teacher.Feedback" />
                <input type="hidden" name="QuestionnaireID" value="10" />
			    <table border="0" cellpadding="0" cellspacing="0" width="750" align="center">
			        <tr>
				        <td align="left" width="550"><%=strDataUpdateStatus %></td>
				        <td align="right">
					        <input type="hidden" name="Action" value="">										        				
					        <%if strError = "" then %>
					        <input type="button" value="<%=strSave%>" id="btnUpdate" name="btnUpdate" onClick="javascript:update_TeacherFeedbackCheck('Update');">
					        <%end if %>
					        <input type="button" value="<%=strExit%>" id="btnExit" name="btnExit" onClick="javascript:window.location='teacher.asp';">
					        &nbsp;
				        </td>
			        </tr>
			        <!-- show error if any -->
			        <tr><td colspan="2"><%=strError%></td></tr>
			        <!-- end error-->
			    </table>			      			    
			    <table border="1" width="760" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                           <%
                            Table = "Teacher"  
                            DataView = Table
                            QuestionnaireID = 10	
                            '*******************************************************************
                            ' Questionnaire Start
                            '*******************************************************************
                            ' get the checklist data
                            strSql = "SELECT * FROM [" & DataView & "] WHERE EDIYear = " & EDIYear & " AND teacherID = '" & session("TeacherID") & "'"                            
                            'response.write strsql
                            '*******************************************************************
				            ' Start - Questionnaire
				            '******************************************************************* 				
                            call buildQuestionnaire
                            '*******************************************************************
				            ' End - Questionnaire
				            '******************************************************************* 				
                            %>			   
	                    </td>
	                </tr>
                </table>	
                <input type="hidden" name="hdnCheckBoxes" value="<%=strCheckBoxes %>" />
			    <table border="0" cellpadding="0" cellspacing="0" width="750" align="center">
			        <tr>
				        <td align="right" width="550"></td>
				        <td align="right">					        
					        <%if strError = "" then %>
					        <input type="button" value="<%=strSave%>" id="btnUpdate2" name="btnUpdate2" onClick="javascript:update_TeacherFeedbackCheck('Update');">
					        <%end if %>
					        <input type="button" value="<%=strExit%>" id="btnExit2" name="btnExit2" onClick="javascript:window.location='teacher.asp';">
					        &nbsp;
				        </td>
			        </tr>
			        <!-- show error if any -->
			        <tr><td colspan="2"><%=strError%></td></tr>
			        <!-- end error-->
			    </table>			 
			    </form>			    
		    </td></tr>
		</table>			
	<!-- #include file="shared/page_footer.asp" -->
</body>
</html>
<%
	' close and kill recordset and connection
	call close_adodb(rstConfig)
	call close_adodb(rstData)
	call close_adodb(conn)
end if
%>
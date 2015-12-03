<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/UCLAQuestionnaireBuilder.asp" -->  
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
    
    call open_adodb(conn,"UCLAEDI")
    set rstData = Server.CreateObject("ADODB.Recordset")
    set rstConfig = Server.CreateObject("ADODB.Recordset")
    dim strChildID 
    blnShowStatus = false
    
    
    if Request.Form("frmAction").Count > 0 then 
        If Request.Form("frmAction") = "Update" then 
            if Request.form("Locked") = "False"  Then
                select case Request.Form("CurrentSection")
                    ' Change 2010 3.2.1-2 a - Checklist to Demographics
	                'case "Checklist"		            
                    case "Demographics"
		                strSQL = "UPDATE dbo.[ChildChecklist] SET "			        
		            case "Section A"
		                strSQL = "UPDATE dbo.[ChildSectionA] SET "
		            case "Section B"
		                strSQL = "UPDATE dbo.[ChildSectionB] SET "
		            case "Section C"
		                strSQL = "UPDATE dbo.[ChildSectionC] SET "
		            case "Section D"
		                strSQL = "UPDATE dbo.[ChildSectionD] SET "       
		            case "Section E"
		                strSQL = "UPDATE dbo.[ChildSectionE] SET "			        
	            End Select
        	    		    
	            for each item in Request.Form		        		 
	                if NOT (item="OriginalCityChildResidesIn" OR item="OriginalChildAddress" OR item="OriginalSchoolChildID" OR item="CityChildResidesIn" OR item="ChildAddress" OR item="SchoolChildID" OR item="Source" OR item = "GoToChildID" OR item = "QuestionnaireID" OR item = "frmAction" OR item = "frmSection" OR item = "frmNextChild" OR item = "BirthDateDay" OR item = "BirthDateYear" OR item = "BirthDateMonth" OR item = "CompletionDateDay" OR item = "CompletionDateYear" OR item = "CompletionDateMonth" OR item = "btnSave" OR item = "Locked" OR item = "Student" OR item ="ChildID" OR item ="XML" or item="CurrentSection" or item="GoToSection" or item="hdnCheckBoxes") then 
		                blnUpdate = true
		                'if left(item ,3) = "str" then
			             '   strSql = strSql & item & " = " & checknull(Request.Form(item)) & ","
		                'else
		                if lcase(right(item,4)) = "date" then 
		                    strSql = strSql & item & " = " & checkDate(Request.Form(item)) & ","
		                else
			                strSql = strSql & item & " = " & checkValue(Request.Form(item)) & ","
		                end if 
	                end if 
                next
        		
		        ' deal with the checkboxes
		        for each item in split(request.form("hdnCheckBoxes"),",")
		            'response.write item
		            if request.form(item).count = 0 then 
		                strSql = strSql & item & " = 0,"
		            end if 
		        next 
        		
                ' remove the last comma
                'strSql = left(strSql,len(strSql)-1) & " WHERE ChildID = '" & request.form("ChildID") & "'"			    
                ' 2012-11-20 update modified date and user
                strSql = strSql & "modifiedDate = " & checkDate(now) & ", modifiedUser = " & checkValue(session("id")) & " WHERE ChildID = '" & request.form("ChildID") & "'"			    
        		
                if blnUpdate then 
	                'Response.Write strSql
	                conn.execute strSql 
        	               		        
	                strSQL = "INSERT INTO [AuditChild] (SessionID,EDIID, TeacherID,QuestionnaireID) VALUES(" & session.SessionID & "," & request.form("ChildID") & "," & session("TeacherID") & "," & request.form("QuestionnaireID") & ")"    			        
	                'Response.Write strSql
	                conn.execute strSql
                end if 
        					
                ' if no errors then update other
                if conn.errors.count = 0 then 					
                    strDataUpdateStatus = "<font class=""regTextGreen"">" & request.form("CurrentSection") & " Data saved successfully.</font><br/><br/>"
                else
                    strDataUpdateStatus = "<font class=""regtextred"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
                end if 
                                
                if request.form("OriginalCityChildResidesIn") <> request.form("CityChildResidesIn") OR request.form("OriginalChildAddress") <> request.form("ChildAddress") OR request.form("OriginalSchoolChildID") <> request.form("SchoolChildID") then
                    strSQL = "UPDATE dbo.child SET CityChildResidesIn = " & checkValue(request.form("CityChildResidesIn")) & ", ChildAddress=" & checkValue(request.form("ChildAddress")) & ", SchoolChildID = " & checkValue(request.form("SchoolChildID")) & " WHERE childID = " & request.form("ChildID")
                    'response.write strSql
                    conn.execute strSql
                    if conn.errors.count = 0 then 					
                        strDataUpdateStatus = strDataUpdateStatus & "<font class=""regTextGreen"">Child Demographics saved successfully.</font><br/><br/>"
                    else
                        strDataUpdateStatus = strDataUpdateStatus  & "<font class=""regtextred"">Error Number : " & conn.errors(0).number & "<br /><br />Description : " & makeReadable(conn.errors(0).description) & "<br/><br/></font>"
                    end if 
                end if 
            end if ' locked 
                      
            if request.Form("Source") = "Exit" then 
                response.Redirect("teacher_class.asp")
            end if
            
            if request.Form("Source") = "Check" then 
                session("childID") = request.form("ChildID")                
                response.Redirect("teacher_questionnairelock.asp")                
            end if                                                 
                        
            if request.form("GoToChildID") <> "" then                    
                strChildID = request.form("GoToChildID")
            else 
                if request.form("childID") <> "" then                    
                    strChildID = request.form("childID")
                else
                    ' GET DEFAULT 
                    strChildID = 1
                end if 
            end if             
	    end if 
	elseif request.form.count >0 then 
	    ' entry from class list	
	    response.Write request.Form("Source")
	    ' GET DEFAULT 
	    if request.form("childID") <> "" then                    
            strChildID = request.form("childID")
        else
            ' GET DEFAULT 
            strChildID = 1
        end if 
        
        if request.Form("showStatus") = "True" then 
            blnShowStatus = true                
        end if 
	else
        
        response.redirect("teacher_class.asp")
        '******************************
        ' NO ID - SEND TO CLASS LIST!!!
        '******************************
    end if 
    
        dim Table 
    dim QuestionnaireID              
                                  
    '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	' EDI SECTIONS
	'		- determine which section and show those questions
    ' Change 2010 3.2.1-2 a - Checklist to Demographics
	'///////////////////////////////////////////////////////////////////
    'if Request.Form("GoToSection").Count = 0 OR Request.Form("GoToSection") = "Checklist" OR Request.Form("GoToSection") = "" then
    if Request.Form("GoToSection").Count = 0 OR Request.Form("GoToSection") = "Demographics" OR Request.Form("GoToSection") = "" then
        'strSection = "Checklist"
        strSection = "Demographics"
    else
        strSection = Request.Form("GoToSection")
    end if                

	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	' CHECKLIST SECTION 
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	select case strSection	
    ' Change 2010 3.2.1-2 a - Checklist to Demographics
	    'CASE "Checklist"
        CASE "Demographics"
	        Table = "ChildChecklist"
	        DataView = "GetDataChildChecklist"
            QuestionnaireID = 1
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	' SECTION A 
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    CASE "Section A"
	        Table = "ChildSectionA"  
            DataView = Table
            QuestionnaireID = 2	
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	' SECTION B Language and Cognitive Skills 
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    CASE "Section B"
	        Table = "ChildSectionB"  
            DataView = Table
            QuestionnaireID = 3	
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	' SECTION C Physical Well Being 
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    CASE "Section C"
	        Table = "ChildSectionC"  
            DataView = Table
            QuestionnaireID = 4								
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	' SECTION D Physical Well Being 
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    CASE "Section D"
	        Table = "ChildSectionD"  
	        DataView = Table
            QuestionnaireID = 5                        
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	' SECTION E Physical Well Being 
	'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    CASE "Section E"
            Table = "ChildSectionE"  
            DataView = Table
            QuestionnaireID = 6			                        	
	end select
    
	  '***********************************************************
    ' start - previous and next child ID's
    '*********************************************************** 
    strSQL = "exec dbo.GetChildDetails " & strChildID                
    rstData.Open strSql, conn
    if not rstData.eof then         
        strEDIID = rstData("EDIID")
        localID = rstData("LocalID")
        address = rstData("Address")
        city = rstData("City")
        state = rstData("State")
        IsLocked = rstData("IsLocked")
        nextChild = rstData("next")
        previousChild = rstData("previous")
        districtID = rstData("districtID")
        
        
        ' set the child lock status
        session("isChildLocked")= isLocked
        
        ' only show the buttons when on the checklist
        if strSection = "Checklist" then 
            if isnull(rstData("previous")) then                                   
                strPrevious = ""
            else
                strPrevious = "<a class=""webButtonNavigation"" href=""javascript:SaveUCLAEDIChild('" & strChildID & "','" & previousChild & "','" & strSection & "','" & QuestionnaireID & "');""  style=""background-image:url(images/UCLAPreviousChild.png);"" />"
            end if 
            
            if isnull(rstData("next")) then                                   
                strNext = ""
            else
                strNext = "<a class=""webButtonNavigation"" href=""javascript:SaveUCLAEDIChild('" & strChildID & "','" & nextChild & "','" & strSection & "','" & QuestionnaireID & "');"" style=""background-image:url(images/UCLANextChild.png);"" />"
            end if 
        end if 
        
        if IsLocked then
            strLock = "<img border=""0"" src=""images\UCLALocked.png"" alt=""Locked"" name=""Locked"" /><font class=""boldTextGreen"">&nbsp;Complete and Locked</font>"
            strCheck = ""            
        else
            'strLock = "<img border=""0"" src=""images\UCLAUnlocked.png"" alt=""Unlocked"" name=""Unlocked"" /><font class=""boldTextBlack"">&nbsp;Unlocked</font>"
            strLock = "<a class=""boldLinkBlue"" href=""javascript:SaveUCLAEDI('" & strChildID & "','" & strSection & "','" & strSection & "','" & QuestionnaireID & "','Check');""><img border=""0"" src=""images\UCLACheck.png"" alt=""Check"" name=""Check"" />&nbsp;Check for Completeness</a>"
        end if             
    else
        strPrevious = ""
        strNext = ""
    end if 

    rstData.close
	    
	if strChildID > 0 then     
	    strSql = "exec dbo.CompletionCheck " & strchildID		
        dim sectionComplete(5)		        
        rstData.Open strSql, conn                                                                                
		sectionComplete(0) = rstData("checklist")
		sectionComplete(1) = rstData("sectionA")
		sectionComplete(2) = rstData("sectionB")
		sectionComplete(3) = rstData("sectionC")
		sectionComplete(4) = rstData("sectionD")
		sectionComplete(5) = rstData("sectionE")
		statusQuestion = rstData("status")
	else
	    response.redirect "teacher_class.asp"
	end if 
	
	rstData.close
     '***********************************************************
    ' end  - previous and next child ID's
    '***********************************************************
%>
<html>
<!-- #include file="shared/head.asp" -->
<body onload="StartClock24();checkStatus('<%= statusQuestion%>');" oncontextmenu="return false;">
    <!-- #include file="shared/page_header.asp" -->
      
    <form id="Children" name="Children" method="post" action="teacher_questionnaire.asp">  
    	<input type="hidden" name="ChildID" value="" />		
		<input type="hidden" name="frmAction" value="" />
		<input type="hidden" name="CurrentSection" value="" />
        <input type="hidden" name="QuestionnaireID" value="" />
		<input type="hidden" name="GoToSection" value="" />		
		<input type="hidden" name="GoToChildID" value="" />			
		<input type="hidden" name="Locked" value="<%=IsLocked %>" />	
		<input type="hidden" name="Source" value="" />	
		<!--<input type="hidden" name="frmNextChild" value="" />-->
		<a class="reglinkMaroon" href="teacher.asp">Home</a>&nbsp;<font class="regTextBlack">></font>&nbsp;<a class="reglinkMaroon" href="teacher_class.asp">Teacher Classes</a>&nbsp;<font class="regTextBlack">></font>&nbsp;<font class="boldTextBlack">EDI Questionnaire</font>
        <table border="1" style="border-color:#0084A8;" cellpadding="0" cellspacing="0" width="760">
			<tr>
				<td>
				    
					<table border="0" cellpadding="0" cellspacing="0" width="750" align="center">
						<tr>
							<td align="right" width="400"><font class="headerBlue">EDI Questionnaire(<%=localID%>)</font></td>
							<td align="right">
								<input type="button" value="<%=strClassList%>" name="Exit" onclick="javascript:SaveUCLAEDI('<%=strChildID %>','<%=strSection%>','<%=strSection%>','<%=QuestionnaireID%>','Exit');" id="Exit" />
								&nbsp;
								<input type="button" value="Cancel" name="Cancel" onclick="javascript:window.location='teacher_class.asp';" id="Cancel" />
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
					<table border="0" cellpadding="0" cellspacing="0" width="750" align="center">
						<tr>
						    <td align="right"><font class="boldTextBlack">School Child ID:&nbsp;</font></td>
						    <%response.Write buildTextInput("SchoolChildID",50,localID,1) %>
						    <%response.Write buildHiddenInput("OriginalSchoolChildID",localID) %>
						    <td width = "350" rowspan="2"><%=strLock %></td>
						</tr>
						<tr>
						    <td align="right"><font class="boldTextBlack">Address:&nbsp;</font></td>
						    <%response.Write buildTextInput("ChildAddress",200,address,1) %>						    
						    <%response.Write buildHiddenInput("OriginalChildAddress",address) %>
						</tr>
						<tr>
						    <td align="right"><font class="boldTextBlack">City:&nbsp;</font></td>
						    <%response.Write buildTextInput("CityChildResidesIn",200,city,1) %>
						    <%response.Write buildHiddenInput("OriginalCityChildResidesIn",city)
						    response.write "<td width = ""350"">&nbsp;</td>"						    
						    %>
						</tr>
						<tr>
						    <td align="right"><font class="boldTextBlack">State:&nbsp;</font></td>
						    <%response.Write buildReadonlyTextInput("State",200,state,1, False) %>
						    <td width = "350">&nbsp;</td>
						</tr>						
					</table>
					<br />					
				</td>
			</tr>
	    </table>
		
        <table border="1" width="760" cellpadding="0" cellspacing="0">
            <tr><td align="center">
                <%                																
				
				'*******************************************************************
				' Start - Navigation
				'*******************************************************************
				
                ' build the navigation bar
                strNavigation = getNavigation(strSection,strChildID,QuestionnaireID)
                
                ' write the navigation bar
                response.write strNavigation
                '*******************************************************************
				' End - Navigation
				'*******************************************************************
				
                ' get the checklist data
                strSql = "SELECT * FROM [" & DataView & "] WHERE childID = '" & strChildID & "'"
                '*******************************************************************
				' Start - Questionnaire
				'******************************************************************* 				
                call buildQuestionnaire
                '*******************************************************************
				' End - Questionnaire
				'******************************************************************* 				
											
				' write the navigation bar
                response.write strNavigation
                %>	        
	        </td></tr>
        </table>	
        <input type="hidden" name="hdnCheckBoxes" value="<%=strCheckBoxes %>" />
        	
    </form>	
    <!-- #include file="shared/page_footer.asp" -->
</body>
</html>
<%
    call close_adodb(rstConfig)
	call close_adodb(rstData)
	call close_adodb(conn)
end if 
%>
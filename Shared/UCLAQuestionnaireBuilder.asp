<%
dim aLU
dim strCheckBoxes

sub buildQuestion(strColour,QuestionNumber, QuestionText, strColumnName,currentvalue,inputType, rowcounter, lookupTable,lookupID, Orientation, repeatLookup,colspan,columns,maxlength, IsSecondColumn,hasNotification,notification,notificationCondition)
	if IsSecondColumn = "False" then 
		'response.write rowCounter & strColumnName & "=" & currentvalue & orientation & repeatlookup
		Response.Write "<tr bgcolor=""" & strColour & """>"		           
		response.write "<td align=""left"" valign=""top"" width=""50""><font class=""boldTextBlack"">" &  QuestionNumber & "</font></td>" 
		Response.Write "<td align=""left"" width=""480"" valign=""top""><font class=""boldTextBlack"">" & QuestionText  & "</font></td>"
    end if 
    
	SELECT CASE inputType
		CASE "Radio"
			if RepeatLookup then
				response.write buildRadioInputWithRepeat(strColumnName,currentvalue)
			elseif hasNotification 	then 
				response.write buildRadioInputWithTextAndNotification(lookupTable,strColumnName,Orientation,currentvalue,lookupID,notification,notificationcondition) 				
			else
				response.write buildRadioInputWithText(lookupTable,strColumnName,Orientation,currentvalue,lookupID) 				
			end if 
		CASE "Text"
			response.write buildTextInput(strColumnName, maxlength, currentvalue,colspan)
		CASE "ReadonlyText"
			response.write buildReadonlyTextInput(strColumnName, maxlength, currentvalue,colspan,true)
		CASE "Numeric"
		     response.write buildNumericTextInput(strColumnName, maxlength, CurrentValue, colspan)
		CASE "Textarea"
			response.write buildTextareaInput(strColumnName, 50, currentvalue, Colspan,columns)					
		CASE "Checkbox"
            response.write buildCheckBox(strColumnName, currentvalue)
		CASE "Date"			
			if isDate(currentvalue)  then 
				response.write buildDateInput(strColumnName, year(currentvalue),month(currentvalue),day(currentvalue),colspan)'buildNullDateInput(strColumnName)	
			else
				response.write buildNullDateInput(strColumnName,colspan)	
			end if 
		CASE "Select"
			response.write buildSelectInput(LookupTable,strColumnName,currentvalue, lookupID,colspan)                               
		CASE Else
			response.write "<td><font class=""boldTextBlack"">New Question Type</font></td>"
	END SELECT
end sub

Function buildHeader(header, Colour, hasHelp)      	
    strHeader = "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"">"																																	    
    strHeader = strHeader & "<tr bgcolor="""& colour&""">"
	strHeader = strHeader & "<td align=""left"" valign=""top"" width=""750""><font class=""subHeaderBlue"">" & header & "</font></td>"
    if hasHelp then
        strHeader = strHeader & getHelpLink
    end if 
    strHeader = strHeader & "</tr>"
    strHeader = strHeader & "</table>"
 
    buildHeader = strHeader
end function 

Function buildQuestionHeader(header, tableName, lookupID)
    strHeader = "<td colspan=""2"" align=""left"" valign=""top"" width=""530""><font class=""subHeaderBlue"">" &  header & "</font></td>"
    aLU = getLookupValues(tableName, lookupID)
        
    for row = 0 to ubound(aLU,2)
        Name = aLU(0,row)
        Value = aLU(1,row)
        colwidth = 230/(ubound(aLU,2)+1)
    	    	
        strHeader= strHeader & "<td align=""center"" valign=""middle"" width=""" & colwidth & """><font class=""boldTextBlack"">" & name & "</font></td>"				
        
        ' if has help - helpicon
    next         
    
    buildQuestionHeader = strHeader
end function 

Function buildRadioInputWithRepeat(columnName,CurrentValue)       
    
    for row = 0 to ubound(aLU,2)
        Name = aLU(0,row)
        Value = aLU(1,row)
    
    	strRadioButtons = strRadioButtons & "<td align=""center"" valign=""middle"">"
    	strRadioButtons = strRadioButtons & "<input type=""radio"" title=""" & Name &""" id=""" & columnName & """ name=""" & columnName & """ value=""" & value & """"
		if value = currentValue then 
			strRadioButtons = strRadioButtons & " checked=""checked"""
		end if 
		strRadioButtons = strRadioButtons & " />"				
		strRadioButtons = strRadioButtons & "</td>"	
    next 
        
    buildRadioInputWithRepeat = strRadioButtons
end Function

Function buildRadioInputWithText(tableName,columnName,Orientation, CurrentValue,lookupID) 
    aLU = getLookupValues(tableName,lookupID)
    
    strRadioButtons = "<td align=""left"" valign=""middle"">"
    for row = 0 to ubound(aLU,2)
        Name = aLU(0,row)
        Value = aLU(1,row)
    	
    	strRadioButtons = strRadioButtons & "<input type=""radio"" title=""" & Name &""" id=""" & columnName & """ name=""" & columnName & """ value=""" & value & """"
		if value = currentValue then 
			strRadioButtons = strRadioButtons & " checked=""checked"""
		end if 
		strRadioButtons = strRadioButtons & "><font class=""regTextBlack"">" & name & "</font></input>"
		
		' vertical radio buttons or horizontal
		if trim(Orientation) = "Vertical" then 
		    strRadioButtons = strRadioButtons & "<br />"
		end if 
    next 
    strRadioButtons = strRadioButtons & "</td>"
    
    buildRadioInputWithText = strRadioButtons
end Function

Function buildRadioInputWithTextAndNotification(tableName,columnName,Orientation, CurrentValue,lookupID,notification,notificationCondition) 
    aLU = getLookupValues(tableName,lookupID)
    //onchange="javascript:checkStatus(this.selectedIndex,'Student must be currently in your class to do the EDI.  If the child is currently in your class but has been there for less than one month do not complete the rest of the form, save and lock the questionnaire.');    
    
    strRadioButtons = "<td align=""left"" valign=""middle"">"
    for row = 0 to ubound(aLU,2)
        Name = aLU(0,row)
        Value = aLU(1,row)
    	
    	strRadioButtons = strRadioButtons & "<input type=""radio"" onclick=""javascript:if(this.value" & notificationCondition & "){sendNotification('"&notification&"')};"" title=""" & Name &""" id=""" & columnName & """ name=""" & columnName & """ value=""" & value & """"
		if value = currentValue then 
			strRadioButtons = strRadioButtons & " checked=""checked"""
		end if 
		strRadioButtons = strRadioButtons & "><font class=""regTextBlack"">" & name & "</font></input>"
		
		' vertical radio buttons or horizontal
		if trim(Orientation) = "Vertical" then 
		    strRadioButtons = strRadioButtons & "<br />"
		end if 
    next 
    strRadioButtons = strRadioButtons & "</td>"
    
    buildRadioInputWithTextAndNotification = strRadioButtons
end Function



Function buildReadonlyTextInput(columnName, MaxLength, CurrentValue, colspan, systemGenerated)
    'on error resume next
    
    strText = "<td align=""left"" valign=""middle"" colspan=""" & colspan & """><input style=""background-color:lightgray"" type=""text"" size=""25"" id=""" & columnName & """ name=""" & columnName & """ value=""" & currentvalue & """ maxlength=""" & MaxLength & """ readonly disabled=""disabled""/>"
	
	if systemGenerated then 
		strText = strText & "<br /><span style=""color:red;"">*** Note: field is readonly & system generated</span>"
	end if 
	
	strText = strText & "</td>"
    
    buildReadonlyTextInput = strText
end Function

Function buildTextInput(columnName, MaxLength, CurrentValue, colspan)
    'on error resume next
    
     strText = "<td align=""left"" valign=""middle"" colspan=""" & colspan & """><input type=""text"" size=""25"" id=""" & columnName & """ name=""" & columnName & """ value=""" & currentvalue & """ maxlength=""" & MaxLength & """ /></td>"
    
    buildTextInput = strText
end Function

Function buildNumericTextInput(columnName, MaxLength, CurrentValue, colspan)
    'on error resume next    
    strText = "<td align=""left"" valign=""middle"" colspan=""" & colspan & """><input type=""text"" onkeydown=""javascript:maskInput()"" size=""25"" id=""" & columnName & """ name=""" & columnName & """ value=""" & currentvalue & """ maxlength=""" & MaxLength & """ /></td>"
    
    buildNumericTextInput = strText
end Function


Function buildTextAreaInput(columnName, MaxLength, CurrentValue,colspan,columns)
    'on error resume next
    
    strText = "<td align=""left"" valign=""middle"" colspan="""& colspan &"""><textarea rows=""3"" cols="""& columns &""" id=""" & columnName & """ name=""" & columnName & """>" & currentvalue & "</textArea></td>"
    
    buildTextAreaInput = strText
end Function

Function buildDateInput(columnName, CurrentYear, CurrentMonth, CurrentDay, colspan)
    ' Month                    
    strDate = strDate & "<td align=""left"" valign=""middle""  colspan=""" & colspan & """>"           
	strDate = strDate & "<select id=""" & columnName & "Month"" name=""" & columnName & "Month"" onChange=""javascript:changeMonth('" & columnName & "',document.Children." & columnName & "Day.value);document.Children." & columnName & ".value = document.Children." & columnName & "Year.value + '-' + document.Children." & columnName & "Month.value + '-' + document.Children." & columnName & "Day.value"";>"
	strDate = strDate & "<option value=""-1""></option>"
	for introw = 1 to 12
	    strDate = strDate & "<option value = """ & intRow & """"
	    if currentMonth = intRow then 
		    strDate = strDate & " selected=""selected"""
	    end if 

		strDate = strDate & ">" & monthname(intRow,false) & "</option>"
	next				
	strDate = strDate & "</select>"
	
	'Day
	strDate = strDate & "<select id=""" & columnName & "Day"" name=""" & columnName & "Day"" onChange=""javascript:document.Children." & columnName & ".value = document.Children." & columnName & "Year.value + '-' + document.Children." & columnName & "Month.value + '-' + document.Children." & columnName & "Day.value "";>"
	strDate = strDate & "<option value=""-1""></option>"
	
	for introw = 1 to getDaysInMonth(CurrentMonth, CurrentYear)
		strDate = strDate & "<option value = """ & intRow & """"
		if CurrentDay = intRow then 
			strDate = strDate &  " selected=""selected"""
		end if 
		' write the day
		strDate = strDate &  ">" & intRow & "</option>"
	next
	strDate = strDate & "</select>"
	 
	'Year   
	strDate = strDate & "<select id=""" & columnName & "Year"" name=""" & columnName & "Year"" onChange=""javascript:document.Children." & columnName & ".value = document.Children." & columnName & "Year.value + '-' + document.Children." & columnName & "Month.value + '-' + document.Children." & columnName & "Day.value "";>"
	strDate = strDate & "<option value=""-1""></option>"				
	for introw = 1 to 10
		strDate = strDate & "<option value = """ & intRow + year(date)-10 & """"
		if CurrentYear = intRow + year(date)-10 then 
			strDate = strDate &  " selected=""selected"""
		end if 
		' write the day
		strDate = strDate & ">" & intRow + year(date)-10 & "</option>"
	next				
	strDate = strDate & "</select>"
	strDate = strDate & "<input type=""hidden"" name=""" & columnName & """ value=""" & currentYear & "-" & currentmonth & "-" & currentDay & """ />"
	strDate = strDate & "</td>"
    
    buildDateInput = strDate
end Function

Function buildNullDateInput(columnName, colspan)
    ' Month                    
    strDate = strDate & "<td align=""left"" valign=""middle""  colspan=""" & colspan & """>"           
	strDate = strDate & "<select id=""" & columnName & "Month"" name=""" & columnName & "Month"" onChange=""javascript:changeMonth('" & columnName & "',document.Children." & columnName & "Day.value);document.Children." & columnName & ".value = document.Children." & columnName & "Year.value + '-' + document.Children." & columnName & "Month.value + '-' + document.Children." & columnName & "Day.value"";>"
	strDate = strDate & "<option value=""-1""></option>"
	for introw = 1 to 12
	    strDate = strDate & "<option value = """ & intRow & """>" & monthname(intRow,false) & "</option>"		
	next				
	strDate = strDate & "</select>"
	
	'Day
	strDate = strDate & "<select id=""" & columnName & "Day"" name=""" & columnName & "Day"" onChange=""javascript:document.Children." & columnName & ".value = document.Children." & columnName & "Year.value + '-' + document.Children." & columnName & "Month.value + '-' + document.Children." & columnName & "Day.value "";>"
	strDate = strDate & "<option value=""-1""></option>"
	
	for introw = 1 to getDaysInMonth(1, 2009)
		strDate = strDate & "<option value = """ & intRow & """"
		if CurrentDay = intRow then 
			strDate = strDate &  " selected=""selected"""
		end if 
		' write the day
		strDate = strDate &  ">" & intRow & "</option>"
	next
	strDate = strDate & "</select>"
	 
	'Year   
	strDate = strDate & "<select id=""" & columnName & "Year"" name=""" & columnName & "Year"" onChange=""javascript:document.Children." & columnName & ".value = document.Children." & columnName & "Year.value + '-' + document.Children." & columnName & "Month.value + '-' + document.Children." & columnName & "Day.value "";>"
	strDate = strDate & "<option value=""-1""></option>"				
	for introw = 1 to 10
		strDate = strDate & "<option value = """ & intRow + year(date)-10 & """"
		if CurrentYear = intRow + year(date)-10 then 
			strDate = strDate &  " selected=""selected"""
		end if 
		' write the day
		strDate = strDate & ">" & intRow + year(date)-10 & "</option>"
	next				
	strDate = strDate & "</select>"
	strDate = strDate & "<input type=""hidden"" name=""" & columnName & """ value="""" />"
	strDate = strDate & "</td>"
    
    buildNullDateInput = strDate
end Function

function buildCheckBox(columnname,currentvalue)
    strCheck = "<td align=""center""><input type=""checkbox"" value=""true"" id=""" & columnname & """ name=""" & columnname & """"
    if currentvalue = true then 
        strCheck = strCheck & " checked=""CHECKED"""
    end if                                      
    strCheck = strCheck & "/></td>"
    
    if len(strCheckBoxes) > 0 then 
        strCheckboxes = strCheckboxes & ","
    end if 
    
    strCheckboxes = strCheckboxes & columnname 
    
    buildcheckbox = strCheck    
End function


Function buildSelectInput(tableName,columnName,CurrentValue,LookupID, colspan)               
    if isnull(tablename) Then 
        dim aLU(2,100)
        ' no lookup - load with integer values
        for i = 0 to 100 
            aLU(0,i) = i
            aLU(1,i) = i
        next
    else        
        ' get the lookup values
        aLU = getLookupValues(tableName,lookupID)
    end if 
    
    strSelect = "<td align=""left"" valign=""middle"" colspan=""" & colspan & """>"
    strSelect = strSelect & "<select name=""" & columnName & """ id=""" & columnName & """>"
	strSelect = strSelect & "<option value=""-1""></option>"										
	
	if currentValue = 255 then 			
		strSelect = strSelect & "<option value=""255"" selected=""selected"">Unknown</option>"										
	else
		strSelect = strSelect & "<option value=""255"">Unknown</option>"										
	end if 
    
    for row = 0 to ubound(aLU,2)
        Name = aLU(0,row)
        Value = aLU(1,row)
    	
	    strSelect = strSelect & "<option value=""" & value & """"
		if value = currentValue then 			
			strSelect = strSelect & " selected=""selected"""
		end if 
		strSelect = strSelect & ">" & name & "</option>"		
    next 
    
    strSelect = strSelect & "</select>"    
    strSelect = strSelect & "</td>"
    
    buildSelectInput = strSelect
end Function

function buildHiddenInput(columnName, value)
    buildHiddenInput = "<input type=""hidden"" name=""" & columnName & """ value=""" & value & """ />"
end function

Function getLookupValues(tableName, lookupID)
    on error resume next
    
	set rstLU = Server.CreateObject("ADODB.Recordset")
	
	if tablename = "EDI.Config.Lookups" then
	    strSql = "SELECT [" & strLanguage & "],[Value] FROM [" & tableName & "] WHERE LookupID = " & lookupID & " ORDER BY [Sequence]"	
	else
	    strSql = "SELECT [" & strLanguage & "],[Value] FROM [" & tableName & "] ORDER BY [Sequence]"	
	end if 
	
	rstLU.Open strSql, conn, 1  
	
	if not rstLU.eof then 
		getLookupValues = rstLU.getrows
	end if 
	
	call close_adodb(rstLU)
end Function

function getDaysInMonth(strMonth,strYear)
dim strDays	 
    Select Case cint(strMonth)
        Case 1,3,5,7,8,10,12:
			strDays = 31
        Case 4,6,9,11:
		    strDays = 30
        Case 2:
		    if  ((cint(strYear) mod 4 = 0  and  cint(strYear) mod 100 <> 0) or ( cint(strYear) mod 400 = 0) ) then
		      strDays = 29
		    else
		      strDays = 28 
		    end if	
    End Select 
    
    getDaysInMonth = strDays

end function

function getNavigation(currentSection, strEDIID, QuestionnaireID)
    dim aSection(5)
    dim i
    dim currentSectionIndex

    ' Change 2010 3.2.1-2 a - Checklist to Demographics
    'aSection(0) = "Checklist"
    aSection(0) = "Demographics"
    aSection(1) = "Section A"
    aSection(2) = "Section B"
    aSection(3) = "Section C"
    aSection(4) = "Section D"
    aSection(5) = "Section E"
    
    i = 0
    strHTML = "<br />&nbsp;<input type=""button"" onclick=""javascript:goWindow('documents/EDI Teacher Guide 2012.pdf','Guide','490','500','top=0,left=125,resizable=yes');"" name=""btnGuide"" value=""GUIDE"" title=""GUIDE"" />"
    for each item in aSection       
		if sectionComplete(i) then 
			strNavClass = "UCLANavItemComplete"
			strNavSelectedClass = "UCLANavSelectedComplete"
		else 
			strNavClass = "UCLANavItem"
			strNavSelectedClass = "UCLANavSelected"
		end if 
        if item = currentSection then 
            'strHTML = strHTML & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font class=""UCLANavSelected"">" & item & "</font>"
			strHTML = strHTML & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font class="""&strNavSelectedClass&""">" & item & "</font>"
            currentSectionIndex = i
        else            
            'strHTML = strHTML & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=""javascript:SaveUCLAEDI('" & strEDIID & "','" & item & "','" & currentSection & "','" & QuestionnaireID & "','Navigation');"" class=""UCLANavItem"">" & item & "</a>"
			strHTML = strHTML & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=""javascript:SaveUCLAEDI('" & strEDIID & "','" & item & "','" & currentSection & "','" & QuestionnaireID & "','Navigation');"" class="""& strNavClass&""">" & item & "</a>"
        end if
		
		if sectionComplete(i) then 
			strHTML = strHTML & "</span>"
		end if 
        
        i = i + 1
    next 
    strHTML = strHTML & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=""button"" onclick=""javascript:SaveUCLAEDI('" & strEDIID & "','" & currentSection & "','" & currentSection & "'," & QuestionnaireID & ",'Save');"" name=""btnSave"" value=""" & lblSaveEDI & """ title=""" & lblSaveEDI & """ /><br />"    
    
    ' Change #49 - 2013-09
    if currentSectionIndex < 5 then 
        ' show save button and take them to the next section
		strHTML = strHTML & "<div class=""Save""><a id=""SaveNext"" class=""webButtonSaveNext"" href=""javascript:void(0);"" onclick=""javascript:SaveUCLAEDI('" & strEDIID & "','" & aSection(currentSectionIndex+1) & "','" & currentSection & "'," & QuestionnaireID & ",'Navigation');"" title=""" & lblSaveNextEDI & """ style=""background-image:url(images/SaveNext.png);""></a></div>"
        'strHTML = strHTML & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=""button"" onclick=""javascript:SaveUCLAEDI('" & strEDIID & "','" & aSection(currentSectionIndex+1) & "','" & currentSection & "'," & QuestionnaireID & ",'Navigation');"" name=""btnSave"" value=""" & lblSaveNextEDI & """ title=""" & lblSaveNextEDI & """ /><img border=""0"" src=""images\right.gif"" alt=""Next"" name=""Next"" align=""bottom"" /><br /><br />"        
    else
		strHTML = strHTML & "<div class=""Save""><a id=""SaveCheck"" class=""webButtonSaveCheck"" href=""javascript:void(0);"" onclick=""javascript:SaveUCLAEDI('" & strEDIID & "','" & currentSection & "','" & currentSection & "'," & QuestionnaireID & ",'Check');"" title=""" & lblSaveCheckEDI & """ style=""background-image:url(images/SaveCheck.png);""></a></div>"
	end if 

    getNavigation = strHTML
end function 

function getHelpLink()    
    getHelpLink = "<td><a href=""" & rstConfig("helpText") & """ target=""_blank""><img border=""0"" src=""images\UCLAHelp.png"" alt=""For Help See Guide"" name=""Help"" title=""For Help See Guide"" height=""20""/></a></td>"  
end Function

function getCulturallySensitiveLink()
    getCulturallySensitiveLink = "<td><a href=""" & rstConfig("helpText") & """ target=""_blank""><img border=""0"" src=""images\UCLACulturallySensitiveRedBackground.png"" alt=""Culturally Sensitive See Guide"" name=""CulturallySensitive"" title=""Culturally Sensitive See Guide"" height=""22""/></a></td>"  
end Function

function getNewSection()
    getNewSection = "</table><br /><table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"">"
end function															    		    

'*******************************************************************
' Questionnaire Start
'*******************************************************************
sub buildQuestionnaire()
    'response.write strsql
    rstData.Open strSql, conn
    if not rstData.eof then             		    
        strSql = "SELECT [English],[Spanish],[VariableName],[TableName],[ColumnName],[ColumnName2],[IsSectionHeader],[IsQuestionHeader],[IsHeader],[QuestionNumber],[HasLookupTable],[RepeatLookup],[LookupTable],[LookupID],[InputType],[maxlength],[Orientation],[colSpan],[newSection],[hasHelp], [helpText],[isCulturallySensitive],[TextAreaColumns],[isRequired],[isConditional],[condition],[hasNotification],[notificationCondition],[notification],[lookuptable2],[lookupid2]  FROM [dbo].[EDI.Config.Questionnaires] WHERE QuestionnaireID = " & QuestionnaireID & " AND EDIYear = " & EDIYear & " ORDER BY Sequence"
        					
        'open the demographic questions 
        rstConfig.Open strSql, conn

        ' Header	
        if not rstConfig.eof then 
            Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"">"																					
            Response.Write "<tr><td colspan=""3""><br /></td></tr>"
            Response.write "<tr><td width=""23%"" align=""right"">&nbsp;" & strPrevious & "</td><td width=""56%"" align=""center"" valign=""middle""><font class=""headerBlue"">" &  rstConfig(strLanguage) & "</font></td><td width=""23%"" align=""left"">&nbsp;" & strNext & "</td></tr>"
            Response.Write "<tr><td colspan=""3""><br /></td></tr>"
            Response.Write "</table>"		
            rstConfig.movenext
        end if 

        response.write "<br />"

        'Survey
        Response.Write "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"">"																															
        rowCounter = 0 

        do while not rstConfig.EOF 
            rowCounter = rowCounter + 1
            if rowCounter mod 2 = 1 then 
                strColour = "whitesmoke"
            else
                strColour = "white"
            end if 
        	
            if rstConfig("IsHeader") then 
                response.write "</table>"
                response.write "<br />"
                Response.Write buildHeader(rstConfig(strLanguage), strColour,rstConfig("hasHelp"))
                Response.Write "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"">"																																	    		    
            else
                if rstConfig("newSection") then 
                    response.write getNewSection                                
                end if 
                
                ' Check for headers 
                if rstConfig("IsQuestionHeader") then                             
                    'write the questions
                    
                    ' show the feedback                                        
                    if blnShowStatus then                                             
                        strCheck = isRequired(null)
                        select case strCheck
                            case "true" ' passed the condition for a required field
                                strColour = "#F8E0E0"
                                strRequired = "<img border=""0"" src=""images\UCLARequired.png"" alt=""Required"" name=""Required"" title=""Required"" height=""20""/>&nbsp;"
                            case "false" ' failed the required condition
                                strRequired = "<img border=""0"" src=""images\UCLAOK.png"" alt=""Required"" name=""OK"" title=""OK"" height=""20""/>&nbsp;"
                            case "na" ' when a condition is null
                                strRequired = ""
                        end select
                    else
                        strRequired = ""
                    end if 
                    
                    Response.Write "<tr bgcolor=""" & strColour & """>"		        
                    response.write buildQuestionHeader(strRequired & rstConfig(strLanguage), rstConfig("LookupTable"),cint(rstConfig("LookupID")))              
                else
                    'write the questions		            
                    strColumnName = rstConfig("columnName")                                  
                    currentvalue =  rstData(strColumnName)
                     
                     ' show the feedback                                        
                    if blnShowStatus then
                        strCheck = isRequired(currentValue)
                        select case strCheck
                            case "true" ' passed the condition for a required field
                                strColour = "#F8E0E0"
                                strRequired = "<img border=""0"" src=""images\UCLARequired.png"" alt=""Required"" name=""Required"" title=""Required"" height=""20""/>&nbsp;"
                            case "false" ' failed the required condition
                                strRequired = "<img border=""0"" src=""images\UCLAOK.png"" alt=""Required"" name=""OK"" title=""OK"" height=""20""/>&nbsp;"
                            case "na" ' when a condition is null
                                strRequired = ""
                        end select
                     else
                        strRequired = ""
                     end if    
                    'response.Write "strCheck = " & strCheck
                    ' build the question                           
                    
                    call buildQuestion(strColour, strRequired & rstConfig("QuestionNumber") ,  rstConfig(strLanguage),strColumnName, rstData(strColumnName),rstConfig("InputType"),rowCounter,rstConfig("lookupTable"),rstConfig("LookupID"), rstConfig("Orientation"), rstConfig("repeatLookup"),rstConfig("colspan"),rstConfig("TextAreaColumns"),rstConfig("maxlength"),"False",rstConfig("hasNotification"),rstConfig("Notification"),rstConfig("NotificationCondition"))                                                                                              
                    
                    ' build the second column
                    strColumnName = rstConfig("columnName2")                    
                    if len(strColumnName) > 0 then                                                 
                        currentvalue =  rstData(strColumnName)                                                                                            
                        ' build the question
                        call buildQuestion(strColour, rstConfig("QuestionNumber"),  rstConfig(strLanguage),strColumnName, currentValue,rstConfig("InputType"),rowCounter,rstConfig("lookupTable2"),rstConfig("LookupID2"), rstConfig("Orientation"), rstConfig("repeatLookup"),0,0,rstConfig("maxlength"),"True",rstConfig("hasNotification"),rstConfig("Notification"),rstConfig("NotificationCondition"))                                                               
                    end if                                                                                     
                end if
                
                if rstConfig("isCulturallySensitive") then 
                    response.write getCulturallySensitiveLink
                elseif rstConfig("hasHelp") then
                    response.write getHelpLink
                end if	
            end if 	                   
            
            response.write "</tr>"		  
            
            rstConfig.movenext
        loop
        Response.Write "</table>"	
    else
        strError = "<font class=""regtextred="""">No data on child - " & strChildID & "</font>"
    end if
    
    ' close the recordset
    rstConfig.close
    
    '*******************************************************************
	' Section E - District Questions - Start
	'******************************************************************* 				
    if strSection = "Section E" then 
        
         ' call district questionnaire if section E
        Call buildDistrictQuestionnaire
        'strSql = "SELECT English,  FROM 
        'response.write "District Questions"
    end if 
	'*******************************************************************
	' Section E - District Questions - Emd
	'******************************************************************* 	
   
    
    ' close the recordset
    rstData.close
end sub 
'*******************************************************************
' Questionnaire End
'*******************************************************************
function isRequired(currentValue)
    if rstConfig("isrequired") then                         
        if isnull(currentValue) then 
            isRequired = "true"
        else
            isRequired = "false"
        end if         
    elseif rstConfig("isconditional") then    
        blnCondition = checkConditions(rstConfig("condition"))
                                    
        select case blnCondition
            case "pass" ' passed the condition for a required field
                isRequired = "true"
            case "fail" ' failed the required condition
                isRequired = "false"
            case "na" ' when a condition is null
                isRequired = "na"
        end select
    else
        isRequired = "na"                        
    end if     
end function

Function CheckConditions(condition)
dim blnCheck 

    if instr(condition,"|")> 0 then
    	orConditions = split(condition,"|")            
      ' perform the or check ' break out the name\value check 
		
	for each oritem in orConditions
		if instr(oritem,"&")= 0 then	
			'response.write "HEY" & oritem
	      	blnCheck = CheckCondition(oritem)

			if blnCheck = "pass" then 
				exit for 
			end if	
		else
			'response.write oritem
		end if
	next 
    end if 
	'response.write "**blnCheck=" & blnCheck
    if blnCheck <> "fail" AND blnCheck <> "na" then 
	'response.write "RUNNING"
	    ' split the AND Conditions 
	
	    andConditions = split(condition,"&")

	    for each item in andConditions    

		if instr(item,"|")= 0 then
			'response.write item
	      	blnCheck = CheckCondition(item)

			if blnCheck = "fail" or blnCheck = "na" then 
				exit for 
			end if 
		end if 
	    next 
	    'response.Write "condition =" & blnCheck &"<br />"
     end if 
    CheckConditions = blnCheck
end function

Function CheckCondition(condition)
dim blnCheck


        acon = split(condition,"=")
'        response.Write condition & rstData(acon(0))        
        if lcase(acon(1)) = "null" then 
            if isnull(rstData(acon(0))) then                                             
                'response.Write "pass"
                blnCheck = "pass"    
            else 
                'response.Write "fail"
                blnCheck = "fail"
           '     exit for    
            end if        
        else    
            if isnull(rstData(acon(0))) then                          
                blnCheck = "na"
            '    exit for  
            elseif isnumeric(rstData(acon(0))) then 
                'response.Write "numeric"
			if rstData(acon(0)) = "True" then 
				value = 1
			else 
				value = clng(rstData(acon(0)))
			end if 

                if value = clng(acon(1)) then 
                    ' condition is met - but value is specified
                 '   response.Write "pass"
                    blnCheck = "pass"                                    
                elseif value <> clng(acon(1)) then 
                  '  response.Write "fail - " & clng(rstData(acon(0))) & "<>" &  clng(acon(1))
                    blnCheck = "fail"
                  '  exit for                                                                                                                   
                end if                 
            else
                if cstr(rstData(acon(0))) = cstr(acon(1)) then                     
                    blnCheck = "pass"                                    
                elseif cstr(rstData(acon(0))) <> cstr(acon(1)) then 
                    blnCheck = "fail"                                     
                   ' exit for                                                                                                                   
                end if     
            end if 
        end if 
	'response.write blnCheck
    CheckCondition = blnCheck
End Function 

'*******************************************************************
' District Questions Start
'*******************************************************************
sub buildDistrictQuestionnaire()
    if not rstData.eof then             		    
        strSql = "SELECT [English],[Spanish],[VariableName],[TableName],[ColumnName],[Sequence] as QuestionNumber,[LookupTable],[LookupID],[InputType],[maxlength],[newSection],[hasHelp],[helpText],[Orientation],[repeatLookup],[colspan],[TextAreaColumns],[maxlength] FROM [dbo].[EDI.Config.DistrictQuestions] WHERE DistrictID = " & districtID & " AND EDIYear = " & EDIYear & " AND len(rtrim(ltrim(English)))>0 ORDER BY Sequence" 
                			
        'open the demographic questions 
        rstConfig.Open strSql, conn

        ' Header	
        if not rstConfig.eof then 
            Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"">"																					
            Response.Write "<tr><td colspan=""3""><br /></td></tr>"
            Response.write "<tr><td width=""23%"" align=""right"">&nbsp;</td><td width=""56%"" align=""center"" valign=""middle""><font class=""headerBlue"">District Questions</font></td><td width=""23%"" align=""left"">&nbsp;</td></tr>"
            Response.Write "<tr><td colspan=""3""><br /></td></tr>"
            Response.Write "</table>"		            
        end if 

        response.write "<br />"

        'Survey
        Response.Write "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""750"" align=""center"">"																															
        rowCounter = 0 


        do while not rstConfig.EOF 
            rowCounter = rowCounter + 1
            if rowCounter mod 2 = 1 then 
                strColour = "whitesmoke"
            else
                strColour = "white"
            end if 
        	
            
            if rstConfig("newSection") and rowcounter > 1  then 
                response.write getNewSection                                
            end if 
            
                       
            
            'write the questions		            
            strColumnName = rstConfig("columnName")                                  
            currentvalue =  rstData(strColumnName)
             
            
            'if rstConfig("InputType") = "Radio2" Then 
                if isnumeric(rstConfig("LookupID")) then 
                    ' Build the header
                    Response.Write "<tr bgcolor=""" & strColour & """>"		        
                    response.write buildQuestionHeader(null, rstConfig("LookupTable"),cint(rstConfig("LookupID")))              
                    Response.Write "</tr>"		
                end if 
                    
                'call buildQuestion(strColour, rstConfig("QuestionNumber") ,  rstConfig(strLanguage),strColumnName, rstData(strColumnName),rstConfig("InputType"),rowCounter,rstConfig("lookupTable"),rstConfig("LookupID"), rstConfig("Orientation"), rstConfig("repeatLookup"),rstConfig("colspan"),rstConfig("TextAreaColumns"),rstConfig("maxlength"),"False",false,null,null)                                                                                                                                                                                                                                                     
                call buildQuestion(strColour, rstConfig("QuestionNumber") ,  rstConfig(strLanguage),strColumnName, rstData(strColumnName),rstConfig("InputType"),rowCounter,rstConfig("lookupTable"),rstConfig("LookupID"), rstConfig("Orientation"), True,rstConfig("colspan"),rstConfig("TextAreaColumns"),rstConfig("maxlength"),"False",false,null,null)                
            'else
            
            'end if 
            
            response.write "</tr>"		  
            
            rstConfig.movenext
        loop
        Response.Write "</table>"	
    else
        strError = "<font class=""regtextred="""">No data on child - " & strChildID & "</font>"
    end if
end sub 
'*******************************************************************
' District Questions End
'*******************************************************************
 %>

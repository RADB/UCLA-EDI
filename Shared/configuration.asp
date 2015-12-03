<%
EDIYear = session("config_EDIYear")
encrytionkey = "UCLAEDI2009"
EmailTo = "andrew@renner.ca"
strDemographics = "Demographics"
strExit = "Return to Home Page"
strClassList = "Save & Return to Class List"
strHome = "Home"
strSave = "Save"
lblName = "Teacher Name"	
lblFirstName = "First Name"
lblLastName = "Last Name"
lblEmail = "Email"
lblSex = "Sex"
lblAge = "Age"
lblLanguage = "Language"
lblPhone = "Phone"
lblAdd = "Add"
lblComments = "Comments"
lblClassInfo = "EDI Questionnaires"
lblUpdate = "Update"
lblStatus = "Status"
lblLocal = "Local ID"
lblEDI = "EDI"
lblPostal = "Postal Code"
lblDOB = "Date of Birth"
lblEDIID = "EDI ID"
lblSummary = "View Child Summary"
lblClassSummary = "View Class Summary"
lblStudent = "Student Information"
lblCancel = "Cancel"
lblMale = "Male"
lblFemale = "Female"
lblteacher = "Teacher"
lblSchool = "School"
lblSite = "Site"
lblSaveEDI = "Save EDI"
lblSaveNextEDI = "Save EDI and Move to Next Section"
lblSaveCheckEDI = "Save EDI and Check for Completeness"
lblFax = "Fax"
lblPass = "Username\Password"
lblPassword = "Password"
strMsg = "To make a change to your name or password, overwrite the current entry and press the Save button"
strSaveMessage = "Do you want to save the change before exiting?"
strLanguage = "English"
intLanguage = 1
'strLink = "documents\\EDI%20Guide%202003.pdf"
strLink = replace(session("strLink"),"\","\\")
lblIncomplete = "Incomplete and Unlocked"
lblComplete = "Complete and Locked"
strComplete = "Complete"
strIncomplete= "Incomplete"
lblLock = "Lock Child"
lblCompletion = "Check for Completeness"
lblFinished = "Finished/Submit to McMaster"
strWarning = "Student must be currently in your class to do the EDI.  If the child is currently in your class but has been there for less than one month do not complete the rest of the form, save and lock the questionnaire."
lblNext = "Next Student"
lblPrevious = "Previous Student"
lblAddStudent = "Add Student"
lblTrainingFeedback = "e-Edi Teacher Training Feedback Form"
lblCode = "Teacher Code"


function checknull(strTemp)
	if isnull(strTemp) or len(strTemp) = 0 then 
		checknull = "null"
	else
		checknull = "'" & replace(strTemp,"'","''") & "'"
	end if 
end function

function checkvalue(strTemp)
	if isnull(strTemp) or len(strTemp) = 0 or strTemp = "-1" then 
		checkvalue = "null"	
	elseif isdate(strTemp) then 
		checkvalue = "'" & strTemp & "'"	
	else
		checkvalue = "'" & replace(strTemp,"'","''") & "'"
	end if 
end function

function checknumber(intTemp)
	if isnull(intTemp) or intTemp = "-1" then 
		checknumber = "null"
	else
		checknumber = intTemp
	end if 
end function

function checkDate(tempDate)
	if isdate(tempDate) then 
		checkDate = "'" & tempDate & "'"
	else
		checkDate= "null"
	end if 
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'  Function Name:    makeReadable
'  Author:           Andrew Renner
'  Date:             June 4, 2001
'  Variables Passed: None
'  Pseudo Code:      1) Removes the jargon from db error messages
'
'  Revision List:    |Author           |Date              |Modifications
'                    |-----------------+------------------+---------------
'                    |Andrew Renner    |July 11, 2001     |Added Comments
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function makeReadable(strTest)
   ' replaces the jsrgon in the error string with ""
   strTest = Replace(strTest, "[Microsoft]", "")
   strTest = Replace(strTest, "[SQL Server]", "")
   strTest = Replace(strTest, "[ODBC SQL Server Driver]", "")
   strTest = Replace(strTest, "[ODBC Microsoft Access Driver]", "")
   strTest = Replace(strTest, "[ODBC Driver Manager]", "")
   strTest = Replace(strTest, "[ODBC]", "")
   strTest = Replace(strTest, "[Oracle]", "")
   strTest = Replace(strTest, "[Ora]", "")
      
   ' returns the clean error string
   makeReadable = strTest
End Function



Response.write "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">"
%>        

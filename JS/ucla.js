
// check to make sure the user entres a username and password
function checkForm() 
{ 
	var errors ="";
	var	iLoc = document.login.email.value.indexOf("@");
			  
  // check the username
  if( ( iLoc<1 ) || ( iLoc == (document.login.email.value.length-1) ) )
  {
		errors += "- Email must contain an e-mail address.\n";
  		alert("The following error(s) occurred:\n" + errors);	
		document.login.email.focus();
		return false;
	}
			  
  // check the password
  if( document.login.password.value.length == 0 ) 
  {
		errors += "- Password is required.\n"; 
		alert("The following error(s) occurred:\n" + errors);	
		document.login.password.focus();
		return false;
	}
				
	return true;
}

function passwordChange()
{
   var errors="";
   			
  // check the password
  if( document.Passwords.strPassword.value.length == 0 ) 
  {
		errors += "- Password is required.\n"; 
		alert("The following error(s) occurred:\n" + errors);	
		document.Passwords.strPassword.focus();
		return false;
	}
				
	return true;
}			
// set the focus to the item that needs it
function checkFocus(intField)
{

	// gets the querystring from the browser
	var strLoc = window.location.search;
	
	if((intField==2) || (strLoc.indexOf("email=") > -1))
	{
		document.login.password.focus();
		document.login.check.value = 1;
	}
	else
		document.login.email.focus();				
}

function showDateTime(Value) 
    {
        if(Value>9)
        {
        return Value;
        }
        else
        {
            return '0' + Value;
        }
    }
    
function StartClock24() 
{    
var AutoLogOut

TheDate = new Date;

document.getElementById('datetime').innerHTML = showDateTime(TheDate.getFullYear()) + '-' + showDateTime(TheDate.getMonth()+1) + '-' + showDateTime(TheDate.getDate()) + '&nbsp;&nbsp;' + showDateTime(TheDate.getHours()) + ':' + showDateTime(TheDate.getMinutes()) + ':' + showDateTime(TheDate.getSeconds()) + '&nbsp;&nbsp;';

setTimeout('StartClock24()',1000);
// set a form variable with the start time and compare to timeout value....
}    

function StartLogoutClock24() 
{    
var AutoLogOut
var AutoSave

TheDate = new Date;

document.getElementById('datetime').innerHTML = showDateTime(TheDate.getFullYear()) + '-' + showDateTime(TheDate.getMonth()+1) + '-' + showDateTime(TheDate.getDate()) + '&nbsp;&nbsp;' + showDateTime(TheDate.getHours()) + ':' + showDateTime(TheDate.getMinutes()) + ':' + showDateTime(TheDate.getSeconds()) + '&nbsp;&nbsp;';


document.forms.Children.TimeOnPage.value =parseInt(document.forms.Children.TimeOnPage.value) + 1;

AutoLogOut = document.forms.Children.AutoLogOff.value - document.forms.Children.TimeOnPage.value;
AutoSave = document.forms.Children.AutoSave.value - document.forms.Children.TimeOnPage.value;

if (AutoLogOut < 0)
{

	document.getElementById('logouttime').innerHTML = 'AutoLogout Disabled'
}
else
{
	document.getElementById('logouttime').innerHTML = 'AutoLogout(seconds) =' + AutoLogOut;
}

if (AutoSave < 0)
{

	document.getElementById('savetime').innerHTML = 'AutoSave Disabled'
}
else
{
	document.getElementById('savetime').innerHTML = 'AutoSave(seconds) = ' + AutoSave;
}
if (AutoLogOut==0)
{
// set the logout variable to true
document.forms.Children.Logout.value = 'True'; 
// save and logout
document.getElementById('Exit').click();
}

if (AutoSave==0)
{
// save and exit
document.getElementById('Exit').click();
}

setTimeout('StartLogoutClock24()',1000);
// set a form variable with the start time and compare to timeout value....
}    

function reset_interval() 
{	
	document.forms.Children.TimeOnPage.value = 0;
}

function changeMonth(name, dayNumber)
{
    var objDay
    
    // get the object
    eval('objDay=document.Children.'+name+'Day');
    
    // clear the object    
    objDay.options.length=0;     
  
    // Get the no of days in the month
    var NoOfDays = eval('DaysInMonth(document.Children.' + name + 'Year.value, document.Children.' + name + 'Month.value)');
    
    
    // Build the days select box
    for(var i=1;i<=NoOfDays;i++)
    {
        //create new option
        var option = new Option(i, i); 
        //Add the new option it to the select
        objDay.options[i]=option;         
    }
    
    // if the existing date is greater than the number of days in the month then choose the latest day
    if (dayNumber > NoOfDays)
        dayNumber = NoOfDays;
           
    //select the previous value
    objDay.selectedIndex = dayNumber;
}


function DaysInMonth(Year,Month) 
{
    //get the number of days in the month
    var dd = new Date(Year, Month, 0);
    return dd.getDate();
}

function SaveUCLAEDI(ChildID, GotoSection, CurrentSection, QuestionnaireID,Source)
{	
	// submit the form to the child screen
	document.forms.Children.frmAction.value = 'Update';
	document.forms.Children.CurrentSection.value = CurrentSection;
	document.forms.Children.QuestionnaireID.value = QuestionnaireID;
	document.forms.Children.GoToSection.value = GotoSection;
	document.forms.Children.ChildID.value = ChildID;
	document.forms.Children.Source.value = Source;
	document.forms.Children.submit();
}

function SaveUCLAEDIChild(ChildID,GoToChildID, CurrentSection, QuestionnaireID)
{	
	// submit the form to the child screen
	document.forms.Children.frmAction.value = 'Update';
	document.forms.Children.CurrentSection.value = CurrentSection;	
	document.forms.Children.GoToSection.value = CurrentSection;	
	document.forms.Children.QuestionnaireID.value = QuestionnaireID;
	document.forms.Children.ChildID.value = ChildID;
	document.forms.Children.GoToChildID.value = GoToChildID;
	document.forms.Children.submit();
}

function update_TeacherFeedbackCheck(strValue)
{	
	var errors ="";
	
	// if any errors are detected
	if (errors) 
	{	
		alert('The following error(s) occurred:\n\n' + errors);
	}
	else
	{
		document.forms.TeacherFeedback.Action.value = strValue;
		document.forms.TeacherFeedback.submit();
	}	
}

function update_TeacherConsent(strValue)
{		
    document.forms.Consent.Decision.value = strValue;	
	document.forms.Consent.submit();	
}

function goWindow(strURL,strName,strWidth,strHeight,strOthers)
{
//resizable=1,scrollbars=1,location=0,menubar=0,status=0,toolbar=0,directories=0
	var strFeatures = "width=" + strWidth + ",height=" + strHeight;
	if (strOthers.length != 0)
		strFeatures += "," + strOthers;
	
	var newWindow = window.open(strURL,strName,strFeatures);
	newWindow.focus();
}  

function GoToEDIQuestionnaire(Action, ChildID)
{	
	// submit the form to the child screen
	document.forms.Children.action = Action;
	document.forms.Children.target = '';	
	document.forms.Children.childID.value = ChildID;	
	document.forms.Children.submit();
}

function GoToEDIQuestionnaireSection(Action, ChildID,Section)
{	
	// submit the form to the child screen
	document.forms.Children.action = Action;
	document.forms.Children.target = '';	
	document.forms.Children.childID.value = ChildID;	
	document.forms.Children.GoToSection.value = Section;	
	document.forms.Children.submit();	
}

function DeleteChild(classID, childID)
{
	eval('document.forms.Class' + classID + '.DeleteChildID.value = ' + childID);
	eval('document.forms.Class' + classID + '.submit()');
}

function RestoreChild(classID, childID)
{
	eval('document.forms.Class' + classID + '.RestoreChildID.value = ' + childID);
	eval('document.forms.Class' + classID + '.submit()');
}

function AddEDIChild(classID)
{	
	// submit the form to the child screen
	//document.forms.Children.target = '';	
	eval('document.forms.Class' + classID + '.classID.value = ' + classID);
	eval('document.forms.Class' + classID + '.submit()');
}

function confirmLock(childID, CheckList, SectionA, SectionB, SectionC, SectionD, SectionE, strAction) 
{
	var strMessage = "";
	if (CheckList=='False')
		strMessage += "- Demographics\n"
	if (SectionA=='False')
		strMessage += "- Section A\n"
	if (SectionB=='False')
		strMessage += "- Section B\n"
	if (SectionC=='False')
		strMessage += "- Section C\n"
	if (SectionD=='False')
		strMessage += "- Section D\n"	
	if (SectionE=='False')
		strMessage += "- Section E\n"
		
	if (strMessage != "")
		strMessage = "The following sections are not complete:\n" + strMessage;
		
	var intConfirm = confirm(strMessage + '\nAre you sure you want to mark this EDI as complete and lock this childs questionnaire?\n\nOnce locked you will no longer be able to edit their EDI.')
	
	if (intConfirm)
	{
		alert('Your questionnaire is now being marked as complete.  You will be returned to the class information page when complete.');
		document.forms.Children.target = '';
		document.forms.Children.childID.value = childID;
		document.forms.Children.action = strAction;		
		document.forms.Children.submit();
	}
}

function sendNotification(notification)
{
    alert(notification);
}

function maskInput() 
{     
        var key_code = window.event.keyCode; 
        var oElement = window.event.srcElement; 
        //&& !window.event.ctrlKey        
        if (!window.event.shiftKey  && !window.event.altKey) 
        { 
                //(key_code > 95 && key_code < 106) numeric keypad
                //((key_code > 47 && key_code < 58) top row numbers
                if ((key_code > 47 && key_code < 58) || (key_code > 95 && key_code < 106)) 
                { 
                    if (key_code > 95)  
                            key_code -= (95-47); // return the numbers 
                    oElement.value = oElement.value; 
                // backspace || Arrow keys  || right arrow || left arrow
                } else if(key_code == 8 || key_code == 46 || key_code==39 || key_code==37) { 
                        oElement.value = oElement.value; 
                //tab || ctl     
                } else if(key_code != 9 || key_code != 17) { 
                        event.returnValue = false; 
                }     
        } 
    } 


function checkURL()
{
	// gets the querystring from the browser
	var strLoc = window.location.href.toLowerCase();
	
	//update the url to https
	if (strLoc.indexOf("http://") == 0)
        strLoc = strLoc.replace('http://','https://');
	
	if (strLoc.indexOf("https://broncosolutions.ca") == 0)
		window.location = strLoc.replace('https://broncosolutions.ca','https://www.broncosolutions.ca');
}

function checkStatus(status)
{
	if (status > 1)
		alert('Your answer to question 14 in the demographics section indicates that you are finished with the EDI for this student. \n If this is correct, please click on the "check for completeness" button and then submit (lock) this child.' + status);
}


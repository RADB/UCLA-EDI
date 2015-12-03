<!-- #include file="shared/security.asp" -->
<!-- #include file="shared/configuration.asp" -->
<%
' if the user has not logged in they will not be able to see the page
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
%>

<html>
<!-- #include file="shared/head.asp" -->	
<body onload="StartClock24();">
	<!-- #include file="shared/page_header.asp" -->		
	<table width="760" border="0">
		<tr>
			<td>
				<font class="boldTextBlack">Home</font>					
			</td>
			<td align="right">
				<input type="button" onclick="javascript:window.location='default.asp?status=logout';" name="Logout" value="Logout">
			</td>
		</tr>
	</table>

    <table width="760" class="tableBorder" height="100" cellpadding="0" cellspacing="5">
        <tr><td colspan="2" align="center"><font class="headerBlue">Teacher Menu</font></td></tr>
        <tr>
	        <td width="380" align="center" valign="middle">
	            <br />		                           
	            <br />		                           
                <a id ="UCLAQuestionnaire" class="webButtonLarge" href="teacher_class.asp" title="UCLA Questionnaires" style="background-image:url(images/UCLAQuestionnaires.png);"></a>                    
	        </td>
	        <td rowspan="2" align="center">
	            <table width="360" class="tableBorder" height="100" cellpadding="0" cellspacing="5">
	                <tr valign="top">
	                    <td colspan="2" align="center"><font class="subHeaderBlue">Manage My EDI Account</font><br /></td>
	                </tr>
	                <tr>
	                    <td  valign="middle">
	                        <br />
	                        <a id ="UCLAProfile" class="webButtonNormal" href="teacher_account.asp" title="Teacher Profile" style="background-image:url(images/UCLAProfile.png);"></a>
	                        <br />
                        </td>
	                    <td align="left">You can manage your account profile here - correct name, change password etc.</td>
	                </tr>
	                <tr>
	                    <td>
	                        <br />	                        
	                            <a id="ConsentForm" class="webButtonNormal" href="javascript:goWindow('teacher_consent_printable.asp','TeacherConsentForm','620','600','top=0,left=125,resizable=1,scrollbars=1');"  title="UCLA Teacher Consent" style="background-image:url(images/UCLATeacherConsent.png);"></a>                    
	                        <br />
	                    </td>
	                    <td align="left">Print a copy of the Teacher Consent Form here.</td>
	                </tr>
	                <tr>
	                    <td>
	                        <a id ="UCLAFeedback" class="webButtonNormal" href="teacher_feedback.asp" title="Teacher Feedback Form" style="background-image:url(images/UCLAFeedback.png);"></a>
	                    </td>
	                    <td align="left">When you have completed questionnaires for all your students. Please complete the e-EDI Teacher Feedback Form</td>
	                </tr>
	            </table>            
	        </td>
	    </tr>	
	    <tr><td><br /></td></tr>
	   <!-- <tr>
	        <td width="380" align="center">		            
	            <a id="UCLAGuide" class="webButtonLarge" href="documents/EDI Teacher Guide 2010.pdf" target="_blank" title="UCLA Guide" style="background-image:url(images/UCLAGuide.png);"></a>                    
	            <br />
	        </td>
	    </tr>-->		
        <tr><td colspan="2"><br /></td></tr>
        <tr>
            <td colspan="2" align="center">
                <table width="740" class="tableBorder" cellpadding="0" cellspacing="5">
                    <tr>
                        <td colspan="4" align="center">
                            <font class="subHeaderBlue">Other Information</font><br /><br />
                        </td>
                    </tr>
	                <tr valign="top">
	                    <td align="center">
	                        <a id="UCLAReports" class="webButtonNormal" href="teacher_reports.asp"  title="UCLA Reports" style="background-image:url(images/UCLAReportsandResources.png);"></a>                    
	                    </td>
	                    <td align="center">
	                        <a id="UCLAFAQ" class="webButtonNormal" href="teacher_faq.asp"  title="UCLA FAQ" style="background-image:url(images/UCLAFAQ.png);"></a>                    
	                    </td>
	                    <td align="center">
	                        <a id="UCLALinks" class="webButtonNormal" href="teacher_links.asp" title="UCLA Links" style="background-image:url(images/UCLALinks.png);"></a>                    
	                    </td>
	                    <td align="center">
	                        <a id="UCLAContactInformation" class="webButtonNormal" href="teacher_contactinformation.asp" title="UCLA Contact Information" style="background-image:url(images/UCLAContactInformation.png);"></a>                    
	                    </td>
	                </tr>
	            </table>
            </td>
        </tr>
	</table>    
	<br />
	
	<!-- #include file="shared/page_footer.asp" -->
</body>
</html>
<%
end if
%>
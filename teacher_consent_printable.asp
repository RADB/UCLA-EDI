<!-- #include file="shared/security.asp" -->
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
%>
<html>
<!-- #include file="shared/head.asp" -->
<body>
    <table id="PrintTable1" border="0" cellpadding="0" cellspacing="0" width="580">					    				
        <tr>
            <td align="center">
	            <a class="bigLinkBlue" href="javascript:window.print();"><img border="0" src="images\UCLAPrinter.png" alt="Printer" name="Printer" /> &nbsp;Print Consent Form</a>
	        </td>
	    </tr>
	</table>
    <table id="ConsentTable" border="0" cellpadding="0" cellspacing="0" width="580">					    				
	    <tr>
	        <td>
	            <p align="center" class="regTextBlack">University of California, Los Angeles</p>
				<%
				distID = cint(session("districtID"))
				if distID = 305 or distID = 312 or distID = 335 or distID = 336 or distID = 337 or distID = 338 or distID = 339 or distID = 340 or distID = 341 or distID = 342 or distID = 343 then 'or distID = 25 
					pk = true
				else 
					pk = false
				end if

				' only write this section for pk4 districts
				if pk=true then 
					response.write "<p align=""center"" class=""boldTextBlack"">PK4 TEACHER INFORMATION SHEET AND CONSENT FORM</p>"
				else
					response.write "<p align=""center"" class=""boldTextBlack"">KINDERGARTEN TEACHER INFORMATION SHEET AND CONSENT FORM</p>"
				end if 
				%>
                
                <p align="center" class="regTextBlack">UCLA Center for Healthier Children, Families and Communities</p>
                <p align="center" class="boldTextBlack">Early Development Instrument (EDI)</p>
                <p align="left" class="regTextBlack">Dear <%=session("name") %>,</p> 
                <p align="left" class="regTextBlack">Please read the information below carefully and then select either "I Agree" or "I Do Not Agree".  You should print or save this consent form for your records.</p>              

                <%
				if pk=true then 
					response.write "<p align=""left"" class=""regTextBlack"">The school district, in partnership with the UCLA Center for Healthier Children, Families and Communities is conducting a project in your school to collect information about children's development in PK4 using the Early Development Instrument (EDI). The EDI was developed by the Offord Centre for Child Studies at McMaster University in Canada in co-operation with principals and PK4 teachers. The EDI information will be used in your community to improve services for young children and their families. UCLA CHCFC is coordinating the EDI project which asks teachers to complete the EDI checklist on all children in their class and also complete several short anonymous teacher feedback forms.</p>"
				else
					response.write "<p align=""left"" class=""regTextBlack"">The school district, in partnership with the UCLA Center for Healthier Children, Families and Communities is conducting a pilot project in your school to begin collecting information about children's development in kindergarten using the Early Development Instrument (EDI).  The EDI was developed by the Offord Centre for Child Studies at McMaster University in Canada in co-operation with principals and kindergarten teachers.  The EDI information will be used in your community to improve services for young children and their families.   UCLA CHCFC is coordinating the EDI project which asks teachers to complete the EDI checklist on all children in their class and also complete several short anonymous teacher feedback forms.</p>"
				end if
				
				' only write this section if not district 284
				if cint(session("districtID")) <> 284 then 
				'	response.write "<p align=""left"" class=""regTextBlack"">You are being asked to participate in the EDI project because you and the other teachers in your school volunteered to use the EDI in your classrooms during the second half of the academic year.  Your participation in the EDI project is voluntary.  </p>"
				end if 
				%>
				
                <p align="left" class="boldTextBlack">PURPOSE OF THE STUDY</p>
				<%
				' only write this section if not district 284
				if pk=true then 
					response.write "<p align=""left"" class=""regTextBlack"">The EDI is a population-based checklist that holistically assesses groups of kindergarten-age children in the areas of physical and social-emotional health as well as language and cognitive development. PK4 teachers complete an EDI on each child outside of class. Children's names do not appear on the EDI questionnaires and the EDI is not used as an individual level diagnostic tool. Results are never reported at the child, teacher or classroom level. The collected information is reported at a group level (i.e. school, neighborhood, school district, etc) and is used as a policy planning tool to improve strategies and systems for young children and their families.</p>"
				else
					response.write "<p align=""left"" class=""regTextBlack"">The EDI is a population-based Kindergarten checklist that holistically assesses groups of children in the areas of physical and social-emotional health as well as language and cognitive development.  Kindergarten teachers complete an EDI on each child outside of class.  Children's names do not appear on the EDI questionnaires and the EDI is not used as an individual level diagnostic tool.  Results are never reported at the child, teacher or classroom level.  The collected information is reported at a group level (i.e. school, neighborhood, school district, etc) and is used as a policy planning tool to improve strategies and systems for young children and their families.    </p>"
				end if 
				%>
                
                <p align="left" class="boldTextBlack">PROCEDURES</p>
				<%
				response.write "<p align=""left"" class=""regTextBlack"">Participation in this project involves the following:</p>"
				%>
				<ul>
					<li class="regTextBlack">Receive a 1-2hour orientation on how to fill out the EDI at your school site;</li> 
					<li class="regTextBlack">Complete a confidential Teacher Form to evaluate your satisfaction with the overall implementation process and collect basic demographic information (approximately 5 minutes);</li> 
					<li class="regTextBlack">Fill out an EDI student checklist on each child in your classroom (approximately 10-20 minutes per student);</li> 
				</ul>
                
                <p align="left" class="boldTextBlack">POTENTIAL RISKS AND DISCOMFORTS</p>
                <p align="left" class="regTextBlack">There are no known risks to the participants in this survey.</p>


                <p align="left" class="boldTextBlack">POTENTIAL BENEFITS TO SUBJECTS AND/OR TO SOCIETY</p>
                <p align="left" class="regTextBlack">The results of the EDI provide the opportunity to systematically reflect on all aspects of each child's development in the first year of school.  In addition, it also provides the following benefits:</p>
                <ul>
                <li class="regTextBlack">Presents baseline data about how children in a geographic area are faring in each of the developmental domains of the EDI</li>
                <li class="regTextBlack">Assists in the development and strengthening of relationships between key agencies and stakeholders in the community based on the findings from the EDI</li>
                <li class="regTextBlack">Facilitates community mobilization and development of forward planning and action based on the results of EDI</li>
                <li class="regTextBlack">Provides the early education and school communities with the opportunity to reflect on the development of children entering school and to consider and plan for their optimal early development, school transitions and future needs.</li>
                </ul>
                       
				<%
				' only write this section if not district 284
				if cint(session("districtID")) <> 284 then 
					response.write "<p align=""left"" class=""boldTextBlack"">PAYMENT FOR PARTICIPATION</p>"
					response.write "<p align=""left"" class=""regTextBlack"">If teachers are asked to participate in the EDI project during school hours, then EDI related activities will either take place during an administrative training day or substitute teachers will be provided. If teachers are asked to participate in completing the EDIs after school hours, then their participation will be strictly voluntary. In this case, participating teachers will be compensated for their time according to local school policies. Teacher compensation is based on the equivalent of 10-20 minutes per EDI performed plus two hours for training and evaluation activities combined.</p>"
				end if 
				%>
				
                <p align="left" class="boldTextBlack">CONFIDENTIALITY</p>
                <p align="left" class="regTextBlack">Any information that is obtained in connection with this study and that can be identified with you will remain confidential and will be disclosed only with your permission or as required by law. All surveys and data for this pilot will be provided to the UCLA CHCFC, where they will be recorded, analyzed, and stored in confidential, password-protected locations.  </p>

                <p align="left" class="regTextBlack">The EDI student checklist that you complete on each child in your class will contain some general demographic information on children such as the child's student ID number, home address, zip code of home residence, ethnicity, and gender.  Children's names will not be on the EDI forms and researchers at UCLA will not have access to children's names.  For data analysis purposes, each child's EDI form will be associated with your confidential Teacher Form. However, no data will be reported at the teacher or classroom level.  Data will only be reported at the school or district levels of aggregation.  </p>

                <p align="left" class="regTextBlack">The anonymous survey that teachers will be asked to complete is to help UCLA evaluate your satisfaction with the 2-hour orientation and with the EDI implementation process.  Results from these surveys will be reported as a group representing summaries statistics from all teachers and will never identify you as an individual.  </p>

                <%
				' only write this section if not district 284
				if cint(session("districtID")) <> 284 then                                 
					response.write "<p align=""left"" class=""boldTextBlack"">PARTICIPATION AND WITHDRAWAL</p>"
					response.write "<p align=""left"" class=""regTextBlack"">If teachers are asked to participate in the EDI project during school hours, then EDI related activities will either take place during an administrative training day or substitute teachers will be provided. If teachers are asked to participate in completing the EDIs after school hours, then you can choose whether to be in this study or not. If you volunteer to be in this study, you may withdraw at any time without consequences of any kind.</p>"
				end if 
				%>
                <p align="left" class="boldTextBlack">IDENTIFICATION OF INVESTIGATORS</p>
                <p align="left" class="regTextBlack">If you have any questions or concerns about the EDI project, please contact your school district representative</p>

                <p align="left" class="boldTextBlack">RIGHTS OF TEACHER PARTICIPATING IN PROJECT</p>
                <p align="left" class="regTextBlack">You are not waiving any legal rights because of your participation in the EDI Project. If you wish to ask questions about your rights as a research participant or if you wish to voice any problems or concerns you may have about the study to someone other than the researchers, please call the Office of the Human Research Protection Program at (310) 825-7122 or write to Office of the Human Research Protection Program, UCLA, 11000 Kinross Avenue, Suite 102, Box 951694, Los Angeles, CA 90095-1694.</p>  

                <p align="left" class="boldTextBlack">TEACHER CONSENT</p>

                <p align="left" class="regTextBlack">I understand the procedures described above.  My questions have been answered to my satisfaction, and I agree to participate in the EDI project.</p> 

                <p align="left" class="regTextBlack">By clicking "I Agree" below you acknowledge that you have read, understand, and agree with the statements listed above.  If you do not agree, you will not be able to continue with the EDI project. If you have questions regarding the EDI project, please contact Lisa Stanley at (310)312-9083 or email her at <a href="mailto:LisaStanley@mednet.ucla.edu" class="reglinkMaroon">LisaStanley@mednet.ucla.edu</a>.</p>      
                <p align="center" class="boldTextBlack"><img src="images\UCLAcheckmark.png" alt="CheckMark" name="CheckMark" />AGREED to by <%=session("name") & " - " & session("consentDate") %></p>
	        </td>
	    </tr>	
	    <tr><td><br/></td></tr>
    </table>
      <table id="PrintTable2" border="0" cellpadding="0" cellspacing="0" width="580">					    				
        <tr>
            <td align="center">
	            <a class="bigLinkBlue" href="javascript:window.print();"><img  border="0" src="images\UCLAPrinter.png" alt="Printer" name="Printer" /> &nbsp;Print Consent Form</a>
	        </td>
	    </tr>
	</table>
</body>
</html>
<%

end if
%>

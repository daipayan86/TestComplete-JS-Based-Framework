//USEUNIT _begin
//USEUNIT _end
//USEUNIT AmazonCommonFuncs
//USEUNIT CommonFuncs
//USEUNIT CommonVars
//USEUNIT DbConn
//USEUNIT HTMLReporting
//USEUNIT Library
//USEUNIT Properties
//USEUNIT ReportCommonFuncs
//USEUNIT Repository
//USEUNIT SysAdminCommonFuncs
//USEUNIT Unexpected_Window
/************************************************************************************
Test Steps:
===========
Step1 Login to Avenio(Millisect)  as admin user.
Result: "It successfully logs into Avenio(Millisect) application.
        It displays case list."


Step2 Click on New Job button
Result:It displays case setup screen.

Step3 In Case set up page 
Enter the case information and click on Scan Stage button.
Result: User is navigated to the stage overview screen.
      It scans slides

Step4 Navigate to Job list and verify case 'CASE03'  is displayed.
Result: CASE03 created is displayed in job list.


Created By : Janardhana                
***********************************************************************************/
function UID2403() {
    Properties.TC = "UID2403_Create_Job_from_Stage";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);
    var objCaseID = Properties.caseID+CommonFuncs.Get_unique_id();
    var objPatientname = Properties.patientName+CommonFuncs.Get_unique_id();
    var objPatientID = Properties.patientID+CommonFuncs.Get_unique_id();
    

    //Step1 Login to Avenio(Millisect)  as admin user.
    //Result: "It successfully logs into Avenio(Millisect) application.It displays case list."
    if (AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD)) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }

    //Step2 Click on New Job button
    //Result:It displays case setup screen.
    AmazonCommonFuncs.clickBtnByName("New Job");
    if (AmazonCommonFuncs.VerifyNotificationWindow1("Return")) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step3 In Case set up page 
   //Enter the case information and click on Scan Stage button.
  //Result: User is navigated to the stage overview screen. It scans slides
    if (AmazonCommonFuncs.createCaseAndVerify(objCaseID,objPatientname,objPatientID,Properties.MALE_GEN,Properties.TISSUE_NAME,Properties.DOWNSTREAM_NAME)) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }
    
    //Step4 Navigate to Job list and verify case 'CASE03'  is displayed.
    //Result: CASE03 created is displayed in job list.
    AmazonCommonFuncs.MenuNavigate("Job List");Delay(wait_time_very_long);Delay(wait_time_long);
    if(AmazonCommonFuncs.search_Case_verify(objCaseID,"Open")){
       ReportCommonFuncs.Report_a_verify(4, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(4, "Fail", "Y");
    }
    
    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();
}


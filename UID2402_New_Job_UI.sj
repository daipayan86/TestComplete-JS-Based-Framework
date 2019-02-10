﻿//USEUNIT _begin
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
Step1 Login as admin
Result: User logs in successfully.

Step2 Click on New Job button
Result:It displays case setup screen.

Step3 Verify Case Setup UI
Result : 'The Case Information pane of the Case Setup page shall present the following fields:
Case Information
Case ID
Pathologist Name
Patient Name
Patient ID
Date of Birth
Gender
Request Site
Request date
Case Notes
Test Information
Reference image with options from stage,from file
Downstream applcation
Target volume
Target area
Thickness
Tissue type
Test orders
Test notes
Buttons:
Scan stage button
    Return link

Created By : Janardhana              
***********************************************************************************/
function UID2402() {
    Properties.TC = "UID2402_New_Job_UI";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME)

    //Step1 Login as admin
    //Result: User logs in successfully.
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

    //Step3 Verify Case Setup UI
    //Result : 'The Case Information pane of the Case Setup page shall present the following fields:
    //Case Information
    //Case ID
    //Pathologist Name
    //Patient Name
    //Patient ID
    //Date of Birth
    //Gender
    //Request Site
    //Request date
    //Case Notes
    //Test Information
    //Reference image with options from stage,from file
    //Downstream applcation
    //Target volume
    //Target area
    //Thickness
    //Tissue type
    //Test orders
    //Test notes
    //Buttons:
    ///Scan stage button
    // Return link
    if (verifyLabels()) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }
    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();

    function verifyCaseID(NameText) {
        try {
            var Page = CommonVars.page;
            PropArray = new Array("ClrClassName", "WPFControlText");
            ValuesArray = new Array("TextBlock", NameText);
            var objtxtCaseId = Page.Find(PropArray, ValuesArray, _depth);
            if (objtxtCaseId.Exists) {
                return true;
            } else {
                return false;
            }
        } catch (e) {
            Log.Message("verifyCaseID() Error" + e.description);
        }
    }

    function verifyLabels() {
        try {
            var objCaseID = verifyCaseID("Case ID");
            var objPatient = AmazonCommonFuncs.VerifyLabelNearText("Patient", "TextBox");
            var objPatientID = AmazonCommonFuncs.VerifyLabelNearText("Patient ID", "TextBox");
            var objGender = AmazonCommonFuncs.VerifyLabelNearText("Gender", "ComboBox");
            var objDOB = AmazonCommonFuncs.VerifyLabelNearText("Date Of Birth", "DatePicker");
            var objPathologist = AmazonCommonFuncs.VerifyLabelNearText("Pathologist", "TextBox");
            var objRequestSite = AmazonCommonFuncs.VerifyLabelNearText("Request Site", "TextBox");
            var objRequestDate = AmazonCommonFuncs.VerifyLabelNearText("Request Date", "DatePicker");
            var objCaseNotes = AmazonCommonFuncs.VerifyLabelNearText("Case Notes", "TextBox");
            var objTestOrders = AmazonCommonFuncs.VerifyLabelNearText("Test Orders", "TextBox");
            var objTestNotes = AmazonCommonFuncs.VerifyLabelNearText("Test Notes", "TextBox");
            var objTissueType = AmazonCommonFuncs.VerifyLabelNearText("Tissue Type", "ComboBox");
            var objDownStreamAPP = AmazonCommonFuncs.VerifyLabelNearText("Downstream Application", "ListBox");
            var objThickness = AmazonCommonFuncs.VerifyLabelNearText("Thickness", "IntegerUpDown");
            var objTargetVolume = AmazonCommonFuncs.VerifyLabelNearText("Target Volume", "TextBlock");
            var objTargetArea = AmazonCommonFuncs.VerifyLabelNearText("Target Area", "TextBlock");
            var objScanStageBtn = AmazonCommonFuncs.verifyBtnByName("SCAN STAGE");
            var objReturnBtn = AmazonCommonFuncs.verifyBtnByName("Return");
            var objFromStage = AmazonCommonFuncs.VerifyLabelNearText("From Stage", "RadioButton");
            var objFromFile = AmazonCommonFuncs.VerifyLabelNearText("From File", "RadioButton");
            if (objCaseID && objPatient && objPatientID && objGender && objDOB && objPathologist && objRequestSite && objRequestDate && objCaseNotes && objTestNotes && objTissueType && objDownStreamAPP && objThickness && objTargetVolume && objTargetArea && objReturnBtn && objScanStageBtn && objReturnBtn && objFromFile) {
                return true;
            } else {
                return false;
            }
        } catch (e) {
            Log.Message("verifyLabels() Error" + e.description);
        }
    }
}
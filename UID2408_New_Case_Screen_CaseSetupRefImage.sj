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
Step1 Click on NEW JOB button.
Result:"It  display case setup screen to enter,
 Case Information 
 Reference Image 
 Sample Information"

Step2 Enter the Case information and Sample information.
Result:It updates all the entered information.

Step3 Check the  Reference Image pane of the Case Setup page
Result: "Options to select reference image are displayed. 
- From Stage radio button
- From File radio button
- Import Image file selection box"

Step4 "Click on From File radio button Select Reference image"
Result: "It opens a new window to select a reference image from local directory.
     It display selected reference image path."

Step5 Click on Scan Stage.
Result:User is navigated to Stage Overview Screen.

Step6 Click on the Setup button from the Dissection Panel on the Stage Overview screen
Result: User is bought back to the Case Setup Page

Step7 Import another image as a Reference Image From File and Click on the save button
Result: User is bought again to the Stage Overview Screen

Step8 Verify the Slide image and the Reference image
Result: The Reference Image selected is recent one and not the previous one


Created By : Janardhana                
***********************************************************************************/
function UID2408() {
    Properties.TC = "UID2408_New_Case_Screen_CaseSetupRefImage";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);
    var objCaseID = Properties.caseID + CommonFuncs.Get_unique_id();
    var objPatientname = Properties.patientName + CommonFuncs.Get_unique_id();
    var objPatientID = Properties.patientID + CommonFuncs.Get_unique_id();
    AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD);


    //Step1 Click on NEW JOB button.
    //Result:"It  display case setup screen to enter,
    //Case Information 
    //Reference Image 
    //Sample Information"
    AmazonCommonFuncs.clickBtnByName("New Job");
    if (AmazonCommonFuncs.VerifyNotificationWindow1("Return")) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }

    //Step2 Enter the Case information and Sample information.
    //Result:It updates all the entered information.
    if (enterCaseDetails(objCaseID, objPatientname, objPatientID, Properties.MALE_GEN, Properties.TISSUE_NAME, Properties.DOWNSTREAM_NAME)) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step3 Check the  Reference Image pane of the Case Setup page
    //Result: "Options to select reference image are displayed. 
    //- From Stage radio button
    //- From File radio button
    // - Import Image file selection box"
    var objScanStage = verifyReferencePane("From Stage");
    var objFileStage = verifyReferencePane("From File");
    if (objScanStage && objFileStage) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }


    //Step4 "Click on From File radio button Select Reference image"
    //Result: "It opens a new window to select a reference image from local directory.
    //It display selected reference image path."
    if (AmazonCommonFuncs.select_Image("From File","analysis_result.jpg")) {
        ReportCommonFuncs.Report_a_verify(4, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(4, "Fail", "Y");
    }

    //Step5 Click on Scan Stage.
    //Result:User is navigated to Stage Overview Screen.
    AmazonCommonFuncs.clickBtnByName("SCAN STAGE");
    Delay(wait_time_very_long);
    Delay(wait_time_long);
    if (verifyScreen()) {
        ReportCommonFuncs.Report_a_verify(5, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(5, "Fail", "Y");
    }

    //Step6 Click on the Setup button from the Dissection Panel on the Stage Overview screen
    //Result: User is bought back to the Case Setup Page
    clickSetupBtn();Delay(wait_time_long);
    if (AmazonCommonFuncs.VerifyNotificationWindow1("Return")) {
        ReportCommonFuncs.Report_a_verify(6, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(6, "Fail", "Y");
    }

    //Step7 Import another image as a Reference Image From File and Click on the save button
    //Result: User is bought again to the Stage Overview Screen
    var objImportImage = AmazonCommonFuncs.select_Image("From File", "Tissue_Image.jpg");
    var objSaveBtn = AmazonCommonFuncs.clickBtnByName("Save");
    Delay(wait_time_very_long);
    Delay(wait_time_long);
    var objStageSetupScreen = verifyScreen();
    if (objImportImage && objSaveBtn && objStageSetupScreen) {
        ReportCommonFuncs.Report_a_verify(7, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(7, "Fail", "Y");
    }
   
    //Step8 Verify the Slide image and the Reference image
    //Result: The Reference Image selected is recent one and not the previous one
    if(AmazonCommonFuncs.createTissuePortion(100, 280, 90, 150, 1)){
    ReportCommonFuncs.Report_a_verify(8, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(8, "Fail", "Y");
    }
    
    

    CommonFuncs.Verify_final_result(_final_result);
    CommonFuncs.Finish_test();


function verifyReferencePane(imageFile) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("RadioButton", imageFile);
        var txtFile = Page.Find(PropArray, ValuesArray, _depth);
        var objFileSelectionBox = AmazonCommonFuncs.VerifyLabelNearText("Import Image", "TextBox");
        if (objFileSelectionBox && txtFile.Exists) {
            Log.Message("ReferencePane is avaliable with Radiobuttons");
            return true;
        } else {
            Log.Message("ReferencePane is not avaliable with Radiobuttons");
            return false;
        }
    } catch (e) {
        Log.Message("verifyReferencePane() Error" + e.description);
        return false;
    }
}

function enterCaseDetails(casedId, patientName, patientID, Gender, TissueType, DownStreamName) {
    try {
        var objCaseID = SysAdminCommonFuncs.enterLabelNearText("TextBox", "WPFObject(\"CaseIdTextBox\")", casedId, "TextBox");
        var objPatientName = EnterAnyText("Patient", patientName, "TextBox");
        var objPatientID = EnterAnyText("Patient ID", patientID, "TextBox");
        var objGender = EnterAnyText("Gender", Gender, "ComboBox");
        var objTissueType = EnterAnyText("Tissue Type", TissueType, "ComboBox");
        var objDownStream = EnterAnyText("Downstream Application", DownStreamName, "ListBox");
        if (objCaseID && objPatientName && objPatientID && objGender && objTissueType && objDownStream) {
            Log.Message("Case details are entered");
            return true;
        } else {
            Log.Message("Case details are not entered");
            return false;
        }
    } catch (e) {
        Log.Message("enterCaseDetails() Error" + e.description);
        return false;
    }
}

function verifyScreen() {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("StageOverviewView", "WPFObject(*\"StageOverviewView*\")");
        var objStageOverviewScreen = Page.Find(PropArray, ValuesArray, _depth);
        if (objStageOverviewScreen.Exists) {
            Log.Message(objStageOverviewScreen + "Page is exists");
            return true;
        } else {
            Log.Message(objStageOverviewScreen + "Page is exists");
            return false;
        }
    } catch (e) {
        Log.Message("verifyScreen() Error" + e.description);
        return false;
    }
}

function clickSetupBtn() {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "Name");
        ValuesArray = new Array("MenuItem", "WPFObject(*\"MenuItem*\")");
        objSetupBtn = Page.Find(PropArray, ValuesArray, _depth);
        if (objSetupBtn.Exists) {
            objSetupBtn.Click();
            Log.Message("Clicking Setup....");
            Sys.Keys("[Down], [Enter]");
            return true;
        } else {
            Log.Message("Setup button not clicked in Scan Stage screen");
            return false;
        }
    } catch (e) {
        Log.Message("clickSetupBtn() Error" + e.description);
        return false;
    }
}
}
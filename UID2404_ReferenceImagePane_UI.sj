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
Step1 "In Case setup screen Verify Reference image pane"
Result: "The Reference image pane of the Case setup page shall present radio buttons for selecting the reference image as below:
-From Stage
-From File"

Step2 Verify if the user can Import the image as a Reference Image by clicking on the Import button when the 'From File' radio button is selected
Result:User shall be able to browse the image for the case from an existing image file

Step3 Select the 'From Stage' Radio Button'
Result: The Import Image option gets disabled.

Step4 "Fill in all the required details and click on the scan stage button
On the Stage Overview Screen page, select one of the slide and draw a tissue portion.
  Select the radio button on the tissue portion for marking it as a reference image"
Result: Tissue portion drawn is selected as reference.



Created By : Janardhana                Date: 
***********************************************************************************/
function UID2404() {
    Properties.TC = "UID2404_ReferenceImagePane_UI";
    CommonFuncs.Begin_test();
    AmazonCommonFuncs.CloseApplicaton(Properties.APP_NAME);
    AmazonCommonFuncs.LoadApplication(Properties.APP_NAME);
    var objCaseID = Properties.caseID + CommonFuncs.Get_unique_id();
    var objPatientname = Properties.patientName + CommonFuncs.Get_unique_id();
    var objPatientID = Properties.patientID + CommonFuncs.Get_unique_id();
    AmazonCommonFuncs.login(Properties.ADMIN_ID, Properties.ADMIN_PASSWORD);


    //Step1 "In Case setup screen Verify Reference image pane"
    //Result: "The Reference image pane of the Case setup page shall present radio buttons for selecting the reference image as below:
    //-From Stage
    //-From File"
    AmazonCommonFuncs.clickBtnByName("New Job");
    Delay(wait_time);
    var objScanStage = verifyReferencePane("From Stage");
    var objFileStage = verifyReferencePane("From File")
    if (objScanStage && objFileStage) {
        ReportCommonFuncs.Report_a_verify(1, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(1, "Fail", "Y");
    }

    //Step2 Verify if the user can Import the image as a Reference Image by clicking on the Import button when the 'From File' radio button is selected
    //Result:User shall be able to browse the image for the case from an existing image file
    if (AmazonCommonFuncs.select_Image("From File","analysis_result.jpg")) {
        ReportCommonFuncs.Report_a_verify(2, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(2, "Fail", "Y");
    }

    //Step3 Select the 'From Stage' Radio Button'
    //Result: The Import Image option gets disabled.
    if (verifyFieldDisabled("From Stage", "Import Image")) {
        ReportCommonFuncs.Report_a_verify(3, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(3, "Fail", "Y");
    }

    //Step4 "Fill in all the required details and click on the scan stage button
    //On the Stage Overview Screen page, select one of the slide and draw a tissue portion.
    //Select the radio button on the tissue portion for marking it as a reference image"
    //Result: Tissue portion drawn is selected as reference.
    var objScanStage = AmazonCommonFuncs.createCaseAndVerify(objCaseID, objPatientname, objPatientID, Properties.MALE_GEN, Properties.TISSUE_NAME, Properties.DOWNSTREAM_NAME);
    var objTissuePortion = AmazonCommonFuncs.createTissuePortion(100, 280, 90, 150, 1);
    var objReferenceBtn = AmazonCommonFuncs.EnterAnyText("Reference", "Checked", "RadioButton");
    if (objScanStage && objTissuePortion && objReferenceBtn) {
        ReportCommonFuncs.Report_a_verify(4, "Pass", "N");
    } else {
        ReportCommonFuncs.Report_a_verify(4, "Fail", "Y");
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

function verifyFieldDisabled(ImageFile, NameText) {
    try {
        var Page = CommonVars.page;
        PropArray = new Array("ClrClassName", "WPFControlText");
        ValuesArray = new Array("RadioButton", ImageFile);
        var objRadioButton = Page.Find(PropArray, ValuesArray, _depth);
        if (objRadioButton.Exists) {
            objRadioButton.Click();
            PropArray = new Array("ClrClassName", "WPFControlText");
            ValuesArray = new Array("TextBlock", NameText);
            var txtBlockobj = Page.Find(PropArray, ValuesArray, _depth);
            var objparent = txtBlockobj.Parent;
            PropArray = new Array("ClrClassName", "Visible");
            ValuesArray = new Array("TextBox", "True");
            objtxtBox = objparent.Find(PropArray, ValuesArray, _depth);
            if (objtxtBox.IsEnabled == false) {
                Log.Message("Import image text box is disalbed");
                return true;
            } else {
                Log.Message("Import image text box is Enabled");
                return false;
            }
        } else {
            Log.Message(objRadioButton + "does not exists");
            return false;
        }
    } catch (e) {
        Log.Message("verifyFieldDisabled() Error" + e.description);
        return false;
    }
}
}
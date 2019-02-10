
var ie;
var page ;
var wait_time_short = 1000;
var wait_time = 3000;
var wait_time_long = 5000;
var wait_time_very_long = 20000;
var _depth = 1000;
var Step_Count=1;

//Login
var home_page;
var _login_status=false;
var _pageload_status = false;
var current_vantage_panel;
var login_user;
var _alert_cleared=false;
var _load_page_errormsg=false;
      
//true if run as project, else false;
var _run_in_project_mode=false;

//Report
var _final_result = true;  
var _report_filename = "../Reports/Report-temp.txt";
var _filePath_html="../Reports/ReportHtml-temp"+ Math.floor((Math.random() * 1000) + 1) +".html";
var _summary_filename;
var _summaryHtml_filename="../Reports/ReportSummaryHtml-temp.html";
var _missingRecords_filename = "../Reports/MissingRecords-temp.txt";
var strScreenshotPath;
var ScreenshotID;

var _project_starttime;
var _project_endtime;
var _tc_count;    
var _passed_count;
var _failed_count; 


//HPQC
var _hpqcTestname = "invalid"

//Export Report in Text
var XMLRowcount = 1;
var strFolderExportLogs = "TempExprtFoldr";
var ExportedFileName =  ProjectSuite.Path +"\Reports\\"+ strFolderExportLogs +"\\";
var TextFileName =  ProjectSuite.Path +"\Reports\\";
var ReportXmlPath = ExportedFileName + "\\TestLog.xml"

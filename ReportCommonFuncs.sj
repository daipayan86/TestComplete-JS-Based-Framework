//USEUNIT CommonVars
//USEUNIT Properties

/***********************************************************************
[Purpose]
Printing Report Header before test start

[Parameters] 
no parameter.

[Return]
No return  

Created On: 05/08/2014 By: <Samitha Karunaratne>
*************************************************************************/
function Report_header()
{
      var myFile,oFile;
        
  switch(aqString.ToUpper(Properties.TestReporting)) 
    {
      case "TEXT": 
          Log.Message("Test Result posting in to TEXT Report!");
          Header_TEXTReport();
          break;
      case "HTML": 
          Log.Message("Test Result posting in to HTML Report!");
          Header_HTMLReport();
          break;
      case "HPQC":
          Log.Message("Test Result posting in to HPQC!");
          break;
      case "HPQC&HTML":
          Log.Message("Test Result posting in to HTML & HPQC!");
          break;
      case "HPQC&TEXT":
          Log.Message("Test Result posting in to TEXT & HPQC!");
          break;
      default:
          //default code block
          Log.Message("Test Result posting in to Default!");
    }

      //Write detailed report header in to TEXT report
      function Header_TEXTReport()
      {
        if(Utilities.FileExists(CommonVars._report_filename) == false)
              aqFile.Create(CommonVars._report_filename);  
          
        myFile = aqFile.OpenTextFile(CommonVars._report_filename, aqFile.faWrite, aqFile.ctUnicode);

        myFile.WriteLine("-----------------------------------------------------------------------------------");
        //myFile.WriteLine("Test Case            : " + Get_current_testitem_name());
        myFile.WriteLine("Test Case            : " + Properties.TC);
        myFile.WriteLine("Workstation          : " + Sys.HostName + " / " + Properties.BrowserInfo);
        myFile.WriteLine("Server Info          : " + Properties.SERVER_IP + " / "+ Properties.BUILD + " / "+ Properties.db + " / "+ Properties.LAN_VERSION);
        myFile.WriteLine("Executed By          : " + Sys.UserName);
        myFile.WriteLine("Date & Time Executed : " + aqDateTime.Now());
        myFile.WriteLine("-----------------------------------------------------------------------------------");
        myFile.WriteLine(StringWrite("Test Description","vlarge") +" | Status");
        myFile.Close();
      }
      
      //Write detailed report header in to HTML report
      function Header_HTMLReport()
      {
        //Mobine, please make sure your code here.  
        if(Utilities.FileExists(CommonVars._filePath_html) == false)
              {
                aqFile.Create(CommonVars._filePath_html);
                Html_Styling();
              }        
          Header_TCDetailsReport();
          
      }      
     
       
      function Header_TCDetailsReport()
      { 
          Step_Count=1; // Reset the Step Counter to 1
          aqFile.WriteToTextFile(CommonVars._filePath_html, "<table class='Mytbl' >",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td width='25%'>Test Case</td><td>" + Properties.TC + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td>Workstation</td><td>" + Sys.HostName + " / " + Properties.BrowserInfo + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td>Server Info</td><td>" + Properties.SERVER_IP + " / "+ Properties.BUILD + " / "+ Properties.db + " / "+ Properties.LAN_VERSION + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td>Executed By</td><td>" + Sys.UserName + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td>Date & Time Executed</td><td>" + aqDateTime.Now() + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._filePath_html, "</table> ",aqFile.ctUTF8);
          
          if ( Properties.STATION != "WPW") {
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<table class='names'> ",aqFile.ctUTF8);
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr> ",aqFile.ctUTF8);
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<th width='5%'>Step #</th>  ",aqFile.ctUTF8);
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<th width='20%'>Action</th>  ",aqFile.ctUTF8);
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<th width='30%'>Expected result</th>	 ",aqFile.ctUTF8);
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<th width='30%'>Actual result</th>	 ",aqFile.ctUTF8);
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<th width='10%'>Pass/Fail Status</th>  ",aqFile.ctUTF8);
              //Added new Column Name "Document"
              aqFile.WriteToTextFile(CommonVars._filePath_html, "<th width='5%'>Document</th>  ",aqFile.ctUTF8);
              aqFile.WriteToTextFile(CommonVars._filePath_html, "</tr>",aqFile.ctUTF8);
          }
       }
}

function Html_Styling(){
          oFile = aqFile.OpenTextFile(CommonVars._filePath_html, aqFile.faWrite, aqFile.ctUTF8, true);
          oFile.Write("<!DOCTYPE html> ");
          oFile.Write("<html>");
          oFile.Write("<head><script src='Js/jquery-2.1.4.min.js'></script>\n<script src='Js/toggleImage.js' type='text/javascript'></script>");
          oFile.Write("<style>");
          oFile.Write("table {");
          oFile.Write("width:100%;");
          oFile.Write("}");
          oFile.Write("table, th, td {");
          oFile.Write("border: 1px solid black;");
          oFile.Write("border-collapse: collapse;");
          oFile.Write("}");
          oFile.Write("th, td {");
          oFile.Write("padding: 5px;");
          oFile.Write("text-align: left;");
          oFile.Write("}");
          oFile.Write("table.names tr:nth-child(even) { ");
          oFile.Write("background-color: #ffffff; ");
          oFile.Write("} ");
          oFile.Write("table.names tr:nth-child(odd) { ");
          oFile.Write("background-color:#ffffff; ");
          oFile.Write("} ");
          oFile.Write("table.names th	{ ");
          oFile.Write("background-color: #c1c1c1; }");
          oFile.Write(".Mytbl {width:100%;background-color: #C7AFEF;} ");
          oFile.Write(".Mytblfooter {width:100%;background-color: #ffffff;} ");
          oFile.Write(".Mytblconfig {width:100%;background-color: #B0B7F0;}");
          oFile.Write("</style> ");
          oFile.Write("</head> ");
          oFile.Write("<body> ");
          oFile.Write("<div style='border: 1px solid; position:fixed; top:50px; left:50px; display: none' class='arrow_image'><img src='' width='900px'; height= '550px';></div>");
          oFile.Close();
}

/***********************************************************************
[Purpose]
Write script execution summary  at the end of the report body

[Parameters] 
final result string

[Return]
No return  

Created On: 05/08/2014 By: <Samitha Karunaratne>
Updated On: 08/05/2014 By: <Samitha Karunaratne> Reason: assign test step status in to global variable CommonVars._final_result.
*************************************************************************/
function Report_a_verify(stepNum, execStatus, scre)
{
  var stepNum="Step"+stepNum;
  if(Properties.STATION == 'WPW') {
    Log.Message(stepNum);
  }
  
  switch(aqString.ToUpper(Properties.TestReporting)) 
    {
      case "TEXT": 
          //Log.Message("Test Step Result posting in to Text Report!");
          Body_TEXTReport();
          break;
      case "HTML": 
          //Log.Message("Test Step Result posting in to Text Report!");
          Body_HTMLReport();
          break;
      case "HPQC":
          //Log.Message("Test Step Result posting in to HPQC!");
          Body_HPQCReport();
          break;
      case "HPQC&HTML":
          //Log.Message("Test Step Result posting in to HTML & HPQC!");
          Body_HPQCReport();
          break;
      case "HPQC&TEXT":
          //Log.Message("Test Step Result posting in to TEXT & HPQC!");
          Body_HPQCReport();
          break;
      default:
          //default code block
          Log.Message("Test Step Result posting in to Default!");
    }
    
  
  function Body_TEXTReport()
  {
    //  resultstr = "User logs out and displays login screen.  | true";
    var myFile = aqFile.OpenTextFile(CommonVars._report_filename, aqFile.faWrite, aqFile.ctUnicode);
  
    //var str = aqString.Trim(resultstr);  
    var strExp =  getStrTestStep(stepNum)[0];
//    if (aqString.Find(str, "|")!= -1){
//      aqString.ListSeparator = "|";
      var strTestStep = stepNum+": "+strExp;
      var strTestStepresult = aqString.ToUpper(execStatus);
      var isDocument = aqString.ToUpper(isDocument);
      //strTestStepresult = aqString.Trim(strTestStepresult, aqString.stAll);
        
      if (strTestStepresult == "PASS" || strTestStepresult == "TRUE" || strTestStepresult == "PASSED")
        {
          strTestStepresult = "PASS";
        }
      else//(strTestStepresult=="FAIL")// || strTestStepresult == "FALSE")
        {
          strTestStepresult = "FAIL";
          isDocument = "Y";
          CommonVars._final_result = false;
        }
    
        if (aqString.GetLength(strTestStep) < 90){
          myFile.WriteLine(StringWrite(strTestStep,"vlarge")+" | "+ strTestStepresult);        
        }      
        else{      
          if (aqString.GetLength(strTestStep) < 120){
          myFile.WriteLine(StringWrite(strTestStep,"xlarge")+" | "+ strTestStepresult);        
          }
          else{  
            myFile.WriteLine(strTestStep+" | "+ strTestStepresult);
          }
        } 
        
        if (isDocument == "Y" || isDocument == "YES" || isDocument == "TRUE")
        {
          isDocument = "Yes";
          TakeScreenShot();
        }   
//    }
//    else{
//      myFile.WriteLine(str);
//    }
      Step_Count=Step_Count+1;
      myFile.Close();
  }
  
  //Write resut in to HTML report body
  function Body_HTMLReport()
  {    
      //precondition for WebPortal with no configurations
      if ( Properties.STATION == "WPW" && CommonVars._configNum === "" &&  Step_Count == 1) {
            var oFile = aqFile.OpenTextFile(CommonVars._filePath_html, aqFile.faWrite, aqFile.ctUTF8);
            oFile.Write("<table class='names'> ");
            oFile.Write("<tr> ");
            oFile.Write("<th width='5%'>Step #</th>  ");
            oFile.Write("<th width='20%'>Action</th>  ");
            oFile.Write("<th width='30%'>Expected result</th>	 ");
            oFile.Write("<th width='30%'>Actual result</th>	 ");
            oFile.Write("<th width='10%'>Pass/Fail Status</th>  ");
            oFile.Write("<th width='5%'>Document</th>  ");
            oFile.Write("</tr>");
            oFile.Close();
      }
  
//    var str = aqString.Trim(resultstr);  
//    if (aqString.Find(str, "|")!= -1){
      //aqString.ListSeparator = "|";
      //New line
      //Check for how many nodes in the XML file
       if (getStrTestStep(stepNum).length == 2) {
                  var strExp    =  getStrTestStep(stepNum)[0];
                  var strAct    =  getStrTestStep(stepNum)[1];
                  var strAction = "";
       }  else {
                  var strAction =  getStrTestStep(stepNum)[0];
                  var strExp    =  getStrTestStep(stepNum)[1];
                  var strAct    =  getStrTestStep(stepNum)[2];       
       }
       
       //If Step 1 has only 2 nodes print the UID to the file
        if (stepNum == "Step1") {
         if (getStrTestStep("Step1").length == 2) {
         writeMissingRecordsToFile(Properties.UID + " does not contain the 'Action' node");  
         } }
         
      var strTestStep = strExp;
      var strTestStepresult = aqString.ToUpper(execStatus);
      var isDocument=aqString.ToUpper(scre);
      //strTestStepresult = aqString.Trim(strTestStepresult, aqString.stAll);
        
      if (strTestStepresult == "PASS" || strTestStepresult == "TRUE" || strTestStepresult == "PASSED" )
        {
          strTestStepresult = "PASS";
          strAct = strExp;
        }
      else
        {
          strTestStepresult = "FAIL";
          isDocument = "Y";
          CommonVars._final_result = false;
        }
      // To remove the 'step # :' from the strTestStep 
      
//      if(strTestStep.indexOf(":")+1<9)
//            strTestStep=strTestStep.slice(strTestStep.indexOf(":")+1, strTestStep.length);
//        else 
//            strTestStep=strTestStep.slice(7, strTestStep.length);
        // comment for the above line : if no ":" found before 9th char then slice from 7th char
      if(strTestStep != null   && strTestStepresult != null)
          {
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr> ",aqFile.ctUTF8);
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<td>" + stepNum + "</td> ",aqFile.ctUTF8);
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<td>" + strAction + "</td> ",aqFile.ctUTF8);
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<td>" + strTestStep + "</td>	",aqFile.ctUTF8);
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<td>" + strAct + "</td>	",aqFile.ctUTF8);
            if(aqString.Trim(strTestStepresult, aqString.stAll)=="PASS")
            {
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<td bgcolor='#d6e3bc'>" + strTestStepresult + "</td>  ",aqFile.ctUTF8);
            }
            else if(aqString.Trim(strTestStepresult, aqString.stAll)=="FAIL")
            {
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<td bgcolor='#F04E3C'>" + strTestStepresult + "</td>  ",aqFile.ctUTF8);
            }
            
            if (isDocument =="Y" || isDocument == "YES" || isDocument == "TRUE")
            {
              isDocument = "Yes";
              TakeScreenShot();
            }
            
            //New column item to report screenshot
            aqFile.WriteToTextFile(CommonVars._filePath_html, "<td>" ,aqFile.ctUTF8);
               if(isDocument == "Yes"){
                var arrElement = Project.Path.split("\\");
                var PrjName = arrElement[arrElement.length -2];
                var fileNamePath = "..\\"+ PrjName +"\\Screenshots\\"+Properties.TC +"\\UID"+Properties.UID+"_Step"+CommonVars.Step_Count+".jpeg";
                aqFile.WriteToTextFile(CommonVars._filePath_html, "<a href='#' class='but' value='Show Image' name ='"+ fileNamePath + "'> "+ isDocument + "</a></td>\n",aqFile.ctUTF8);
                } else{
                aqFile.WriteToTextFile(CommonVars._filePath_html,  isDocument + "</td>	",aqFile.ctUTF8);
                }
                aqFile.WriteToTextFile(CommonVars._filePath_html, "</tr> ",aqFile.ctUTF8);
                Step_Count=Step_Count+1;
          }
      else if(strTestStep == null && strTestStepresult != "")
            {
                strTestStepresult = aqString.Replace(strTestStepresult, "-", "");
                aqFile.WriteToTextFile(CommonVars._filePath_html, "<td colspan='4' style=font-weight:bold>" + strTestStepresult + "</td>  ",aqFile.ctUTF8);
                aqFile.WriteToTextFile(CommonVars._filePath_html, "</tr> ",aqFile.ctUTF8);
      
            } 
    }
        
 
  
  function Body_HPQCReport()
  {
      var strExp =  getStrTestStep(stepNum)[0];
      var strAct =  getStrTestStep(stepNum)[1];
      var strTestStep = strExp;
      var strTestStepresult = aqString.ToUpper(execStatus);
        
      if (strTestStepresult == "PASS" || strTestStepresult == "TRUE" || strTestStepresult == "PASSED" ) {
          strTestStepresult = "Passed";
          //strAct = strExp;
          strAct = 'USEEXPECTED';
      }
      else {
          strTestStepresult = "Failed";
          CommonVars._final_result = false;
      }
    
      if(strTestStep != null && strTestStepresult != null) {
          if(aqString.ToUpper(scre) == "Y" || aqString.ToUpper(scre) == "N") {
              //qcLogStep( strStep, strStep2, strTestStepresult, "N");
              qcLogStep( Step_Count, strAct, strTestStepresult, scre);
          } else {
              qcLogStep( Step_Count, strAct, strTestStepresult, "N");
          }
          Log.Message("Sent to HPQC> stepNum:"+stepNum+" \nstrAct: "+strAct+" \nstrTestStepresult: "+strTestStepresult);
          Step_Count=Step_Count+1;
      } else {
          Log.Error("Body_HPQCReport() error, strTestStep and strTestStepresult is null. Check XML file.");
      }
  }
  
  //Chathura - Function implemntation for Reading step strings from XML
    /*.................................................
Return the Actual & Expected Test Step String for the given Test Step No

Parameter  :  Step1

Ex         :  getStrTestStep("Step1")

Return     :  Actual & Expected Steps
...................................................*/
  function getStrTestStep(stepNumber)
  {
    try {
        var Doc, s, Nodes, ChildNodes, i, Node;
  
        // for MSXML 6: 
        Doc = Sys.OleObject("Msxml2.DOMDocument.6.0");

        Doc.async = false;
  
        // Load data from a file
        // var filename = ProjectSuite.Path + "\WorkstationData\\DDT\\Languages\\UID1433.xml";
        var filename = ProjectSuite.Path + "\WorkstationData\\DDT\\ScriptData\\TestSteps\\UID" + Properties.UID +".xml";
         Doc.load(filename);
        // Report an error, if, for instance, the markup or file structure is invalid 
        if(Doc.parseError.errorCode != 0)
        {
          s = "Reason:\t" + Doc.parseError.reason + "\n" +
              "Line:\t" + aqConvert.VarToStr(Doc.parseError.line) + "\n" + 
              "Pos:\t" + aqConvert.VarToStr(Doc.parseError.linePos) + "\n" + 
              "Source:\t" + Doc.parseError.srcText;
          // Post an error to the log and exit
          Log.Error("Cannot parse the document.", s); 
          return;
        }
  
        //Define the namespace of the node   
        Doc.setProperty('SelectionNamespaces', "" + "xmlns:ns =" +'"' + Properties.UID + '"' + "");
  
        //Use an XPath expression to obtain a list of "control" nodes with the "Checkboxes" namespace 
        Nodes = Doc.selectNodes("//ns:" + stepNumber);
  
        //create an array to store steps data
        var testSteps = [];
  
         // Process the node
        for(i = 0; i < Nodes.length; i++)
        {
          // Get the node from the collection of the found nodes 
          Node = Nodes.item(i);
          // Get child nodes 
          ChildNodes = Node.childNodes;
          // return child nodes
          for (j = 0 ; j < ChildNodes.length ; j++) 
            {
              var steps = ChildNodes.item(j).text
              testSteps.push(steps)        
            }
            return testSteps;
        } 
        return null
    } catch(e) {
        Log.Warning("getStrTestStep() catch error"+e.description);
        return null
    }
  }  

 } 
//////////////////////12/04/2014////Samitha Karunaratne//// Ready to use////////////////////////////////////
//Write resut summary at the end of TEXT/HTML report body
//
function Report_a_verifySummary(resultstr)
{ 
  switch(aqString.ToUpper(Properties.TestReporting)) 
    {
      case "TEXT":           
          Body_TEXTReportSummary();
          break;
      case "HTML":           
          Body_HTMLReportSummary();
          break;
      case "HPQC":                    
          break;      
      default:
          //default code block
          Log.Message("Test Step Result posting in to Default!");
    }

  function Body_TEXTReportSummary()
  {    
    var myFile = aqFile.OpenTextFile(CommonVars._report_filename, aqFile.faWrite, aqFile.ctUnicode);  
    var str = aqString.Trim(resultstr);  
    myFile.WriteLine(str);
    myFile.Close();
  }
  
  //Write resut summary at the end of HTML report body
  function Body_HTMLReportSummary()
  {  
    var str = aqString.Trim(resultstr); 
    aqFile.WriteToTextFile(CommonVars._filePath_html, "<td colspan='5' style=font-weight:bold>" + str + "</td>  ",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "</tr> ",aqFile.ctUTF8);        
  }  
}


/***********************************************************************
Author: Samitha Karunaratne
Date Created: 05/08/2014

[Purpose]
Write formatted strings to report files based on the length of the expected test result

[Parameters] 
text: Expected test result string
value: Defined level of the fixed print size  

[Return]
Expected test result string with spaces at the end to make fixed length line 
*************************************************************************/

function StringWrite(text,value)
{

  var text=aqConvert.VarToStr(text);
  var value=aqConvert.VarToStr(value);
  var lenght=aqString.GetLength(text)

  if(value=="small")
  {
   for(i=0;i<(45-lenght);i++)
   text=text+" ";
   return text;
  }
  
  if(value=="large")
  {
   for(i=0;i<(60-lenght);i++)
   text=text+" ";
   return text;
  }
  
  if (value=="vlarge")
  {
   for(i=0;i<(90-lenght);i++)
   text=text+" ";
   return text;
  }
  if (value=="xlarge")
  {
   for(i=0;i<(120-lenght);i++)
   text=text+" ";
   return text;
  }

}

/***********************************************************************
[Purpose]
Printing Report footer after test finished

[Parameters] 
no parameter.

[Return]
No return  

Created On: 05/08/2014 By: <Samitha Karunaratne>
*************************************************************************/
function Report_footer()
{
  switch(aqString.ToUpper(Properties.TestReporting)) 
    {
        case "TEXT": 
            Log.Message("Test Step Result posted in to TEXT Report!");
            Footer_TEXTReport();
            break;
        case "HTML": 
            Log.Message("Test Step Result posted in to HTML Report!");
            Footer_HTMLReport();
            break;
        case "HPQC":
            Log.Message("Test Step Result posted in to HPQC!");
            break;
        case "HPQC&HTML":
            Log.Message("Test Step Result posted in to HTML & HPQC!");
            break;
        case "HPQC&TEXT":
            Log.Message("Test Step Result posted in to TEXT & HPQC!");
            break;
        default:
            //default code block
            Log.Message("Test Footer posted in to Default!");
    }

  function Footer_TEXTReport()
  {  
    var myFile = aqFile.OpenTextFile(CommonVars._report_filename, aqFile.faWrite, aqFile.ctUnicode);

    myFile.WriteLine("");
    myFile.WriteLine(""); 
    myFile.WriteLine("---------------------Automation test result confirmation---------------------------");
    myFile.WriteLine("");
    myFile.WriteLine("Confirmed By:______________________________________________________________________");
    myFile.WriteLine("");
    myFile.WriteLine("Date:__________________________________________");
    myFile.WriteLine("");
    myFile.WriteLine("");
    myFile.Close();
  }
  
  function Footer_HTMLReport()
  {
    //Mobine, your report footer goes here.
    aqFile.WriteToTextFile(CommonVars._filePath_html, "</table> ",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "<table class='Mytblfooter' >",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td colspan='2'>Automation test result confirmation</td></tr> ",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td width='25%'>Confirmed By:</td><td></td></tr> ",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "<tr><td>Date:</td><td> </td></tr>",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "</table> ",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "</body>  ",aqFile.ctUTF8);
    //aqFile.WriteToTextFile(FilePath_HTML, "</html>",aqFile.ctUTF8);
    aqFile.WriteToTextFile(CommonVars._filePath_html, "<br>",aqFile.ctUTF8);
  }
  
}


/***********************************************************************
[Purpose]
To return a unique string based on current data/time.
This is for generating an unique id to avoid duplicates.

[Parameters] 
no parameter.

[Return]
return the URID, for example: 12201711 stands for (Dec.20 - 17:11)  

Created On: 05/08/2014 By: <Samitha Karunaratne>
*************************************************************************/
function Get_unique_report_id()
{
  var CurrentDate = aqDateTime.Today();
  var CurrentTime = aqDateTime.Time();

  // Return the parts of the current date&time
  var Year = aqDateTime.GetYear(CurrentDate);
  var Month = aqDateTime.GetMonth(CurrentDate);
  var Day = aqDateTime.GetDay(CurrentDate);
  var Hours = aqDateTime.GetHours(CurrentTime);
  var Minutes = aqDateTime.GetMinutes(CurrentTime);
  

  if(Month<10)
    Month = "0" + Month;
    
  if(Day<10)
    Day = "0" + Day;

  if(Hours<10)
    Hours = "0" + Hours;
  if(Minutes<10)
    Minutes = "0" + Minutes;


  URID = Month+""+Day+""+Hours+""+Minutes;
  return URID;
}

function Get_current_project_suite_name()
{
  var projectName = aqFileSystem.GetFileName(ProjectSuite.FileName)
  projectName = projectName.substring(0, projectName.length - 4);
  return projectName;    
}

function Get_current_project_name()
{
  var projectName = aqFileSystem.GetFileName(Project.FileName)
  projectName = projectName.substring(0, projectName.length - 4);
  return projectName;    
}

function Get_current_testitem_name()
{
  try{
    TestItems = Project.TestItems;
    Log.Message("The " + TestItems.Current.Name + " test item is currently running.",TestItems.Current.Description);
    return TestItems.Current.Name;
  }
  catch(e) {}
}

function Get_current_testitem_desc()
{
  try
  {
    TestItems = Project.TestItems;
    Log.Message("The " + TestItems.Current.Name + " test item is currently running.",TestItems.Current.Description);
      
    return   TestItems.Current.Description;
  } 
  catch (e)  {}
}


/***********************************************************************
[Purpose]
To create report file according to Project name and Date/Time.

[Sample]
SLIS-12201433.txt

Created On: 05/08/2014 By: <Samitha Karunaratne>
*************************************************************************/
function Create_report_file()
{          

	  if(aqString.ToUpper(Properties.TestReporting)=="TEXT")
	  {
		Create_TEXTReport();
	  }
	  if(aqString.ToUpper(Properties.TestReporting)=="HTML")
	  {
		Create_HTMLReport();
	  }
		
	  function Create_TEXTReport()
	  {
		var u_id =   Get_unique_report_id();      
		CommonVars._report_filename = "../Reports/Report-"+Properties.TP+"-"+Get_current_project_name()+"-"+u_id+".txt";
		CommonVars._summary_filename = "../Reports/SummaryReport-"+Properties.TP+"-"+Get_current_project_name()+"-"+u_id+".txt";
		aqFile.Create(CommonVars._report_filename); 
		aqFile.Create(CommonVars._summary_filename); 
		Log.Message("report file message",CommonVars._report_filename + " and " + CommonVars._summary_filename + " Created.");  
	  }
	  
	  function Create_HTMLReport()
	  {
		//Mobine, Your HTML file creation goes here.
		
	   if (!aqFile.Exists(CommonVars._filePath_html))
	   {
		  var u_id =   Get_unique_report_id();      
		  CommonVars._filePath_html = "../Reports/Report-"+Properties.TP+"-"+Get_current_project_name()+"-"+u_id+".html";
		  CommonVars._summaryHtml_filename = "../Reports/SummaryReport-"+Properties.TP+"-"+Get_current_project_name()+"-"+u_id+".html";
		  aqFile.Create(CommonVars._filePath_html); 
		  aqFile.Create(CommonVars._summaryHtml_filename);
		  Html_Styling(); 
		  Log.Message("report file message",CommonVars._filePath_html + " and " + CommonVars._summaryHtml_filename + " Created.");  
	   }
		else
		{
		Log.Message("Report file already created - Continue appending in the same file");
		}
	  }
  
}

function Export_logs()
{
  var FileName;
  FileName = "../Reports/Log-"+Properties.TP+"-"+Get_unique_report_id()+".mht";
  //Change to false to improve performance for .mht file. Change in future.
  Log.SaveResultsAs(FileName, lsMHT, false);
}
/************************************************************************
Author: Samitha Karunaratne
Date Create: 05/08/2014 

[Purpose]
Create report folders. This will execute at the begining of each test and 
creates a unique folder for each individual test case.
 
[Parameter]:sPath
Path that folder need to be created
 
[Return]
No Return
 *************************************************************************/

function CreateReportFolder(sPath)
{ 
  var sPath=sPath;
  // Creates the folder
  aqFileSystem.CreateFolder(sPath);
 
  // Creates a file in the specified folder
  if (aqFileSystem.GetFolderInfo(sPath).Exists){ 
    aqFileSystem.DeleteFile(sPath+"\\*.*"); //delete all files if already exist any.
    Log.Message("Folder Created: "+ sPath);
  }
  else 
  Log.Error("Error while creating folder"+spath); 
}

/************************************************************************
Author: Samitha Karunaratne
Date Create: 05/08/2014 

[Purpose]
Take screenshots and put in to project specific Reports/Screen/..folder
 
[Parameter]:No Parameters
 
[Return]
No Return
 *************************************************************************/
function TakeScreenShot(objDesktopScreen)
{  
  
  if(Properties.STATION == "WPW"){
    var fileName = CommonVars.strScreenshotPath+"\\UID"+Properties.UID+"_"+_configName+"_Step"+CommonVars.Step_Count+".jpeg";
  } else {
    var fileName=CommonVars.strScreenshotPath+"\\UID"+Properties.UID+"_Step"+CommonVars.Step_Count+".jpeg";
  }
  var page;var pic;
  {
    page = Sys.Desktop;
    pic = page.Picture().SaveToFile(fileName); 
  }
  Log.Message("Screen "+fileName+" has been saved");
  //CommonVars.ScreenshotID++;
  //For web pages, input parameter is optional, it takes picture of current browser object.
/*  if(objDesktopScreen==null) 
  {   
    page = Sys.Browser(Properties.BROWSER).page("*");
    //pic =page.PagePicture().SaveToFile(fileName); //avoid using since this make some page eliments invisible.
    pic =page.Picture().SaveToFile(fileName);     
  }
  else //if input parameter not provided. takes whole desktop picture.
  {
    page = Sys.Desktop;
    pic = page.Picture().SaveToFile(fileName); 
  }
  Log.Message("Screen "+fileName+" has been saved");
  //CommonVars.ScreenshotID++;
  */
}


/************************************************************************
Author: Samitha Karunaratne

[Purpose]
Write final result in to main test suite driver excel sheet..Data/PreConditionData.xlsm
 
[Parameter]:Res - Final pass/fail status of the test script

[Return]
No Return, it will print final pass/fail status to main excel suite driver

Note: this function calling at final result wrap up functions 
Flag_pass() and Flag_fail()
 *************************************************************************/
function PrintResultToExcelDriver(Res)
{  
  UID = aqString.Substring(Properties.TC, 3, 4);  
  var fileName = ProjectSuite.Path + "\Reports\\TestSuite-Summary.xlsm"; 
  
  //Terminate any open workbooks  
  var p = Sys.FindChild("ProcessName", "EXCEL");
  while(p.Exists){
 
    p.Close();
     
    //Wait until the process is closed. 
    isClosed = p.WaitProperty("Exists", false);
 
    //If closing failed, terminate the process. 
    if(isClosed == false){ 
      p.Terminate();
      Log.Message("Closing all open excell documents..");
    }    
} 

  //Open excel worksheet to write data 
  var app = Sys.OleObject("Excel.Application");
      
  var book = app.Workbooks.Open(fileName);
  var sheet = book.Sheets("Main");
  app.DisplayAlerts = false;
  
  // Write an index of the current row and column to a cell
  var rowCount = sheet.UsedRange.Rows.Count + 1;  
  for(var row = 2; row < rowCount; row++){    
      if(sheet.Cells(row, 2).value == UID){
        sheet.Cells(row, 4) = "Yes";
        sheet.Cells(row, 5) = Res;
        Log.Message(UID + ":"+ sheet.Cells(row, 5).value);
        }
  }      
    
  book.Save();
  app.Quit();
}

/************************************************************************
Author: Samitha Karunaratne

[Purpose]
Write final result in to main test suite driver XML sheet..Data/PreConditionData.xlsm
 
[Parameter]:Res - Final pass/fail status of the test script

[Return]
No Return, it will print final pass/fail status to main excel suite driver

Note: this function calling at final result wrap up functions 
Flag_pass() and Flag_fail()
 *************************************************************************/

function PrintResultToXML(isRun, executionStatus)
{
  var Doc, s, Nodes, ChildNodes, i, Node;
   
  var executionStatus = executionStatus || "Not Completed";
  // Create a COM object 
  // If you have MSXML 6: 
  Doc = Sys.OleObject("Msxml2.DOMDocument.6.0");

  Doc.async = false;
  
  // Load data from a file
  // We use the file created earlier
  var filename = ProjectSuite.Path + "\Reports\\TestSuite-Summary.xml";
  Doc.load(filename);
  
  // Report an error, if, for instance, the markup or file structure is invalid 
  if(Doc.parseError.errorCode != 0)
  {
    s = "Reason:\t" + Doc.parseError.reason + "\n" +
        "Line:\t" + aqConvert.VarToStr(Doc.parseError.line) + "\n" + 
        "Pos:\t" + aqConvert.VarToStr(Doc.parseError.linePos) + "\n" + 
        "Source:\t" + Doc.parseError.srcText;
    // Post an error to the log and exit
    Log.Error("Cannot parse the document.", s); 
    return;
  }
  
    //Define required nodes to change
    //Use an XPath expression to obtain a list of "control" nodes with the "Checkboxes" namespace 
    Nodes = Doc.selectNodes("//UID");
    
    for(i = 0; i < Nodes.length; i++)
      {
        // Get the node from the collection of the found nodes 
        Node = Nodes.item(i);
        
        if (Node.text == Properties.UID) {        
            var currentParentNode = Node.parentnode; 
            currentParentNode.childNodes.item(3).firstChild.replaceData(0 ,15, isRun);   
            currentParentNode.childNodes.item(4).firstChild.replaceData(0 ,15, executionStatus);  
            Doc.Save(filename);
            return;
        } 
        
      } 
      
      Log.Message(Properties.UID + " Not found in the project summary XML");
      writeMissingRecordsToFile(Properties.TC + " Not found in the project summary XML");
}

/************************************************************************
Author: Samitha Karunaratne

[Purpose]
Write project start and end times to TestSuite-Summary.xml
 
[Parameter]:UID : "Project" by default

[Return]
No Return, it will print project start and end times to TestSuite-Summary.xml

Note: this function calling at _end 

 *************************************************************************/

function printExecTimelinesToXML(UID)
{
  var Doc, s, Nodes, ChildNodes, i, Node;
   
  var UID = UID || "Project";
  // Create a COM object 
  // If you have MSXML 6: 
  Doc = Sys.OleObject("Msxml2.DOMDocument.6.0");

  Doc.async = false;
  
  // Load data from a file
  // We use the file created earlier
  var filename = ProjectSuite.Path + "\Reports\\TestSuite-Summary.xml";
  Doc.load(filename);
  
  // Report an error, if, for instance, the markup or file structure is invalid 
  if(Doc.parseError.errorCode != 0)
  {
    s = "Reason:\t" + Doc.parseError.reason + "\n" +
        "Line:\t" + aqConvert.VarToStr(Doc.parseError.line) + "\n" + 
        "Pos:\t" + aqConvert.VarToStr(Doc.parseError.linePos) + "\n" + 
        "Source:\t" + Doc.parseError.srcText;
    // Post an error to the log and exit
    Log.Error("Cannot parse the document.", s); 
    return;
  }
  
    //Define required nodes to change
    //Use an XPath expression to obtain a list of "control" nodes with the "Checkboxes" namespace 
    Nodes = Doc.selectNodes("//record");

    // Process the node
    for (i = 0; i < Nodes.length; i++)
    {
        // Get the node from the collection of the found nodes 
        Node = Nodes.item(i);
        // Get child nodes 
        ChildNodes = Node.childNodes;
        //for (j = 0; j < ChildNodes.length; j++)
        //{
            if (ChildNodes.item(1).text == aqConvert.VarToStr(UID))
            {
                var currentParentNode = ChildNodes.item(1).parentnode;                    
                    if(ChildNodes.item(3).text == "NoData"){
                      ChildNodes.item(3).firstChild.replaceData(0 ,100, CommonVars._project_starttime); // Write project start time
                      Log.Message("Project Start time updated in XML Test Suite Summary " + CommonVars._project_starttime);
                    }
                    ChildNodes.item(4).firstChild.replaceData(0 ,100, CommonVars._project_endtime); // replace the project end time
                    Log.Message("Project End time updated in XML Test Suite Summary " + CommonVars._project_endtime);
                    Doc.Save(filename);
                    return;

            }
        //}

    }
}


/************************************************************************
Author: Samitha Karunaratne

[Purpose]
Write missing record in to '../Reports/MissingRecords-temp.txt' file
 
[Parameter]:Missing record - negative out put of PrintResultToXML(isRun, executionStatus) function

[Return]
No Return, it will print a record in to a file

Note: this function calling at PrintResultToXML(isRun, executionStatus)

 *************************************************************************/

function writeMissingRecordsToFile(missingRecord)
{
  if(Utilities.FileExists(CommonVars._missingRecords_filename) == false)
        aqFile.Create(CommonVars._missingRecords_filename);  
          
  myFile = aqFile.OpenTextFile(CommonVars._missingRecords_filename, aqFile.faWrite, aqFile.ctUnicode);
  myFile.WriteLine("-----------------------------------------------------------------------------------");       
  myFile.WriteLine("Missing            : " + missingRecord);          
  myFile.Close();
}


/***********************************************************************
Author: Ke Wang
Modified: 12/18/2012

[Purpose]
Log test case as PASS if verify pass.
Log test case as FAIL if verify pass.
*************************************************************************/
function Verify_final_result(ret)
{
    if(!ret)
        Flag_fail(); 
    else
        Flag_pass();
}
function Flag_pass()
{
    CommonVars._passed_count++;
    if(Properties.TestReporting=="TEXT"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" PASS! ---------------- ";
      ReportCommonFuncs.Report_a_verifySummary(""); 
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      //ReportCommonFuncs.PrintResultToExcelDriver("PASS");
      ReportCommonFuncs.PrintResultToXML("Yes" , "PASS");
    Log.Message(final_result);
    }
    
    if(Properties.TestReporting=="HTML"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" PASS! ---------------- ";
      //ReportCommonFuncs.Report_a_verifySummary(""); 
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      ReportCommonFuncs.PrintResultToExcelDriver("PASS");
      ReportCommonFuncs.PrintResultToXML("Yes" , "PASS");
      Log.Message(final_result);
    }   
    
    if(Properties.TestReporting=="HPQC"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" PASS! ---------------- ";
      //ReportCommonFuncs.Report_a_verifySummary(""); 
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      //ReportCommonFuncs.PrintResultToExcelDriver("PASS");
      ReportCommonFuncs.PrintResultToXML("Yes" , "PASS");
      Log.Message(final_result);
    }  
    
}
function Flag_fail()
{
    CommonVars._failed_count++;
    if(Properties.TestReporting=="TEXT"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" FAIL! ---------------- ";
      ReportCommonFuncs.Report_a_verifySummary("");    
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      //ReportCommonFuncs.PrintResultToExcelDriver("FAIL");
      ReportCommonFuncs.PrintResultToXML("Yes" , "FAIL");
      Log.Error(final_result);
    }
    
    if(Properties.TestReporting=="HTML"){     
      final_result =  "---------------- Automation TC# "+ Properties.PQ +": " +Properties.TC+" FAIL! ---------------- ";
      //ReportCommonFuncs.Report_a_verifySummary("");    
      ReportCommonFuncs.Report_a_verifySummary(final_result); 
      //ReportCommonFuncs.PrintResultToExcelDriver("FAIL");
      ReportCommonFuncs.PrintResultToXML("Yes" , "FAIL");
      Log.Error(final_result);
    }
}


// Summary Report

function _summary()
{
      var myFile;
      
      if(aqString.ToUpper(Properties.TestReporting)=="TEXT")
      {
        summary_TEXTReport();
      }
      if(aqString.ToUpper(Properties.TestReporting)=="HTML")
      {
        summary_HTMLReport();
      }
      
      function summary_TEXTReport()
      {
        if(Utilities.FileExists(CommonVars._summary_filename) == false)
              aqFile.Create(CommonVars._summary_filename);  
          
        myFile = aqFile.OpenTextFile(CommonVars._summary_filename, aqFile.faWrite, aqFile.ctUnicode);

        myFile.WriteLine("____________________________________________");
        myFile.WriteLine("# Project Summary # ");
        myFile.WriteLine("Start Time    : " +CommonVars._project_starttime);
        myFile.WriteLine("End Time      : " +CommonVars._project_endtime);
        myFile.WriteLine("Total tested  : " +  CommonVars._tc_count);
        myFile.WriteLine("Passed        : " +  CommonVars._passed_count);
        myFile.WriteLine("Failed        : " +  CommonVars._failed_count);
        myFile.WriteLine("____________________________________________");
        myFile.WriteLine(""); 
        myFile.WriteLine("");       
        myFile.WriteLine(""); 
        myFile.WriteLine("---------------------Automation test result confirmation---------------------------");
        myFile.WriteLine("");
        myFile.WriteLine("Confirmed By:______________________________________________________________________");
        myFile.WriteLine("");
        myFile.WriteLine("Date:__________________________________________");
        myFile.WriteLine("");
        myFile.WriteLine("");
        myFile.Close();
      
        return;
      }
      
      function summary_HTMLReport()
      {
        //Mobine your HTML summary implementation goes here.
        // for summary
        
          aqFile.Create(CommonVars._summaryHtml_filename);
          var oFile = aqFile.OpenTextFile(CommonVars._summaryHtml_filename, aqFile.faWrite, aqFile.ctUTF8, true);
    
          oFile.Write("<!DOCTYPE html> ");
          oFile.Write("<html>");
          oFile.Write("<head>");
          oFile.Write("<style>");
          oFile.Write("table {");
          oFile.Write("width:100%;");
          oFile.Write("}");
          oFile.Write("table, th, td {");
          oFile.Write("border: 1px solid black;");
          oFile.Write("border-collapse: collapse;");
          oFile.Write("}");
          oFile.Write("th, td {");
          oFile.Write("padding: 5px;");
          oFile.Write("text-align: left;");
          oFile.Write("}");
          oFile.Write("table.names tr:nth-child(even) { ");
          oFile.Write("background-color: #ffffff; ");
          oFile.Write("} ");
          oFile.Write("table.names tr:nth-child(odd) { ");
          oFile.Write("background-color:#ffffff; ");
          oFile.Write("} ");
          oFile.Write("table.names th	{ ");
          oFile.Write("background-color: #c1c1c1; }");
          oFile.Write(".Mytbl {width:100%;background-color: #C7AFEF;} ");
          oFile.Write(".Mytblfooter {width:100%;background-color: #ffffff;} ");
          oFile.Write("</style> ");
          oFile.Write("</head> ");
          oFile.Write("<body> ");
          oFile.Write("<p>&nbsp;</p> ");
          oFile.Close();
          
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<table class='Mytbl' >",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td width='30%' colspan='2'>Project Summary</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td>Start Time</td><td>" + CommonVars._project_starttime + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td>End Time</td><td>" + CommonVars._project_endtime+ "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td>Total tested</td><td>" + CommonVars._tc_count + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td>Passed</td><td>" + CommonVars._passed_count + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td>Failed</td><td>" + CommonVars._failed_count + "</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "</table> ",aqFile.ctUTF8);
          //aqFile.WriteToTextFile(FilePath_HTML, "<br> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<table class='Mytbl' >",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td colspan='2'>Automation test result confirmation</td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td width='20%'>Confirmed By:</td><td></td></tr> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "<tr><td>Date:</td><td> </td></tr>",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "</table> ",aqFile.ctUTF8);
          aqFile.WriteToTextFile(CommonVars._summaryHtml_filename, "</body> ",aqFile.ctUTF8);
        
      }
}
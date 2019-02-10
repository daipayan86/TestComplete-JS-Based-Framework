//USEUNIT Library

function _end()
{
       CommonVars._project_endtime = "" + aqDateTime.Now(); 
       _summary();
       ReportCommonFuncs.printExecTimelinesToXML();
       //CommonFuncs.Close_browser();
	   ExportTestResults();
       return;
}

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

  // ***************** Export Logs to Text Files ***************************//

function ExportTestResults()
{
  FS = Sys.OleObject("Scripting.FileSystemObject");
  var prjName = aqString.SubString(Project.FileName, Project.Path.length, (Project.FileName.length - Project.Path.length))
  ExportFile = FS.CreateTextFile(TextFileName + "_" + prjName.replace(".mds", ".log") ,true);

  if (aqFileSystem.CreateFolder(strFolderExportLogs) == 0)
   Log.Message("Created new folder " + strFolderExportLogs + ".");
    // Saves the test results
    Log.SaveResultsAs(ExportedFileName, lsHTML , false, 1); 
  
  //Find File while Looping in the directory
  var foundFiles, aFile;
  foundFiles = aqFileSystem.FindFiles(ExportedFileName, "TestLog.xml", true);

  if (foundFiles != null)
    while (foundFiles.HasNext())
    {
      aFile = foundFiles.Next();
      var funDesc = "------------------"+aFile.ParentFolder.ParentFolder.ParentFolder.Name +" : "+ aFile.ParentFolder.Name +" : "+ aFile.DateLastModified + "------------------";
//      Log.Message("-------------"+ aFile.Path+"--------------");
      ExportFile.WriteLine(funDesc); // Writing data to file
      XMLRowcount = 1;
      ReadTestXMLDOM(aFile.Path);
    }
  else
    Log.Message("No TestLog.xml files were found."); 
    
    // Delete the created folder and files
    aqFileSystem.DeleteFolder(ExportedFileName, true);
    Log.Message("Deleted the folder and files in "+ strFolderExportLogs);  
 
}

function ReadTestXMLDOM(ReportXmlPath)
{
  var Doc, Node, s;
  
  // Create a COM object 
  // If you have MSXML 4: 
  //Doc = Sys.OleObject("Msxml2.DOMDocument.4.0");
  // If you have MSXML 6: 
  Doc = Sys.OleObject("Msxml2.DOMDocument.6.0");

  Doc.async = false;
  
  // Load data from a file
  // We use the file created earlier
  Doc.load(ReportXmlPath);
  
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
  
  // Obtain the node
  Node = Doc.documentElement;
 
  // Process the node
  ProcessNode(Node);
}

function ProcessNode(ANode)
{
  var FID, Attrs, i, Attr, ChildNodes;
  if(ANode.parentNode.nodeName  == "Message" ){
  var s = "Row " + XMLRowcount + " "  + aqConvert.VarToStr(ANode.parentNode.nextSibling.basename)+ " : "+ aqConvert.VarToStr(ANode.parentNode.nextSibling.nodeTypedValue)  +" " + aqConvert.VarToStr(ANode.parentNode.nextSibling.nextSibling.nextSibling.nextSibling.nextSibling.nodeTypedValue) + " " + aqConvert.VarToStr(ANode.nodeValue) ;
  ExportFile.WriteLine(s); // Writing data to file
  XMLRowcount = XMLRowcount + 1;
  }
  // Obtain the collection of child nodes
  ChildNodes = ANode.childNodes;
  // Processes each node of the collection
  for(i = 0; i < ChildNodes.length; i++)
     ProcessNode(ChildNodes.item(i)); 
}


//******************************Export Log Ends***************************//
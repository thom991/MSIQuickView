function PlotInExcel(Figure1)%(DataX,DataY)
%Decription: This script lets you save your plot in Excel
%Auther: Amit Doshi
% global sum_of_intensities
global pathname answer
global fileName SheetName SheetIndex Range
%       imagesc(sum_of_intensities)
% Plotting to make sure that you have right plot.................................................................
%       plot(DataX,DataY);
%       xlabel('X Values');
%       ylabel('Y Values');
      print -dmeta;   %.................Copying to clipboard
      
% Excel file path and Name.............................
try
%      m=warndlg('Close all excel files and then proceed.If already closed ignore!');
%      uiwait(m);
%      fileDir=uigetdir('','Select a folder for saving XLS');
%      workSheetDetail=inputdlg({'Filename:','SheetName','SheetIndex','Cell Location'},...
%                             'Excel workbook details',1,{'Test.xls','TestData','1','E5'}) ;  
    if exist([pathname 'Images' filesep answer{1,1} '_ROI_Img.xlsx'],'file')
        delete([pathname 'Images' filesep answer{1,1} '_ROI_Img.xlsx'])
    end
     fileName  = [pathname 'Images' filesep answer{1,1} '_ROI_Img.xlsx'];%[fileDir,'\',workSheetDetail{1}];
     SheetName='Image';
     SheetIndex=1;%str2double(workSheetDetail{3});
     Range = 'E5';%workSheetDetail{4};
   %.............excel COM object..........................................
     Excel = actxserver ('Excel.Application');
     Excel.Visible = 1;

     if ~exist(fileName,'file')
           ExcelWorkbook=Excel.Workbooks.Add;
           ExcelWorkbook.SaveAs(fileName);
           ExcelWorkbook.Close(false);
     end
     invoke(Excel.Workbooks,'Open',fileName); %Open the file
     Sheets = Excel.ActiveWorkBook.Sheets;
     if gt(SheetIndex,3)
         for i=1:SheetIndex-3
            Excel.ActiveWorkBook.Sheets.Add;
         end
     %else  
     end 
        ActiveSheet = get(Sheets, 'Item', SheetIndex);
     %end
     set(ActiveSheet,'Name',SheetName)
     ActiveSheet.Select;
     ActivesheetRange = get(ActiveSheet,'Range',Range);
     ActivesheetRange.Select;
     ActivesheetRange.PasteSpecial; %.................Pasting the figure to the selected location
     Excel.ActiveWorkbook.Save% Now save the workbook
     if eq(Excel.ActiveWorkbook.Saved,1)
         Excel.ActiveWorkbook.Close;
     else
         Excel.ActiveWorkbook.Save;
     end
     invoke(Excel, 'Quit');   % Quit Excel    
     delete(Excel);% End process
     msgbox('Done!');
     close gcf;
catch
    msgbox(lasterr)
end
%-----------------------------------end of function"PlotInExcel--------------------------------------
 


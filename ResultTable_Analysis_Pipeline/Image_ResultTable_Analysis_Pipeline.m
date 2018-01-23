% Description: This script allows the user to load and analyze their ResultTable data, using script written by Shixuan Liu,
%              analysisPlot_sameGemThe_MAD_eden.m and scatterPlots_eden.m. The user can save all genreated open figure windows to a specified
%              directory.
%
% Maintainer: Justin Sing
% Last Modified: Dec. 07, 2017

clear
[FileName,FolderName] = uigetfile('\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\*.mat','Select the ResultTable Data File');
load([FolderName '\' FileName]);
% opts = detectImportOptions('\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Raw Data\Mammalian cells\Dataset_description_2015.xlsx')
% readtable('\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Raw Data\Mammalian cells\Dataset_description_2015.xlsx',opts)

% Prompts user with a dialog box to specify which 
prompt = {'Channel 1','Channel 2','Channel 3','Channel 4'};dlg_title = 'Channel Selection';num_lines = 1;defaultans = {'None','None','None','None'};
Channels = inputdlg(prompt,dlg_title,num_lines,defaultans);

% Calls function analysisPlot_sameGem_Thr_MAD_eden script
statTab = analysisPlot_sameGemThr_MAD_eden(ResultTable,Channels);
% Calls function scatterPlots_eden script
scatterPlots_eden(statTab)
% Calls function FigureSaver script
FigureSaver()
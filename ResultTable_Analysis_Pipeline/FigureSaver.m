%Date Modified: Dec. 01, 2017 by JCS
%This script saves figures that are currently open in the matlabs current active session.
function FigureSaver()
%User needs to change the path that they want to store their figures to
% FolderName = '\\carbon.research.sickkids.ca\rkafri\Chris L\20171130_CL_Greiner_uClear_96RESULTS inverted';
% [~,FolderName] = uigetfile('\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\*.mat','Select the Excel Data File')
%Prompts user for directory to store figures in
FolderName = uigetdir('C:\','Select the directory you wish to store your figures in');

%Obtains Figure objects that are currently active
FigList= findobj(allchild(0),'flat','Type','figure');
%For loop to iterate through each figure
for iFig = 1:size((FigList),1)
    %Obtains unique handle for current figure object
    FigHandle=FigList(iFig);
    %     FigName=FigHandle.Name
    %Assigning a figure name for saving
    %     h1 = gca;
    %     title_str = h1.Title.String
    figure(FigHandle);%Brings current figure to forefront
    h1 = get(gca,'title');
    title_str = get(h1, 'string');
    if title_str == 'S'
        title_str = num2str(iFig);
    elseif isempty(title_str)
        title_str = num2str(iFig);
    else
        title_str = strrep(title_str, ':','_');
        title_str = strrep(title_str, ' ','_');
        title_str =  strrep(title_str, ',','_');
    end
    FigName = ['Figure_' title_str '.fig']
    %Saves figure with given figure name to the desired input path directory
    saveas(FigHandle,fullfile(FolderName,FigName))
    clearvars FigHandle h1 title_str
end
end


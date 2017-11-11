function varargout = O_GUI_6(varargin)  
% O_GUI_6 MATLAB code for O_GUI_6.fig
%       O_GUI_6, by itself, creates a new O_GUI_6 or raises the existing
%      singleton*.
%
%      H = O_GUI_6 returns the handle to a new O_GUI_6 or the handle to
%      the existing singleton*.
%
%      O_GUI_6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in O_GUI_6.M with the given input arguments.
%
%      O_GUI_6('Property','Value',...) creates a new O_GUI_6 or raises the 
%      existing singleton*.
%Starting from the left, property value pairs are
%      applied to the GUI before O_GUI_6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to O_GUI_6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Edit the above text to modify the response to help O_GUI_6
%
% Last Modified by GUIDE v2.5 13-Aug-2016 21:05:09
%
% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @O_GUI_6_OpeningFcn, ...
    'gui_OutputFcn',  @O_GUI_6_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before O_GUI_6 is made visible.
function O_GUI_6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to O_GUI_6 (see VARARGIN)

% Choose default command line output for O_GUI_6
handles.output = hObject;
% Shixuan: Setting Default Parameters
handles.O.selectImage = 0;  % identify whether a image has been selected; 0 mean no image
handles.O.IsExcel = 0;
handles.O.IsExcel = 0;
handles.O.OutputDir = '\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\';

% Update handles structure
set(handles.MaxSize,'SliderStep',[0.001 0.01])
warning off
addpath('\\carbon.research.sickkids.ca\rkafri\MATLAB\General Tools')

figure(900)
imagesc(1)
colormap gray


set(handles.Dataset_selection,'BackgroundColor',[0.8 0.8 0]); % the yellow road
figure(999);

handles.Image_Display=gca;
handles.O.Display_Mode='Regular';
set(handles.Image_Display,'visible','on')

% GETTING THE SPOT CELLS
LS=dir('O_SpotCells*');
LS=struct2cell(LS);
LS=LS(1,:)';
set(handles.Spotting_algorithm,'string',LS)
handles.O.Spotting_alg='O_SpotCells';
handles.O.Watershed_not_calculated=false(1,4);

guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = O_GUI_6_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Kafri: prepare the visual GUI
figure(999); set(gca,'xtick',[],'ytick',[])
figure(998); set(gca,'xtick',[],'ytick',[])

% Kafri: populate the popup menue based on default excel file
DataSetDescriptionFile=get(handles.Excell_sheet_location,'String');
[~,~,raw]=xlsread(DataSetDescriptionFile,'General_Info');
GlobalDirName=raw{1,2};
FlatFieldDirName=raw{3,2};
[rrr,txt,rr]=xlsread(DataSetDescriptionFile,'DataSet_List');
rr=rr(1:1+length(rrr(:,1)),1:17);
T=cell2table(rr(2:end,:),'variablenames',rr(1,:));
Number_Of_datasets=size(txt,1);
List_of_datasets=T.Dataset_name;
set(handles.Dataset_selection,'String',List_of_datasets)

DDD=dir('\\carbon.research.sickkids.ca\rkafri\OPRETTA\FlatFieldFiles');
counter=0;
for i=3:length(DDD)
    if ~isempty(regexp(DDD(i).name,'.mat'))
        counter=counter+1;
        LS{counter}=DDD(i).name;
        LSd(counter)=DDD(i).datenum;
    end
end
[srt,srti]=sort(LSd,'descend');
set(handles.Flat_Field_selection,'String',LS)
set(handles.Flat_Field_selection,'value',1)

contents = cellstr(get(handles.Flat_Field_selection,'String'));
FileName=contents{get(handles.Flat_Field_selection,'Value')};
load(['\\carbon.research.sickkids.ca\rkafri\OPRETTA\FlatFieldFiles\' FileName]);
handles.O.flat.Multipicative_Biase=Multipicative_Biase;
handles.O.flat.FileName=['\\carbon.research.sickkids.ca\rkafri\OPRETTA\FlatFieldFiles\' FileName];

% handles.O.flat.Additive_Biase=Additive_Biase;
guidata(hObject, handles);


XLS=T;
handles.O.XLS=XLS;
handles.O.GlobalDirName=GlobalDirName;
handles.O.IsExcel=1;
handles.O.CurrentTimePoint=1;
handles.O.FlatFieldDirName=FlatFieldDirName;
handles.O.Excell_Sheet_Location=DataSetDescriptionFile;
Selected_dataset=get(handles.Dataset_selection,'value');
handles.O.Magnification=handles.O.XLS.magnification(Selected_dataset);
handles.O.Smoothing_alpha_max_width=handles.O.Magnification;
figure(999)
handles.O.SegmentedImage.CorruptRegion=[];
% axis off
% axes(handles.axes2)
axis off
figure(998)
axis off
% axes(handles.line_scan_2)
axis off
handles.O.SegmentedImage.BW_spots=[];
smoothing_alpha=zeros(4,1);Intensity_thr=zeros(4,1);
Min_Area=ones(4,1)*100; Max_Area=ones(4,1)*1e9;
CloseW=ones(4,1); OpenW=ones(4,1); Seed=[false ; false ; false ; false];
Watershed=[false ; false ; false ; false];
Name={' ',' ',' ',' '}';Label={' ',' ',' ',' '}';
handles.O.General_Thresholds=table(Name,Label,smoothing_alpha,Intensity_thr,Min_Area,Max_Area,CloseW,OpenW,Seed,Watershed);
guidata(hObject,handles)
set(handles.uitable3,'ColumnEditable',[false true true true true true true true true true]);
set(handles.uitable3,'ColumnFormat',{'char',{'Nucleus' 'Cell' 'Other' 'Non'},'numeric','numeric','numeric','numeric','numeric','numeric','logical','logical'});
set(handles.uitable3,'ColumnName',{'Name' 'Label' 'smoothing' 'Threshold' 'Min Area' 'Max Area' 'Close W' 'Open W' 'Seed' 'Watershed'});

%% Kafri: docking the figure
% set(handles.figure1,'windowstyle','docked');


% --- pushbutton: SAVE button ---% Shixuan: save parameters to excel file
function save_parameters_button_Callback(~, eventdata, handles)
% hObject    handle to save_parameters_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ImageIDs=handles.O.ImageIDs; %DirName=handles.O.DirName;
Spotting_Choice=find(handles.O.General_Thresholds.Seed);

if isempty(Spotting_Choice)
    clc
    disp('WARNING: NO SEEDS!!')
    YN=input('OK? (yes/no)','s');
    if strcmpi(YN,'no')
        return
    end
end

Nuclear_Channel=find(strcmp(handles.O.General_Thresholds.Label,'Nucleus'));

if isempty(Nuclear_Channel)
    clc
    disp('WARNING: NO Nucleus!!')
    YN=input('OK? (yes/no)','s');
    if strcmpi(YN,'no')
        return
    end
end

Cytoplasmic_Channel=find(strcmp(handles.O.General_Thresholds.Label,'Cell'));

if isempty(Cytoplasmic_Channel)
    clc
    disp('WARNING: NO Cell!!')
    YN=input('OK? (yes/no)','s');
    if strcmpi(YN,'no')
        return
    end
end

ImageIDs=handles.O.ImageIDs;

SegmentationParameters.NumRows=handles.O.NumRows;
SegmentationParameters.NumColumns=handles.O.NumColumns;
SegmentationParameters.magnification=handles.O.Magnification;
SegmentationParameters.DirName=[handles.O.DirName '\Images'];
SegmentationParameters.FlatField_Correction=get(handles.FlatField_Correction,'value');
SegmentationParameters.OutputDir=handles.O.OutputDir;
SegmentationParameters.DataSetName=handles.O.DataSetName;
SegmentationParameters.FlatFileName=handles.O.flat.FileName;
SegmentationParameters.Regional_Thresholding=0;

handles.O.SegmentationParameters=SegmentationParameters;

handles.O.FlatField_Correction=get(handles.FlatField_Correction,'value');


General_Thresholds=handles.O.General_Thresholds;
if ~isdir([SegmentationParameters.OutputDir 'Dataset_' regexprep(SegmentationParameters.DataSetName,'\W','_')  'RESULTS'])
    mkdir([SegmentationParameters.OutputDir 'Dataset_' regexprep(SegmentationParameters.DataSetName,'\W','_')  'RESULTS'])
end
FileName=handles.SegmentationParameters_file_name.String;
Data.O=rmfield(handles.O,{'BW','WS','IM','BW_spots','Original_IM','XLS'});
save([SegmentationParameters.OutputDir 'Dataset_' regexprep(SegmentationParameters.DataSetName,'\W','_')  'RESULTS\SegPar_' FileName],'Data');
clc
disp([SegmentationParameters.OutputDir 'Dataset_' regexprep(SegmentationParameters.DataSetName,'\W','_')  'RESULTS\SegPar_' FileName])
winopen([SegmentationParameters.OutputDir 'Dataset_' regexprep(SegmentationParameters.DataSetName,'\W','_')  'RESULTS\'])

% --- Excell_sheet_location: excel File Directory ---% in case user use other excel file as input
function Excell_sheet_location_Callback(hObject, eventdata, handles)
% hObject    handle to Excell_sheet_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Excell_sheet_location as text
%        str2double(get(hObject,'String')) returns contents of Excell_sheet_location as a double
set(handles.figure1,'color',[1 0 0 ])
InputDir=get(hObject,'String');
% TEST IF FILE EXISTS
if (exist(InputDir, 'file') == 2 && ~isempty(regexp(InputDir,'.xls', 'once')))  % excel file exist
    DataSetDescriptionFile=get(handles.Excell_sheet_location,'String');
    [~,~,raw]=xlsread(DescriptionFile,'General_Info');
    GlobalDirName=raw{1,2};
    FlatFieldDirName=raw{3,2};
    [~,txt,~]=xlsread(DataSetDescriptionFile,'DataSet_List');
    Number_Of_datasets=size(txt,1);
    List_of_datasets=txt(2:Number_Of_datasets,1);
    set(handles.Dataset_selection,'String',List_of_datasets)
    for i=1:length(txt(1,:))
        VarNames(i)=regexprep(txt(1,i),' ','_');
    end
    XLS=cell2table(txt(2:end,:),'variablenames',VarNames);
    handles.O.XLS=XLS;
    handles.O.GlobalDirName=GlobalDirName;
    handles.O.IsExcel=1;
    handles.O.FlatFieldDirName=FlatFieldDirName;
else % file doesn't exist OR not excel file
    handles.O.IsExcel=0;
    figure(999); cla
    axes(handles.axes2); cla
    figure(998); cla
end
handles.O.DataSetName = handles.O.XLS.Dataset_name{get(handles.Dataset_selection,'value')};

guidata(hObject,handles)
set(handles.figure1,'color',[0.9 0.9 0.9])

function Excell_sheet_location_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Excell_sheet_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Dataset_selection: Image Folder ---
function [handles]=Dataset_selection_Callback(hObject, eventdata, handles)
% hObject    handle to Dataset_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Dataset_selection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dataset_selection
% Kafri: select a dataset from excell sheet
handles.O.Display_Mode='Regular';
set(handles.Display_Channal,'value',1)
set(handles.InspectedProperty,'value',1)
figure(900)
cla
set(handles.Image_selection,'BackgroundColor',[1 1 1])
Dataset_num=get(handles.Dataset_selection,'value');
handles.O.FileType=handles.O.XLS.FileType{Dataset_num};


if handles.O.IsExcel==1
    figure(999)
    axis on
    cla
    set(gca,'xlim',[0.5 1360.5])
    set(gca,'ylim',[0.5 1024.5])
    set(gca,'color','k')
    text(100,200,'LOADING . . . ','fontsize',30,'color','r')
    text(100,300,'PLEASE WAIT !!!!','fontsize',30,'color','r')
    pause(0.1)
    GlobalDirName=handles.O.GlobalDirName;
    XLS=handles.O.XLS;
    DatasetID=Dataset_num;
    LocalDir=XLS.directory{DatasetID};
    if isempty(regexp(LocalDir,'\\'))
        DirName=[GlobalDirName '\' LocalDir];
    else
        DirName=LocalDir;
    end
    handles.O.DirName=DirName;
    
    % Kafri populate the PlateMap
    set(handles.Image_selection,'value',1)
    if ~isdir(DirName) % if directory DOES NOT exist
        % Clear the Listbox
        set(handles.Image_selection,'String',{'non'})
        handles.O.IsExcel=0;
        figure(999)
        axis on
        cla
        set(gca,'xlim',[0.5 1360.5])
        set(gca,'ylim',[0.5 1024.5])
        set(gca,'color','k')
        text(100,200,'big problem !! . . . ','fontsize',30,'color','r')
        text(100,300,'DIRECTORY DOES NOT EXIST !!!!','fontsize',30,'color','r')
        pause(20)
        %         axes(handles.axes2); cla
        figure(998); cla
    else               % if directory DOES exist
        handles.O.IsExcel=1;
        
        % WAIT MESSEGE
        figure(999)
        axis on
        cla
        set(gca,'xlim',[0.5 1360.5])
        set(gca,'ylim',[0.5 1024.5])
        set(gca,'color','k')
        text(100,200,'LOADING . . . ','fontsize',30,'color','r')
        text(100,300,'PLEASE WAIT !!!!','fontsize',30,'color','r')
        drawnow
        %  END OF WAIT MESSEGE
        
        [ImageIDs,BaseName,NumberLengths]=O_retrieve_names_v2(DirName,handles.O.XLS.FileType{DatasetID});
%         if strcmp(XLS{94,2},'Operetta') && strcmp(ImageIDs.Properties.VariableNames(11),'Drug_treatment')
%             ImageIDs.Properties.VariableNames{11}='Compound';
%         end
%         if strcmp(XLS{94,2},'Operetta') && strcmp(ImageIDs.Properties.VariableNames(12),'Drug_washout')
%             ImageIDs.Properties.VariableNames{12}='Concentration';
%         end
%         if strcmp(XLS{94,2},'Operetta') && size(ImageIDs,2)==13
%             ImageIDs.Cell_Count=char.empty(size(ImageIDs,1),0);
%         end
        handles.O.Image_Retrieval_data.Image_File_Base_Name=BaseName;
        handles.O.Image_Retrieval_data.NumberLengths=NumberLengths;
        handles.O.PlateType=handles.O.XLS.PlateSize(DatasetID);
        handles.O.ImagedChannels=unique(ImageIDs.Channel);
        if any(ismember(ImageIDs.Properties.VariableNames,'ch_name'))
            [unq,iunq]=unique(ImageIDs.Channel);
            handles.O.Image_Retrieval_data.ch_names=ImageIDs.ch_name(iunq);
            ImageIDs.ch_name=[];
        end
        % DETERMINE IF IT IS A 96 OR 384 WELL PLATE
        if handles.O.PlateType==384
            handles.O.NumColumns=24;
            handles.O.NumRows=16;
        elseif handles.O.PlateType==96
            handles.O.NumColumns=12;
            handles.O.NumRows=8;
        elseif handles.O.PlateType==1
            handles.O.NumColumns=1;
            handles.O.NumRows=1;
        end
        
        handles.O.Channels = [XLS.color_1(DatasetID) XLS.color_2(DatasetID) XLS.color_3(DatasetID) XLS.color_4(DatasetID)];
        
        set(handles.Display_Channal,'String',[handles.O.Channels(handles.O.ImagedChannels)])
        
        handles.O.ImageIDs=ImageIDs;
        [handles]=Select_Plate_Region(hObject,handles,ImageIDs);
    end
    handles.O.selectImage = 0;
    % write down the channel lables
    guidata(hObject,handles)
    
end


figure(999);cla
set(gca,'color','w')
pause(0.1)
set(handles.Time_Scale_Slider,'Min',1,'Max',max(ImageIDs.Time),'Value',1)
handles.O.CurrentTimePoint=1;
if strcmpi(handles.O.XLS.FileType{DatasetID},'Operetta')
    Plot_plate_map(handles)
end
handles.O.DataSetName = handles.O.XLS.Dataset_name{get(handles.Dataset_selection,'value')};

set(handles.Dataset_selection,'BackgroundColor',[1 1 1])
set(handles.Image_selection,'BackgroundColor',[0.8 0.8 0]);


% INITIALIZING GENERAL THRESHOLDS

smoothing_alpha=zeros(4,1);Intensity_thr=zeros(4,1);
Min_Area=ones(4,1)*100; Max_Area=ones(4,1)*1e9;
CloseW=ones(4,1); OpenW=ones(4,1); Seed=[false ; false ; false ; false];
Watershed=[false ; false ; false ; false];
Name={' ',' ',' ',' '}';Label={' ',' ',' ',' '}';
handles.O.General_Thresholds=table(Name,Label,smoothing_alpha,Intensity_thr,Min_Area,Max_Area,CloseW,OpenW,Seed,Watershed);
handles.O.General_Thresholds.Label={'Non' 'Non' 'Non' 'Non'}';
handles.O.General_Thresholds.Name={'' '' '' ''}';
handles.O.General_Thresholds.Seed=false(4,1);
handles.O.General_Thresholds.CloseW=zeros(4,1);
handles.O.General_Thresholds.OpenW=zeros(4,1);
handles.O.General_Thresholds.Intensity_thr=zeros(4,1);
handles.O.General_Thresholds.Max_Area=zeros(4,1);
handles.O.General_Thresholds.Min_Area=zeros(4,1);
handles.O.General_Thresholds.smoothing_alpha=zeros(4,1);
for i=1:size(handles.O.General_Thresholds,1)
    eval(['str=handles.O.XLS.color_' num2str(i) '(' num2str(DatasetID) ');'])
    if iscell(str)
        Labels{i}=str{1};
    else
        Labels{i}='None';
    end
end
Labels=Labels';
handles.O.General_Thresholds.Name=Labels;

% TRIMMING GENERAL THRESHOLDS TABLE TO INCLUDE ONLY IMAGED CHANNALS
handles.O.General_Thresholds=handles.O.General_Thresholds(handles.O.ImagedChannels,:);

handles.O.MaxInt=ones(size(handles.O.ImagedChannels))*NaN;
% REMOVING THE CH BUTTONS FOR NON-IMAGED CHANNALS
for i=1:4
    if ismember(i,handles.O.ImagedChannels)
        eval(['set(handles.ch' num2str(i) ',''string'',Labels{' num2str(i) '})'])
        eval(['set(handles.ch' num2str(i) ',''visible'',''on'')'])
    else
        eval(['set(handles.ch' num2str(i) ',''visible'',''off'')'])
    end
end

set(handles.uitable3,'data',table2cell(handles.O.General_Thresholds))
set(handles.uitable3,'data',handles.uitable3.Data(handles.O.ImagedChannels,:))

set(handles.ColorDisp,'visible','off')
set(handles.InspectedProperty,'visible','off')
if max(ImageIDs.Time)==1
    set(handles.Time_Scale_Slider,'visible','off')
    set(handles.text28,'visible','off')
else
    set(handles.Time_Scale_Slider,'visible','on')
    set(handles.text28,'visible','on')
end
for ch=handles.O.ImagedChannels'
    handles.O.SeedChoice{ch}='';
end
[handles]=O_Update_GUI(handles);
[handles]=O_Update_General_Thresholds(hObject,handles);
guidata(hObject,handles)


function []=Plot_plate_map(handles)
Dataset_num=get(handles.Dataset_selection,'value');
if strcmpi(handles.O.FileType,'Operetta')
    % PLOT PLATE MAP
    figure(900)
    hold off
    [X,Y]=meshgrid(1:handles.O.NumRows,1:handles.O.NumColumns);
    Rows=X(:);
    Columns=Y(:);
    % column goes to 12 row goes to 8
    RelevantWells=unique([handles.O.ImageIDs.Row handles.O.ImageIDs.Column],'rows');
    alpha=handles.O.NumColumns/12;
    
    
    scatter(Columns,Rows,60/alpha,'b');
    set(gca,'ydir','reverse')
    hold on
    scatter(RelevantWells(:,2),RelevantWells(:,1),60/alpha,'g','filled');
    
    if isfield(handles,'ImageID')
        scatter(handles.O.ImageID(2),handles.O.ImageID(1),150/alpha,'r','linewidth',4);
    end
    set(gca,'xtick',1:handles.O.NumColumns)
    set(gca,'ytick',1:handles.O.NumRows,'yticklabel',{'A','B','C','D','E','F','G','H'})
    set(gca,'fontsize',6/alpha)
    axis([0 handles.O.NumColumns+1 0 handles.O.NumRows+1])
    %     set(gcf,'color',[0 0 0 ])
    set(gca,'color',[0 0 0 ])
end


function Dataset_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dataset_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% guitable
function thrCheck_Callback(hObject, eventdata,handles)
% eventdata.Indices;
% eventdata.NewData;
Imaged_ch=handles.O.ImagedChannels;
data=get(hObject,'Data'); % get the data cell array of the table
cols=get(hObject,'ColumnFormat'); % get the column formats
SelectedVarID=eventdata.Indices(1,2);
Selected_variable=hObject.ColumnName{SelectedVarID};
L=size(handles.O.General_Thresholds,1);
switch Selected_variable
    case 'Seed'
        handles.O.General_Thresholds.Seed(Imaged_ch)=false(length(Imaged_ch),1);
        handles.O.General_Thresholds.Seed(eventdata.Indices(1,1))=eventdata.NewData;
        data(:,SelectedVarID)=mat2cell(handles.O.General_Thresholds.Seed,true(1,L));
        set(hObject,'Data',data)
        set(handles.OperationLabel,'string','Thresholding','fontsize',12)
        set(handles.OperationLabel,'backgroundcolor','b')
        handles.O.Watershed_not_calculated=true(1,4);
    case 'Watershed'
        handles.O.General_Thresholds.Watershed(Imaged_ch)=false(length(Imaged_ch),1);
        handles.O.General_Thresholds.Watershed(eventdata.Indices(1,1))=eventdata.NewData;
        data(:,SelectedVarID)=mat2cell(handles.O.General_Thresholds.Watershed,true(1,L));
        set(hObject,'Data',data)
    case 'Label'
        if ~strcmp(eventdata.NewData,'Non')
            ii=strcmp(handles.O.General_Thresholds.Label,eventdata.NewData);
            if any(ii)
                handles.O.General_Thresholds.Label{ii}='Non';
            end
        end
        handles.O.General_Thresholds{eventdata.Indices(1,1),eventdata.Indices(1,2)}={eventdata.NewData};
        handles.O.Watershed_not_calculated=true(1,4);
    otherwise
        handles.O.General_Thresholds{eventdata.Indices(1,1),eventdata.Indices(1,2)}=eventdata.NewData;
end

[handles]=O_Update_GUI(handles);
[handles]=O_Update_General_Thresholds(hObject,handles);

% --- Image_selection: list the images in the directory---
function Image_selection_Callback(hObject, eventdata, handles)
% hObject    handle to Image_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Image_selection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Image_selection
Dataset_num=get(handles.Dataset_selection,'value');
handles.O.FileType=handles.O.XLS.FileType{Dataset_num};
if handles.O.IsExcel==1 && handles.O.IsExcel ==1
    drawnow
    handles.O.selectImage = 1;
    ID=get(hObject,'Value');
    handles.O.ImageID=handles.O.ActivePlateListNumbers(ID,:);
    
    [handles]=O_LoadImages_Internal(hObject,handles);
    guidata(hObject,handles)
    [handles]=O_Threshold_and_Display(hObject,handles);
    %     [handles]=DisplayImage(hObject,handles);
    Plot_plate_map(handles)
    set(handles.Image_selection,'BackgroundColor',[1 1 1])
    
end

function Image_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- smoothing_slider: Smooth Factor------
function smoothing_slider_Callback(hObject, eventdata, handles)
% hObject    handle to smoothing_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if handles.O.IsExcel==1 && handles.O.IsExcel ==1 && handles.O.selectImage == 1
    handles.O.Display_Mode='Regular';
    set(handles.OperationLabel,'string','SEEDS','fontsize',15)
    set(handles.OperationLabel,'BackgroundColor','g','FontWeight','bold','ForegroundColor','w')
    
    [handles]=O_Update_General_Thresholds(hObject,handles);
    [handles]=O_Spot_Image(hObject,handles);
end

function smoothing_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothing_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Threshold: Threshold for Nuclear Mask ---
function Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% IF WE "JUST" IDENTIFIED SEEDS WE NEED TO WATERSHED
ch=get(handles.Display_Channal,'value');
Seed_ch=find(handles.O.General_Thresholds.Seed);

thr=get(hObject,'Value');
handles.O.General_Thresholds.Intensity_thr(ch)=thr;
handles.O.Display_Mode='Regular';
guidata(hObject,handles)
set(handles.OperationLabel,'string','Thresholding','fontsize',12)
set(handles.OperationLabel,'backgroundcolor','b')
[handles]=O_Update_General_Thresholds(hObject,handles);

function Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% function [handles]=O_Threshold_and_Display(hObject,handles)
% ch=get(handles.Display_Channal,'value');
% Nucleus_ch=find(strcmp(handles.O.General_Thresholds.Label,'Nucleus'));
% Cell_ch=find(strcmp(handles.O.General_Thresholds.Label,'Cell'));
% if ~isempty(Nucleus_ch) && ...
%         ~isempty(Cell_ch) && ...
%         handles.O.General_Thresholds.Intensity_thr(Nucleus_ch)>0 && ...
%         handles.O.General_Thresholds.smoothing_alpha(Nucleus_ch)>0 && ...
%         isempty(handles.O.BW{Nucleus_ch})
%     set(handles.Display_Channal,'value',Nucleus_ch);
%     [handles]=O_Threshold_and_Display2(hObject,handles);
%     set(handles.Display_Channal,'value',ch);
% end
% [handles]=O_Threshold_and_Display2(hObject,handles);


% --- nuc_border_button: Show/NOT Show nuclear border ---
function nuc_border_button_Callback(hObject, eventdata, handles)
% hObject    handle to nuc_border_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nuc_border_button
if  handles.O.selectImage == 1
    set(handles.figure1,'color',[0 0 1])
    [handles]=O_Segment_and_display_Image(hObject,handles);
    set(handles.figure1,'color',[0.9 0.9 0.9])
end


% --- Display_Channal: choose channel for showing ---
function Display_Channal_Callback(hObject, eventdata, handles)
% hObject    handle to Display_Channal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Display_Channal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Display_Channal
ch=get(hObject,'value');
set(handles.Threshold,'Min',0,'Max',prctile(IM{ch}(:),90))
if get(handles.Threshold,'max')<get(handles.Threshold,'value')
    v=get(handles.Threshold,'value');
    set(handles.Threshold,'max',v+100)
end

set(handles.figure1,'color',[0 0 1])
[handles]=O_Update_GUI(handles);
[handles]=O_Segment_and_display_Image(hObject,handles);
%     [handles]=DisplayImage(hObject,handles);
set(handles.figure1,'color',[0.9 0.9 0.9])
guidata(hObject,handles)


function Display_Channal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Display_Channal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function [handles]=Select_Plate_Region(hObject,handles,ImageIDs)
Dataset_num=get(handles.Dataset_selection,'value');

T=ImageIDs;
if strcmpi(handles.O.FileType,'Operetta')
    T(:,{'Channel','Plate','FileNumber','FileName','FileDate','Color','Compound','Concentration','Cell_Type','Cell_Count'})=[];
else
    T(:,{'Channel'})=[];
end

T=unique(T,'rows');
if size(T,1)>100
    I=round(linspace(1,size(T,1),100));
    T=T(I,:);
end

for counter=1:size(T,1)
    for k=1:size(T,2)
        txt{k}=[T.Properties.VariableNames{k} ':' num2str(T{counter,k})];
    end
    PlateList{counter,1}=strjoin(txt);
end
handles.PlateList=PlateList;

handles.O.ActivePlateList=PlateList;
handles.O.PlateListNumbers=T;
handles.O.ActivePlateListNumbers=T;

set(handles.Image_selection,'String',PlateList')
guidata(hObject,handles)

% --- Executes on slider movement.
function Image_contrast_1_Callback(hObject, eventdata, handles)
% hObject    handle to Image_contrast_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=min([get(handles.Image_contrast_1,'value') get(handles.Image_contrast_2,'value')]);
set(handles.Image_contrast_1,'value',val);

[handles]=O_Threshold_and_Display(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Image_contrast_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_contrast_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Image_contrast_2_Callback(hObject, eventdata, handles)
% hObject    handle to Image_contrast_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=max([get(handles.Image_contrast_1,'value') get(handles.Image_contrast_2,'value')]);
set(handles.Image_contrast_2,'value',val);
[handles]=O_Threshold_and_Display(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Image_contrast_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_contrast_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.LineScanPos=1-get(hObject,'Value');
guidata(hObject,handles)
if get(handles.DispBG,'value')
    [handles]=CalcDark2(hObject, handles);
    O_Threshold_and_Display(hObject,handles);
else
    O_Threshold_and_Display(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Rescale_Intensity.
function Rescale_Intensity_Callback(hObject, eventdata, handles)
% hObject    handle to Rescale_Intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ch=get(handles.Display_Channal,'value');

figure(999)
hold off
imshow(handles.O.IM{ch},[])
colormap hsv
[x,y,u]=ginput(1);
SelectedIntensity=handles.O.IM{ch}(round(y),round(x));
eval(['set(handles.Threshold,''Max'',SelectedIntensity)'])
eval(['set(handles.Threshold,''value'',SelectedIntensity/2)'])
handles.O.MaxInt(ch)=SelectedIntensity;
colormap gray
guidata(hObject,handles)


% --- Executes on slider movement.
function Time_Scale_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Time_Scale_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.O.CurrentTimePoint=round(get(hObject,'value'));
handles.O.ImageID.Time=handles.O.CurrentTimePoint;
[handles]=O_LoadImages_Internal(hObject,handles);
% handles=DisplayImage(hObject,handles);
guidata(hObject,handles)
% --- Executes during object creation, after setting all properties.
function Time_Scale_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_Scale_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function MaxSize_Callback(hObject, eventdata, handles)
% hObject    handle to MaxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.O.Display_Mode='Regular';
MinAllowedArea=get(handles.MinSize,'value')+1;
val=max([round(get(hObject,'Value')) MinAllowedArea]);
if val>get(hObject,'max')
    set(hObject,'max',val+1)
end
set(hObject,'value',val)
[handles]=O_Update_General_Thresholds(hObject,handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function MaxSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function MinSize_Callback(hObject, eventdata, handles)
% hObject    handle to MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.O.Display_Mode='Regular';
MinAllowedArea=get(handles.MaxSize,'value');
val=min([round(get(hObject,'Value')) MinAllowedArea]);
if val>get(hObject,'max')
    set(hObject,'max',val+1)
end
set(hObject,'value',val)
[handles]=O_Update_General_Thresholds(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in FlatField_Correction.
function FlatField_Correction_Callback(hObject, eventdata, handles)

if get(hObject,'Value')
    contents = cellstr(get(handles.Flat_Field_selection,'String'));
    FileName=contents{get(handles.Flat_Field_selection,'Value')};
    load(['\\carbon.research.sickkids.ca\rkafri\OPRETTA\FlatFieldFiles\' FileName]);
    handles.O.flat.Multipicative_Biase=Multipicative_Biase;
    %     handles.O.flat.Additive_Biase=Additive_Biase;
    handles.O.flat.FileName=['\\carbon.research.sickkids.ca\rkafri\OPRETTA\FlatFieldFiles\' FileName];
    guidata(hObject, handles);
else
    handles.O.flat.Multipicative_Biase=ones(1024,1360);
end

% hObject    handle to FlatField_Correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FlatField_Correction


% --- Executes on selection change in Flat_Field_selection.
function Flat_Field_selection_Callback(hObject, eventdata, handles)
% hObject    handle to Flat_Field_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
FileName=contents{get(hObject,'Value')};
load(['\\carbon.research.sickkids.ca\rkafri\OPRETTA\FlatFieldFiles\' FileName]);
handles.O.flat.Multipicative_Biase=Multipicative_Biase;
handles.O.flat.FileName=['\\carbon.research.sickkids.ca\rkafri\OPRETTA\FlatFieldFiles\' FileName];

% handles.O.flat.Additive_Biase=Additive_Biase;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Flat_Field_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Flat_Field_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SegmentationParameters_file_name_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentationParameters_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SegmentationParameters_file_name as text
%        str2double(get(hObject,'String')) returns contents of SegmentationParameters_file_name as a double


% --- Executes during object creation, after setting all properties.
function SegmentationParameters_file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SegmentationParameters_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [handles]=CalcDark2(hObject, handles)
clc
disp(['Open Width is "selected value" X "50% image width"'])
disp(['Close Width is "selected value" X "10"'])

ch=get(handles.Display_Channal,'value');
im=handles.O.Original_IM{ch};
OWidth_alpha=get(handles.Owidth,'value');
CWidth_alpha=get(handles.Cwidth,'value');

ImageNormalizarionParameters.CWidth_alpha=CWidth_alpha;
ImageNormalizarionParameters.OWidth_alpha=OWidth_alpha;
ImageNormalizarionParameters.flat.Multipicative_Biase=[];
ImageNormalizarionParameters.flat.Additive_Biase=[];

[BG]=O_NormalizeImages(im,ImageNormalizarionParameters);
handles.O.CalcDark2.SmallIM=BG.SmallIM;
handles.O.CalcDark2.imo=BG.imo;
handles.O.CalcDark2.a=BG.imresize_alpha;
handles.O.IM{ch}=BG.BG;

guidata(hObject, handles);

function [handles]=O_RevertBG(hObject,handles)
ch=get(handles.Display_Channal,'value');
handles.O.IM{ch}=handles.O.Original_IM{ch};
guidata(hObject, handles);
% --- Executes on slider movement.
function Owidth_Callback(hObject, eventdata, handles)
% hObject    handle to Owidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.O.Display_Mode='Regular';
if get(hObject,'value')==0
    [handles]=O_RevertBG(hObject,handles);
    [handles]=O_Update_General_Thresholds(hObject,handles);
else
    [handles]=CalcDark2(hObject, handles);
    [handles]=O_Update_General_Thresholds(hObject,handles);
end
% --- Executes during object creation, after setting all properties.
function Owidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Owidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Cwidth_Callback(hObject, eventdata, handles)
% hObject    handle to Cwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.O.Display_Mode='Regular';
[handles]=CalcDark2(hObject, handles);
[handles]=O_Update_General_Thresholds(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Cwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in DispBG.
function DispBG_Callback(hObject, eventdata, handles)
% hObject    handle to DispBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.Owidth,'value')==0
    clc
    disp('Open Width set to Zero')
    set(hObject,'value',false)
else
    [handles]=O_Threshold_and_Display(hObject,handles);
end
% Hint: get(hObject,'Value') returns toggle state of DispBG


% --- Executes on button press in ch1.
function ch1_Callback(hObject, eventdata, handles)
% hObject    handle to ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Display_Channal,'value',1)
IM=handles.O.IM;
set(handles.Threshold,'Min',0,'Max',prctile(IM{1}(:),90))
if get(handles.Threshold,'max')<get(handles.Threshold,'value')
    v=get(handles.Threshold,'value');
    set(handles.Threshold,'max',v+100)
end
if ~isnan(handles.O.MaxInt(1))
    set(handles.Threshold,'Min',0,'Max',handles.O.MaxInt(1))
end

[handles]=O_Update_GUI(handles);
set(handles.figure1,'color',[0 0 1])
[handles]=O_Threshold_and_Display(hObject,handles);
%     [handles]=DisplayImage(hObject,handles);
set(handles.figure1,'color',[0.9 0.9 0.9])
guidata(hObject,handles)


% --- Executes on button press in ch2.
function ch2_Callback(hObject, eventdata, handles)
% hObject    handle to ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Display_Channal,'value',2)
IM=handles.O.IM;
if length(IM)>1
    set(handles.Threshold,'Min',0,'Max',prctile(IM{2}(:),90))
    if get(handles.Threshold,'max')<get(handles.Threshold,'value')
        v=get(handles.Threshold,'value');
        set(handles.Threshold,'max',v+100)
    end
    if ~isnan(handles.O.MaxInt(2))
        set(handles.Threshold,'Min',0,'Max',handles.O.MaxInt(2))
    end
    
    [handles]=O_Update_GUI(handles);
    set(handles.figure1,'color',[0 0 1])
    [handles]=O_Threshold_and_Display(hObject,handles);
    %     [handles]=DisplayImage(hObject,handles);
    set(handles.figure1,'color',[0.9 0.9 0.9])
    guidata(hObject,handles)
end

% --- Executes on button press in ch3.
function ch3_Callback(hObject, eventdata, handles)
% hObject    handle to ch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Display_Channal,'value',3)
IM=handles.O.IM;
if length(IM)>2
    set(handles.Threshold,'Min',0,'Max',prctile(IM{3}(:),90))
    if get(handles.Threshold,'max')<get(handles.Threshold,'value')
        v=get(handles.Threshold,'value');
        set(handles.Threshold,'max',v+100)
    end
    if ~isnan(handles.O.MaxInt(3))
        set(handles.Threshold,'Min',0,'Max',handles.O.MaxInt(3))
    end
    
    
    [handles]=O_Update_GUI(handles);
    set(handles.figure1,'color',[0 0 1])
    [handles]=O_Threshold_and_Display(hObject,handles);
    %     [handles]=DisplayImage(hObject,handles);
    set(handles.figure1,'color',[0.9 0.9 0.9])
    guidata(hObject,handles)
end

% --- Executes on button press in ch4.
function ch4_Callback(hObject, eventdata, handles)
% hObject    handle to ch4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Display_Channal,'value',4)
IM=handles.O.IM;
if length(IM)>3
    set(handles.Threshold,'Min',0,'Max',prctile(IM{4}(:),90))
    if get(handles.Threshold,'max')<get(handles.Threshold,'value')
        v=get(handles.Threshold,'value');
        set(handles.Threshold,'max',v+100)
    end
    if ~isnan(handles.O.MaxInt(4))
        set(handles.Threshold,'Min',0,'Max',handles.O.MaxInt(4))
    end

    
    [handles]=O_Update_GUI(handles);
    set(handles.figure1,'color',[0 0 1])
    [handles]=O_Threshold_and_Display(hObject,handles);
    %     [handles]=DisplayImage(hObject,handles);
    set(handles.figure1,'color',[0.9 0.9 0.9])
    guidata(hObject,handles)
end


% --- Executes on selection change in Spotting_algorithm.
function Spotting_algorithm_Callback(hObject, eventdata, handles)
% hObject    handle to Spotting_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Spotting_algorithm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Spotting_algorithm
contents = cellstr(get(hObject,'String'));
handles.O.Spotting_alg=regexprep(contents{get(hObject,'Value')},'.m','');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Spotting_algorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Spotting_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15
disp('l')

% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Max_MinSize_Callback(hObject, eventdata, handles)
% hObject    handle to Max_MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=str2num(get(hObject,'string'));
set(handles.MinSize,'max',val)
set(handles.MinSize,'val',val/2)
% Hints: get(hObject,'String') returns contents of Max_MinSize as text
%        str2double(get(hObject,'String')) returns contents of Max_MinSize as a double


% --- Executes during object creation, after setting all properties.
function Max_MinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_MaxSize_Callback(hObject, eventdata, handles)
% hObject    handle to Max_MaxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_MaxSize as text
%        str2double(get(hObject,'String')) returns contents of Max_MaxSize as a double
val=str2num(get(hObject,'string'));
set(handles.MaxSize,'max',val)
set(handles.MaxSize,'val',val/2)


% --- Executes during object creation, after setting all properties.
function Max_MaxSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_MaxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Segment_One_Image.
function Segment_One_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Segment_One_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ColorDisp,'visible','on')
set(handles.InspectedProperty,'visible','on')

Spotting_Choice=find(handles.O.General_Thresholds.Seed);
clc
if isempty(Spotting_Choice)
    disp('WARNING: NO SEEDS!!')
end

Watershed_Choice=find(handles.O.General_Thresholds.Watershed);

if isempty(Watershed_Choice)
    disp('WARNING: NO Watershed!!')
end

Nuclear_Channel=find(strcmp(handles.O.General_Thresholds.Label,'Nucleus'));
            
if isempty(Nuclear_Channel)
    disp('WARNING: NO Nucleus!!')
end

Cytoplasmic_Channel=find(strcmp(handles.O.General_Thresholds.Label,'Cell'));

if isempty(Cytoplasmic_Channel)
    disp('WARNING: NO Cell!!')
end

ImageIDs=handles.O.ImageIDs;

SegmentationParameters.NumRows=handles.O.NumRows;
SegmentationParameters.NumColumns=handles.O.NumColumns;
SegmentationParameters.magnification=handles.O.Magnification;
SegmentationParameters.DirName=[handles.O.DirName '\Images'];
SegmentationParameters.FlatField_Correction=get(handles.FlatField_Correction,'value');
SegmentationParameters.OutputDir=handles.O.OutputDir;
SegmentationParameters.DataSetName=handles.O.DataSetName;
SegmentationParameters.FlatFileName=handles.O.flat.FileName;
SegmentationParameters.Regional_Thresholding=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is to tell the software to accept ...    %%%
% input images and not load.                    %%%
SegmentationParameters.No_Loading_Images=true;  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handles.O.SegmentationParameters=SegmentationParameters;
handles.O.FlatField_Correction=get(handles.FlatField_Correction,'value');
General_Thresholds=handles.O.General_Thresholds;


% DEFINING A SINGLE IMAGE AS AN INPUT TO O_SegmentCells_v6
T=handles.O.CurrentTimePoint;
ImageIDs=handles.O.ImageIDs;

I=find(ImageIDs.Channel==1);
ImageIDs=ImageIDs(I,:);
ImageIDs(:,{'Channel'})=[];

[tf,loc]=ismember(ImageIDs(:,handles.O.ImageID.Properties.VariableNames),handles.O.ImageID);
I=find(tf & ImageIDs.Time==T);

set(handles.OperationLabel,'string','Inspect')
set(handles.OperationLabel,'BackgroundColor','m','FontWeight','bold','ForegroundColor','w')

Data.O=handles.O;
t1=datetime;
t2=datetime;
K=0.2;
[iterTable,ImageID,O]=O_SegmentCells_v6_SingleImage(Data.O,ImageIDs(I,:),t1,t2);
handles.O.BW_color=O.BW;
if isempty(iterTable)
    clc
    disp('NOT ENOUGH PARAMETERS TO SEGMENT')
end
handles.O.ResultTable=iterTable;

if get(handles.ColorDisp,'value')
    handles.O.Display_Mode='ColorInspection';
else
    handles.O.Display_Mode='Inspection';
end
Prop=handles.O.ResultTable.Properties.VariableNames';
Prop=[Prop];
set(handles.InspectedProperty,'String',Prop)
[handles]=O_Threshold_and_Display(hObject,handles);


% --- Executes on selection change in InspectedProperty.
function InspectedProperty_Callback(hObject, eventdata, handles)
% hObject    handle to InspectedProperty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns InspectedProperty contents as cell array
%        contents{get(hObject,'Value')} returns selected item from InspectedProperty
if get(handles.ColorDisp,'value')
    handles.O.Display_Mode='ColorInspection';
else
    handles.O.Display_Mode='Inspection';
end
[handles]=O_Threshold_and_Display(hObject,handles);


% --- Executes during object creation, after setting all properties.
function InspectedProperty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InspectedProperty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ColorDisp.
function ColorDisp_Callback(hObject, eventdata, handles)
% hObject    handle to ColorDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ColorDisp
if get(handles.ColorDisp,'value')
    handles.O.Display_Mode='ColorInspection';
else
    handles.O.Display_Mode='Inspection';
end
[handles]=O_Threshold_and_Display(hObject,handles);


% --- Executes on button press in LoadParameters.
function LoadParameters_Callback(hObject, eventdata, handles)
% hObject    handle to LoadParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB code file');
load([PathName '\' FileName])

set(handles.Dataset_selection,'value',Data.O.Dataset_num)
[handles]=Dataset_selection_Callback(hObject, eventdata, handles);
guidata(hObject,handles)
Image_selection_Callback(hObject, eventdata, handles);


handles.O.General_Thresholds=Data.O.General_Thresholds;
set(handles.uitable3,'Data',table2cell(handles.O.General_Thresholds));

Labels=handles.O.General_Thresholds.Name;

% REMOVING THE CH BUTTONS FOR NON-IMAGED CHANNALS
for i=1:4
    if ismember(i,handles.O.ImagedChannels)
        eval(['set(handles.ch' num2str(i) ',''string'',Labels{' num2str(i) '})'])
        eval(['set(handles.ch' num2str(i) ',''visible'',''on'')'])
    else
        eval(['set(handles.ch' num2str(i) ',''visible'',''off'')'])
    end
end
[handles]=O_Update_All_GUI_buttons(handles);
[handles]=O_Update_GUI(handles);
guidata(hObject, handles);


%% CENTER FUNCTIONS

function [handles]=O_Spot_Image(hObject,handles)

% CHANNAL INFORMATION
ch=get(handles.Display_Channal,'value');

% START SPOTTING
im=handles.O.IM{ch};
alpha= get(handles.smoothing_slider, 'Value');
thr=handles.O.General_Thresholds.Intensity_thr(ch);
BW=handles.O.BW{ch};
eval(['[BW_spots,sIM_small]=' handles.O.Spotting_alg '(alpha,im,thr);'])
BW_spots=BW_spots&BW;
[x,y]=find(BW_spots);
handles.O.BW_spots{ch}=BW_spots;
figure(999)
imshow(im,[])
hold on
plot(y,x,'or')
hold off
handles.O.Watershed_not_calculated(ch)=true;
guidata(hObject,handles)

function [handles]=O_Threshold_and_Display(hObject,handles)

% STEP #1: CALCULATE SEEDS & SMOOTHED IM
for ch=handles.O.ImagedChannels'
    im=handles.O.IM{ch};
    alpha=handles.O.General_Thresholds.smoothing_alpha(ch);
    thr=handles.O.General_Thresholds.Intensity_thr(ch);
    if alpha==0
        handles.O.BW_spots{ch}=zeros(size(im));
        handles.O.sIM_small{ch}=[];
    else
        eval(['[BW_spots,sIM_small]=' handles.O.Spotting_alg '(alpha,im,thr);'])
        handles.O.BW_spots{ch}=BW_spots;
        handles.O.sIM_small{ch}=sIM_small;
    end
end

% STEP #2: THRESHOLD
for ch=handles.O.ImagedChannels'
    thr=handles.O.General_Thresholds.Intensity_thr(ch);
    im=handles.O.IM{ch};
    handles.O.BW{ch}=im>thr;
    handles.O.BW{ch}=imopen(handles.O.BW{ch},strel('square',2));
    handles.O.BW_spots{ch}=handles.O.BW_spots{ch}&handles.O.BW{ch};
end

% STEP #3: WATERSHED
clc
Cell_ch=find(strcmp(handles.O.General_Thresholds.Label,'Cell'));

% change channal order so that "cell" is last
Channals=[setdiff(handles.O.ImagedChannels,Cell_ch) ; Cell_ch];

for ch=Channals'
    [Condition,Seeds]=Choose_Seeds(handles.O,ch);
                                                                                                                           % CONDITIONS FOR WATERSHEDDING
    if ~strcmp(get(handles.OperationLabel,'string'),'SEEDS') ...                    % CONDITION 1: user is NOT currently in the process of seeding
            && any(Seeds(:))                                                                                  % CONDITION 2: seeds have been identified                                                       
        if handles.O.Watershed_not_calculated(ch)                                          % CONDITION 3: watershed has not yet been calculated
                                                                                                                           %                        watershed is recalculated in 3 conditions: 
                                                                                                                           %                        a. re-seeding
                                                                                                                           %                        b. choosing a new def for Nuc Channal
                                                                                                                           %                        c. loading new images  
            im=handles.O.IM{ch};
            sIM_small=handles.O.sIM_small{ch};
            handles.O.WS{ch}=O_WaterShedCells( im,Seeds,sIM_small );
            handles.O.BW_spots{ch}=Seeds;
            handles.O.Watershed_not_calculated(ch)=false;
            handles.O.SeedChoice{ch}=Condition;
        end
        if ~isempty(handles.O.WS{ch})
            handles.O.BW{ch}=handles.O.BW{ch}&handles.O.WS{ch};
        end
        handles.O.BW{ch}=imreconstruct(Seeds>0,handles.O.BW{ch}>0);
        % clean up
        handles.O.BW{ch}=imfill(handles.O.BW{ch},'holes');
        Mn=handles.O.General_Thresholds.Min_Area(ch);
        Mx=handles.O.General_Thresholds.Max_Area(ch);
        handles.O.BW{ch}=bwareafilt(handles.O.BW{ch},[Mn Mx+1]);
    end
    handles.O.BW{ch}=imclearborder(handles.O.BW{ch});
end

% prepare info
ch=get(handles.Display_Channal,'value');
im=handles.O.IM{ch};
Cell_ch=find(strcmp(handles.O.General_Thresholds.Label,'Cell'));
Nucleus_ch=find(strcmp(handles.O.General_Thresholds.Label,'Nucleus'));
Display_Mode=handles.O.Display_Mode;
if ~strcmpi(handles.O.Display_Mode,'Inspection') && ~strcmpi(handles.O.Display_Mode,'ColorInspection')
    if strcmp(handles.O.SeedChoice{ch},'Use Nucleii as seeds')
        Display_Mode='ShowNuc';
    end
end


% show image
figure(999)
clf
LineScanPos=round((1-get(handles.slider6,'Value'))*(size(im,1)-1)+1);
IntMx=max(im(:));
IntMn=min(im(:));
DeltaInt=IntMx-IntMn;
IntMx=IntMx-DeltaInt*(1-get(handles.Image_contrast_2,'value'));
IntMn=IntMn+DeltaInt*get(handles.Image_contrast_1,'value');

switch Display_Mode
    case 'ShowNuc'
        BW=handles.O.BW{ch};
        if isempty(Nucleus_ch)
            Nuc=zeros(size(im));
        else
            Nuc=handles.O.BW{Nucleus_ch}>0;
        end
        Cell=BW>0;
        Nuc=Nuc&BW;
        Cell=imreconstruct(Nuc,Cell);
        img1=showseg_thick(NormalizeImage(im,[IntMn IntMx]),Cell,[1 0 0]);        
        img2=showseg_thick(img1,Nuc,[0 1 0]);
        imshow(img2)
        handles.O.BW{ch}=BW;
        line([1 size(im,2)],[LineScanPos LineScanPos])
        title('Segmented Nuclei are used as seeds')
    case 'Regular'
        BW=handles.O.BW{ch};
        imshow(showseg_thick(NormalizeImage(im,[IntMn IntMx]),BW,[1 0 0]))
        line([1 size(im,2)],[LineScanPos LineScanPos])
        SpottingChoice=find(handles.O.General_Thresholds.Seed);
        if isempty(SpottingChoice)
            SpottingChoice=ch;
        end
        alpha=handles.O.General_Thresholds.smoothing_alpha(SpottingChoice);
        if alpha>0
            if ~isempty(handles.O.BW_spots{SpottingChoice})
                [x,y]=find(handles.O.BW_spots{SpottingChoice});
                hold on
                plot(y,x,'o','markersize',3,'MarkerEdgeColor','b','MarkerFaceColor',[0.7 0.7 0.7])
                hold off
            end
            if ~isempty(find(handles.O.General_Thresholds.Seed))
                title('Spotting channal is used for seeds')
            end
        end
    case 'Inspection'
        Nucleus_ch=find(strcmp(handles.O.General_Thresholds.Label,'Nucleus'));
        Cell_ch=find(strcmp(handles.O.General_Thresholds.Label,'Cell'));
        
        InsPropVal=handles.InspectedProperty.Value;
        InsProp=handles.InspectedProperty.String{InsPropVal};
        im1=showseg_thick(NormalizeImage(handles.O.IM{ch}),handles.O.BW{Nucleus_ch},[1 0 0]);
        if isempty(Cell_ch)
            im2=im1;
        else
            im2=showseg_thick(im1,handles.O.BW{Cell_ch},[0 0 1]);
        end
        imshow(im2)
        
        for ii=1:size(handles.O.ResultTable.Centroid,1)
            vals=eval(['handles.O.ResultTable.' InsProp '(ii,:)']);
            
            if length(vals)>1
                if ~strcmp(InsProp,'Centroid')
                    vals=vals(ch);
                end
            end
            if isnumeric(vals(1,1))
                str=sprintf('\n%.1E',vals);
                text(handles.O.ResultTable.Centroid(ii,1),handles.O.ResultTable.Centroid(ii,2),str,'color','m','fontsize',6)
            end
        end
    case 'ColorInspection'
        if ~isempty(handles.O.ResultTable)
            InsPropVal=handles.InspectedProperty.Value;
            InsProp=handles.InspectedProperty.String{InsPropVal};
            if ~strcmp(InsProp,'Centroid')
                Nucleus_ch=find(strcmp(handles.O.General_Thresholds.Label,'Nucleus'));
                Cell_ch=find(strcmp(handles.O.General_Thresholds.Label,'Cell'));
                NBW=handles.O.BW_color{Nucleus_ch};
                vals=eval(['handles.O.ResultTable.' InsProp]);
                if size(vals,2)>1
                    vals=vals(:,ch);
                end
                if isnumeric(vals(1))
                    for iN=1:max(NBW(:))
                        NBW(NBW==iN)=vals(iN);
                    end
                    imshow(NBW,[min(vals) max(vals)]);colormap jet
                end
            end
        end
end


figure(998)
ch=get(handles.Display_Channal,'value');
thr=handles.O.General_Thresholds.Intensity_thr(ch);
if get(handles.DispBG,'value')
    smallIM=handles.O.CalcDark2.SmallIM;
    imo=handles.O.CalcDark2.imo;
    a=handles.O.CalcDark2.a;
    plot(smallIM(round(LineScanPos*a),:),'k');
    hold on
    plot(imo(round(LineScanPos*a),:),'r');
    axis tight
    hold off
    set(gca,'xtick',[],'ytick',[])
else
    plot(im(LineScanPos,:));
    hold on
    line([1 size(im,2)],[thr thr],'color','m')
    axis tight
    hold off
    set(gca,'xtick',[],'ytick',[])
end


guidata(hObject,handles)

function [imn]=NormalizeImage(im,varargin)

IM=im2double(im);
imn=(IM-min(IM(:)))/(max(IM(:))-min(IM(:)));

if ~isempty(varargin)
    imn=(IM-varargin{1}(1))/(varargin{1}(2)-varargin{1}(1)); %%??
end

function [handles]=O_Update_General_Thresholds(hObject,handles)
set(handles.uitable3,'data',handles.uitable3.Data(handles.O.ImagedChannels,:))

ch=get(handles.Display_Channal,'value');

Nuclear_Channel=find(strcmp(handles.uitable3.Data(:,2),'Nucleus'));
Cytoplasmic_Channel=find(strcmp(handles.uitable3.Data(:,2),'Cell'));

handles.O.General_Thresholds.Intensity_thr(ch)=get(handles.Threshold,'value');
handles.O.General_Thresholds.smoothing_alpha(ch)=get(handles.smoothing_slider,'value');
handles.O.General_Thresholds.Min_Area(ch)=get(handles.MinSize,'value');
handles.O.General_Thresholds.Max_Area(ch)=get(handles.MaxSize,'value');
handles.O.General_Thresholds.OpenW(ch)=get(handles.Owidth,'value');
handles.O.General_Thresholds.CloseW(ch)=get(handles.Cwidth,'value');

set(handles.uitable3,'Data',table2cell(handles.O.General_Thresholds))
guidata(hObject,handles)
set(handles.uitable3,'CellEditCallback', {@thrCheck_Callback, handles});



if isfield(handles.O,'IM') % only if images have been loaded
    [handles]=O_Threshold_and_Display(hObject,handles);
end

function [handles]=O_Update_GUI(handles)
ch=get(handles.Display_Channal,'value');

val=handles.O.General_Thresholds.Intensity_thr(ch);
set(handles.Threshold,'value',val);
if val<=get(handles.Threshold,'min')
    set(handles.Threshold,'min',val*0.2);
elseif val>=get(handles.Threshold,'max')
    set(handles.Threshold,'max',val*2+0.1);
end


set(handles.smoothing_slider,'min',0);
set(handles.smoothing_slider,'max',1);
val=handles.O.General_Thresholds.smoothing_alpha(ch);
val=min(val,1);
val=max(val,0);
set(handles.smoothing_slider,'value',val);

val=handles.O.General_Thresholds.Min_Area(ch);
set(handles.MinSize,'value',val);
if val<=get(handles.Threshold,'min')
    set(handles.MinSize,'min',val*0.2);
elseif val>=get(handles.Threshold,'max')
    set(handles.MinSize,'max',val*2+0.1);
end

val=handles.O.General_Thresholds.Max_Area(ch);
set(handles.MaxSize,'value',val);
if val<=get(handles.Threshold,'min')
    set(handles.MaxSize,'min',val*0.2);
elseif val>=get(handles.Threshold,'max')
    set(handles.MaxSize,'max',val*2+0.1);
end


val=handles.O.General_Thresholds.OpenW(ch);
val=min(val,get(handles.Owidth,'max'));
val=max(val,get(handles.Owidth,'min'));
set(handles.Owidth,'value',val);

val=handles.O.General_Thresholds.CloseW(ch);
val=min(val,get(handles.Cwidth,'max'));
val=max(val,get(handles.Cwidth,'min'));
set(handles.Cwidth,'value',val);

function [handles]=O_Update_All_GUI_buttons(handles)
for ch=1:length(handles.O.General_Thresholds.Intensity_thr)
    
    val=handles.O.General_Thresholds.Intensity_thr(ch);
    set(handles.Threshold,'value',val);
    if val<=get(handles.Threshold,'min')
        set(handles.Threshold,'min',val*0.2);
    elseif val>=get(handles.Threshold,'max')
        set(handles.Threshold,'max',val*2+0.1);
    end
    
    
    set(handles.smoothing_slider,'min',0);
    set(handles.smoothing_slider,'max',1);
    val=handles.O.General_Thresholds.smoothing_alpha(ch);
    val=min(val,1);
    val=max(val,0);
    set(handles.smoothing_slider,'value',val);
    
    val=handles.O.General_Thresholds.Min_Area(ch);
    set(handles.MinSize,'value',val);
    if val<=get(handles.Threshold,'min')
        set(handles.MinSize,'min',val*0.2);
    elseif val>=get(handles.Threshold,'max')
        set(handles.MinSize,'max',val*2+0.1);
    end
    
    val=handles.O.General_Thresholds.Max_Area(ch);
    set(handles.MaxSize,'value',val);
    if val<=get(handles.Threshold,'min')
        set(handles.MaxSize,'min',val*0.2);
    elseif val>=get(handles.Threshold,'max')
        set(handles.MaxSize,'max',val*2+0.1);
    end
    
    
    val=handles.O.General_Thresholds.OpenW(ch);
    val=min(val,get(handles.Owidth,'max'));
    val=max(val,get(handles.Owidth,'min'));
    set(handles.Owidth,'value',val);
    
    val=handles.O.General_Thresholds.CloseW(ch);
    val=min(val,get(handles.Cwidth,'max'));
    val=max(val,get(handles.Cwidth,'min'));
    set(handles.Cwidth,'value',val);
end

function [handles]=O_LoadImages_Internal(hObject,handles)
handles.O.Dataset_num=get(handles.Dataset_selection,'value');
handles.O.LoadingPie=true;
handles.O.FlatField_Correction=get(handles.FlatField_Correction,'value');
handles.O.Selected_ch=get(handles.Display_Channal,'value');
clc
disp('Loading Images')
disp(handles.O.ImageID)
[O]=O_LoadImages(handles.O);
handles.O=O;
IM=handles.O.IM;
for k=1:length(IM)
    if isnan(handles.O.MaxInt(k))
        set(handles.Threshold,'Min',0,'Max',prctile(IM{k}(:),90))
    else
         set(handles.Threshold,'Min',0,'Max',handles.O.MaxInt(k))
    end
end
MaxAllowedArea=0.95*prod(size(IM{1}));
set(handles.MaxSize,'max',MaxAllowedArea)
set(handles.MinSize,'max',MaxAllowedArea/10)
set(handles.MaxSize,'min',0)
set(handles.MinSize,'min',0)
if get(handles.Threshold,'max')<get(handles.Threshold,'value')
    v=get(handles.Threshold,'value');
    set(handles.Threshold,'max',v+100)
end

% RESETTING THE NEWLY SEEDED CRITERIA
handles.O.Watershed_not_calculated=true(1,length(handles.O.ImagedChannels));


[handles]=O_Update_General_Thresholds(hObject,handles);
guidata(hObject,handles)


% --- Executes on slider movement.
function Smoothing_slider_2_Callback(hObject, eventdata, handles)
% hObject    handle to Smoothing_slider_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Smoothing_slider_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Smoothing_slider_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider21_Callback(hObject, eventdata, handles)
% hObject    handle to slider21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

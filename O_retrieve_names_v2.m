function [ImageID,BaseName,NumberLengths]=O_retrieve_names_v2(DirName,FileType)
BaseName=0;
counter=0;

if ~strcmpi(FileType,'Operetta')
    listing=dir([DirName]);
    
    for i=1:length(listing)
        IsTiff=~isempty(strfind(listing(i).name,'.tif'));
        if IsTiff
            counter=counter+1;
            [T,BaseName,NumberLengths]=CollectImageNumbers(listing(i).name,FileType);
            if ~exist('ImgTable')
                ImgTable=T;
                if strcmp(FileType,'FileType3')
                    
                end
            else
                ImgTable=[ImgTable;T];
                if strcmp(FileType,'FileType3')
                    
                end

            end
            if mod(i,10)==0
                figure(999)
                hold off
                barh(i/length(listing),'facecolor','r');axis([0 1 0.5 1.5])
                title('Loading Image Directory')
                drawnow
            end
        end
    end
    if min(ImgTable.Channel)==0
        ImgTable.Channel=ImgTable.Channel+1;
    end
    ImageID=ImgTable;
elseif strcmpi(FileType,'Operetta')
    listing=dir([DirName '\Images']);
    D=dir([DirName '\Assaylayout']);
    s = xml2struct([DirName '\Assaylayout\' D(3).name]);
    for i=1:length(s.AssayLayout.Layer)
        s.AssayLayout.Layer{i}.Name.Text=regexprep(s.AssayLayout.Layer{i}.Name.Text,'\W*','_');
    end
    
    for i=1:length(s.AssayLayout.Layer)
        eval(['Parameter' num2str(i) '=s.AssayLayout.Layer{' num2str(i) '}.Name.Text;'])
        eval(['Parameter' num2str(i) '=regexprep(Parameter' num2str(i) ',''[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]'','''');'])
    end
    if length(s.AssayLayout.Layer{1}.Well)==1 %% This if condition added by Shixuan
        C=str2num(s.AssayLayout.Layer{1}.Well.Col.Text);
        R=str2num(s.AssayLayout.Layer{1}.Well.Row.Text);
        PlateMap.color(R,C)=str2num(s.AssayLayout.Layer{3}.Well.Color.Text);
        for i2=1:length(s.AssayLayout.Layer)
            eval(['PlateMap.Parameter' num2str(i2) '{R,C}=s.AssayLayout.Layer{1}.Well.Value.Text;'])
        end
    else
        for i=1:length(s.AssayLayout.Layer{1}.Well)
            C=str2num(s.AssayLayout.Layer{1}.Well{i}.Col.Text);
            R=str2num(s.AssayLayout.Layer{1}.Well{i}.Row.Text);
            PlateMap.color(R,C)=str2num(s.AssayLayout.Layer{3}.Well{i}.Color.Text);
            for i2=1:length(s.AssayLayout.Layer)
                eval(['PlateMap.Parameter' num2str(i2) '{R,C}=s.AssayLayout.Layer{1}.Well{i}.Value.Text;'])
            end
        end
    end
    clear Parameter1 Parameter2 Parameter3 Parameter4
    for i=1:length(listing)
        IsTiff=~isempty(strfind(listing(i).name,'.tiff'));
        if IsTiff
            counter=counter+1;
            FileNumbers=regexp(listing(i).name,'r(?<row>\d+)c(?<column>\d+)f(?<field>\d+)p(?<plate>\d+)-ch(?<channal>\d+)sk(?<time>\d+)','names');
            C=str2num(FileNumbers.column);
            Column(counter,1)=C;
            R=str2num(FileNumbers.row);
            Row(counter,1)=R;
            Field(counter,1)=str2num(FileNumbers.field);
            Plate(counter,1)=str2num(FileNumbers.plate);
            Channel(counter,1)=str2num(FileNumbers.channal);
            Time(counter,1)=str2num(FileNumbers.time);
            FileNumber(counter,1)=counter;
            FileName{counter,1}=listing(i).name;
            FileDate{counter,1}=listing(i).date;
            Color(counter,1)=PlateMap.color(R,C);
            for i2=1:length(s.AssayLayout.Layer)
                eval([s.AssayLayout.Layer{i2}.Name.Text '{counter,1}=PlateMap.Parameter' num2str(i2) '{R,C};'])
            end
        end
    end
    ImageID=table(Row,Column,Channel,Field,Time,Plate,FileNumber,FileName,FileDate,Color);
    for i2=1:length(s.AssayLayout.Layer)
        eval(['T=table(' s.AssayLayout.Layer{i2}.Name.Text ');'])
        ImageID = [ImageID T];
    end
    BaseName=NaN;
    NumberLengths=NaN;
end




function [T,BaseName,NumberLengths]=CollectImageNumbers(filename,FileType)

if strcmpi(FileType,'FileType1')
    % NameType #1
    % example: LKB1_PML_S0003(P4)_C02_M0000_ORG.tif
    Nums=regexp(filename,'(?<BaseName>.*)_S(?<S>\d+)\(\w+(?<P>\d+)\)_C(?<Channel>\d+)_M(?<M>\d+)_ORG.tif','names');
    BaseName=Nums.BaseName;
    Nums=rmfield(Nums,'BaseName');
    NumberLengths=structfun(@length,Nums)';
    T=array2table(structfun(@str2num,Nums)','variablenames',fieldnames(Nums)');
    % T=[T table(1,'variablename',{'Time'}) table({filename},'variablename',{'FileName'})];
    T=[T table(1,'variablename',{'Time'})];
elseif strcmpi(FileType,'FileType2')
    % NameType #2
    % example: New_S0000(TR1)_C00_M0000_ORG.tif
    Nums=regexp(filename,'(?<BaseName>.*)_S(?<S>\d+)\(\w+(?<P>\d+)\)_C(?<Channel>\d+)_M(?<M>\d+)_ORG.tif','names');
    BaseName=Nums.BaseName;
    Nums=rmfield(Nums,'BaseName');
    NumberLengths=structfun(@length,Nums)';
    T=array2table(structfun(@str2num,Nums)','variablenames',fieldnames(Nums)');
    % T=[T table(1,'variablename',{'Time'}) table({filename},'variablename',{'FileName'})];
    T=[T table(1,'variablename',{'Time'})];
elseif strcmpi(FileType,'FileType3')
    % NameType #2
    % example: New_S0000(TR1)_C00_M0000_ORG.tif
    Nums=regexp(filename,'(?<BaseName>.*)_S(?<S>\d+)\((?<P>.+)\)_C(?<Channel>\d+)\((?<ch_name>.+)\)_M(?<M>\d+)','names');
    BaseName=Nums.BaseName;
    ch_name=Nums.ch_name;
    Well_Num=Nums.P(1:2);
    Nums=rmfield(Nums,'BaseName');
    Nums=rmfield(Nums,'ch_name');
    Nums=rmfield(Nums,'P');
    NumberLengths=structfun(@length,Nums)';
    T=array2table(structfun(@str2num,Nums)','variablenames',fieldnames(Nums)');
    % T=[T table(1,'variablename',{'Time'}) table({filename},'variablename',{'FileName'})];
    T=[T table(1,'variablename',{'Time'})];
    Row=findstr(Well_Num(1),'ABCDEFGH');
    Column=str2num(Well_Num(2));
    T=[T table(Row,'variablename',{'Row'})];
    T=[T table(Column,'variablename',{'Column'})];
    T=[T table({ch_name},'variablename',{'ch_name'})];
elseif strcmpi(FileType,'Operetta')
    
end






function Show_Selected_Cell(ResultTable,Data)

%% Plot data and choose cell.

Sample= ResultTable.Row==2 & ResultTable.Column==2;
figure(1000)
X=ResultTable.NArea(Sample);
Y=log(ResultTable.NInt(Sample,2));
plot(X,Y,'.')
[x,y,button] = ginput(1);

xy=[ones(length(X),1)*x ones(length(Y),1)*y];
XY=[X Y];
D=pdist2(XY,xy);
D=D(:,1);
[mn,mni]=min(D);
test=find(Sample);
SelectedCell=test(mni);

%% Find and segment single image.
ImageIDs=Data.O.ImageIDs;
t1=datetime;
t2=datetime;

I= ImageIDs.Row==ResultTable.Row(SelectedCell) ...
    & ImageIDs.Column==ResultTable.Column(SelectedCell) ...
    & ImageIDs.Field==ResultTable.Field(SelectedCell) ...
    & ImageIDs.Channel==1;


[iterTable,ImageID,O]=O_SegmentCells_v6_SingleImage(Data.O,ImageIDs(I,:),t1,t2);
figure(2000);imshowpair(O.IM{1},bwperim(O.BW{1}))
text(ResultTable.Centroid(SelectedCell,1),ResultTable.Centroid(SelectedCell,2),'x','Color','r')










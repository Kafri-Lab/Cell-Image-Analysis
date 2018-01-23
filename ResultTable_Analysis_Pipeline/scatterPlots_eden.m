function scatterPlots_eden(statTab)


legends = {'LKB1', 'AMPKa1','control25','AMPKa2', 'a1a2', 'UT', 'STRADa', 'STRADb','control50','BRSK1'};

edgeColor = [repmat([0 0 0],5,1); 1 1 1; repmat([0 0 0],4,1)];
faceColor = [.5 0 0; .8 0 0; 0 0 .7; .5 .5 0; .8 .8 0; 0 0 1; 0 .8 0; .3 .3 1; 1 0 1; .7 .9 .3; ];
%faceColor = [ 0.8 0 0; .4 .4 1; 0 0.7 0; .8 .8 0; 0 0 1; 1 0 1; 1 .5 .5; .8 .8 1; .4 1 .4; 1 1 0.4];

%% Plot size-proportion
figure();
for col = 2:11
    idx = statTab.Column==col;
    scatter(statTab.MedianSize(idx,2), statTab.Props(idx,1), 250, ...
        'MarkerFaceColor', faceColor(col-1,:), 'MarkerEdgeColor',edgeColor(col-1,:), 'LineWidth',2);
    hold on; %pause
end
xlabel('EG1 Cell Size (SE)'); ylabel('EG1 Proportion'); set(gca, 'FontSize', 12);
legend(legends);

figure();
for col = 2:11
    idx = statTab.Column==col;
    scatter(statTab.MedianSize(idx,end), sum(statTab.Props(idx,1:3),2), 250, ...
        'MarkerFaceColor', faceColor(col-1,:), 'MarkerEdgeColor',edgeColor(col-1,:), 'LineWidth',2);
    hold on; %pause
end
xlabel('G1 Cell Size (SE)'); ylabel('G1 proportion'); set(gca, 'FontSize', 12);
%% Plot size-number
figure();
for col = 2:11
    idx = statTab.Column==col;
    scatter(statTab.MedianSize(idx,2), statTab.CellNum(idx,1), 250, ...
        'MarkerFaceColor', faceColor(col-1,:), 'MarkerEdgeColor',edgeColor(col-1,:), 'LineWidth',2);
    hold on; %pause
end
xlabel('EG1 Cell Size (SE)'); ylabel('Cell Number'); set(gca, 'FontSize', 12);

%%
figure();
for col = 2:11
    idx = statTab.Column==col;
    scatter(statTab.NucArea(idx,2), statTab.Props(idx,1), (10-statTab.Row(idx))*30, ...
        'MarkerFaceColor', faceColor(col-1,:), 'MarkerEdgeColor',edgeColor(col-1,:), 'LineWidth',2);
    hold on; %pause
end
xlabel('EG1 Cell Size (NucArea)'); ylabel('EG1 Proportion'); set(gca, 'FontSize', 12);
end
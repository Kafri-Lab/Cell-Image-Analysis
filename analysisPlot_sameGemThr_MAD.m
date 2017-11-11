  %% This script use DAPI and Geminin to divide cells into different cell cycle stages
Wells = unique(ResultTable(:,1:2));
CellNum = ones(size(Wells,1), 2)*nan; % 1st col raw number, 2nd col corrected number
Props = ones(size(Wells,1), 5)*nan; % EG1, LG1, G1S, S, G2
MedianSize = ones(size(Wells,1), 7)*nan; % average, EG1, LG1, G1S, S, G2, G1(EG1+LG1+G1S)
DNA2N = ones(size(Wells,1),1)*nan; % DAPI level for 2N
NucArea = ones(size(Wells,1), 7)*nan; % average, EG1, LG1, G1S, S, G2, G1(EG1+LG1+G1S)
sizeMAD = ones(size(Wells,1), 7)*nan; % average, EG1, LG1, G1S, S, G2, G1(EG1+LG1+G1S)

Gem = log(ResultTable.NInt(:,2));
[fg, xg] = ksdensity(Gem, linspace(prctile(Gem, 0.1), prctile(Gem, 99.9),500));
pk1Gem = xg(fg==max(fg));
xg = xg(fg>max(fg)/20); fg = fg(fg>max(fg)/20);
[pks,loc] = findpeaks(fg); 
if length(pks)==2
    pk2Gem = xg(loc(2));
else
    pk2Gem = xg(max(loc)); % pk2Gem = xg(loc((pks==max(pks(find(diff(pks)>0,1):end)))));
end

for kk = 1:size(Wells,1)
    row = Wells.Row(kk);
    col = Wells.Column(kk);
    Cells = ResultTable(ResultTable.Row==row&ResultTable.Column==col,:);
    Cells = Cells(Cells.NInt(:,2)>0,:); %get rid of cells with negative geminin level
    if size(Cells, 1)<200; continue; end % no cell data
    DNA = Cells.NInt(:,1);
    Gem = log(Cells.NInt(:,2));
    Size = Cells.CInt(:,3);
    N_Area = Cells.NArea;
    % Set adaptive thresholds for DNA
    [fi,xi] = ksdensity(DNA,linspace( prctile(DNA,0.5),prctile(DNA, 98), 5e2));
    xi = xi(fi>max(fi)/5); fi = fi(fi>max(fi)/5);
     [~,loc] = findpeaks(fi); 
     if length(loc)==1
         pk1DNA = xi(loc);   
     elseif length(loc)==2
         pk1DNA = xi(min(loc));
     else
         continue;
     end
%     pk1DNA = xi(fi==max(fi));  % DNA level of 2N peak
%     [fi,xi] = ksdensity(DNA, 0.5*pk1DNA:0.02*pk1DNA:2.5*pk1DNA);
%     pk1DNA = xi(fi==max(fi));
    DNA2N(kk)=pk1DNA;
    %pk2DNA = xi(fi==max(fi(xi>1.7*pk1DNA)));
    DNA_thr1 = 0.8*pk1DNA;
    DNA_thr2 = 1.2*pk1DNA;
    DNA_thr3 = 1.85*pk1DNA;
    DNA_thr4 = 2.3*pk1DNA;
%     % Set adaptive thresholds for Geminin
%     [fj,xj] = ksdensity(Gem(DNA>DNA_thr1&DNA<DNA_thr2)); % find 1st peak of Gem
%     xj = xj(fj>0.05); fj = fj(fj>0.05);
%     pk1Gem = xj(fj==max(fj));
%     [fj,xj] = ksdensity(Gem(DNA>DNA_thr3&DNA<DNA_thr4)); % find 1st peak of Gem
%     xj = xj(fj>0.05); fj = fj(fj>0.05);
%     [~,loc] = findpeaks(fj); 
%     pk2Gem = xj(fj==max(fj)); %xj(max(loc));   

    Gem_thr1 = pk1Gem + 0.25*(pk2Gem - pk1Gem);
    Gem_thr2 = pk1Gem + 0.8*(pk2Gem - pk1Gem);
    Gem_thr3 = (Gem_thr1+Gem_thr2)/2;
    % Index for different cell cycle groups
    idxEG1 = DNA>DNA_thr1 & DNA<DNA_thr2*1.05 & Gem<Gem_thr1;
    idxLG1 = DNA>DNA_thr1 & DNA<DNA_thr2 & Gem>Gem_thr1 & Gem<Gem_thr2;
    idxG1S = DNA>DNA_thr1 & DNA<DNA_thr2 & Gem>Gem_thr2;
    idxS = DNA>DNA_thr2 & DNA<DNA_thr3 & Gem>Gem_thr1+0.1;
    idxG2 = DNA>DNA_thr3 & DNA<DNA_thr4 & Gem>Gem_thr3;
    idxAll = idxEG1|idxLG1|idxG1S|idxS|idxG2;
    % Calculate
    CellNum(kk,1) = size(Cells, 1); % raw cell number
    CellNum(kk,2) = sum(idxAll); % corrected cell number (within reasonable DNA level)
    Props(kk,:) = [sum(idxEG1) sum(idxLG1) sum(idxG1S) sum(idxS) sum(idxG2)] /sum(idxAll) ; % EG1, LG1, G1S, S, G2
    MedianSize(kk,:) = [median(Size(idxAll)) median(Size(idxEG1)) median(Size(idxLG1)) median(Size(idxG1S))...
        median(Size(idxS)) median(Size(idxG2)) median(Size(idxEG1|idxLG1|idxG1S))]; % average, EG1, LG1, G1S, S, G2  
    NucArea(kk,:) = [median(N_Area(idxAll)) median(N_Area(idxEG1)) median(N_Area(idxLG1)) median(N_Area(idxG1S))...
        median(N_Area(idxS)) median(N_Area(idxG2)) median(N_Area(idxEG1|idxLG1|idxG1S))]; % average, EG1, LG1, G1S, S, G2      
    sizeMAD(kk,:) = [mad(Size(idxAll),1) mad(Size(idxEG1),1) mad(Size(idxLG1),1) mad(Size(idxG1S),1)...
        mad(Size(idxS),1) mad(Size(idxG2),1) mad(Size(idxEG1|idxLG1|idxG1S),1)]; % average, EG1, LG1, G1S, S, G2  

    % Visualization
    figure(1);
    subplot(1,2,1)
    plot(DNA(idxEG1), Gem(idxEG1), 'go');hold on;
    plot(DNA(idxLG1), Gem(idxLG1), 'ro');
    plot(DNA(idxG1S), Gem(idxG1S), 'yo');
    plot(DNA(idxS), Gem(idxS), 'co');
    plot(DNA(idxG2), Gem(idxG2), 'mo');
    plot(DNA, Gem, '.'); 
    plot([1 1]*pk1DNA, [prctile(Gem, 1) prctile(Gem, 98)], 'k'); %2N DNA
    plot([prctile(DNA, 1) prctile(DNA, 98)], [1 1]*pk1Gem, 'k');
    plot([prctile(DNA, 1) prctile(DNA, 98)], [1 1]*pk2Gem, 'k'); hold off
    %legend('EG1', 'LG1', 'G1S', 'S', 'G2');
    title(['Well: row ' int2str(row) ', col ' int2str(col)])
    set(gca, 'FontSize', 14); xlabel('DNA'); ylabel('Gem');
    %xlim([pk1DNA*0.6 pk1DNA*3]); ylim([pk1Gem-0.5*(pk2Gem-pk1Gem) pk2Gem+0.8*(pk2Gem-pk1Gem)])
    xlim([prctile(DNA, 1) prctile(DNA, 99)]); ylim([prctile(Gem, 1) prctile(Gem, 99)])
    subplot(1,2,2); plot(DNA, Gem, '.')
    title(['Well: row ' int2str(row) ', col ' int2str(col)])
    set(gca, 'FontSize', 14); xlabel('DNA'); ylabel('Gem');
    xlim([prctile(DNA, 1) prctile(DNA, 99)]); ylim([prctile(Gem, 1) prctile(Gem, 99)])
    pause(0.5);
end

statTab = [Wells, table(CellNum, Props, MedianSize, NucArea, DNA2N, sizeMAD)];
%% Plate pattern
figure(); imagesc(reshape(statTab.NucArea(:,1), 10, 6)'); title('Avg Nuclear Area'); colorbar

figure(); imagesc(reshape(statTab.CellNum(:,1), 10, 6)'); title('Cell Number'); colorbar
figure(); imagesc(reshape(statTab.MedianSize(:,1), 10, 6)'); title('Avg Size'); colorbar
figure(); imagesc(reshape(statTab.MedianSize(:,2), 10, 6)'); title('EG1 Size'); colorbar
figure(); imagesc(reshape(statTab.MedianSize(:,end), 10, 6)'); title('G1 Size'); colorbar
figure(); imagesc(reshape(statTab.Props(:,1), 10, 6)'); title('EG1 Proportion'); colorbar
figure(); imagesc(reshape(sum(statTab.Props(:,1:3), 2), 10, 6)'); title('G1 Proportion'); colorbar
figure(); imagesc(reshape(statTab.Props(:,4), 10, 6)'); title('S Proportion'); colorbar

figure(); imagesc(reshape(statTab.sizeMAD(:,1), 10, 6)'); title('Avg Size MAD'); colorbar
figure(); imagesc(reshape(statTab.sizeMAD(:,2), 10, 6)'); title('EG1 Size MAD'); colorbar
figure(); imagesc(reshape(statTab.sizeMAD(:,2)./statTab.MedianSize(:,2), 10, 6)'); title('EG1 Size MAD (Normalized)'); colorbar
figure(); imagesc(reshape(statTab.sizeMAD(:,end), 10, 6)'); title('G1 Size MAD'); colorbar
%%
edgeColor = [0 0 0; 0 0 0; 0 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 0 0 0; 0 0 0; 0 0 0];
faceColor = [ 0.8 0 0; .4 .4 1; 0 0.7 0; .8 .8 0; 0 0 1; 1 0 1; 1 .5 .5; .8 .8 1; .4 1 .4; 1 1 0.4];

names = {'Average','EG1', 'LG1', 'G1/S', 'S', 'G2', 'G1'};
figure(); count=0;
for stage = [1:3 7 4:6]
    count = count+1;
    subplot(2,4,count);
    for col = [6 7 2:5 8:11]%2:11%
        idx = statTab.Column==col;
        scatter(statTab.MedianSize(idx,stage), statTab.sizeMAD(idx,stage)./statTab.MedianSize(idx,stage), (10-statTab.Row(idx))*30, ...
            'MarkerFaceColor', faceColor(col-1,:), 'MarkerEdgeColor',edgeColor(col-1,:), 'LineWidth',2);
        hold on; %pause
    end
    title(names{stage});
end

%% DAPI level of 2N DNA
figure(); imagesc(reshape(DNA2N(:,1), 10, 6)');colorbar; title('DAPI level of 2N DNA')
figure(); plot(DNA2N, MedianSize(:,1),'bo'); xlabel('DAPI level of 2N DNA'); ylabel('Cell Size');


names = {'Average','EG1', 'LG1', 'G1', 'G1/S', 'S', 'G2'};
figure(); count=0;
for stage = [1:3 7 4:6]
    count = count+1;
    subplot(2,4,count);
    for col = [6 7 2:5 8:11]%2:11%
        idx = statTab.Column==col;
        scatter(statTab.MedianSize(idx,stage), statTab.sizeMAD(idx,stage)./statTab.MedianSize(idx,stage), (10-statTab.Row(idx))*30, ...
            'MarkerFaceColor', faceColor(col-1,:), 'MarkerEdgeColor',edgeColor(col-1,:), 'LineWidth',2);
        hold on; %pause
    end
    title(names{stage});
end

for count=1:7
    subplot(2,4,count);
    xlim([5.3e6 1.32e7]); ylim([0.09 0.26]);
end
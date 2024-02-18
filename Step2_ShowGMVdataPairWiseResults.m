clear all; clc; close all;

load('GMVaal3ArrayFinal.mat');  % 14x9x153 

load('ROIsPassBonff_13subs.mat'); %% in 153
GMVaal3Array = GMVaal3ArrayFinal(:,:,ROIsPassBonff);    %13x9x8
ROIsPassBonff
load('ROInames.mat');  % 153x1

P = 1;                 % P = [1 2 3 4 5 6]
HAMD_table_NEW = GMVaal3Array(:,:,P);

PairWiseTvalueMatrix = zeros(size(HAMD_table_NEW,2), size(HAMD_table_NEW,2));
PairWisePvalueMatrix = zeros(size(HAMD_table_NEW,2), size(HAMD_table_NEW,2));

Parray = [];
for p = 1:8
    for q = (p+1):9
        tmp = HAMD_table_NEW(:,p) - HAMD_table_NEW(:,q);
        [H,P,CI,STATS] = ttest(tmp);
        PairWisePvalueMatrix(q,p) = P;
        PairWiseTvalueMatrix(q,p) = STATS.tstat; 
        Parray(end+1) = P;
    end
end

AA = -PairWiseTvalueMatrix;
%% BenfferroniÐ£Õý
figure(1);
imagesc(PairWiseTvalueMatrix);
min(PairWiseTvalueMatrix(:))
max(PairWiseTvalueMatrix(:))
colorbar;
P_bonff = 0.01/(8*9/2);
for p = 1:8
    for q = (p+1):9
        if   PairWisePvalueMatrix(q,p) < P_bonff
            hold on;
            plot(p,q,'k*','LineWidth',0.8, 'MarkerSize',8);
        end
    end
end

caxis([-10 0]);
box off;

for p = 1:10
    for q = 1:p
        plot([q-1.5,q-0.5],[p-.5,p-.5],'k-','LineWidth',1.0);
        plot([9.5-p, 9.5-p],[10.5-q,9.5-q],'k-','LineWidth',1.0);
    end
end


set(gca,'xtick',[1:1:9]);
set(gca,'xticklabel',{'Baseline','ECT1', 'ECT2','ECT3','ECT4', 'ECT5','ECT6','ECT7', 'ECT8'});
set(gca, 'XTickLabelRotation', 90);
set(gca,'ytick',[1:1:9]);
set(gca,'yticklabel',{'Baseline','ECT1', 'ECT2','ECT3','ECT4', 'ECT5','ECT6','ECT7', 'ECT8'});
set(gca,'FontSize',10, 'FontWeight','bold');

clear all; clc; close all;

load('GMVaal3ArrayFinal.mat');  

PvalueMatrix = zeros(1, size(GMVaal3ArrayFinal,3));
FvalueMatrix = zeros(1, size(GMVaal3ArrayFinal,3));

for ROIidx = 1:size(GMVaal3ArrayFinal,3)
    tmp =  GMVaal3ArrayFinal(:,:,ROIidx);
    [p, table] = anova_rm(tmp,'off');
    
    PvalueMatrix(ROIidx) = table2array(table(2,6));   % 1x153
    FvalueMatrix(ROIidx) = table2array(table(2,5));   % 1x153
end


%% Bonfferroni correction
P_bonff = 0.01/166;
ROIsPassBonff = find(PvalueMatrix<P_bonff);
ROIsPassBonff
save('ROIsPassBonff_13subs', 'ROIsPassBonff'); %% in 153

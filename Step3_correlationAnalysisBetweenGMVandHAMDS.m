clear all; clc; close all;

%% loading Gender, Age infomations
load('Gender_vec.mat');
load('Age_vec.mat');

%% load GMV
load('GMVaal3ArrayFinal.mat'); 

TotalGMV = sum(sum(GMVaal3ArrayFinal, 3),2);
TotalGMV_vec = zscore(TotalGMV);

load('ROIsPassBonff_13subs.mat'); 
ROIsPassBonff
GMVaal3Array = GMVaal3ArrayFinal(:,:,ROIsPassBonff);  

%% load HAMDS
load('HAMD_table.mat');     % 18x9 or 15x9

%% Partial Correlation analysis
load('ROInames.mat');

% ECT0 to ECT8
m = 1; n = 9;

for p = 1:size(GMVaal3Array,3)
    GMVt1 = GMVaal3Array(:,m,p);
    GMVt2 = GMVaal3Array(:,n,p);
    GMVchange = GMVt2 - GMVt1;
    GMVchange = GMVchange./GMVt1;
    
    HAMDSt1 = HAMD_table(:,m);
    HAMDSt2 = HAMD_table(:,n);
    HAMDSchange = HAMDSt1 - HAMDSt2 ;

    [r_value,p_value] = partialcorr(GMVchange, HAMDSchange, [Age_vec Gender_vec TotalGMV_vec],  'type' , 'Spearman');

    % plot part  
    x = HAMDSchange';
    y = GMVchange';


    [h, pp] = sort(x);
    x = x(pp);
    y = y(pp);

    figure(p);
    plot(x, y, 'bx','linewidth',2);
    hold on;
    [pp, s] = polyfit(x, y, 1);
    [yfit, dy] = polyconf(pp, x, s, 'predopt', 'curve');
    plot(x, yfit, 'color', 'r','linewidth',2);
    plot(x, yfit-dy, 'color', 'r','linestyle',':','linewidth',2);
    plot(x, yfit+dy, 'color', 'r','linestyle',':' ,'linewidth',2);
    xlabel('HAMDS decrease: ECT0 - ECT8');
    ylabel('GMV increase: ECT8 - ECT0');

    AA = strfind(ROInames(ROIsPassBonff(p)), ';');
    NameStr = ROInames(ROIsPassBonff(p));
    
    NameStr = NameStr{1}(1:AA{1}(end));
    title({'Corrlation Analysis:', NameStr,  ['r = ' num2str(r_value) ', p = ' num2str(p_value)]}, 'FontSize', 12);
end



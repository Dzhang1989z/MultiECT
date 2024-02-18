clear all; clc; close all;

%% load HAMDS
load('HAMD_table.mat');    

%% load AGE and Gender of these 13 subjects
load('Age_vec.mat');
load('Gender_vec.mat');

%% right hipp part 
load('FCmatrixHippRight_Cluster.mat');   %  % 13x9x4
GMVaal3Array = FCmatrixHippRight;

m = 1; n = 2;

GMVchange_positive = 0;
GMVchange_negative = 0;
GMVchange_all = 0;

for p = 1:size(GMVaal3Array,3)
    GMVt1 = GMVaal3Array(:,m,p);
    GMVt2 = GMVaal3Array(:,n,p);
    
   if mean(GMVt1) > 0
        GMVchange_positive = GMVchange_positive + (GMVt2 - GMVt1);
    else
        GMVchange_negative = GMVchange_negative + (GMVt2 - GMVt1);
   end
    GMVchange_all = GMVchange_all + (GMVt2 - GMVt1);
end

HAMDSt1 = HAMD_table(:,m);
HAMDSt2 = HAMD_table(:,n);
HAMDSchange = HAMDSt2 - HAMDSt1;

%%  positive part plot
GMVchange = GMVchange_all;
[r_value,p_value] = partialcorr(GMVchange, HAMDSchange, [Age_vec Gender_vec],  'type' , 'Spearman');

% plot part  
x = GMVchange';
y = HAMDSchange';

[h, pp] = sort(x);
    
x = x(pp);
y = y(pp);

figure(1)
plot(x, y, 'bx','linewidth',2);
hold on;
[pp, s] = polyfit(x, y, 1);
[yfit, dy] = polyconf(pp, x, s, 'predopt', 'curve');
plot(x, yfit, 'color', 'r','linewidth',2);
plot(x, yfit-dy, 'color', 'r','linestyle',':','linewidth',2);
plot(x, yfit+dy, 'color', 'r','linestyle',':' ,'linewidth',2);
xlabel('FC change: T2 - T1');
ylabel('HAMDS change: T2 - T1');
    
title({'Positive FCs:',  ['r = ' num2str(r_value) ', p = ' num2str(p_value)]}, 'FontSize', 12);


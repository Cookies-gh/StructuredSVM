close all
clear
clc

addpath(genpath('GeometricContext'));
addpath(genpath('Data'));

addpath('display');
addpath('lineseg');
addpath('vanishingpoint');
addpath('geometry');
addpath('orientmap');
addpath('ComputeVP');
addpath('CLayouts');
addpath('Tools');
addpath('FreeSpace');
Files = dir('Data/Images');
LengthFiles = length(Files);
matlabpool open 

for i=3:LengthFiles
    
imgname=Files(i).name;
img=imread(imgname);
if exist(['Data/trainData/OM_train/OM',imgname,'.mat'],'file') & ~exist(['Data/trainData/Loss/Loss',imgname,'.mat'],'file')
    i
%     [vp p All_lines]=getVP(img,0);
    [h w kk]=size(img);
%     VP=vp;
% 
%     vp=[VP(1) VP(2);VP(3) VP(4);VP(5) VP(6)];
%     [vp P]=ordervp(vp,h,w,p);
%     vpdata.vp=vp;
%     vpdata.dim=[h w];

%     load(['Data/trainData/OM_train/OM',imgname,'.mat'])
%     load(['Data/trainData/GC_train/GC',imgname,'.mat'])
    load(['Data/groundtruth/',imgname(1:end-4),'_labels.mat'])
    load(['Data/trainData/CD_train/cdlayout',imgname,'.mat'])
    load(['Data/trainData/integImage/Integ',imgname,'.mat'])
    
    if length(gtPolyg)<5
        for j=1:5-length(gtPolyg)
            gtPolyg{end+1}=[];
        end
    end 

    %[features] =getLayoutfeats(gtPolyg,integData,vp,h,w,0,100);
    Loss = Computer_loss2(h,w, polyg, gtPolyg);


%    save(['Data/trainData/GD_feat_train/GD_feat',imgname,'.mat'],'features')
    save(['Data/trainData/Loss/Loss',imgname,'.mat'],'Loss')
%     save(['Data/trainData/VP/vp',imgname,'.mat'],'vp')
%     save(['Data/trainData/integImage/Integ',imgname,'.mat'],'integData')
end

end
matlabpool close
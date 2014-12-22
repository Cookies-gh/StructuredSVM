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

for i=3:LengthFiles
    
imgname=Files(i).name;
img=imread(imgname);
if ~exist(['Data/trainData/OM_train/OM',imgname,'.mat'],'file')
    
    [vp p All_lines]=getVP(img,0);
    [h w kk]=size(img);
    VP=vp;
    if numel(VP)<3
       continue; 
    end
    vp=[VP(1) VP(2);VP(3) VP(4);VP(5) VP(6)];
    [vp P]=ordervp(vp,h,w,p);
    vpdata.vp=vp;
    vpdata.dim=[h w];
    
    
    [OM]=ComputeOM( img ,0);
    [GC,GC_disp] = ComputeGC( img,0);
    [integData]=getIntegralimages(OM,GC,vp,100);

    [polyg, Features] = getcandboxlayout( vpdata.vp,vpdata.dim(1),vpdata.dim(2), integData,100);
    save(['Data/trainData/OM_train/OM',imgname,'.mat'],'OM')
    save(['Data/trainData/GC_train/GC',imgname,'.mat'],'GC')
    save(['Data/trainData/Feat_train/feat',imgname,'.mat'],'Features')
    save(['Data/trainData/CD_train/feat',imgname,'.mat'],'polyg')
end

end


function [integData]=getIntegralimages(OM,GC,vp,quantsiz)

feat=cat(3,OM,GC);
[h w imk]=size(feat);
for i=1:imk
    feat_img{i}=feat(:,:,i);
end

integData=struct('intI12',' ','intI23',' ','intI31',' ',...
    'intnum12',' ', 'intnum23',' ', 'intnum31',' ');
%,...
%   'theta_ind12',' ','theta_ind23',' ','theta_ind31',' ');

for feat=1: length(feat_img)

    intI12{feat}=[];
    intI23{feat}=[];
    intI31{feat}=[];


    vno1=1;vno2=2;
    [feat_avg, feat_sum, num_12, theta_ind12]= txfmImg(vp([vno1 vno2],:),feat_img{feat},0,quantsiz,1);
    intI12{feat} = cumsum(cumsum(double(feat_sum)),2);
    intI12{feat}=[zeros(1,size(intI12{feat},2)) ; intI12{feat}];
    intI12{feat}=[zeros(size(intI12{feat},1),1)  intI12{feat}];

    vno1=2;vno2=3;
    [feat_avg, feat_sum, num_23, theta_ind23]= txfmImg(vp([vno1 vno2],:),feat_img{feat},0,quantsiz,1);
    intI23{feat} = cumsum(cumsum(double(feat_sum)),2);
    intI23{feat}=[zeros(1,size(intI23{feat},2)) ; intI23{feat}];
    intI23{feat}=[zeros(size(intI23{feat},1),1)  intI23{feat}];

    vno1=3;vno2=1;
    [feat_avg, feat_sum, num_31, theta_ind31]= txfmImg(vp([vno1 vno2],:),feat_img{feat},0,quantsiz,1);
    intI31{feat} = cumsum(cumsum(double(feat_sum)),2);
    intI31{feat}=[zeros(1,size(intI31{feat},2)) ; intI31{feat}];
    intI31{feat}=[zeros(size(intI31{feat},1),1)  intI31{feat}];

    %check for nan inf
    if numel(find(isnan(feat_sum))) > 0 | numel(find(isinf(feat_sum))) > 0
        disp('Feats are NaN');
        keyboard;
    end

end



%% save integData
intnum12=cumsum(cumsum(double(num_12)),2);
intnum12=[zeros(1,size(intnum12,2)) ; intnum12];
intnum12=[zeros(size(intnum12,1),1)  intnum12];

intnum23=cumsum(cumsum(double(num_23)),2);
intnum23=[zeros(1,size(intnum23,2)) ; intnum23];
intnum23=[zeros(size(intnum23,1),1)  intnum23];

intnum31=cumsum(cumsum(double(num_31)),2);
intnum31=[zeros(1,size(intnum31,2)) ; intnum31];
intnum31=[zeros(size(intnum31,1),1)  intnum31];


integData.intI12=intI12;
integData.intI23=intI23;
integData.intI31=intI31;
integData.intnum12=intnum12;
integData.intnum23=intnum23;
integData.intnum31=intnum31;

integData.theta_ind12=theta_ind12;
integData.theta_ind23=theta_ind23;
integData.theta_ind31=theta_ind31;
%%


return;

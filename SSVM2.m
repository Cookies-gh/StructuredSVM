close all
clear
clc
addpath(genpath('Data'));

Maxiter=50;

load(['Data/trainData/imglist.mat']);
N=length(imglist)-100;

%load(['Data/trainData/GD_feat_train/GD_feat',imgname,'.mat'],'features');

w=zeros(55,1);
l=zeros(N,1);
e=0;
C=1;

phiy=cell(1,1);
phiybar=cell(1,1);
delta=cell(1,1);

for i=1:N
    imgname=imglist{i}; 
    load(['Data/trainData/GD_feat_train/GD_feat',imgname,'.mat'])
    phiy{i}=features;
    load(['Data/trainData/Feat_train/feat',imgname,'.mat']);
    phiybar{i}=Features;
    load(['Data/trainData/Loss/Loss',imgname,'.mat'])
    delta{i}=Loss;
end
 
S=cell(N,1);
S_pre=S;
IN=eye(N);
I55=eye(55);
for iter=1:Maxiter
    iter
  %-- find argmax ybar
    Si=S{i};
    for i=1:N
        ymax=1;
        Lmax=0;
        %%  find ybar=argmax Lw %%
        for numc=1:size(phiybar{i},1)
            Lw=delta{i}(numc)-(phiy{i}-phiybar{i}(numc,:))*w;
            if Lw>=Lmax
                Lmax=Lw;
                ymax=numc;
            end
        end
        Si=S{i};
        %% check margin
        if delta{i}(ymax)-(phiy{i}-phiybar{i}(ymax,:))*w>l(i)+e
            Si=[Si,ymax];  
            S{i}=Si;
        end
    end
        
        %% 1/2 X'*H*X +f'*X   A*X<=b
    H=[I55,zeros(55,N)]'*[I55,zeros(55,N)];
    f=[C/N.*ones(1,N)*[zeros(N,55),IN]]';
    A=[];
    b=[];
    for n=1:N
        if isempty(S{n})
            continue
        end
        cst=length(S{n});           
        for numcst=1:cst
            tempA=( phiy{n}-phiybar{n}(S{n}(numcst),:) )*[I55,zeros(55,N)]+IN(n,:)*[zeros(N,55),IN];
            A=[A;-tempA];

            tempb=delta{n}(numcst);
            b=[b;-tempb];                   
        end
    end
    
    A=[A;-[zeros(N,55),IN]];
    b=[b;zeros(N,1)];
    X = quadprog(H,f,A,b,[],[]);
    w=[I55,zeros(55,N)]*X;
    l=[zeros(N,55),IN]*X;

    if isequal( S, S_pre);
        break
    end
    S_pre=S;
end
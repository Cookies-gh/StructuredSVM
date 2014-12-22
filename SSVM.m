
close all
clear
clc
addpath(genpath('Data'));
addpath(genpath('qpc'));
Maxiter=50;

load(['Data/trainData/imglist.mat']);
N=length(imglist)-100;

%load(['Data/trainData/GD_feat_train/GD_feat',imgname,'.mat'],'features');

w=zeros(55,1);
l=zeros(N,1);
e=0.2;
C=1;
phiy=cell(1,1);
phiybar=cell(1,1);
delta=cell(1,1);
zero_55_N=zeros(55,N);
zero_N_55=zeros(N,55);

for i=1:N
    imgname=imglist{i}; 
    load(['Data/trainData/GD_feat_train/GD_feat',imgname,'.mat'])
    phiy{i}=features;
    load(['Data/trainData/Feat_train/feat',imgname,'.mat']);
    phiybar{i}=Features;
    load(['Data/trainData/Loss/Loss',imgname,'.mat'])
    delta{i}=Loss;
end
object=[];

S=cell(N,1);
IN=eye(N);
I55=eye(55);
for iter=1:Maxiter
    iter
    S_pre=S;
    w_pre=w;
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
            %% 1/2 X'*H*X +f'*X   A*X<=b
            H=[I55,zero_55_N]'*[I55,zero_55_N];
            f=[C.*ones(1,N)*[zero_N_55,IN]]';
            A=[];
            b=[];
            for n=1:N
                if isempty(S{n})
                    continue
                end
                cst=length(S{n});           
                for numcst=1:cst
                    tempA=( phiy{n}-phiybar{n}(S{n}(numcst),:) )*[I55,zero_55_N]+IN(n,:)*[zero_N_55,IN];
                    A=[A;-tempA];
                    
                    tempb=delta{n}(numcst);
                    b=[b;-tempb];                   
                end
            end
%             A=[A;-[zero_N_55,IN]];
%             b=[b;zeros(N,1)];
            lb=[ -inf*ones(55,1);zeros(N,1)];
            ub=inf*ones(N+55,1);
            [X,err,lm] = qpas(H,f,A,b,[],[],lb,ub,0);
            %X = quadprog(H,f,A,b,[],[]);
            w=[I55,zero_55_N]*X;
            l=[zero_N_55,IN]*X;

        end
    end
    energy=0.5*w'*w+C/N*sum(l);
    object=[object;energy];
    plot(w)
    drawnow
    if isequal( S, S_pre);
        break
    end
%     if max(w-w_pre)<1e-3
%         break
%     end
end
            
        
       
        
        
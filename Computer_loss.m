function delta = Computer_loss(h,w,y, ybar)
  %% compute delta-t
    delta_t=0;
    for i=1:5
        if ( ~isempty(y{i}) & isempty(ybar{i}) ) | ( isempty(y{i}) & ~isempty(ybar{i}) )
            delta_t=delta_t+1;
        end
    end

    delta_p=0;
    delta_c=0;
    for i=1:5
        if ~isempty(y{i}) & ~isempty(ybar{i})  
   %% compute delta-c
            delta_c=delta_c+norm( sum(y{i},1)/size(y{i},1)-sum(ybar{i},1)/size(ybar{i},1) );
   %% compute delta-p    
            I1=poly2mask( y{i}(:,1),y{i}(:,2),h,w );
            I2=poly2mask( ybar{i}(:,1),ybar{i}(:,2),h,w );
            I_same=I1 & I2;
            I_over=I1 | I2;
            delta_p=delta_p+(1-sum(I_same(:))/sum(I_over(:)));         
        elseif isempty(y{i}) & isempty(ybar{i})
            delta_c=delta_c;
            delta_p=delta_p;
        else
            delta_c=delta_c+10000; 
            delta_p=delta_p+10000;
        end
    end 
    delta = delta_t+delta_c+delta_p;
end


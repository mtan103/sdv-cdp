clc;
clear;
addpath tensor_toolbox
addpath AO-ADMM


%% Create tensor
load PaviaU
%load Salinas_corrected
%X = salinas_corrected;
X = paviaU;
size_tens = size(X);
% Normalize the tensor entries
normalizing_factor =max(X,[],'all');
X = X./normalizing_factor;

%% Run CPD and reconstruct
tic
F = 200; % rank
X_cpd = [];
X_data=tensor(X);
iter_mttkrp=120;
for d = 1:3
    Hinit{d} = rand( size_tens(d), F );
end
ops.init = Hinit;
ops.constraint{1} = 'nonnegative';
ops.constraint{2} = 'nonnegative';
ops.constraint{3} = 'nonnegative';
ops.mu = 0;
ops.maxitr = iter_mttkrp/3;
[A_admm,his] = AOadmm(X_data,F,ops);
X_cpd = cpdgen(A_admm);

CPD_parameters = F*(size_tens(1)+size_tens(2)+size_tens(3));
CPD_compression = CPD_parameters/numel(X)
cpd_time = toc
%% Run SVD on each slab and reconstruct
tic
F = 200; % rank
X_svd = [];
%for loop for the slabs (I+J)R K times
j=size_tens(3);
for i=1:j
    %svd(X(:,:,i),F); this works too, just slower 
    [U(:,:,i),D(:,:,i),V(:,:,i)] = svds(X(:,:,i),F); 
    X_svd(:,:,i) = U(:,:,i)*D(:,:,i)*V(:,:,i)';
end

% Compute SVD compression ratio
% Add your code

SVD_parameters = F*(size_tens(1)+size_tens(2))*size_tens(3);
SVD_compression = SVD_parameters/numel(X)
svd_time = toc
%% Display any slab and Compare
index=56;
subplot(1,3,1)
fig=imshow(X(:,:,index)*normalizing_factor,[]);
title("Original");
%mt(1) = title('TEST1');
subplot(1,3,2)
imshow(X_svd(:,:,index)*normalizing_factor,[]);
title("SVD-Reconstructed");
%mt(2) = title('TEST2');
subplot(1,3,3)
imshow(X_cpd(:,:,index)*normalizing_factor,[]);
title("CPD-Reconstructed");
%mt(3) = title('TEST3');
%set(mt,'Position',[150 300],'VerticalAlignment','top','Color',[1 0 0])
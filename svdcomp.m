clc;
clear;
addpath tensor_toolbox
addpath AO-ADMM
%% create tensor 
X = imread('osulogo.jpg');
X = im2double(X);
size_tens = size(X);
% Normalize the tensor entries
normalizing_factor =max(X,[],'all');
X = X./normalizing_factor;

%% svd
tic
F = 50; % rank
X_svd = [];
%for loop for the slabs (I+J)R K times
j=size_tens(3);
for i=1:j
    [U(:,:,i),D(:,:,i),V(:,:,i)] = svds(X(:,:,i),F); 
    X_svd(:,:,i) = U(:,:,i)*D(:,:,i)*V(:,:,i)';
end

% Compute SVD compression ratio

SVD_parameters = F*(size_tens(1)+size_tens(2))*size_tens(3);
SVD_compression = SVD_parameters/numel(X)
svd_time = toc

%% image     
imshow(X_svd(:,:,3)*normalizing_factor,[]);
title("Singular Value of 50");
% imshow(X);
% title("original");
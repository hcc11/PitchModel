tic
% matlabpool open local 4
clear all
figure(1), clf
A=zeros(200,5000);
parfor i=1:5000*10
for j=1:200
    A(j,i)=sin(i*2*pi/1024);
end
end
toc
imagesc(A)
% matlabpool close
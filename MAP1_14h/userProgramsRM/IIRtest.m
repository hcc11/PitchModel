clear all
dt=.0001;
bw=100;
% gammatone filter coefficients for linear pathway
phi = 2 * pi * bw * dt;
cf=1000;
theta = 2 * pi * cf * dt;
cos_theta = cos(theta);
sin_theta = sin(theta);
alpha = -exp(-phi).* cos_theta;
a0 = 1;
a1 = 2 * alpha;
a2 = exp(-2 * phi);
z1 = (1 + alpha .* cos_theta) - (alpha .* sin_theta) * 1i;
z2 = (1 + a1 .* cos_theta) - (a1 .* sin_theta) * 1i;
z3 = (a2 .* cos(2 * theta)) - (a2 .* sin(2 * theta)) * 1i;
tf = (z2 + z3) ./ z1;
b0 = abs(tf);
b1 = alpha .* b0;
GTlin_a = [a0, a1, a2];
GTlin_b = [b0, b1];


% GTlinOrder=DRNLlinearOrder;
% GTlinBdry=cell(nEars,nBFs,GTlinOrder);

% y=filter(b,a,x);
% 
% [linOutput, GTlinBdry{ear, BFno,order}] = ...
%     filter(GTlin_b(BFno,:), GTlin_a(BFno,:), linOutput, ...
%     GTlinBdry{ear, BFno,order});


x=rand(20,1000);
y=zeros(size(x));
%
% for n=4:length(x)
%     for order=1:3
% y(n)=b0*x(n)+b1*x(n-1)-a1*y(n-1)-a2*y(n-2);
%     end
% end
%

GTlinOrder=3
for order = 1 : GTlinOrder
    y(:,tPTR)=GTlin_b0*x(tPTR)+GTlin_b1*x(tPTR-1) ...
        -GTlin_a1*linOutput(tPTR-1)-GTlin_a2*linOutput(tPTR-2);
end

% y =  filter([b0 b1], [a0 a1 a2], x);

[fft_powerdB, fft_phase, frequencies, fft_ampdB]=UTIL_FFT(y,dt,50);

figure(1), clf

plot(frequencies,fft_powerdB)


% gammatone filter coefficients for linear pathway
clear all
nBFs=10;
x=rand(nBFs,1000);
linOutput=zeros(size(x));
dt=1/20000;

bw=100:100:100*nBFs;
phi = 2 * pi * bw * dt;
cf=1000:1000:1000*nBFs;
theta = 2 * pi * cf * dt;
cos_theta = cos(theta);
sin_theta = sin(theta);
alpha = -exp(-phi).* cos_theta;
a0 = ones(nBFs,1);
a1 = 2 * alpha;
a2 = exp(-2 * phi);
z1 = (1 + alpha .* cos_theta) - (alpha .* sin_theta) * 1i;
z2 = (1 + a1 .* cos_theta) - (a1 .* sin_theta) * 1i;
z3 = (a2 .* cos(2 * theta)) - (a2 .* sin(2 * theta)) * 1i;
tf = (z2 + z3) ./ z1;
b0 = abs(tf);
b1 = alpha .* b0;

GTlin_a0= a0;
GTlin_a1= a1';
GTlin_a2= a2';
GTlin_b0= b0';
GTlin_b1= b1';
GTlinOrder=3;

% for tPTR=5:1000
%     for order = 1 : GTlinOrder
%         linOutput(:,tPTR)=GTlin_b0.*x(:,tPTR)+GTlin_b1.*x(:,tPTR-1) ...
%             -GTlin_a1.*linOutput(:,tPTR-1)-GTlin_a2.*linOutput(:,tPTR-2);
%     end
% end


IHC_cilia_RPParams.tc=1.2e-4;
        a1=dt/IHC_cilia_RPParams.tc - 1;
        a0=1;
        b0=1+ a1;

IHCciliaFilter_b1=a0;
IHCciliaFilter_b2=a1;
IHCciliaFilter_a1=b0;
IHCciliaDisplacement=x;

for tPTR=5:1000
    IHCciliaDisplacement(:,tPTR)=...
        IHCciliaFilter_b1.*IHCciliaDisplacement(:,tPTR)+ ...
        IHCciliaFilter_b2.*IHCciliaDisplacement(:,tPTR-1) - ...
        IHCciliaFilter_a1.*IHCciliaDisplacement(:,tPTR-1);
end

sampleBF=3;
[fft_powerdB, fft_phase, frequencies, fft_ampdB]= ...
    UTIL_FFT(IHCciliaDisplacement(sampleBF,:),dt,50);

cf(sampleBF)
figure(1), clf

tt=frequencies<5000;
plot(frequencies(tt),fft_powerdB(tt))




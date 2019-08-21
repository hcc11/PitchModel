function [estTau, k, error]=UTIL_fitRisingTimeConstant (time, values, asymptote, plotIt)
% y= k*exp(-t/tau)
% log(y)= log(k) +(-1/tau)*t  (a first-order polynomial in t)
% polyval coefficients are -1/tau and log(k) respectively
% This test is approximate and works best if the time constant is 
% at least half as short as the longest time specified

if nargin<4, plotIt=0; end
if asymptote==999, %use last value as asymptote estimate and discard it
   asymptote=max(values); 
   values=values(1:end-1);
   time=time(1:end-1);
end
% for values rising to asymptote
decrement=asymptote-values;

% remove zero or negative values
idx=find(decrement>0);
decrement=decrement(idx); time=time(idx); values=values(idx);

% fit using logs
logValues=log(decrement);
warning off
p=polyfit(time, logValues, 1);
warning on
k=exp(p(2)); 
if any(p(1)), estTau=-1/p(1); else estTau=0; end

% compute fits
logPredicted=polyval(p,time);
predicted=exp(logPredicted);
error=sum((predicted-values).^2);

if plotIt
hdl14=figure (1);  
warning off
hold off
plot(time,values, 'go'), hold on
plot(time,asymptote-predicted,'b')
title(['compute rising tau - ' num2str(estTau)])
warning on
end


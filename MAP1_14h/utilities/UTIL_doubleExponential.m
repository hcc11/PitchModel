function [bestSoFar, t, bestPrediction]= ...
    UTIL_doubleExponential(data, dt, limits, asymptote)
% doubleExponential fits a double exponential to data
%  y=a1*exp(-t/tau1)+a2*exp(-t/tau2)+asymptote;
%
% limits contains the values of a1, a2, tau1, tau2 to be considered
%
% Output is plotting ready: plot(t,bestPrediction)
% bestSoFar is [error a1 a2 tau1 tau2]
% empty 't' indicates not enough data

t=dt:dt:dt*length(data);
if length(data)<5
    bestSoFar=[];
    t=[];
    bestPrediction=[];
    return
end

dbstop if error
if nargin<4
    if length(data)>10
    asymptote=mean(data(end-10:end)); 
    else
        asymptote=0;    % pro tem
    end
end

% avoid occasional zero or near zero values
data(data<0.005)=0.005;

bestSoFar=inf;
for a1=limits.a1(1):limits.a1(2):limits.a1(3)
    for a2=limits.a2(1):limits.a2(2):limits.a2(3)
        for tau1= limits.tau1(1):limits.tau1(2):limits.tau1(3)
            for tau2=limits.tau2(1):limits.tau2(2):limits.tau2(3)
                y=a1*exp(-t/tau1)+a2*exp(-t/tau2)+asymptote;
                myError=sum((y-data).^2);
                if myError<bestSoFar(1)
                    bestSoFar=[myError a1 a2 tau1 tau2];
                    bestPrediction=y;
%                     disp(num2str([myError bestSoFar]))
                end
            end
        end
    end
end
if bestSoFar(4)==limits.tau1(1) || bestSoFar(4)==limits.tau1(3)
    bestSoFar(4)=NaN;
end
if bestSoFar(5)==limits.tau2(1) || bestSoFar(5)==limits.tau2(3)
    bestSoFar(5)=NaN;
end
% error is per data point
bestSoFar(1)=bestSoFar(1)/length(data);
% figure(1),clf,plot (t,data),  hold on, plot(t,bestPrediction,':r')
% set(gcf,'name','PSTH and exp fit')
% title(num2str([bestSoFar(4) bestSoFar(5)]))


function [estTau, k, myError]=... 
    Util_fitFallingTimeConstant (time, values, asymptote, plotIt)
% y= k*exp(-t/tau)
% log(y)= log(k) +(-1/tau)*t  (a first-order polynomial in t)
% polyval coefficients are -1/tau and log(k) respectively
% This test is approximate and works best if the time constant is
% at least half as short as the longest time specified

if nargin<4, plotIt=0; end
if asymptote==999, %use last value as asymptote estimate and discard it
    asymptote=min(values);
    values=values(1:end-1);
    time=time(1:end-1);
end

asymptoteVals=asymptote./[1:10];
bestError=inf;
for asymptote=asymptoteVals;
    % for values falling to asymptote
    increment=values-asymptote;

    % remove zero or negative values
    idx=find(increment>0);
    increment=increment(idx);
    time=time(idx);
    values=values(idx);

    % fit using logs
    logValues=log(increment);
    warning off
    p=polyfit(time, logValues, 1);
    warning on
    k=exp(p(2));
    estTau=0;
    if any(p(1))
        estTau=-1/p(1);
    end

    % compute fit
    logPredicted=polyval(p,time);
    predicted=exp(logPredicted);
    myError=sum((predicted-values+asymptote).^2);

    if myError<bestError
        bestError=myError;
        bestTau=estTau;
        bestAsymptote=asymptote;
        bestk=k;
        bestp=p;
    end
%     [bestError bestTau bestAsymptote bestk bestp]

    % compute fit
    logPredicted=polyval(bestp,time);
    predicted=exp(logPredicted);
    myError=sum((predicted-values+bestAsymptote).^2);

    if plotIt
        figure (1);
        set(gcf,'units', 'normalized');
        set(gcf, 'position', [.75 .58 .245 .3]),  clf  % timeconstant of a section
        warning off
        plot(time,values, 'go'), hold on
        plot(time,predicted+bestAsymptote,'b')
        plot([0 max(time)], [bestAsymptote bestAsymptote],':')
        ylim([0 inf])
        hold off
        title([' tau - ' num2str(bestTau)])
        warning on
    end
end

estTau=bestTau;
k=bestk;
myError=bestError;


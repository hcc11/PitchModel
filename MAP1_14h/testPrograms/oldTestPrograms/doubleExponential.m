function bestSoFar=doubleExponential(data, dt, limits)
dbstop if error
t=dt:dt:dt*length(data);

% data=5*exp(-t/.002)+2*exp(-t/.03)+1;
asymptote=min(data);
bestSoFar=inf;
for a1=limits.a1(1):limits.a1(2):limits.a1(3)
    for a2=limits.a2(1):limits.a2(2):limits.a2(3)
        for tau1= limits.tau1(1):limits.tau1(2):limits.tau1(3)
            for tau2=limits.tau2(1):limits.tau2(2):limits.tau2(3)
                y=a1*exp(-t/tau1)+a2*exp(-t/tau2)+asymptote;
                myError=sum((y-data).^2);
                if myError<bestSoFar(1)
                    bestSoFar=[myError a1 a2 tau1 tau2];
                    bestPredicted=y;
                end
            end
        end
    end
end
bestSoFar(1)=bestSoFar(1)/length(data);
figure(1),clf,plot(t,bestPredicted,':r'), hold on,plot (t,data)


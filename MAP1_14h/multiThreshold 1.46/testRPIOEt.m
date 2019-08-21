% testRPIOEt
% test receptor potential input/output funtion 
%  at two levels of Et and at two frequencies

MAPparamsName='Normal';

channelBFs=[500 4000];
Ets=[100e-3 20e-3];
figure(22), clf

paramChanges=['IHC_cilia_RPParams.Et=' num2str(Ets(1)) ';'];
result=testRP(channelBFs(1),MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'r')
hold on

paramChanges=['IHC_cilia_RPParams.Et=' num2str(Ets(2)) ';'];
result=testRP(channelBFs(1),MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'r:')


paramChanges=['IHC_cilia_RPParams.Et=' num2str(Ets(1)) ';'];
result=testRP(channelBFs(2),MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'k')

paramChanges=['IHC_cilia_RPParams.Et=' num2str(Ets(2)) ';'];
result=testRP(channelBFs(2),MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'k:')

xlim([-20 100])
ylim([-0.07 -0.02])
legend (...
    [num2str(channelBFs(1)) 'Hz Et=' num2str(Ets(1))],...
    [num2str(channelBFs(1)) 'Hz Et=' num2str(Ets(2))],...
    [num2str(channelBFs(2)) 'Hz Et=' num2str(Ets(1))],...
    [num2str(channelBFs(2)) 'Hz Et=' num2str(Ets(2))],...
    'location', 'northwest'...
    )

    ylabel('receptor potential')
xlabel('tone level')



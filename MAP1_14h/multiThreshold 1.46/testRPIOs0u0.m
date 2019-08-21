% testRPIOEt
% test receptor potential input/output funtion 
%  at two levels of s0 and at two frequencies

MAPparamsName='Normal';

BF=1000;

s0=[1e-9 1e-10];
u0=[1e-9 1e-10];

figure(22), clf
paramChanges=cell(1,2);

paramChanges{1}=['IHC_cilia_RPParams.s0=[63.1 12.7]*' num2str(s0(1)) ';'];
paramChanges{2}=['IHC_cilia_RPParams.u0=[52.7 29.4]*' num2str(u0(1)) ';'];
result=testRP(BF,MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'r')
hold on

paramChanges{1}=['IHC_cilia_RPParams.s0=[63.1 12.7]*' num2str(s0(2)) ';'];
paramChanges{2}=['IHC_cilia_RPParams.u0=[52.7 29.4]*' num2str(u0(1)) ';'];
result=testRP(BF,MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'r:')


paramChanges{1}=['IHC_cilia_RPParams.s0=[63.1 12.7]*' num2str(s0(1)) ';'];
paramChanges{2}=['IHC_cilia_RPParams.u0=[52.7 29.4]*' num2str(u0(2)) ';'];
result=testRP(BF,MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'k')

paramChanges{1}=['IHC_cilia_RPParams.s0=[63.1 12.7]*' num2str(s0(2)) ';'];
paramChanges{2}=['IHC_cilia_RPParams.u0=[52.7 29.4]*' num2str(u0(2)) ';'];
result=testRP(BF,MAPparamsName,paramChanges);
figure(22)
plot(result(2:end,1),result(2:end,2),'k:')

xlim([-20 100])
ylim([-0.07 -0.02])
legend (...
    ['s0=' num2str(s0(1)) ' u0=' num2str(u0(1))],...
    ['s0=' num2str(s0(2)) ' u0=' num2str(u0(1))],...
    ['s0=' num2str(s0(1)) ' u0=' num2str(u0(2))],...
    ['s0=' num2str(s0(2)) ' u0=' num2str(u0(2))],...
    'location', 'northwest'...
    )

ylabel('receptor potential')
xlabel('tone level')

cmd=['MAPparams' MAPparamsName '(-1, 48000, 1, paramChanges);'];
eval(cmd)

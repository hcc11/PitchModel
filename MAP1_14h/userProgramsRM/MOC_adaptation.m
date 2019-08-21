dbstop if error
figure(1), clf, hold on
results=[];

for maskerLength=[.02 .04 .1];
dt= 0.001;
time=dt:dt:0.2;
input=zeros(1,length(time));
input(time<maskerLength)=1;

MOCtau=0.03;
eMOCdt=exp(-dt/MOCtau);
MOCa=0.08;

adaptTau=0.05;
eAdaptdt=exp(-dt/adaptTau);
adaptA=0.045;

MOC=zeros(1,length(time));
adapt=zeros(1,length(time));

for i=2:length(time)
    MOC(i)=MOC(i-1)*eMOCdt+MOCa*input(i);
    adapt(i)=adapt(i-1)*eAdaptdt+adaptA*input(i);
end
combined=MOC+adapt;
difference=MOC-adapt;
figure(1)
plot(time,[input;MOC;adapt;combined])

idx=find(difference<0);
results=[results time(idx(1))-maskerLength];
end

disp('MOCtau   MOCa adaptTau adaptA')
disp(num2str([MOCtau  MOCa adaptTau adaptA]))
disp('results')
disp(num2str(results))
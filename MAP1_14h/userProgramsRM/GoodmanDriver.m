dbstop if error
duration=1;
dt=1/50000;
probedB=70;
ramptime=0.004;
probeFrequency=1000;

        time1=dt: dt: duration;
        amp=10^(probedB/20)*28e-6;
        inputSignal=amp*sin(2*pi*probeFrequency*time1);
        rampDuration=.005; rampTime=dt:dt:rampDuration;
        ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ones(1,length(time1)-length(rampTime))];
        inputSignal=inputSignal.*ramp;
        inputSignal=inputSignal.*fliplr(ramp);
tic
        [ i, s ] = get_an_spikesDG( inputSignal, 1/dt, 100:100:4000, 'Normal',...
            'HSR', '..\' );
        toc
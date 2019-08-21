function inputSignal=gen_stim(signalType,sampleRate,param)
% generate sound stimlus. 
% when signalType is 'MF', 'Shroeder',
% param needs value for fields [ freq_cmpn, phase, duration,rampDuration, leveldBSPL]

% when signalType is 'Trans', 'SAM', 
% param needs value for fields [ F0, carrier, duration, sampleRate,leveldBSPL]

% param.noise = 'low', 'high' or 'bandpass', uses Butterworth filter,
%       needs param.noise_dB, param.noise_cutoff
%       if 'bandpass', param.noise_cutoff = [w1, w2]
% 
% when signalType is 'IRN', param includes d (delay in sec), g (gain), n (repetition #)

% when signalType is 'ALT' or 'SIN', needs field 'BPfilter': [f1, f2] band-pass
% filter of sound

% param.beginSilence, param.endSilence: length of silence add to begining and end (sec). 

dt=1/sampleRate; % seconds
time=dt: dt: param.duration;

switch signalType
    case {'MF','Schroeder','Shroeder','inharmonic','PureTone'}
        inputSignal=sum(cos(2*pi*param.freq_cmpn'*time+param.phase'*ones(size(time))), 1);
    case 'Trans'  % transpose tones  
        plus=@(x) x.*(x>0);
        inputSignal=sum(plus(cos(2*pi*param.F0'*time)), 1).*sin(2*pi*param.carrier*time);
    case 'SAM'   % SAM tones   
        inputSignal=sum(((sin(2*pi*toneFrequency'*time)+1)/2).*sin(2*pi*CarrierFreq*time), 1);
    case 'IRN'
         Nstep=round(param.d/dt);
         y=randn(size(time));
         y2=[zeros(1,Nstep) y(1:end-Nstep)];
         for k=1:param.n
            y2=y+param.g*y2;
            y2=[zeros(1,Nstep) y2(1:end-Nstep)];
         end
         inputSignal=y2;
    case {'ALT','SIN'}
        inputSignal=sum(sin(2*pi*param.freq_cmpn'*time+param.phase'*ones(size(time))), 1);
        if isfield(param,'BPfilter')
            [z, p, k] = butter(16,param.BPfilter/(sampleRate/2),'bandpass');
            [sos,g]=zp2sos(z,p,k);
            h2=dfilt.df2sos(sos,g);
            inputSignal=filter(h2,inputSignal); 
        end
end

targetRMS=20e-6*10^(param.leveldBSPL/20);
rms=(mean(inputSignal.^2))^0.5;
inputSignal=inputSignal*targetRMS/rms;
        
if isfield(param,'noise') 
    noise=randn(size(time));
    [z, p, k] = butter(6,param.noise_cutoff/(sampleRate/2),param.noise);
    [sos,g]=zp2sos(z,p,k);
    h2=dfilt.df2sos(sos,g);
    noise=filter(h2,noise); 
    n_amp=20e-6*10^(param.noise_dB/20);
    noise=noise/(mean(noise.^2))^0.5*n_amp;
    inputSignal=inputSignal+noise;       
end

% apply ramps
% catch rampTime error
if param.rampDuration>0.5*param.duration 
    param.rampDuration=param.duration/2; 
end
rampTime=dt:dt:param.rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*param.rampDuration)+pi)) ...
    ones(1,length(time)-length(rampTime))];
inputSignal=inputSignal.*ramp;
ramp=fliplr(ramp);
inputSignal=inputSignal.*ramp;
   
% add silence
if isfield(param, 'beginSilence')
intialSilence= zeros(1,round(param.beginSilence*sampleRate));
inputSignal= [intialSilence inputSignal];
end
if isfield(param, 'endSilence')
finalSilence= zeros(1,round(param.endSilence*sampleRate));
inputSignal= [inputSignal finalSilence];
end

end
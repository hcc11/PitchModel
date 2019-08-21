function errormsg=nextStimulus(handles)
% Handles everything concerned with the stimulus presentation
%  called from startNewRun in subjGUI

global experiment stimulusParameters withinRuns  betweenRuns

addpath (['..' filesep 'utilities'])

if nargin<1
    handles=[];
end

experiment.status='presentingStimulus';

errormsg='';

% -----------------------------------------choose catch trials at random
% catch trials are for subject threshold measurements only
% this is the only place where withinRuns.catchTrial is set
if experiment.allowCatchTrials
    if withinRuns.trialNumber==1;
        % first trial is never a catch trial
        withinRuns.catchTrial=0;
        withinRuns.catchTrialCount=0;   % reset count on first trial
    elseif withinRuns.trialNumber==2 ...
            && withinRuns.catchTrialCount==0
        % second trial is always a catch trial
        withinRuns.catchTrial=1;
        withinRuns.catchTrialCount=1;   % this must be the first
    elseif withinRuns.thisIsRepeatTrial
        % for requested repeats do not change catch trial status
        withinRuns.thisIsRepeatTrial=0; % reset toggle
    else
        % choose whether or not to have a catch trial
        R=rand;
        if R<stimulusParameters.catchTrialRate
            % catch trial
            withinRuns.catchTrial=1;
            if experiment.useGUIs
                addToMsg('Catch Trial',1)
            end
            withinRuns.catchTrialCount=withinRuns.catchTrialCount+1;
        else
            % not a catch trial
            withinRuns.catchTrial=0;
        end
    end
else
    % no catch trials for statistical evaluations or 2AIFC
    withinRuns.catchTrial=0;
end

%------------ during stimulus presentation show appropriate button images
if experiment.useGUIs
    switch experiment.ear
        case {'statsModelLogistic', 'statsModelRareEvent',...
                'MAPmodel', 'MAPmodelMultiCh', 'MAPmodelSingleCh'}
            % no buttons shown
        otherwise
            switch experiment.threshEstMethod
                case {'2I2AFC++', '2I2AFC+++'}
                    %Except for 2I2AFC
                    % For 2I2AFC the buttons on the screen ab initio
                    set(handles.frame1,'visible','off')
                    set(handles.pushbuttonGO,'visible','off')
                    set(handles.pushbuttoNotSure,'visible','off')
                    set(handles.pushbuttonWrongButton,'visible','off')
                    set(handles.pushbutton3,'visible','off')
                    set(handles.pushbutton0,'visible','off')
                    set(handles.pushbutton1,'visible','on')
                    set(handles.pushbutton2,'visible','on')
                    drawnow
                otherwise
                    % i.e. single interval/ maxLikelihood
                    % includes MAPmodelListen where GUI is animated
                    set(handles.frame1,'backgroundColor','w')
                    set(handles.frame1,'visible','off')
                    set(handles.pushbuttoNotSure,'visible','off')
                    set(handles.pushbuttonWrongButton,'visible','off')
                    set(handles.pushbutton3,'visible','off')
                    set(handles.pushbutton2,'visible','off')
                    set(handles.pushbutton1,'visible','off')
                    set(handles.pushbutton0,'visible','off')
                    pause(.1)
            end
    end
    
    if experiment.useGUIs
        % GUI message board
        set(handles.textMSG,'BackgroundColor','w', 'ForegroundColor', 'b')
    end
end

% Now the serious business of crafting and presenting the stimulus
errormsg= stimulusMakeAndPlay (handles);

if ~isempty(errormsg)
    % e.g. clipping. subjGUI will service the error
    return
end

if experiment.useGUIs
    % after playing the stimulus, reset the subjectGUI
    switch experiment.ear
        case {'statsModelLogistic', 'statsModelRareEvent',...
                'MAPmodel', 'MAPmodelMultiCh', 'MAPmodelSingleCh'}
            % no changes required if model used
            % NB these changes do occur if 'MAPmodelListen' is selected
        otherwise
            switch experiment.threshEstMethod
                case {'2I2AFC++', '2I2AFC+++'}
                    % buttons already visible
                otherwise
                    % single interval now make buttons visible
                    set(handles.frame1,'visible','on')
                    set(handles.pushbuttoNotSure,'visible','on')
                    % set(handles.pushbuttonWrongButton,'visible','on')
                    set(handles.pushbutton0,'visible','on')
                    set(handles.pushbutton1,'visible','on')
                    set(handles.pushbutton2,'visible','on')
                    set(handles.pushbutton3,'visible','on')
            end
    end
    
    switch experiment.paradigm
        case 'SRT'
            % speech recpetion threshold
            % only editdigitInput box needs to be visible
            set(handles.frame1,'backgroundColor','w')
            set(handles.frame1,'visible','off')
            set(handles.pushbuttoNotSure,'visible','off')
            set(handles.pushbuttonWrongButton,'visible','off')
            set(handles.pushbutton3,'visible','off')
            set(handles.pushbutton2,'visible','off')
            set(handles.pushbutton1,'visible','off')
            set(handles.pushbutton0,'visible','off')
            set(handles.editdigitInput,'visible','on')
            set(handles.editdigitInput,'string',[])
            pause(.2)
            uicontrol(handles.editdigitInput)
            
        otherwise
            set(handles.editdigitInput,'visible','off')
    end
end

experiment.status='waitingForResponse';
% home again

% ----------------------------------------------------  stimulusMakeAndPlay
function errormsg=stimulusMakeAndPlay (handles)
% creates the stimulus and plays it; there are two stimuli; cue and test
%  called from nextStimulus

global experiment stimulusParameters betweenRuns withinRuns expGUIhandles 
global audio

errormsg='';

if experiment.useGUIs
    % first post the subjects instructions on subjGUI
    set(handles.textMSG,'string', stimulusParameters.subjectText)
end

thisRunNumber=betweenRuns.runNumber;

% select the new levels of the between runs variables 1 and 2
cmd=(['stimulusParameters.' betweenRuns.variableName1 '= ' ...
    num2str(betweenRuns.var1Sequence(thisRunNumber)) ';']);
% e.g.  stimulusParameters.targetFrequency= 1000;
eval(cmd);
cmd=(['stimulusParameters.' betweenRuns.variableName2 '= ' ...
    num2str(betweenRuns.var2Sequence(thisRunNumber)) ';']);
% e.g.  stimulusParameters.targetDuration= 0.1;
eval(cmd);

% When variableList2 is 'targetFrequency' targetLevel may vary between runs
% If so, it is changed at the end of each variableList1.
% For example, if the target level is SL, this may change at different
%  frequencies (rarely used. In this case the targetFrequency box contains
%  a vector of the target levels to be used
if strcmp(betweenRuns.variableName2, 'targetFrequency') && ...
        length(stimulusParameters.targetLevels)>1
    switch experiment.paradigm
        case {'trainingIFMC', 'TMC','TMC_16ms', 'TMC - ELP', 'IFMC'}
            idx=floor(thisRunNumber/length(betweenRuns.variableList1)-0.01)+1;
%             disp(num2str([thisRunNumber withinRuns.trialNumber idx]))
            cmd=(['stimulusParameters.targetLevel = ' ...
                num2str(stimulusParameters.targetLevels(idx)) ';']);
            eval(cmd);
            if withinRuns.trialNumber==1
                disp(['targetLevel=' ...
                    num2str(stimulusParameters.targetLevel)])
            end
    end
end


% for more readable code use shorter variable names;
% NB these may change below; these are only the starting values

targetType=        stimulusParameters.targetType;
targetDuration=    stimulusParameters.targetDuration;
targetLevel=       stimulusParameters.targetLevel;
targetFrequency=   stimulusParameters.targetFrequency;

maskerType=        stimulusParameters.maskerType;
maskerDuration=    stimulusParameters.maskerDuration;
maskerLevel=       stimulusParameters.maskerLevel;
maskerRelativeFrequency=  stimulusParameters.maskerRelativeFrequency;
maskerFrequency=   maskerRelativeFrequency*targetFrequency;

gapDuration=       stimulusParameters.gapDuration;

rampDuration=      stimulusParameters.rampDuration;
AFCsilenceDuration=stimulusParameters.AFCsilenceDuration; % 2I2AFC gap
backgroundLevel=   stimulusParameters.backgroundLevel;

% Set level of within runs variable (WRV)
% this is the first change to one of the values shown above
cmd=[stimulusParameters.WRVname '= withinRuns.variableValue;' ];
% e.g.: maskerLevel= withinRuns.variableValue;
eval(cmd);

% cue and test stimuli are identical except for a single difference
% depending on the paradigm
cueTestDifference= stimulusParameters.cueTestDifference;
%  cue characteristics before adding cue differences
cueTargetLevel=targetLevel;
cueMaskerFrequency=maskerFrequency;
cueMaskerDuration=maskerDuration;
cueMaskerLevel=maskerLevel;
cueTargetFrequency=targetFrequency;
cueGapDuration=gapDuration;

% ----------------------------paradigm sensitive cue and masker settings
% Switch off unwanted components and base the cue on target values
% For catch trials switch off the target

% --- set cueTarget level according to assessment method
% cue-test difference applies only with singleInterval
switch experiment.threshEstMethod
    case {'2I2AFC++', '2I2AFC+++'}
        % For 2IFC the cue stimulus (masker + probe) is the 'no' window
        % and the target stimulus (masker+probe) is the 'yes' window
        % the order of presentation is decided at the last minute.
        cueTargetLevel=-100;    % the target is never in the 'no' window
        cueMaskerLevel=maskerLevel; % masker level is the same in both
    otherwise
        % 'single interval' or max likelihood
        switch experiment.paradigm
            % cue target is more audible
            case {'training','absThreshold', 'absThreshold_8',  ...
                    'forwardMasking','forwardMaskingD', 'notchedNoiseBW'...
                    'TENtest', 'threshold_duration','discomfort',...
                    'overShoot','overShootB','overShootMB1', ...
                    'overShootMB2', 'OHIO','OHIOabs','OHIOspect'...
                    'OHIOrand', 'OHIOtemp', 'OHIOspectemp'}
                cueTargetLevel=targetLevel+cueTestDifference;
                
            case {'trainingIFMC', ...
                    'TMC','TMC_16ms', 'TMC - ELP', 'IFMC'}
                % cue masker is weaker to make target more audible
                cueMaskerLevel=maskerLevel-cueTestDifference;
        end
end

% 1. ‘OHIOabs’ paradigm is a baseline procedure for measuring absolute
% thresholds (in dB SPL) of the single tone with 12 frequencies:
%    1   2    3     4    5     6     7     8     9     10     11    12
% 494, 663, 870, 1125, 1442, 1838, 2338, 2957, 3725, 4689, 5866, 7334

% 2. ‘OHIOtemp’ is for measuring thresholds for temporally integrated
% combinations of 2, 4, 8, and 12 tones presented simultaneously.
% In our experiment, we used 4680Hz frequency.

% 3. ‘OHIOspec’ is for measuring thresholds for spectrally integrated
% combinations of 2(7335 and 5866Hz), 4(7334, 5866, 4680, and 3725Hz),
% 8(7334, 5866, 4680, 3725, 2957, 2338, 1838, and
% 1442Hz), and
% 12(all 12 frequencies) tones presented simultaneously.

% 4. ‘OHIOspectemp’ is for measuring thresholds for patterned signals
% differing in both the spectral and temporal domains.
% The frequency conditions are the same as that of ‘OHIOspec’.

% 5. ‘OHIOrand’ is for measuring thresholds for spectrotemporally varying
% signals with random frequency presentation.

switch experiment.paradigm(1:3)
    case 'OHI'
        targetType='OHIO';
        OHIOtype=experiment.paradigm;
        
        nTones=betweenRuns.var1Sequence(betweenRuns.runNumber);
        allFreqs=[494, 663, 870, 1125, 1442, 1838, 2338, 2957, 3725, ...
            4689, 5866, 7334];
        toneLevelBoost= ...
            [1	0	0	1	1	4	8	12	12	14	17	19 ];
        
        % for nTones=nTonesList
        switch experiment.paradigm
            %         case ' OHIOabs'
            %             % one tone frequency at a time
            %             stim.frequencies=allFreqs(1);
            %             stim.amplitudesdB=0;
            
            case 'OHIOrand'
                % chose nTones frequencies at random
                x=rand(1,12);
                [sorted idx]=sort(x);
                cueTargetFrequency=allFreqs(idx(1:nTones));
                cueTargetLevel=toneLevelBoost(idx)+...
                    targetLevel + cueTestDifference;
                targetFrequency=allFreqs(idx(1:nTones));
                targetLevel=targetLevel + toneLevelBoost(idx);
                
            case 'OHIOtemp'
                % 4680 Hz repeated nTones times
                cueTargetFrequency=4680*ones(1,nTones);
                cueTargetLevel=repmat(toneLevelBoost(10),1,nTones)+...
                    targetLevel + cueTestDifference;
                targetFrequency=4680*ones(1,nTones);
                targetLevel= targetLevel+repmat(toneLevelBoost(10),1,nTones);
                
            case {'OHIOspect',  'OHIOspectemp'}
                % nTones frequencies either simulataneously or sequentially
                switch nTones
                    case 2
                        cueTargetFrequency=[7335 5866];
                        targetFrequency=[7335 5866];
                        idx=[12 11];
                        cueTargetLevel=targetLevel + ...
                            toneLevelBoost(idx)+cueTestDifference;
                        targetLevel=targetLevel + toneLevelBoost(idx);
                    case 4
                        cueTargetFrequency=[7334, 5866, 4680, 3725];
                        targetFrequency=[7334, 5866, 4680, 3725];
                        idx=[12:-1:9 ];
                        cueTargetLevel=targetLevel + ...
                            toneLevelBoost(idx)+cueTestDifference;
                        targetLevel=targetLevel + toneLevelBoost(idx);
                    case 8
                        cueTargetFrequency=...
                            [7334, 5866, 4680, 3725, 2957, 2338, 1838, 1442];
                        targetFrequency=...
                            [7334, 5866, 4680, 3725, 2957, 2338, 1838, 1442];
                        idx=[12:-1:5 ];
                        cueTargetLevel=targetLevel + ...
                            toneLevelBoost(idx)+cueTestDifference;
                        targetLevel=targetLevel + toneLevelBoost(idx);
                    case 12
                        cueTargetFrequency=allFreqs;
                        targetFrequency=allFreqs;
                        cueTargetLevel=targetLevel + ...
                            toneLevelBoost(1:12)+cueTestDifference;
                        targetLevel=targetLevel + toneLevelBoost(1:12);
                end
        end
        
    otherwise
        OHIOtype='none';
end

switch experiment.paradigm(1:3)
    case 'OHI'
        
        switch experiment.threshEstMethod
            case {'2I2AFC++', '2I2AFC+++'}
                % the cue stimulus (masker + probe) is the 'no' window
                % the target stimulus (masker+probe) is the 'yes' window
                % the order of presentation is decided at the last minute.
                cueTargetLevel=-100;
        end
        
        
        switch experiment.paradigm
            case {'OHIOabs', 'OHIOspect'}
                OHIOtoneDuration=.02+stimulusParameters.stimulusDelay;
                globalStimParams.overallDuration=OHIOtoneDuration;
            otherwise
                OHIOtoneDuration=nTones*0.02+ ...
                    stimulusParameters.stimulusDelay;
                globalStimParams.overallDuration=OHIOtoneDuration;
        end
end

% ----------------------------- catch trial
if withinRuns.catchTrial
    targetLevel=-100;	% no target
end

% ----------------------------- calibration of sound output
% seperate calibration for each frequency to match headphones
% Requested by Oldenburg for their funny headphones
calibrationCorrectiondB=stimulusParameters.calibrationdB;
if calibrationCorrectiondB<-50
    if maskerFrequency==targetFrequency
        load 'calibrationFile'% calibrationFrequency/ attenutation
        idx=find(calibrationFrequency==targetFrequency);
        if isempty(idx)
            error('Calibration by file; target frequency not in file')
        else
            calibrationCorrectiondB=calibrationAttenutation(idx)
        end
    else
        error('calibration by file requested but masker frequency is not the same as target')
    end
end


% -------------------------------------- Checks on excessive signal level

% clipping is relevant only for soundcard use (not modelling)
switch experiment.ear
    case {'left', 'right', 'diotic',...
            'dichotic', 'dioticLeft', 'dichoticRight'}
        experiment.headphonesUsed=1;
    otherwise
        experiment.headphonesUsed=0;
end

% NB calibration *reduces* the level of the soundCard output
switch experiment.ear
    case {'left', 'right', 'diotic',...
            'dichotic', 'dioticLeft', 'dichoticRight'}
        switch experiment.paradigm
            case 'TMCgap'
                clippingLevel=inf;
            otherwise
        clippingLevel=91+calibrationCorrectiondB;
        end
        soundCardMinimum=clippingLevel-20*log10(2^24);
    otherwise
        clippingLevel=inf;
        soundCardMinimum=-inf;
end

% Check for extreme WRV values and abort if necessary
% WRVname specifies the value that changes from trial to trial
withinRuns.forceThreshold=0; % so far no problems with threshold

if ~withinRuns.catchTrial
   errormsg=  checkLimits(clippingLevel);
   if ~isempty(errormsg); 
       return
   end
end

% --------------------------------Ear ----------------------------------
globalStimParams.ears='specified';
% ear: 1=left, 2=right
switch experiment.ear
    case 'left'
        maskerEar=1;
        targetEar=1;
    case 'right'
        maskerEar=2;
        targetEar=2;
    case 'dichoticLeft'
        maskerEar=2;
        targetEar=1;
    case 'dichoticRight'
        maskerEar=1;
        targetEar=2;
    case 'diotic'
        maskerEar=1;
        targetEar=1;
        globalStimParams.ears='diotic';
    case {'MAPmodel', 'MAPmodelMultiCh', 'MAPmodelSingleCh', 'MAPmodelListen',...
            'statsModelLogistic', 'statsModelRareEvent'}
        maskerEar=1;
        targetEar=1;
end

backgroundType=stimulusParameters.backgroundType;
switch stimulusParameters.backgroundType
    case {'noiseDich', 'pinkNoiseDich'}
        %     case 'Dich'
        % dich means put the background in the ear opposite to the target
        backgroundType=backgroundType(1:end-4);
        switch targetEar
            case 1
                backgroundEar=2;
            case 2
                backgroundEar=1;
        end
    otherwise
        %             case {'none','noise', 'pinkNoise', 'TEN','babble'}
        backgroundEar=targetEar;
end

% ------------------------------- Make Stimulus -------------------
% single interval up/down plays cue then target stimulus
% 2IFC uses cue stimulus as interval with no target
globalStimParams.FS=stimulusParameters.sampleRate;
dt=1/stimulusParameters.sampleRate;
globalStimParams.dt=dt;
stimulusParameters.dt=dt; % for use later



globalStimParams.audioOutCorrection=10^(calibrationCorrectiondB/20);
% the output will be reduced by this amount in stimulusCreate
% i.e.  audio=audio/globalStimParams.audioOutCorrection
% A 91 dB level will yield a peak amp of 1 Pa for calibration=0
% A 91 dB level will yield a peak amp of 0.4467 for calibration=7
% A 98 dB level will yield a peak amp of 1 for calibration=7

precedingSilence=stimulusParameters.stimulusDelay;
% all stimuli have 20 ms terminal silence.
% this is clearance for modelling late-ringing targets
terminalSilence=.03;

% Now compute overall duration of the stimulus
% note that all endsilence values are set to -1
%  so that they will fill with terminal silence as required to make
%  components equal in length
% We need to find the longest possible duration
duration(1)=precedingSilence+maskerDuration+cueGapDuration...
    +targetDuration+terminalSilence;
duration(2)=precedingSilence+maskerDuration+gapDuration...
    +targetDuration+ terminalSilence;
% If the gap is negative we need to ignore it when estimating total length
duration(3)=precedingSilence+maskerDuration+ terminalSilence;
globalStimParams.overallDuration=max(duration);
globalStimParams.nSignalPoints=...
    round(globalStimParams.overallDuration*globalStimParams.FS);

% special case
switch experiment.paradigm(1:3)
    case 'OHI'
        switch experiment.paradigm
            case {'OHIOabs', 'OHIOspect'}
                OHIOtoneDuration=.02+stimulusParameters.stimulusDelay;
                globalStimParams.overallDuration=OHIOtoneDuration;
            otherwise
                OHIOtoneDuration=nTones*0.02+stimulusParameters.stimulusDelay;
                globalStimParams.overallDuration=OHIOtoneDuration;
        end
end


%           ----------------------------------------------cue stimulus
% cue masker
componentNo=1;
precedingSilence=stimulusParameters.stimulusDelay;
stimComponents(maskerEar,componentNo).type=maskerType;
stimComponents(maskerEar,componentNo).toneDuration=cueMaskerDuration;
stimComponents(maskerEar,componentNo).frequencies=cueMaskerFrequency;
stimComponents(maskerEar,componentNo).amplitudesdB=cueMaskerLevel;
stimComponents(maskerEar,componentNo).beginSilence=precedingSilence;
stimComponents(maskerEar,componentNo).endSilence=-1;
stimComponents(maskerEar,componentNo).AMfrequency=0;
stimComponents(maskerEar,componentNo).AMdepth=0;
stimComponents(maskerEar,componentNo).notchedNoiseBW=stimulusParameters.notchedNoiseBW;
stimComponents(maskerEar,componentNo).maskerNoiseBW=stimulusParameters.maskerNoiseBW;


if rampDuration<maskerDuration
    % ramps must be shorter than the signal
    stimComponents(maskerEar,componentNo).rampOnDur=rampDuration;
    stimComponents(maskerEar,componentNo).rampOffDur=rampDuration;
else
    % or squeeze the ramp in
    stimComponents(maskerEar,componentNo).rampOnDur=maskerDuration/2;
    stimComponents(maskerEar,componentNo).rampOffDur=maskerDuration/2;
end
stimComponents(maskerEar,componentNo).phases=...
    stimulusParameters.maskerPhase;
stimComponents(maskerEar,componentNo).niterations=0;    % for IRN only
% stimComponents(targetEar,componentNo)

% cue target
componentNo=2;
precedingSilence=precedingSilence + maskerDuration+cueGapDuration;
stimComponents(targetEar,componentNo).type=targetType;
stimComponents(targetEar,componentNo).OHIOtype=OHIOtype;
stimComponents(targetEar,componentNo).toneDuration=targetDuration;
stimComponents(targetEar,componentNo).frequencies=cueTargetFrequency;
stimComponents(targetEar,componentNo).amplitudesdB=cueTargetLevel;
stimComponents(targetEar,componentNo).beginSilence=precedingSilence;
stimComponents(targetEar,componentNo).endSilence=-1;
stimComponents(targetEar,componentNo).AMfrequency=0;
stimComponents(targetEar,componentNo).AMdepth=0;
if rampDuration<targetDuration
    % ramps must be shorter than the signal
    stimComponents(targetEar,componentNo).rampOnDur=rampDuration;
    stimComponents(targetEar,componentNo).rampOffDur=rampDuration;
else
    stimComponents(targetEar,componentNo).rampOnDur=0;
    stimComponents(targetEar,componentNo).rampOffDur=0;
end
stimComponents(targetEar,componentNo).phases=...
    stimulusParameters.targetPhase;
% stimComponents(targetEar,componentNo)

% background same ear as target
componentNo=3;
stimComponents(backgroundEar,componentNo).type=backgroundType;
switch backgroundType
    case 'TEN'
        fileName=['..' filesep '..' filesep ...
            'multithresholdResources' filesep ...
            'backgrounds and maskers'...
            filesep 'ten.wav'];
        [tenNoise, FS]=wavread(fileName);
        tenNoise=resample(tenNoise, globalStimParams.FS, FS);
        stimComponents(backgroundEar,componentNo).type='file';
        stimComponents(backgroundEar,componentNo).stimulus=tenNoise';
end
stimComponents(backgroundEar,componentNo).toneDuration=...
    globalStimParams.overallDuration;
stimComponents(backgroundEar,componentNo).amplitudesdB=backgroundLevel;
stimComponents(backgroundEar,componentNo).beginSilence=0;
stimComponents(backgroundEar,componentNo).endSilence=-1;
stimComponents(backgroundEar,componentNo).AMfrequency=0;
stimComponents(backgroundEar,componentNo).AMdepth=0;
stimComponents(backgroundEar,componentNo).rampOnDur=rampDuration;
stimComponents(backgroundEar,componentNo).rampOffDur=rampDuration;

[cueStimulus, errormsg]=...
    stimulusCreate(globalStimParams, stimComponents);
if ~isempty(errormsg)     % e.g. limits exceeded
    return
end

%               ------------------------------------------ test stimulus
% masker
componentNo=1;
precedingSilence=stimulusParameters.stimulusDelay;
% additional code to allow for variable delay to the test condition
% This is used only by paradigm_overShootVarDelay.m
additionalDelay= stimulusParameters.stimulusDelayVariability* ...
   rand(1,1);
precedingSilence=precedingSilence+ additionalDelay;
globalStimParams.overallDuration=globalStimParams.overallDuration+...
   additionalDelay;
globalStimParams.nSignalPoints=...
    round(globalStimParams.overallDuration*globalStimParams.FS);

stimComponents(maskerEar,componentNo).type=maskerType;
stimComponents(maskerEar,componentNo).toneDuration=maskerDuration;
stimComponents(maskerEar,componentNo).frequencies=maskerFrequency;
stimComponents(maskerEar,componentNo).amplitudesdB=maskerLevel;
stimComponents(maskerEar,componentNo).beginSilence=precedingSilence;
stimComponents(maskerEar,componentNo).endSilence=-1;
stimComponents(maskerEar,componentNo).AMfrequency=0;
stimComponents(maskerEar,componentNo).AMdepth=0;
stimComponents(maskerEar,componentNo).notchedNoiseBW=stimulusParameters.notchedNoiseBW;
stimComponents(maskerEar,componentNo).maskerNoiseBW=stimulusParameters.maskerNoiseBW;
if rampDuration<maskerDuration
    % ramps must be shorter than the signal
    stimComponents(maskerEar,componentNo).rampOnDur=rampDuration;
    stimComponents(maskerEar,componentNo).rampOffDur=rampDuration;
else
    stimComponents(maskerEar,componentNo).rampOnDur=maskerDuration/2;
    stimComponents(maskerEar,componentNo).rampOffDur=maskerDuration/2;
end
stimComponents(maskerEar,componentNo).phases=...
    stimulusParameters.maskerPhase;
stimComponents(maskerEar,componentNo).niterations=0;    % for IRN only

% target
componentNo=2;
targetDelay=precedingSilence+ maskerDuration+ gapDuration;
stimComponents(targetEar,componentNo).type=targetType;
stimComponents(targetEar,componentNo).OHIOtype=OHIOtype;
stimComponents(targetEar,componentNo).toneDuration=targetDuration;
stimComponents(targetEar,componentNo).frequencies=targetFrequency;
stimComponents(targetEar,componentNo).amplitudesdB=targetLevel;
stimComponents(targetEar,componentNo).beginSilence=targetDelay;
stimComponents(targetEar,componentNo).endSilence=-1;
stimComponents(targetEar,componentNo).AMfrequency=0;
stimComponents(targetEar,componentNo).AMdepth=0;
if rampDuration<targetDuration
    % ramps must be shorter than the signal
    stimComponents(targetEar,componentNo).rampOnDur=rampDuration;
    stimComponents(targetEar,componentNo).rampOffDur=rampDuration;
else
    stimComponents(targetEar,componentNo).rampOnDur=0;
    stimComponents(targetEar,componentNo).rampOffDur=0;
end
stimComponents(targetEar,componentNo).phases=stimulusParameters.targetPhase;
% stimComponents(targetEar,componentNo)

% background same ear as target
componentNo=3;
stimComponents(backgroundEar,componentNo).type=backgroundType;
switch backgroundType
    case 'TEN'
        fileName=['..' filesep '..' filesep ...
            'multithresholdResources' filesep ...
            'backgrounds and maskers'...
            filesep 'ten.wav'];
        [tenNoise, FS]=wavread(fileName);
        
        tenNoise=resample(tenNoise, globalStimParams.FS, FS);
        stimComponents(backgroundEar,componentNo).type='file';
        stimComponents(backgroundEar,componentNo).stimulus=tenNoise';
end
stimComponents(backgroundEar,componentNo).toneDuration=...
    globalStimParams.overallDuration;
stimComponents(backgroundEar,componentNo).amplitudesdB=backgroundLevel;
stimComponents(backgroundEar,componentNo).beginSilence=0;
stimComponents(backgroundEar,componentNo).endSilence=-1;
stimComponents(backgroundEar,componentNo).rampOnDur=rampDuration;
stimComponents(backgroundEar,componentNo).rampOffDur=rampDuration;
stimComponents(backgroundEar,componentNo).AMfrequency=0;
stimComponents(backgroundEar,componentNo).AMdepth=0;

% identify timings for MAP peripheral model
switch experiment.paradigm
    case 'gapDetection'
        % gap is the 'target' in this case
        stimulusParameters.testTargetBegins=...
            stimulusParameters.stimulusDelay...
            +stimulusParameters.maskerDuration;
        stimulusParameters.testTargetEnds=...
            stimulusParameters.testTargetBegins+withinRuns.variableValue;
        %     case 'SRT'
        %         set(handles.editdigitInput,'visible','off')
    otherwise
        switch experiment.paradigm
            case 'OHI'
                stimulusParameters.testTargetBegins=0;
                stimulusParameters.testTargetEnds=OHIOtoneDuration;
            case {'multiGauss', 'singleGauss'}
                stimulusParameters.testTargetBegins=targetDelay+0.004;
                stimulusParameters.testTargetEnds=targetDelay+0.009;
            otherwise
                stimulusParameters.testTargetBegins=targetDelay;
                stimulusParameters.testTargetEnds=targetDelay+targetDuration;
        end
end

% ------------------------------------------------------------- play!
% Create and play stimulus (as required by different paradigms)
switch experiment.ear
    case {'statsModelLogistic', 'statsModelRareEvent'}
        audio=[0;0];            % no need to compute stimulus
        
    otherwise                   % create the stimulus
        [targetStimulus, errormsg]= ...
            stimulusCreate(globalStimParams, stimComponents);
        
        if ~isempty(errormsg)   % e.g. limits exceeded
            errormsg
            return
        end
        
        % -----------------------------------  create audio for playback
        switch experiment.ear
            case {'MAPmodel' , 'MAPmodelMultiCh', 'MAPmodelSingleCh', 'MAPmodelListen'}
                % model requires no calibration correction;
                %  signal is already in Pascals
                globalStimParams.audioOutCorrection=1;
                % use only the targetStimulus for the MAP model
                audio=targetStimulus;
                
            otherwise           % left, right diotic dichotic
                if stimulusParameters.includeCue
                    audio= [cueStimulus;  targetStimulus];
                else            % no cue
                    audio=targetStimulus;
                end
        end
        
        % ----------------------------                          playtime
        % order of the cue and test stimuli varies for 2AFC
        switch experiment.threshEstMethod
            case {'2I2AFC++', '2I2AFC+++'}
                % intervening silence (currently none; masking delay serves this purpose)
                IAFCinterveningSilence=zeros(round(AFCsilenceDuration/dt),2);
                if rand>0.5				% put test stimulus first
                    stimulusParameters.testTargetBegins=targetDelay ;
                    stimulusParameters.testTargetEnds= ...
                        targetDelay+targetDuration;
                    stimulusParameters.testNonTargetBegins=...
                        length(cueStimulus)*dt ...
                        + AFCsilenceDuration +targetDelay ;
                    stimulusParameters.testNonTargetEnds=...
                        length(cueStimulus)*dt ...
                        + AFCsilenceDuration+targetDelay+targetDuration;
                    
                    set(handles.pushbutton1,'backgroundcolor','r'), drawnow
                    
                    y=audioplayer(targetStimulus, globalStimParams.FS, 24);
                    playblocking(y)
                    set(handles.pushbutton1,'backgroundcolor',...
                        get(0,'defaultUicontrolBackgroundColor')), drawnow
                    
                    y=audioplayer(IAFCinterveningSilence, ...
                        globalStimParams.FS, 24);
                    playblocking(y)
                    set(handles.pushbutton2,'backgroundcolor','r'), drawnow
                    
                    y=audioplayer(cueStimulus, globalStimParams.FS, 24);
                    playblocking(y)
                    set(handles.pushbutton2,'backgroundcolor',...
                        get(0,'defaultUicontrolBackgroundColor')), drawnow
                    
                    withinRuns.stimulusOrder='targetFirst';
                    
                    audio= [targetStimulus; IAFCinterveningSilence; ...
                        cueStimulus];   % for plotting purposes later
                else					% put test stimulus second
                    stimulusParameters.testTargetBegins=...
                        length(cueStimulus)*dt ...
                        + AFCsilenceDuration +targetDelay ;
                    stimulusParameters.testTargetEnds=...
                        length(cueStimulus)*dt ...
                        + AFCsilenceDuration+targetDelay+targetDuration;
                    stimulusParameters.testNonTargetBegins=targetDelay ;
                    stimulusParameters.testNonTargetEnds=...
                        targetDelay+targetDuration;
                    
                    set(handles.pushbutton1,'backgroundcolor','r'),drawnow
                    
                    y=audioplayer(cueStimulus, globalStimParams.FS, 24);
                    playblocking(y)
                    set(handles.pushbutton1,'backgroundcolor',...
                        get(0,'defaultUicontrolBackgroundColor')), drawnow
                    
                    y=audioplayer(IAFCinterveningSilence, ...
                        globalStimParams.FS, 24);
                    playblocking(y)
                    set(handles.pushbutton2,'backgroundcolor','r'), drawnow
                    
                    y=audioplayer(targetStimulus, globalStimParams.FS, 24);
                    playblocking(y)
                    set(handles.pushbutton2,'backgroundcolor',...
                        get(0,'defaultUicontrolBackgroundColor')), drawnow
                    
                    withinRuns.stimulusOrder='targetSecond';
                    
                    audio= [cueStimulus; IAFCinterveningSilence; ...
                        targetStimulus];    % for plotting purposes later
                end
                
            otherwise                       % singleInterval
                if strcmp(experiment.ear,'MAPmodel') ...
                        || strcmp(experiment.ear,'MAPmodelMultiCh') ...
                        || strcmp(experiment.ear,'MAPmodelSingleCh') ...
                        ||strcmp(experiment.ear,'MAPmodelListen')
                    % don't play for MAPmodel
                    switch experiment.ear
                        % except on special request
                        case {'MAPmodelListen'}
                            y=audioplayer(audio, globalStimParams.FS, 24);
                            playblocking(y) % suspends operations until completed
                    end
                else
                    y=audioplayer(audio, globalStimParams.FS, 24);
                    playblocking(y)
                end	  %   if experiment.ear
        end	% switch experiment.threshEstMethod
end % switch experiment.ear

% Save stimulus as a file
%switch experiment.ear
 %   case	{'MAPmodel', 'MAPmodelListen',  'MAPmodelMultiCh','MAPmodelSingleCh'}
        % save audio for later reference or for input to MAP model
  %      wavwrite(audio/max(audio), globalStimParams.FS,32,'stimulus')
%end

% Plot stimulus --------------------  Panel 1
if experiment.useGUIs
    
    % graphical presentation of the stimulus
    % NB shown *after* the stimulus has been presented
    axes(expGUIhandles.axes1), cla
    % plot is HW rectified and plotted as dB re 28e-6. Calibration is ignored
    t=dt:dt:dt*length(audio);
    plot(t,stimulusParameters.calibrationdB+20*log10((abs(audio)+1e-10)/28e-6))
    ylim([-20 100]), ylabel('stimulus (dB SPL)')
    xlim([0 t(end)])
    grid on
    header=[betweenRuns.variableName1  ': ' ...
        num2str(betweenRuns.var1Sequence(betweenRuns.runNumber))];
    header=[header '      ' num2str(...
        betweenRuns.var2Sequence(betweenRuns.runNumber)) ':' ...
        betweenRuns.variableName2 ];
    title(header)
end

function errormsg= checkLimits(clippingLevel)
global stimulusParameters withinRuns

variableValue=withinRuns.variableValue;
if stimulusParameters.includeCue
    cueLevel= variableValue+ stimulusParameters.cueTestDifference;
else
    cueLevel= variableValue;
end
variableName=stimulusParameters.WRVname;
upperLevel=stimulusParameters.WRVlimits(2);
lowerLevel=stimulusParameters.WRVlimits(1);
errormsg=[];

if max(variableValue, cueLevel)> upperLevel
    errormsg=[variableName  ...
        num2str(max(variableValue, cueLevel)) ' is too high'];
    withinRuns.forceThreshold=upperLevel;
    return
end
if max(variableValue, cueLevel)< lowerLevel
    errormsg=[variableName  ...
        num2str(max(variableValue, cueLevel)) ' is too low'];
    withinRuns.forceThreshold=lowerLevel;
    return
end
if max(variableValue, cueLevel)> clippingLevel
    errormsg=[variableName  ...
        num2str(max(variableValue, cueLevel)) ' is clipping'];
    withinRuns.forceThreshold=upperLevel;
    return
end



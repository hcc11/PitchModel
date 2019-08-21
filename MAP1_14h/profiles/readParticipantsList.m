function participant=readParticipantsList
% readParticipantsList merges information from subject index and data files
%
% Reads the participantDetails.xls and creates a structure (participant)
%  it then finds associated measurements from the 
%   allParticipantsByInitials folder and adds it to the structure.
%
% The individual files are then added to an allParticipants folder 
%  using a new name based on the subject number
%
% The participant structure is then saved as participantCompendium.mat

clear all
dbstop if error
restorePath=path;

% ISOthresholds used to decide if data within normal range
ISOthresholds=[
    250     18;
    500     11;
    1000	6;
    2000	5;
    4000	10;
    8000	18;];
ISOBFs=ISOthresholds(:,1)'; 

disp('running...')
addpath('..' filesep 'profiles' filesep 'allParticipantsByInitials')

% read Excel file containing subject details
[num,txt,raw]=xlsread('participantListwithPersDetails');
% [num,txt,raw]=xlsread('participantList');
% omit header row containing titles (not needed for num)
txt=txt(2:end,:);

[r c]=size(txt);
for subjNo=1:r
   
    participant(subjNo).number=num(subjNo,1);
    participant(subjNo).impaired=num(subjNo,2);
    participant(subjNo).initials=txt{subjNo,4};
    participant(subjNo).matScript=num(subjNo,5);
    participant(subjNo).iffy=num(subjNo,6);
    participant(subjNo).leftEar=num(subjNo,7);
    participant(subjNo).rightEar=num(subjNo,8);
    participant(subjNo).male=num(subjNo,10); % male=1
    participant(subjNo).tinnitus=num(subjNo,11); % tinnitus=1
    participant(subjNo).TMJ=num(subjNo,16); % tinnitus=1
    participant(subjNo).THI=num(subjNo,17); % tinnitus=1
    participant(subjNo).birthYear=num(subjNo,21);
    participant(subjNo).startTest=num(subjNo,22);
    participant(subjNo).age=num(subjNo,23);
    participant(subjNo).shortToneDuration=num(subjNo,27);
    participant(subjNo).longToneDuration=num(subjNo,28);
    participant(subjNo).mixedLoss=num(subjNo,37);
    participant(subjNo).Meniere=num(subjNo,38);
    participant(subjNo).CTusedMe=num(subjNo,51);
    % default
    participant(subjNo).leftEarDataIncomplete=1;
    participant(subjNo).rightEarDataIncomplete=1;

    % code is a discription <number><'IH' or <number><'NH'>    
    if participant(subjNo).impaired
        type='IH';
    else
        type='NH';
    end
    numString=num2str(participant(subjNo).number,'%3.0f');
    participant(subjNo).code= [type  numString];
    
    % read profiles and add to structure
    % if profiles exist and there are no problems with this case
    if participant(subjNo).matScript && ~participant(subjNo).iffy
        
        cmd=[ 'earData=profile_' participant(subjNo).initials '_L;'];
        eval(cmd)   % left ear data now in earData
        
        %% left ear
        earData.ear='left';
        BFs=earData.BFs;
        nBFs=length(BFs);
        
        % check if within normal range
        idx=[]; for i=1:length(ISOBFs), idx=[idx find(ISOBFs(i)==BFs)]; end
        thresholddiffs=(earData.LongTone(idx)-ISOthresholds(:,2)');
        if max(thresholddiffs)>10
            earData.ISOnorm=0;
        else
            earData.ISOnorm=1;
        end
        
        % mean abs threshold
        longToneLeft=earData.LongTone;
        earData.meanLongTone=mean(longToneLeft(~isnan(longToneLeft)));
        
        % scan for incomplete data
        if sum(sum(~isnan(earData.IFMCs)))==0 ...
                ||sum(sum(~isnan(earData.TMC)))==0
            participant(subjNo).leftEarDataIncomplete=1;
        else
            participant(subjNo).leftEarDataIncomplete=0;
        end
        
        % look for min 5 IFMCs at BF and min 5 TMCs at 20 ms 
        %  between 500 Hz and 6 kHz 
         if sum(~isnan(earData.IFMCs(1:6,4)))>5 ...
                && sum(~isnan(earData.TMC(1:6,2)))>5
           participant(subjNo).leftEarDataComplete=1;
           disp(num2str([subjNo sum(~isnan(earData.IFMCs(1:6,4)))...
                 sum(~isnan(earData.TMC(1:6,2)))]))
        else
            participant(subjNo).leftEarDataComplete=0;
        end
                 
        % specify IFMC depth
        % (fp*0.7-fp*1.3)-fp
        leftIFMCdepths= mean([earData.IFMCs(:,2) earData.IFMCs(:,6)], 2)...
            -earData.IFMCs(:,4);
        earData.IFMCdepths=leftIFMCdepths;
        
        % find TMC slopes
        leftTMCslopes=NaN(1,nBFs);
        for BFno=1:nBFs
            x=[earData.Gaps];
            y=earData.TMC(BFno,:);
            % remove NaNs for joined up plot
            [x y]=stripNaNsfromPairedVariables(earData.Gaps,earData.TMC(BFno,:));
            
            if ~isempty(x)
                P=polyfit(x,y,1);
                leftTMCslopes(BFno)=P(1)/10;
            end
        end
        earData.TMCslopes=leftTMCslopes;
        
        participant(subjNo).leftEarData=earData;
        
        %% right ear
        cmd=[ 'earData=profile_' participant(subjNo).initials '_R;'];
        eval(cmd)   % right ear data now in earData
        earData.ear='right';
        participant(subjNo).rightEarData=earData;
        
        BFs=earData.BFs;    idx=[]; for i=1:length(ISOBFs), idx=[idx find(ISOBFs(i)==BFs)]; end
        thresholddiffs=(earData.LongTone(idx)-ISOthresholds(:,2)');
        if max(thresholddiffs)>10
            earData.ISOnorm=0;
        else
            earData.ISOnorm=1;
        end
        
        % mean abs threshold
        longToneRight=earData.LongTone;
        earData.meanLongTone=mean(longToneRight(~isnan(longToneRight)));
        
        % scan for incomplete data
        if sum(sum(~isnan(earData.IFMCs)))==0 ||sum(sum(~isnan(earData.TMC)))==0
            participant(subjNo).rightEarDataIncomplete=1;
        else
            participant(subjNo).rightEarDataIncomplete=0;
        end
        
        % look for min 5 IFMCs at BF and min 5 TMCs at 20 ms 
        %  between 500 Hz and 6 kHz 
        if sum(~isnan(earData.IFMCs(1:6,4)))>5 ...
                && sum(~isnan(earData.TMC(1:6,2)))>5
           disp(num2str([subjNo sum(~isnan(earData.IFMCs(1:6,4)))...
                 sum(~isnan(earData.TMC(1:6,2)))]))
            participant(subjNo).rightEarDataComplete=1;
        else
            participant(subjNo).rightEarDataComplete=0;
        end
            

        % specify IFMC depth
        % (fp*0.7-fp*1.3)-fp
        rightIFMCdepths= mean([earData.IFMCs(:,2) earData.IFMCs(:,6)], 2) -earData.IFMCs(:,4);
        earData.IFMCdepths=rightIFMCdepths;
        
        % find TMC slopes
        rightTMCslopes=NaN(1,nBFs);
        for BFno=1:nBFs
            x=earData.TMCFreq(BFno);
            y=earData.TMC(BFno,:);
            % remove NaNs for joined up plot
            [x y]=stripNaNsfromPairedVariables(earData.Gaps,earData.TMC(BFno,:));
            
            if ~isempty(x)
                P=polyfit(x,y,1);
                rightTMCslopes(BFno)=P(1)/10;
            end
        end
        earData.TMCslopes=rightTMCslopes;        
        participant(subjNo).rightEarData=earData;
        
        %% add file to allParticipants folder if there are no problems
        code=participant(subjNo).code;
        copyFrom=['allParticipantsByInitials\profile_'...
            participant(subjNo).initials '_L.m'];
        copyTo=['allParticipants\profile_' code '_L.m'];
        copyfile(copyFrom, copyTo)

        copyFrom=['allParticipantsByInitials\profile_' participant(subjNo).initials '_R.m'];
        copyTo=['allParticipants\profile_' code '_R.m'];
        copyfile(copyFrom, copyTo)
    end
    
end

disp([num2str(subjNo) ' participants found'])
save participantCompendium participant

disp(['done: saved as ''participantCompendium.mat'''])
path(restorePath)


function [a b]=stripNaNsfromPairedVariables(a,b)
idx=find(~isnan(b)); a=a(idx); b=b(idx);

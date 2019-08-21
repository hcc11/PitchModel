% -----------------------------------------------------MAPmodelRunsGUI
% The computer presses the buttons
% This function calls startNewRun and must be in the same file
function 	MAPmodelRunsGUI(subjHandles)
global experiment stimulusParameters expGUIhandles
global AN_IHCsynapseParams

while strcmp(experiment.status,'waitingForGO')
    % no catch trials for MAP model
    %     experiment.allowCatchTrials=0;
    %     experiment.allowCatchTrials=1;
    
    % initiates run and plays first stimulus and it returns
    %  without waiting for button press
    startNewRun(subjHandles)
    
    if experiment.useGUIs
        % show sample Rate on GUI; it must be set in MAPparams ##??
        set(expGUIhandles.textsampleRate,'string',...
            num2str(stimulusParameters.sampleRate))
    end %if GUIs
    
    % continuous loop until the program stops itself
    while strcmp(experiment.status,'waitingForResponse')
        %  NB at this point the stimulus has been played
        pause(0.1)  % to allow interrupt with CTRL/C
        
        if experiment.useGUIs
            switch experiment.ear
                case { 'MAPmodelListen'}
                    % flash the buttons to show model response
                    set(subjHandles.pushbutton1,'backgroundcolor','y','visible','on')
                    set(subjHandles.pushbutton2,'backgroundcolor','y','visible','on')
            end
        end
        
        % Analayse the current stimulus using MAP
        [modelResponse earObject]= MAPmodel;
        
        if experiment.stop || experiment.singleShot
            % trap for single trial or user interrupt using 'stop' button.
            experiment.status= 'waitingForStart';
            %             experiment.stop=0;
            errormsg='manually stopped';
            addToMsg(errormsg,1)
            return
        end
        
        switch modelResponse
            case 1
                %     userDoesNotHearTarget(subjHandles)
                switch experiment.ear
                    case {'MAPmodelListen'}
                        % illuminate appropriate button
                        set(subjHandles.pushbutton1,...
                            'backgroundcolor','r','visible','on')
                        set(subjHandles.pushbutton2,'backgroundcolor','y')
                end
                userDecides(subjHandles, false);
                if experiment.singleShot, return, end
                
            case 2
                %   userHearsTarget(subjHandles)
                if experiment.useGUIs
                    switch experiment.ear
                        case {'MAPmodelListen'}
                            % illuminate appropriate button (DEMO only)
                            set(subjHandles.pushbutton2,'backgroundcolor',...
                                'r','visible','on')
                            set(subjHandles.pushbutton1,'backgroundcolor','y')
                    end
                end
                
                switch experiment.paradigm
                    case 'discomfort'
                        % always treat discomfort as 'not heard'
                        userDecides(subjHandles, false);
                    otherwise
                        userDecides(subjHandles, true);
                end
            otherwise
                % probably an abort
                return
        end % switch model response
    end  % while waiting for response
end  % while waiting for GO


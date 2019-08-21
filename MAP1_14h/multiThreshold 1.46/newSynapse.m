            for t= ANspeedUpFactor:ANspeedUpFactor:segmentLength;
                ANtimeCount= ANtimeCount+1;
                % convert release rate to probabilities
                releaseProb= vesicleReleaseRate(:,t)*dtSpikes;
                % releaseProb is the release probability *per channel*
                %  but each channel has many synapses
                releaseProb= repmat(releaseProb',nFibersPerChannel,1);
                releaseProb= ...
                    reshape(releaseProb, nFibersPerChannel*nANchannels,1);
                
                % qt=round(qt); % vesicle count must be integer
                M_qt= M- qt;     % number of missing vesicles
                M_qt(M_qt<0)= 0;              % cannot be less than 0
                
                % compiled code is used to speed up the computation using
                %  intpow(x,q), y=x^q where q is integer
                % If 'intpow' is not available for your machine,
                %   uncomment the original MATLAB code here
                %   and for the next three instances
                
                % probabilities are the likelihood that at least one
                % vesicle will be released. ejected is logical 0/1 and
                % limits the number released to 1 in this epoch.
                if CcodeSpeedUp
                    probabilities= 1-intpow((1-releaseProb), qt); %fast
                    ejected= probabilities> rand(length(qt),1);
                    probabilities= 1-intpow((1-xdt), wt);
%                     reprocessed= probabilities>rand(length(M_qt),1);
                    reprocessed= probabilities>rand(length(wt),1);
                    probabilities= 1-intpow((1-ydt), M_qt);
                    replenish= probabilities>rand(length(M_qt),1);
                else                    
                    probabilities= 1-(1-releaseProb).^qt; % slow
                    ejected= probabilities> rand(length(qt),1);
                    probabilities= 1-(1-xdt).^wt; % slow
%                     reprocessed= probabilities>rand(length(M_qt),1);
                    reprocessed= probabilities>rand(length(wt),1);
                    probabilities= 1-(1-ydt).^M_qt; %slow
                    replenish= probabilities>rand(length(M_qt),1);
                end
                reuptakeandlost= AN_rdt_plus_ldt .* AN_cleft;
                reuptake= rdt.* AN_cleft;
                
                qt= qt + replenish - ejected ...
                    + reprocessed;
                
                AN_cleft= AN_cleft + ejected - reuptakeandlost;
                wt= wt + reuptake - reprocessed;
               if plotSynapseContents
                   save_wt_seg(:,ANtimeCount)=wt(end,:); % only last channel
                save_qt_seg(:,ANtimeCount)=qt(end,:); % only last channel
               end
                
                % ANspikes is logical record of vesicle release events>0
                ANspikes(:, ANtimeCount)= ejected;
            end % t

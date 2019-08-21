function ANtrains=run_MAP(inputSignal, sampleRate, BFlist, ...
    MAPparamsName, AN_spikesOrProbability, paramChanges,anf_num)

% ANtrains is cell of colums {'index','duration','type','cf','spikes'};


global dtSpikes ANoutput 
dbstop if error
restorePath=path;

fprintf('\n')
disp(['Signal duration= ' num2str(length(inputSignal)/sampleRate)])
fprintf('%d channels from %d to %d Hz\n',length(BFlist),min(BFlist),max(BFlist))
disp('Computing ANF')

% change current folder
oldFolder = cd('MAP1_14h/MAP');

%%%%%% run for first time use  %%%%%%
% mex intpow.c 

MAP1_14(inputSignal, sampleRate, BFlist, ...
    MAPparamsName, AN_spikesOrProbability, paramChanges);


% change back to oldFolder
cd(oldFolder)

time=dtSpikes*(1:size(ANoutput,2));
duration=max(time);
max_anf=max(anf_num); % # of fibers per BF per type
N_BF=length(BFlist);
type = {'hsr','msr','lsr'};
ANtrains = cell(size(ANoutput,1)+1,5);
ANtrains(1,:)={'index','duration','type','cf','spikes'};
ANtrains(2:end,2)={duration};
count=1;
for i=1:3
    for n=1:anf_num(i)
        for j=1:N_BF
            k=(j-1)*max_anf+n+(i-1)*N_BF*max_anf;
            ANtrains{count+1,1} = count-1;
            ANtrains(count+1,3) = type(i);
            ANtrains{count+1,4} = BFlist(j);
            ANtrains{count+1,5} = time(ANoutput(k,:)); % convert psth to spike times
            count=count+1;
        end
    end
end


% All done. Now sweep the path! 
path(restorePath)


end

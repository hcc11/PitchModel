function [ i, s ] = get_an_spikes( sound, fs, cf, params, fibertype, basepath )

if nargin < 6
    basepath = '..';
end

type = 'spikes';
dt = 1/fs;

switch fibertype
    case 'HSR'
        tauCa = 'IHCpreSynapseParams.tauCa=[200e-6];';
    case 'MSR'
        tauCa = 'IHCpreSynapseParams.tauCa=[45e-6];';
    case 'LSR'
        tauCa = 'IHCpreSynapseParams.tauCa=[25e-6];';
end

param_changes = {
    'AN_IHCsynapseParams.numFibers=1;',
    tauCa
    };
param_changes=[];
restore_path = path;
addpath ([basepath filesep 'MAP'], [basepath filesep 'utilities'], ...
         [basepath filesep 'parameterStore'])
MAP1_14(sound, fs, cf, params, type, param_changes);
global ANoutput;
global dtSpikes;
[k, j] = find(ANoutput); % (channel, time in dtSpikes)
s = dtSpikes*j;
i = k;
path(restore_path);

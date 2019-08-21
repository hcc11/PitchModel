function IHC_cilia_RPParams=IHC_ELP
% [V, method, info, boundaryValue] = IHC_VResp_Vivo (u, method, params)
%
% Implementation IHC receptor potential model for in-vivo experiments.
% References:
% Lopez-Poveda,E., Eustaquio-Martin,A.(2006) A biophysical model of the inner hair cell: the contribution of potassium
% currents to peripherical auditory compression. JARO 
%
% Input arguments:
%   u:      Input signal matrix (number of channels x number of data points). It is assumed to be cilia displacement
%   method: structure containing general information needed
%            .dt: sample time
%   params: Structure containaing the model parameters.
%           Et: Endococlear potential [V]
%           Rp: Epithelium resistance
%           Rt: Epithelium resistance
%           Gl: Apical leakege conductance
%           gmax: apical conductance with all channels fully open (used to determine the apical mechanical conductance) 
%           s0: displacement sensitivity (1/m) (used to determine the apical mechanical conductance) 
%           s1: displacement sensitivity (1/m) (used to determine the apical mechanical conductance) 
%           u0: displacement offset (m) (used to determine the apical mechanical conductance) 
%           u1: displacement offset (m) (used to determine the apical mechanical conductance) 
%           Ca: Apical hair cell membrane capacitance (it must be >=0)
%           Cb: Basolateral hair cell membrane capacitance (it must be >=0)
%           Ekf: Revelsal potential of the fast potassium current [V]
%           Gf: Maximum conductance of fast channel (it must be >=0)
%           Vf: Half-activation setpoint of fast channel
%           Sf: Voltage sensitivity constant of fast channel
%           V2f: Half-activation setpoint of fast channel
%           S2f: Voltage sensitivity constant of fast channel
%           Tf1max: Time constant associated with fast channel
%           aTf1: Time constant associated with fast channel
%           bTf1: Time constant associated with fast channel
%           Tf1min: Time constant associated with fast channel
%           Tf2max: Time constant associated with fast channel
%           aTf2: Time constant associated with fast channel
%           bTf2: Time constant associated with fast channel
%           Tf2min: Time constant associated with fast channel
%           Eks: Revelsal potential of the slow potassium current [V]
%           Gs: Maximum conductance of slow channel (it must be >=0)
%           Vs: Half-activation setpoint of slow channel
%           Ss: Voltage sensitivity constant of slow channel
%           V2s: Half-activation setpoint of slow channel
%           S2s: Voltage sensitivity constant of slow channel
%           Ts1max: Time constant associated with slow channel
%           aTs1: Time constant associated with slow channel
%           bTs1: Time constant associated with slow channel
%           Ts1min: Time constant associated with slow channel
%           Ts2max: Time constant associated with slow channel
%           aTs2: Time constant associated with slow channel
%           bTs2: Time constant associated with slow channel
%           Ts2min: Time constant associated with slow channel
%

IHC_cilia_RPParams=[];
% viscous coupling not discussed in ELP & AEM (2006)
IHC_cilia_RPParams.tc =0.00012; % viscous coupling
IHC_cilia_RPParams.C=	.1; % scalar

% IHC mechanical conductance parameters
IHC_cilia_RPParams.Gl = 0.33e-9;              % Apical leakege conductance
IHC_cilia_RPParams.gmax=9.45e-9;              % Apical conductance with all channels fully open (to determine the apical mechanical conductance) [S]
IHC_cilia_RPParams.s0=[63.1 12.7].*1e-9;      % Displacement sensitivity (1/m)
IHC_cilia_RPParams.u0=[52.7 29.4].*1e-9;      % Displacement offset (m)

IHC_cilia_RPParams.Et=100e-3;       		    % Endococlear potential [V] (Kros and Crawford value)
% IHC_cilia_RPParams.Et=60e-3;       		    % *Endococlear potential [V] (Kros and Crawford value)

IHC_cilia_RPParams.Ekf=-78e-3;				% Reversal potential [V]
IHC_cilia_RPParams.Eks=-75e-3;				% Reversal potential [V]
% IHC_cilia_RPParams.Ekf=-70e-3;				% *Reversal potential [V]
% IHC_cilia_RPParams.Eks=-70e-3;				% *Reversal potential [V]

IHC_cilia_RPParams.Gf=30.7262*1e-9;		    % Maximum conductance of fast channel
IHC_cilia_RPParams.Vf=-43.2029*1e-3;          % Half-activation setpoint of fast channel
IHC_cilia_RPParams.Sf=11.9939*1e-3;		   	% Voltage sensitivity constant of fast channel
IHC_cilia_RPParams.V2f=-64.4*1e-3;            % Half-activation setpoint of fast channel
IHC_cilia_RPParams.S2f=9.6*1e-3;		   	    % Voltage sensitivity constant of fast channel

IHC_cilia_RPParams.Gs=28.7102*1e-9;           % Maximum conductance of slow channel
IHC_cilia_RPParams.Vs=-52.2228*1e-3;          % Half-activation setpoint of slow channel
IHC_cilia_RPParams.Ss=12.6626*1e-3;		    % Voltage sensitivity constant of slow channel
IHC_cilia_RPParams.V2s=-85.2228*1e-3;         % Half-activation setpoint of slow channel
IHC_cilia_RPParams.S2s=16.9*1e-3;             % Voltage sensitivity constant of slow channel

IHC_cilia_RPParams.Ca=0.895e-12;              % Apical capacitance
IHC_cilia_RPParams.Cb=8e-12;                  % Basal capacitance
IHC_cilia_RPParams.Cab=IHC_cilia_RPParams.Ca+IHC_cilia_RPParams.Cb;

IHC_cilia_RPParams.Rp=0.01;                   % Shamma epithelium resistance
IHC_cilia_RPParams.Rt=0.24;                   % Shamma epithelium resistance
% IHC_cilia_RPParams.Rt=0.5;                   % *Shamma epithelium resistance

% Time constants
IHC_cilia_RPParams.Tf1max=0.33*1e-3;
IHC_cilia_RPParams.aTf1=31.25*1e-3;
IHC_cilia_RPParams.bTf1=5.42*1e-3;
IHC_cilia_RPParams.Tf1min=0.10*1e-3;
IHC_cilia_RPParams.Tf2max=0.10e-3;
IHC_cilia_RPParams.aTf2=1e-3;
IHC_cilia_RPParams.bTf2=1e-3;
IHC_cilia_RPParams.Tf2min=0.09e-3;
IHC_cilia_RPParams.Ts1max=9.90e-3;
IHC_cilia_RPParams.aTs1=15.27e-3;
IHC_cilia_RPParams.bTs1=7.27e-3;
IHC_cilia_RPParams.Ts1min=1.30e-3;
IHC_cilia_RPParams.Ts2max=4.27e-3;
IHC_cilia_RPParams.aTs2=48.20e-3;
IHC_cilia_RPParams.bTs2=8.72e-3;
IHC_cilia_RPParams.Ts2min=0.01e-3;


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
%   V:       Out signal matrix (number of channels x number of data points). It is assumed to be IHC receptor potential [V]
%   method   structure containing general information needed
%            .dt: sample time
%   info    structure containing general extra information useful for the user.
%           .Vtm:    IHC membrane potential, matrix (number of channels x number of data points).
%           .Vr:     IHC membrane potential at resting.
%
% Comments:
%
% Comments:
%
% (c) Almudena Eustaquio
%     Universidad de Salamanca 2006
% ------------------------------------------------------------

function [V, method, info, boundaryValue] = IHC_VResp_Vivo (u, method, params)
                
dt=method.dt;   					%Sampling period [s]     
f = 1;							    %Frequency [Hz]                         

if nargin==2
    % IHC mechanical conductance parameters
    params.Gl = 0.33e-9;                % Apical leakege conductance
    params.gmax=9.45e-9;                % Apical conductance with all channels fully open (to determine the apical mechanical conductance) [S]
    params.s0=[63.1 12.7].*1e-9;        % Displacement sensitivity (1/m)
    params.u0=[52.7 29.4].*1e-9;        % Displacement offset (m)
    
    params.Et=100e-3;       		    % Endococlear potential [V] (Kros and Crawford value)
    params.Ekf=-78e-3;				    % Revelsal potential [V]
    params.Eks=-75e-3;				    % Revelsal potential [V]
    params.Gf=30.7262*1e-9;		        % Maximum conductance of fast channel
    params.Vf=-43.2029*1e-3;            % Half-activation setpoint of fast channel
    params.Sf=11.9939*1e-3;		   	    % Voltage sensitivity constant of fast channel
    params.V2f=-64.4*1e-3;              % Half-activation setpoint of fast channel
    params.S2f=9.6*1e-3;		   	    % Voltage sensitivity constant of fast channel
    params.Gs=28.7102*1e-9;             % Maximum conductance of slow channel
    params.Vs=-52.2228*1e-3;            % Half-activation setpoint of slow channel
    params.Ss=12.6626*1e-3;		        % Voltage sensitivity constant of slow channel
    params.V2s=-85.2228*1e-3;           % Half-activation setpoint of slow channel
    params.S2s=16.9*1e-3;		        % Voltage sensitivity constant of slow channel
    params.Ca=0.895e-12;	            % Apical capacitante
    params.Cb=8e-12;                    % Basal conductance
    params.Rp=0.01;                     % Shamma epithelium resistance
    params.Rt=0.24;                     % Shamma epithelium resistance
    
    % Time constants
    params.Tf1max=0.33*1e-3;
    params.aTf1=31.25*1e-3;
    params.bTf1=5.42*1e-3;
    params.Tf1min=0.10*1e-3;
    params.Tf2max=0.10e-3;
    params.aTf2=1e-3;
    params.bTf2=1e-3;
    params.Tf2min=0.09e-3;
    params.Ts1max=9.90e-3;
    params.aTs1=15.27e-3;
    params.bTs1=7.27e-3;
    params.Ts1min=1.30e-3;
    params.Ts2max=4.27e-3;
    params.aTs2=48.20e-3;
    params.bTs2=8.72e-3;
    params.Ts2min=0.01e-3;
end
params.Cab=params.Ca+params.Cb;

%Checking input paramemters
if params.Gf < 0
    error('ERROR >> input parameters: Maximum conductance of fast channel (Gf) must be >=0')
end
if params.Gs < 0
    error('ERROR >> input parameters: Maximum conductance of slow channel (Gs) must be >=0')
end
if params.Ca < 0
    error('ERROR >> input parameters: Apical capacitance (Ca) must be >=0')
end
if params.Cb < 0
    error('ERROR >> input parameters: Basal capacitance (Cb) must be >=0')
end
if params.Gl < 0
    error('ERROR >> input parameters: Apical leakage conductance (Gl) must be >=0')
end
if params.Tf1max < 0
    error('ERROR >> input parameters: Time constant associated with fast channel (Tf1max) must be >=0')
end
if params.Tf1min < 0
    error('ERROR >> input parameters: Time constant associated with fast channel (Tf1min) must be >=0')
end
if params.Tf1min > params.Tf1max
    error('ERROR >> input parameters: Time constant associated with fast channel Tf1max must be >=Tf1min')
end
if params.Tf2max < 0
    error('ERROR >> input parameters: Time constant associated with fast channel (Tf2max) must be >=0')
end
if params.Tf2min < 0
    error('ERROR >> input parameters: Time constant associated with fast channel (Tf2min) must be >=0')
end
if params.Tf2min > params.Tf2max
    error('ERROR >> input parameters: Time constant associated with fast channel Tf2max must be >=Tf2min')
end
if params.Tf2max > params.Tf1max
    error('ERROR >> input parameters: Time constant associated with fast channel Tf1max must be >=Tf2max')
end
if params.Tf2min > params.Tf1min
    error('ERROR >> input parameters: Time constant associated with fast channel Tf1min must be >=Tf2min')
end

if params.Ts1max < 0
    error('ERROR >> input parameters: Time constant associated with slow channel (Ts1max) must be >=0')
end
if params.Ts1min < 0
    error('ERROR >> input parameters: Time constant associated with slow channel (Ts1min) must be >=0')
end
if params.Ts1min > params.Ts1max
    error('ERROR >> input parameters: Time constant associated with slow channel Ts1max must be >=Ts1min')
end
if params.Ts2max < 0
    error('ERROR >> input parameters: Time constant associated with slow channel (Ts2max) must be >=0')
end
if params.Ts2min < 0
    error('ERROR >> input parameters: Time constant associated with slow channel (Ts2min) must be >=0')
end
if params.Ts2min > params.Ts2max
    error('ERROR >> input parameters: Time constant associated with slow channel Ts2max must be >=Ts2min')
end
if params.Ts2max > params.Ts1max
    error('ERROR >> input parameters: Time constant associated with slow channel Ts1max must be >=Ts2max')
end
if params.Ts2min > params.Ts1min
    error('ERROR >> input parameters: Time constant associated with slow channel Ts1min must be >=Ts2min')
end
%End cheking input paramenters

%Initialitation
Gmu = zeros(size(u));
Gu = zeros(size(u));
V = zeros(size(u));
GkfastVN = zeros(size(u));
GkslowVN = zeros(size(u));
GkfastVTN = zeros(size(u));
GkslowVTN = zeros(size(u));
GkfastVT = zeros(size(u));
GkslowVT = zeros(size(u));
Vtm= zeros(size(u));

%Apical mechanical conductance
Gmu = cilia2apicalgm (u, params.gmax, params.s0, params.u0);
method.IHC_ciliaData=Gmu;
%Leakage apical conductance
Gmu0 = cilia2apicalgm (0, params.gmax, params.s0, params.u0);
method.IHC_ciliaDataGmu0=Gmu0;

%Apical conductance
params.Gu0 = Gmu0 + params.Gl;
Gu=Gmu+params.Gl;

if method.segmentNumber==1
    % Determines Vresting
    % The resting potential is the value of Vr 
    %  (intracelular resting potential) that makes CalcVrestingVivo = 0
    % CalcVrestingVivo is minimized with fminsearch of Mathlab.
    boundaryValue=cell(5,1); % V, GkfastVN, GkslowVN, GkfastVTN, GkslowVTN
    Vr0 = -60e-3; % start value for search
    [Vr,fval,exitflag] = fminsearch(@CalcVrestingVivo, Vr0, optimset('TolX',1e-8), params);
    if exitflag <= 0
        error('ERROR >> input parameters: Can´t determine the resting potential')
    end    
    %V0=V(t=0) Initial IHC intracelular voltaje [V]
    V(:,1)=Vr;
else % restore values from previous segment
    Vr=method.restingV;
    V(:,1)=params.boundaryValue{1};
end

Et = params.Et;
Voc=(params.Rp/(params.Rt+params.Rp))*Et;  %Constant ->Shamma aproximation
Ekfastp=params.Ekf+Voc;
Ekslowp=params.Eks+Voc;

Ts=dt; %sampling period
Tf1max=params.Tf1max;
Tf2max=params.Tf2max;
Ts1max=params.Ts1max;
Ts2max=params.Ts2max;
Tf1min=params.Tf1min;
Tf2min=params.Tf2min;
Ts1min=params.Ts1min;
Ts2min=params.Ts2min;
aTf1=params.aTf1;
aTf2=params.aTf2;
aTs1=params.aTs1;
aTs2=params.aTs2;
bTf1=params.bTf1;
bTf2=params.bTf2;
bTs1=params.bTs1;
bTs2=params.bTs2;

for k=1:(length(u)-1)
    Vtm(:,k) = V(:,k) - Voc;
    
    %FAST and SLOW time constants
    Tf1=Tf1min+(Tf1max-Tf1min)./(1+exp((aTf1+Vtm(:,k))/bTf1));
    Tf2=Tf2min+(Tf2max-Tf2min)./(1+exp((aTf2+Vtm(:,k))/bTf2));
    Ts1=Ts1min+(Ts1max-Ts1min)./(1+exp((aTs1+Vtm(:,k))/bTs1));
    Ts2=Ts2min+(Ts2max-Ts2min)./(1+exp((aTs2+Vtm(:,k))/bTs2));
    
    %Checks time constans
    if Tf1<Tf2
        warning ('WARNING >> FAST: time constant 1 < time constant 2');
    end
    if Ts1<Ts2
        warning ('WARNING >> SLOW: time constant 1 < time constant 2');
    end
    
    % Filter coeficients to determine Gk=Gk(Vtm) as a second order Boltzmann function
    Mf1=dt./Tf1;
    Mf2=dt./Tf2;
    Af=2+Mf1+Mf2;
    Bf=Mf1.*Mf2;
    Cf=1+Mf1+Mf2+Mf1.*Mf2;
    Ms1=dt./Ts1;
    Ms2=dt./Ts2;
    As=2+Ms1+Ms2;
    Bs=Ms1.*Ms2;
    Cs=1+Ms1+Ms2+Ms1.*Ms2;
    
    %Dependence of Gk with Vtm: Gk=Gk(Vtm), second order Boltzmann
    GkfastVN(:,k) = 1./(1+exp((params.Vf-Vtm(:,k))/params.Sf) .* (1+ exp((params.V2f-Vtm(:,k))/params.S2f)));  %Voltaje dependence of Gkfast normalized to Gfmax=params.Gf
    GkslowVN(:,k) = 1./(1+exp((params.Vs-Vtm(:,k))/params.Ss) .* (1+ exp((params.V2s-Vtm(:,k))/params.S2s)));  %Voltaje dependence of Gkslow normalized to Gsmax=params.Gs
    
    if k<3
        if method.segmentNumber==1
            %The firts element of Gkfast and Gkslow is not filter
            GkfastVTN(:,k) = GkfastVN(:,k);
            GkslowVTN(:,k) = GkslowVN(:,k);
        else
            x=params.boundaryValue{2}; % previously [GkfastVN(:,k-1) GkfastVN(:,k)]
            GkfastVN(:,1) = x(:,1);
            GkfastVN(:,2) = x(:,2);
            x=params.boundaryValue{3}; % previously [GkslowVN(:,k-1) GkslowVN(:,k)]
            GkslowVN(:,1) = x(:,1);
            GkslowVN(:,2) = x(:,2);
            x=params.boundaryValue{4}; % previously [GkfastVTN(:,k-1) GkfastVTN(:,k)]
            GkfastVTN(:,1) = x(:,1);
            GkfastVTN(:,2) = x(:,2);
            x=params.boundaryValue{5}; % previously [GkslowVTN(:,k-1) GkslowVTN(:,k)]
            GkslowVTN(:,1) = x(:,1);
            GkslowVTN(:,2) = x(:,2);
        end
    else
        GkfastVTN(:,k) = (Af .* GkfastVTN(:,k-1) - GkfastVTN(:,k-2) + GkfastVN(:,k) .* Bf) ./ Cf;  %Voltaje and time dependence of Gkfast normalized to Gfmax=params.Gf
        GkslowVTN(:,k) = (As .* GkslowVTN(:,k-1) - GkslowVTN(:,k-2) + GkslowVN(:,k) .* Bs) ./ Cs;  %Voltaje and time dependence of Gkslow normalized to Gsmax=params.Gs
    end
    GkfastVT(:,k) = params.Gf .* GkfastVTN(:,k);
    GkslowVT(:,k) = params.Gs .* GkslowVTN(:,k);
    % Intracelular potential
    V(:,k+1)=(Et.*Gu(:,k)+Ekfastp.*GkfastVT(:,k)+Ekslowp.*GkslowVT(:,k)...
        +params.Cab/dt.*V(:,k))./(Gu(:,k)+params.Cab/dt+GkfastVT(:,k)+GkslowVT(:,k));
end %for k=2:length(i)
Vtm(:,k+1)=Vtm(:,k);
info.Vtm = Vtm;
info.Vr = Vr;

method.restingV=Vr;
method.IHC_VResp_Vivodt=dt;
boundaryValue{1}= V(:,k+1);
boundaryValue{2}=[GkfastVN(:,k-1) GkfastVN(:,k)];
boundaryValue{3}=[GkslowVN(:,k-1) GkslowVN(:,k)];
boundaryValue{4}=[GkfastVTN(:,k-1) GkfastVTN(:,k)];
boundaryValue{5}=[GkslowVTN(:,k-1) GkslowVTN(:,k)];

function f = CalcVrestingVivo(x, params)
q=params.Rp/(params.Rp+params.Rt);
Voc=q*params.Et;
Gkfast0 = params.Gf/(1+exp((params.Vf+Voc-x)/params.Sf)*(1+ exp((params.V2f+Voc-x)/params.S2f)));
Gkslow0 = params.Gs/(1+exp((params.Vs+Voc-x)/params.Ss)*(1+ exp((params.V2s+Voc-x)/params.S2s)));
f=(params.Gu0 - ((params.Ekf+Voc-x)* Gkfast0 + (params.Eks+Voc-x)* Gkslow0)/(x-params.Et) )^2;

% [Gmu] = cilia2apicalgm (u, order, gmax, s0, u0)
% Calculates the inner hair cell apical mechanical conductance (Gmu) as a
% function of cilia displacement (u) using either a first or a second order
% Boltzman function.
%
% Input arguments
%   u       Cilia displacement (m).
%   gmax    Max. mechanical conductance (S) (conductance with all channels fully open)
%   s0      Displacement sensitivity (1/m).
%   u0      Displacement offset (m)
%
%   Comments:
%           Length s0 and length u0 must be 1 or 2
%           If 1, then a first-order Boltzmann function is used as in Shamma et al. (1986). 
%           To match Shamma, make:   s0 = 1/gamma
%                                    u0 = log(beta)/gamma
%           If 2, then a second-order Boltzmann function is used as in Sumner et al. (2002).
%
% Output arguments
%   Gmu      Apical mechanical membrane conductance
%
% References
%   Shamma, S.A., Chadwich, R.S., Wilbur, W.J., Morrish, K.A. and Rinzel, J. (1986). 
%   "A biophysical model of cochlear processing: intensity dependence of pure tone responses"
%   J. Acooust. Soc. Am. 80 (1), 133-145.
%   Sumner, C.J., Lopez-Poveda, E.A., O'Mard, L.P., Meddis, R. (2002)
%   A revised model of the inner-hair cell and auditory-nerve complex
%   J. Acooust. Soc. Am. 111 (5), 2178-2188.

% (c) Almudena Eustaquio
%     Universidad de Salamanca 2006
% ------------------------------------------------------------

function [Gmu] = cilia2apicalgm (u, gmax, s0, u0)

% Checking input arguments
if gmax < 0
    error ('Checking input arguments: max. mechanical conductance must be >= 0');
end

% Start process.
Gmu = zeros(size(u));
if length(s0)==1 & length(u0)==1
    Gmu=gmax/(1+exp(-(u-u0)/s0));
elseif length(s0)==2 & length(u0)==2
    Gmu=gmax./(1+exp(-(u-u0(1))/s0(1)).*(1+exp(-(u-u0(2))/s0(2))));
else
    error('Input parameters: length(u0) must be equal length(s0) and must be 1 or 2');
end

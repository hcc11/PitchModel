function dy=RM03_full_gsyn(t,y,gsyn)
% full model by Rothman and Manis(2003)
% gsyn: function of t, 

V=y(1,:)*100;m=y(2,:);h=y(3,:);n=y(4,:);
p=y(5,:);w=y(6,:);z=y(7,:);r=y(8,:);

% Parameter Values
Cm   = 12.;   % Membrane capacitance (pF)
gNa  = 1000.; % maximal Na conductance (nS)
gKHT = 150.;  % maximal KHT conductance (nS)
gKLT = 200.;  % maximal KLT conductance (nS)
gh   = 20.;   % maximal h conductance (nS)
glk  = 2.;    % maximal leak conductance (nS)
ENa  =  55.;  % Na reversal potential (mV)
EK   = -70.;  % K reversal potential (mV)
Eh   = -43.;  % h reversal potential (mV)
Elk  = -65.;  % leak reversal potential (mV)
CondAdjust = 2.; % Adjustments for temperature, as in Gai et al
TauAdjust  = 0.33; % Adjustments for temperature, as in Gai et al
VsynE=0; %mv


% Currents
INa  = gNa * m.^3 .* h .* (V - ENa);
IKHT = gKHT * (0.85*n.^2. + 0.15.*p).* (V - EK);
IKLT = gKLT * w.^4 .* z .* (V - EK);
Ih   = gh .* r .* (V - Eh);
Ilk  = glk .* (V - Elk);

Isyn=gsyn(t)*(V-VsynE);


% Update V using Current Balance Equation
% Note factor of 2 for temperature scaling
dV = ( -Isyn - CondAdjust*(INa + IKHT + IKLT + Ih + Ilk )) / Cm /100;


dm=((1. + exp(-(V+38.)/7.)).^-1.-m)./(10./ (5.*exp((V+60)/18.) + 36.*exp(-(V+60.)/25.)) + 0.04)/TauAdjust;
dh=((1. + exp((V+65.)/6.)).^-1. - h) ./(100./ (7.*exp((V+60)/11.) + 10.*exp(-(V+60.)/25.)) + 0.6)/TauAdjust;
dn=((1.+exp(-(V+15.)/5.)).^(-0.5) - n)./(100./ (11.*exp((V+60)/24.) + 21.*exp(-(V+60.)/23.)) + 0.7)/TauAdjust;
dp=((1.+exp(-(V+23.)/6.)).^-1.-p)./(100./ (4.*exp((V+60)/32.) + 5.*exp(-(V+60.)/22.)) + 5.)/TauAdjust;
dw=((1. + exp(-(V+48.)/6.) ).^-0.25 - w)./(100./ (6.*exp((V+60.)/6.) + 16.*exp(-(V+60.)/45.)) + 1.5)/TauAdjust;
dz=((1.-0.5) ./ (1.+exp((V+71.)/10.)) + 0.5 -z)./(1000./ (exp((V+60.)/20.) + exp(-(V+60.)/8.)) + 50.)/TauAdjust;
dr=(((1. + exp((V+76.)/7.)).^-1. - r)./(10.^5./ (237.*exp((V+60)/12.) + 17.*exp(-(V+60.)/14.)) + 25.))/TauAdjust;

dy=[dV;dm;dh;dn;dp;dw;dz;dr];

end
function dy=RM03_2_gsyn(t,y,gsyn,dt)
% a reduced two-variable model of Rothman and Manis(2003) 
% gsyn: a vector of same length as T (equally spaced)
% t in sec

V=y(1);U=y(2);

% load('param_RM03.mat')
% cellfun(@(n,v) assignin('caller',n,v),fieldnames(param_RM03),struct2cell(param_RM03));

% set parameter values
E_K = -70  ;
E_Na = 55  ;
E_h = -43  ;
E_lk = -65 ;
a = 0.9000 ;
b = 0.8742 ;
cm = 12    ;
g_Na = 1000 ;
g_h = 20    ;
g_kht = 150 ;
g_klt = 200 ;
g_lk = 2    ; 
h0 = 0.4450 ;
n0 = 0.0077 ;
p0 = 0.0011 ;
r0 = 0.1470 ;
w0 = 0.5110 ;
z0 = 0.6620 ;

       
h_inf= 1/(1+exp((V+65)/6));
w_inf=(1+exp(-(V+48)/6))^(-1/4);
U_inf= b*(h_inf+b*(a-w_inf))./(a*(1+b^2));
m_inf= 1/(1+exp(-(V+38)/7));
tau_w=100/(6*exp((V+60)/6)+16*exp(-(V+60)/45))+1.5;
tau_h=100/(7*exp((V+60)/11)+10*exp(-(V+60)/25))+0.6;
tau_u=min([tau_w tau_h])*0.33;

VsynE=0; % mv
if t<=dt
    Isyn=gsyn(1) * (V-VsynE);
else
pos=t/dt;ind=floor(pos);mu=(pos-ind);
Isyn=((1-mu)*gsyn(ind)+mu*gsyn(ind+1)) * (V-VsynE);
end

dy=[0;0];
dy(1)=(2/cm*(-g_Na*(m_inf)^3*(a/b)*U*(V-E_Na)-g_klt*a^4*(1-U).^4*z0.*(V-E_K)...
    -g_kht*(0.85*n0^2+0.15*p0).*(V-E_K)-g_lk*(V-E_lk)-g_h*r0*(V-E_h))-Isyn/cm) * 1000;
dy(2)=(U_inf-U)/tau_u * 1000;


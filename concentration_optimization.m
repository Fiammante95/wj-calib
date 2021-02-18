% syms g_aniso(phi)
% syms eta(phi)
% syms dp(phi)
% syms rho_s(phi)
% syms 

syms ma

p_s = 300000; %Pa
rho_a = 4100; %kg/m3
rho_c = 1010; %kg/m3
g = 9.81;
h_s = 0.05; %m
p_mc = 100000; %Pa
xi = 3;
ds = 0.003; %m
n = 0.3;
eta0 = 2.6; %Pa.s^n
phi_div = 0.605;
L = 2;
ra = 0.3;

phi_arr = 0.01:0.01:0.6;

for i=1:length(phi_arr)
    
    phi = phi_arr(i);
    eqn = p_s + (rho_a.*phi+rho_c.*(1-phi)).*g.*h_s == p_mc + (8.*xi.*ma.^2.*(rho_a.*phi+rho_c.*(1-phi)))./(rho_a.^2.*phi.^2.*pi.^2.*ds.^4)+(8.*ma.*(1+3.*n)./(rho_a.*phi.*n.*pi.*ds.^3)).^n.*4.*L./ds.*(eta0.*sqrt((1-phi./phi_div).^(-2.5.*(n+1).*phi_div).*(1-phi).^(1-n)));
    S(i) = vpasolve(eqn,ma,[0 100]);
end

for i=1:length(phi_arr)
    
    phi = phi_arr(i);
    wa = (1+rho_c*(1-phi)/rho_a/phi)^(-1);
    rr(i) = (1+ra)/(1+ra/wa);
end

S_arr = eval(S);
plot(phi_arr,rr)
hold on
plot(phi_arr,S_arr./max(S_arr))
plot(phi_arr,S_arr./max(S_arr).*rr)

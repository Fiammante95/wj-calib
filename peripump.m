syms l(r_roll,r_i);
syms X(r_roll,r_i);
syms A_roll(r_roll,r_i);
syms A_cyl(r_roll,r_i);
syms V_roll(r_i,r_roll);
syms V_cyl(r_i,r_roll);
syms Q_nom(r_i,r_m);
syms Q_roll(r_i,r_roll);
syms V_section(r_roll,r_i,r_m,NU);
syms Q_avg(r_roll,r_i,r_m,NU);
syms V_rot(r_roll,r_i,r_m,NU);

% %dude's thesis
% N = 54; %rpm
% omega = N*2*pi/60; %rad/s
% NU = 3;
% k = 1.87; %unidentified correction coefficient
% rroll = 20; %mm
% rm = 40; %mm
% ri = 4.765; %linspace(0.0001,2.5,100); %mm

%my thesis
N = 10; %rpm
omega = N*2*pi/60; %rad/s
rroll = linspace(3,15,100); %mm
rm = 20; %mm
ri = 1.5; %mm
nu = 6;


l(r_roll,r_i) = acos((r_roll-2*r_i)/r_roll);
X(r_roll,r_i) = r_roll*sin(l);
A_roll(r_roll,r_i) = l/2*r_roll^2-0.5*X*(r_roll-2*r_i);
A_cyl(r_roll,r_i) = X*2*r_i;
V_roll(r_roll,r_i) = A_roll/A_cyl*pi*r_i^2*2*X;
V_cyl(r_roll,r_i) = pi*r_i^2*2*X;

Q_nom(r_m,r_i) = pi*r_m*r_i^2*omega;
Q_roll(r_roll,r_i) = V_roll/2/pi*omega;
V_section(r_roll,r_i,r_m,NU) = pi*r_i^2*(2*pi/NU*r_m)-V_roll;
V_rot(r_roll,r_i,r_m,NU) = V_section*NU;
Q_avg(r_roll,r_i,r_m,NU)= V_rot*N/60;

%eval(V_roll(rroll,ri))*0.001
%eval(Q_nom(rm,ri))*0.001
%eval(Q_roll(rroll,ri)/A_cyl(rroll,ri))

%eval(Q_roll(rroll,ri))/1000
eval(Q_avg(rroll,ri,rm,nu))/1000

nu = 3;
plot(ri./rroll,(1-Q_avg(rroll,ri,rm,nu)./Q_nom(rm,ri)))
hold on
nu = 6;
plot(ri./rroll,(1-Q_avg(rroll,ri,rm,nu)./Q_nom(rm,ri)))
nu = 10;
plot(ri./rroll,(1-Q_avg(rroll,ri,rm,nu)./Q_nom(rm,ri)))

legend("n# rollers = 3","n# rollers = 6","n# rollers = 10")


%plot(ri/rroll,Q_nom(rm,ri)./Q_avg(rroll,ri,rm))

%plot(ri/rroll,Q_roll(rroll,ri)./(Q_nom(rm,ri)-Q_roll(rroll,ri)))


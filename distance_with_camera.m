%Calibration
clear all
close all

calib = menu("Use old calibration?","No","Yes");

if calib == 1
input = inputdlg("What is the reference length?");
L0 = str2double(input{1});

input = inputdlg("What is the two-shot distance?");
delta_m0 = str2double(input{1});

[n,p]=uigetfile('*.*','Select near calibration picture');

imshow(strcat(p,n));
h = imdistline;
pause
%uiwait(msgbox('select the distance on the picture and press OK when finished','modal'));
p01 = getDistance(h);
close


[n,p]=uigetfile('*.*','Select far calibration picture');
imshow(strcat(p,n));

h = imdistline;
pause
p02 = getDistance(h);
close

Xi = L0*(1/p02-1/p01)/delta_m0;

clear h input n p calib

save("cameraCalib");

end

%L0 = 80; %mm
%p01 = 280;
%p02 = 200;

% measurement
% [n,p]=uigetfile('*.*','Select measurement picture');
% imtool(strcat(p,n));
% 
% p1 = 359;
% p2 = 345;
% 
% L = Xi*delta_m*p1*p2/(p1-p2)

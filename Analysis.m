clear all
close all
clc

%% (0)
if 1
    
    [fileName,Path]=uigetfile('D:\Documents\GitHub\arduino-labview-voltage-display\Labview\*.txt','Choose a raw data file');
    raw = readtable(strcat(Path,fileName));
    Dati = raw.TimeSeries';
    
    %cure the data
    zeropos=Dati==0;
    Dati(zeropos) = (Dati(find(zeropos)-2)+Dati(find(zeropos)+2))/2;
    
    figure
    plot(Dati);
    hold on
    uiwait(msgbox('Select an initial and final point','modal'));
    
    choice = 0;
    while choice ~= 2
    [x0, ~] = ginput(1); % Let the user select an x-value from which to crop.
    startplot = plot([x0 x0],[min(Dati) max(Dati)],'k--');
    [x1, ~] = ginput(1); % Let the user select an x-value from which to crop.
    endplot = plot([x1 x1],[min(Dati) max(Dati)],'k--');
    
    choice = menu("confirm selection [Y] or try again [N]","No","Yes");
    
    set(startplot,'Visible','off')
    set(endplot,'Visible','off')
    end
        
    Dati = Dati(floor(x0):ceil(x1));
    
    if exist('fsamp','var') == 0
        input = inputdlg("What is the sampling frequency? please enter an integer value");
        fsamp = str2double(input{1});
    end
else
    
    % Load the data
    [fileName,Path]=uigetfile('*.mat','Choose a file');
    load([Path fileName]);

    
end
% working conditions

% all the "forced2" series were either 50 or 300 steps

%step_rate = 200; %step/s
%steps_per_rev = 200; %step/2pi
rpm = 100; %2pi/min
nrollers = 10; % 1/2pi

fpuls = rpm*nrollers/60*2*pi; %1/s


%% (1)

% Time History plot
%y=conv(Dati-mean(Dati),hanning(5),"same");
%y=Dati-mean(Dati);
y = Dati;
dt=1/fsamp;
N=length(y);
T = N/fsamp;
df = 1/T;
t=[0:1:(N-1)]*dt;

figure
plot(t,y)
xlabel('time[s]')
ylabel('amplitude')
grid
set(gca, 'fontsize', 16)
ylim([min(y) max(y)]);
xlim([t(1) t(end)]);

pause

%% (2) Plot of the spectrum, power spectrum and PSD of the whole signal

% Windowing
window=hanning(N)';
Datah=Dati.*window;

% DFT
[A, frequency]=fft_norm(Datah,fsamp);
A_star=conj(A);

% Plot the spectrum
figure
stem(frequency,abs(A))
hold on
plot([fpuls fpuls],[min(abs(A)) max(abs(A))],'--k')
%set(gca,'Yscale','log')
ylabel('Modulus')
xlabel('[Hz]')
legend('Rectangular')
set(gca, 'fontsize', 16)
xlim([0.5 frequency(end)]);
ylim([0 mean(abs(A))])

pause

% Power Spectrum
SAA=A_star.*A;
SAA(2:end)=SAA(2:end)./2;

% PSD
PSD=SAA./df;

% Plot
figure
semilogy(frequency,abs(A),'b')
hold on
semilogy(frequency,SAA,'r')
semilogy(frequency,PSD,'m')
set(gca,'fontsize',14)
grid on
legend('Spectrum ampl.','Power spectrum','PSD')
title('Whole data set')
xlabel('Frequency [Hz]')
xlim([0.5 10]);

pause

%% (3) Methods for the averaging process

%%% Case resolution 0.1 Hz
ris=0.1;
T=1./ris;
n_point=T.*fsamp;

% Cut the original time-history in sub-time-histories
for kk=1:floor(length(Dati)/n_point)
    % DFT + Windowing
    [sp frequency1]=fft_norm(Dati(n_point*(kk-1)+1:kk*n_point).*(hanning(n_point)'),fsamp);
    % Power spectrum
    SAA_kk=conj(sp).*sp;
    SAA_kk(2:end)=SAA_kk(2:end)./2;
    % Store the data of the k-th sub-time-history
    SP_MAT_ris1(:,kk)=sp;   
    SAA_MAT_ris1(:,kk)=SAA_kk;   
end
% Averaging on the spectra
SP_aver_ris1=sum(SP_MAT_ris1,2)./floor(length(Dati)/n_point); 
% Power spectrum from average spectra
SAA_av_1_ris1= conj(SP_aver_ris1).*SP_aver_ris1;
SAA_av_1_ris1(2:end)=SAA_av_1_ris1(2:end)./2 ;
% Power spectrum from average power spectra
SAA_av_2_ris1=sum(SAA_MAT_ris1,2)./floor(length(Dati)/n_point); 

clear ris sp fin n_punti asp


%%% Case resolution 0.05 Hz
ris=0.05;
T=1./ris;
n_point=T.*fsamp;
for kk=1:floor(length(Dati)/n_point)
    [sp frequency2]=fft_norm(Dati(n_point*(kk-1)+1:kk*n_point).*(hanning(n_point)'),fsamp); % hanning
    SAA_kk=conj(sp).*sp;
    SAA_kk(2:end)=SAA_kk(2:end)./2;
    SP_MAT_ris2(:,kk)=sp;      
    SAA_MAT_ris2(:,kk)=SAA_kk;   
end
SP_aver_ris1_2=mean(SP_MAT_ris2,2);
SAA_av_1_ris1_2= conj(SP_aver_ris1_2).*SP_aver_ris1_2;
SAA_av_1_ris1_2(2:end)=SAA_av_1_ris1_2(2:end)./2;
SAA_av_2_ris2=mean(SAA_MAT_ris2,2); 


% Plot of the results
figure
semilogy(frequency1,abs(SP_aver_ris1),'b','linewidth',2)
hold on
semilogy(frequency2,abs(SP_aver_ris1_2),'r','linewidth',2)
set(gca,'fontsize',14)
title('Average spectrum')
xlabel('Frequency [Hz]')
ylabel('|A| [m/s^2]')
legend('df=0.1','df=0.05')
xlim([0.5 10]);
grid

figure
semilogy(frequency1,(SAA_av_2_ris1),'b','linewidth',2)
hold on
semilogy(frequency2,(SAA_av_2_ris2),'r','linewidth',2)
plot([fpuls fpuls],[min(SAA_av_2_ris1) max(SAA_av_2_ris1)],'--k')
set(gca,'fontsize',14)
title('Average power spectrum')
xlabel('Frequency [Hz]')
ylabel('S_{AA} [(m/s^2)^2]')
legend('df=0.1Hz','df=0.05Hz')
xlim([0.5 10]);
grid

figure
semilogy(frequency1,(SAA_av_2_ris1),'b','linewidth',2)
hold on
semilogy(frequency2,(SAA_av_2_ris2),'r','linewidth',2)
semilogy(frequency1,(SAA_av_1_ris1),'c','linewidth',2)
semilogy(frequency2,(SAA_av_1_ris1_2),'m','linewidth',2)
plot([fpuls fpuls],[min(SAA_av_1_ris1) max(SAA_av_2_ris1)],'--k')
set(gca,'fontsize',14)
title('Power spectra')
xlabel('Frequency [Hz]')
ylabel('S_{AA} [(m/s^2)^2]')
legend('aver. S_{AA} df=0.1Hz','aver. S_{AA} df=0.05Hz', 'aver. A df=0.1Hz', 'aver. A df=0.05Hz','Location','southeast')
xlim([0.5 10]);
grid

        
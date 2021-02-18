clear all
close all
clc

%% (0) From raw data to the timeseries of analysis
    
    [fileName,Path]=uigetfile('D:\Documents\GitHub\arduino-labview-voltage-display\Labview\*.txt','Choose a raw data file');
    raw = readtable(strcat(Path,fileName));
    Dati = raw.TimeSeries';
    
    %interpolate missing data
    zeropos=Dati==0;
    Dati(zeropos) = (Dati(find(zeropos)-2)+Dati(find(zeropos)+2))/2;
    
    % fetch information about sampling rate
    if exist('fsamp','var') == 0
        input = inputdlg("What is the sampling frequency?");
        fsamp = str2double(input{1});
    end
    
    dt=1/fsamp;
    tbuff = 0:dt:dt*(length(Dati)-1);
    
    figure
    plot(tbuff,Dati);
    hold on
    uiwait(msgbox('Select approximate initial and final points','modal'));
    
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
    
    input = inputdlg(strcat("Write the observation period to be considered. maximum is: ",num2str(x1-x0)," s"));
    T = str2double(input{1});
    t1 = ((x1+x0)-T)/2;
    t2 = ((x1+x0)+T)/2;
 
    % because im doing averages, i might not have datapoints on the exact
    % t1 and t2. however, T is for sure multiple of dt, so i just have to
    % move the window a bit.
    
    [t1_closestVal,t1_closestId] = min(abs(tbuff-t1));
    [t2_closestVal,t2_closestId] = min(abs(tbuff-t2));

    y = Dati(t1_closestId:t2_closestId);
    N = length(y);
    df = 1/T;
    t=[0:1:(N-1)]*dt;
 
    
    figure
    plot(t,y)
    hold on
    choice = menu("Windowing: Rectangular[R], Hanning[H], FlatTop[FT]","R","H","FT");
    switch choice 
        
        case 1

        case 2
            
            window=hanning(N)';
            y=y.*window;
            
        case 3
            
            window=flattopwin(N)';
            y=y.*window;
    
           
    end
    plot(t,y)
    xlabel('time[s]')
    ylabel('amplitude')
    legend("original signal","windowed signal")
    grid
    set(gca, 'fontsize', 16)
    ylim([min(y) max(y)]);
    xlim([t(1) t(end)]);

    
    
    

% working conditions

% all the "forced2" series were either 50 or 300 steps

%step_rate = 200; %step/s
%steps_per_rev = 200; %step/2pi
rpm = 100; %2pi/min
nrollers = 10; % pulse/2pi
fpuls = rpm*nrollers/60; %1/s


%% (1)





%% (2) Plot of the spectrum, power spectrum and PSD of the whole signal

% Windowing


% DFT
[A, frequency]=fft_norm(y,fsamp);
A_star=conj(A);

% Plot the spectrum
% figure
% stem(frequency,abs(A))
% hold on
% plot([fpuls fpuls],[min(abs(A)) max(abs(A))],'--k')
% %set(gca,'Yscale','log')
% ylabel('Modulus')
% xlabel('[Hz]')
% %legend('Rectangular')
% set(gca, 'fontsize', 16)
% xlim([0 frequency(end)]);
% ylim([0 mean(abs(A))])


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
semilogy([fpuls fpuls],[min(SAA) max(PSD)],'--k')
set(gca,'fontsize',14)
grid on
legend('Spectrum ampl.','Power spectrum','PSD')
title('Spectrum Analysis')
xlabel('Frequency [Hz]')
xlim([0 fpuls*3]);

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
semilogy(frequency1,SAA_av_2_ris1,'b','linewidth',2)
hold on
semilogy(frequency2,abs(SAA_av_2_ris2),'r','linewidth',2)
semilogy([fpuls fpuls],[min(SAA_av_2_ris2) max(SAA_av_2_ris2)],'--k')
set(gca,'fontsize',14)
title('Average power spectrum')
xlabel('Frequency [Hz]')
ylabel('|A| [m/s^2]')
legend('df=0.1','df=0.05')
xlim([0 fpuls*3]);
grid

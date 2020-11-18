clear all
close all
clc

%% (0)

% working conditions

step_rate = 30; %step/s
steps_per_rev = 200; %step/2pi
nrollers = 6; % 1/2pi


%% (1)

% Load the data
[fileName,Path]=uigetfile('*.mat','Choose a file');
load([Path fileName]);

% Time History plot
%y=conv(Dati-mean(Dati),hanning(10),"same");
y=Dati-mean(Dati);
dt=1/fsamp;
N=length(y);
T = N/fsamp;
t=[0:1:(N-1)]*dt;

figure
plot(t,y)
xlabel('time[s]')
ylabel('amplitude')
grid
set(gca, 'fontsize', 16)

pause

%% spectrum

df = 1/T;

% Check: even or odd?
    rest=floor(N/2)-N/2;
    
    if rest==0 %even case
        %rectangular
        ft_ret=fft(y);
        spectrum_ret(1)=ft_ret(1)/N;
        spectrum_ret(2:N/2)=2*ft_ret(2:N/2)./N;
        spectrum_ret(N/2+1)=ft_ret(N/2+1)/N;
        %hanning
        hann=hanning(N).';
        ft_han=fft(hann.*y);
        spectrum_han(1)=ft_han(1)/N;
        spectrum_han(2:N/2)=2*ft_han(2:N/2)./N;
        spectrum_han(N/2+1)=ft_han(N/2+1)/N;
        %flattop
        flatt=window(@flattopwin,N).';
        ft_flat=fft(flatt.*y);
        spectrum_flat(1)=ft_flat(1)/N;
        spectrum_flat(2:N/2)=2*ft_flat(2:N/2)./N;
        spectrum_flat(N/2+1)=ft_flat(N/2+1)/N;
        
        axis_f=0:df:fsamp/2;
        
    else % odd case
        
        %rectangular
        ft_ret=fft(y);
        spectrum_ret(1)=ft_ret(1)/N;
        spectrum_ret(2:(N+1)/2)=2*ft_ret(2:(N+1)/2)./N;
        %hanning
        hann=hanning(N).';
        ft_han=fft(hann.*y);
        spectrum_han(1)=ft_han(1)/N;
        spectrum_han(2:(N+1)/2)=2*ft_han(2:(N+1)/2)./N;
        %flattop
        flatt=window(@flattopwin,N).';
        ft_flat=fft(flatt.*y);
        spectrum_flat(1)=ft_flat(1)/N;
        spectrum_flat(2:(N+1)/2)=2*ft_flat(2:(N+1)/2)./N;
        
        axis_f=0:df:fsamp/2-df/2;
        
    end
    
    figure
        stem(axis_f,abs(spectrum_ret));
        xlabel('Frequency [Hz]')
        ylabel('|X|')
        hold on
        stem(axis_f,abs(spectrum_flat),'g');
        stem(axis_f,abs(spectrum_han),'r');        
        legend('Rectangular','Flat-top','Hanning')
        set(gca, 'fontsize', 16)
        
        %identification of the maximum in the spectra
        [val_r pos_r]=max(abs(spectrum_ret));
     
        f_r=(pos_r-1)*df;
        
        [val_h pos_h]=max(abs(spectrum_han));
        
        f_h=(pos_h-1)*df;
        
        [val_f pos_f]=max(abs(spectrum_flat));
    
        f_f=(pos_f-1)*df;

        
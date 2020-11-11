clear all
close all

values = [];
frequences = [];
DTsv = [];

% for i = 1:11
%     if i < 10
%         data = load(strcat('Data_0',num2str(i)));
%     else
%         
%          data = load(strcat('Data_',num2str(i)));
%          
%     end

load('Dati01');

signal = Dati;

Fs = fsamp;

N = length(signal);
dt = 1/Fs;
T = N*dt;
Fny = Fs/2;
t = dt:dt:T';
df = 1/T;

window_rect = ones(N,1);
window_hanning = hanning(N);
window_flat = window(@flattopwin,N);

signal_windowed = [window_rect window_hanning window_flat].*signal;

figure()
plot(t,signal_windowed);
legend('rectangular','hanning','flat top');

spect_rect = fft(signal_windowed(:,1));
spect_hanning = fft(signal_windowed(:,2));
spect_flat = fft(signal_windowed(:,3));

y = [spect_rect spect_hanning spect_flat];

if rem(N,2)== 0
    %even
    
    Fmax = Fny;
    y(1,:) = y(1,:)/N;
    y(2:N/2,:) =  y(2:N/2,:)*2/N;
    y(N/2+1,:) =  y(N/2+1,:)/N;
    
    spect = y(1:N/2+1,:);
    
    
else
    %odd
    
    Fmax = Fny-df/2;
    y(1,:) = y(1,:)/N;
    y(2:(N+1)/2,:) =  y(2:(N+1)/2,:)*2/N;
    
    spect = y(1:(N+1)/2,:);
    
end

f = [0:df:Fmax];

abs_spect = abs(spect);
[value,idx] = max(abs_spect);

values = [values;value];
frequences = [frequences;f(idx)];

DTs = T-2;
DTsv = [DTsv;DTs];

figure(100)
semilogy(f,abs(spect))
pause()
    
% disp('maximum of the moduluses are');
% disp(value);
% disp('in the frequencies');
% disp(f(idx));


% end

% figure()
% 
% subplot(2,1,1)
% plot(DTsv,values);
% subplot(2,1,2)
% plot(DTsv,frequences);
% 
% figure()
% subplot(2,1,1)
% plot(values)
% subplot(2,1,2)
% plot(frequences)
% 
% legend('rectangular','hanning','flat top');




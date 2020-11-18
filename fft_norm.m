function [spettro_pos, frequenze]=fft_norm(dati,fsamp)

dim=size(dati);

if dim(2)>dim(1)
    dati=dati';
end

N=length(dati);
df=1/(N*1/fsamp);

if (N/2)==(floor(N/2))
    
    frequenze=0:df:(N/2*df);
    NF=length(frequenze);
    spettro=fft(dati,[],1);
    spettro_pos(1,:)=spettro(1,:)/N;
    spettro_pos(2:N/2,:)=spettro(2:N/2,:)/(N/2);
    spettro_pos(N/2+1,:)=spettro(N/2+1,:)/N;
    
else
    
    frequenze=0:df:((N-1)/2)*df;
    NF=length(frequenze);
    spettro=fft(dati,[],1);
    spettro_pos(1,:)=spettro(1,:)/N;
    spettro_pos(2:(N+1)/2,:)=spettro(2:(N+1)/2,:)/(N/2);
    
end





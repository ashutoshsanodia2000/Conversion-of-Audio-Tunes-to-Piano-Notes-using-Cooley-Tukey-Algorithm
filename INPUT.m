[y,Fs]=audioread('flute.wav');                                 %read the file
filename='C.wav';                                           %name the file
audiowrite(filename,y,Fs);                                  %coonvert ito wav
r=length(y);
k=0;
j=1;
Final=[0 {0} 0];
s=readmatrix('Notesb.xlsx');                                 %input reference freq
[d,f1,f2] = readvars('Notes-1.xlsx');                       %-------------------
while floor(Fs/(5*j))>1                                    %to convert into 2^n
    j=j*2;
end
for n=1:r/Fs*5-1                                                  %take sample(0.1 s)
    samples=[1+floor((n*Fs)/5),floor((n+1)*Fs/5)];
    clear y Fs;
    [y,Fs]=audioread(filename, samples);
    sound(y,Fs)                                                        %for sound
    x=abs(fft_Cooley_Tukey(y(:,1)')');                              %fft
    f=Fs/2*linspace(-1-2/Fs,1-2/Fs,2*j);                            %for index plotting(bin freq-->normalfreq)
    [val, idx] = max(x, [], 1);                                     %taking freq with kax amplitude
    if mag2db(val)>=20                                              %filtering by intensity
    idx=abs(floor(f(idx)));                                         
    if idx(1)<5931                                                  %Assigning frequencies
        a=2;
        while f1(a)<idx(1)
            a=a+1;
        end
        Final=[Final;n/5 d(a-1) s(a-1,2)];
    end
    end
end 
ffinal=cell2mat(Final(:,3));                                        %removing repeatitions
g=0;
i=1;
 while i<length(Final(:,1))
    if ffinal(i)~=g
        g=ffinal(i);
        i=i+1;
    end
    if ffinal(i)==g
        Final(i,:)=[];
        ffinal(i)=[];
    end
 end
Final
ck=categorical(Final(:,2));
subplot(2,1,1)
xlabel('Time')
stem(cell2mat(Final(:,1)),ck)
subplot(2,1,2)
bar(cell2mat(Final(:,1)),cell2mat(Final(:,3)))
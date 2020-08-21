function X = fft_Cooley_Tukey(x)

N = length(x);    
j=1;
pow=1;
while floor(N/j)>1
    j=j*2;
    pow=pow+1;
end                                         %greater 2^n term

x = [x,zeros(1,(2*j)-N)];                   %To make it 2^k
X = bitrevorder(x);                         %for making odd and even seperated
N = length(X);                              %new N length

freq = 0 : (N/2 - 1);                       

phase = cos(2*pi/N*freq) - 1i*sin(2*pi/N*freq);                            

for m = 1 : pow
    L = 2^m;                                                               
    W = phase(1 : N/L : (N/2));

    for k = 0 : L : N - L                                                  
        for n = 0 : L/2 - 1                                                
            one  = X(n + k + 1);
            two = X(n + k + L/2 + 1)*W(n + 1);
            X(n + k + 1)       = one + two;
            X(n + k + L/2 + 1) = one - two;
        end
    end
end

X = [X(N/2:end) X(1:N/2-1)];

end
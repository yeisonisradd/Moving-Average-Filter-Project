clear all;
%part a
load('MiniProject2cleanECG');
load('MiniProject2noisyECG');

%Define the number of samples we will use for the moving average
% This number will take on 4 different values of 2, 3, 5, & 10 to create 4
% different figures
N = [2,3, 5, 10];
for i = 1:4

%Set the length of y1 to be the length of a convolution between a vector of
%size n and the noisyECG signal
y1 = zeros(1,N(i)+length(noisyECG)-1);
%Do the same for t
t = linspace(0,2,N(i)+length(noisyECG)-1);

%part b
for n = 1:length(noisyECG)+N(i)-1
    if(n <= N(i)-1)
        for k = 0:n-1
            y1(n) = y1(n) + noisyECG(n-k)/N(i);
        end
    elseif n > N(i)-1 && n <= 200
        for k = 0:N(i)-1
            y1(n) = y1(n) + (noisyECG(n-k))/N(i);
        end
    elseif n>200
        for k = 0: length(y1)-n
        y1(n) = y1(n) + noisyECG(length(noisyECG)-k)/N(i);
        end
    end
end

%part c
h = ones(1,N(i))/N(i);

%part d
y2 = conv(noisyECG,h);

%part e
figure(i)
titlestring = strcat('ECG Signals over 2 seconds at N = ', num2str(N(i)));
sgtitle(titlestring);
subplot(2,2,1);
plot(time,ECG);
grid ON;
xlabel('time (seconds)');
ylabel('amplitude');
title('Clean ECG');

subplot(2,2,2);
plot(time,noisyECG);
grid ON;
xlabel('time (seconds)');
ylabel('amplitude');
title('noisy ECG');

subplot(2,2,3);
plot(t,y1);
grid ON;
xlabel('time (seconds)');
ylabel('amplitude');
title('signal b');
subplot(2,2,4);
plot(t,y2);
grid ON;
xlabel('time (seconds)');
ylabel('amplitude');
title('convolution signal');
end

%Problem 2
%Open the file
fileName =fopen('MiniProject2RodriguezYeison.dat','r');
%the file has a lot of data, and so we will only overview it for the first second
time= 1;
%read the file which had a signal recorded at a frequency of 256Hz
f=fread(fileName,2*pi*256*time,'uint8');
%sample every other value to save memory and processing time
Orig_Sig=f(1:2:length(f));
%close the file
fclose('all');


% repeat process for part b and e of problem one
for i = 1:4
    %Create an empty vector for the cleaned signal
    cleanedSig = zeros(1,N(i)+length(Orig_Sig)-1);
    %Create any new vectors for time that are necessary
    t2 = linspace(0,1, length(Orig_Sig));
    t3 = linspace(0, 1, length(Orig_Sig)+ N(i) - 1);
for n = 1:length(Orig_Sig)+N(i)-1
    if(n <= N(i)-1)
        for k = 0:n-1
            cleanedSig(n) = cleanedSig(n) + Orig_Sig(n-k)/N(i);
        end
    elseif n > N(i)-1 && n <= length(Orig_Sig)
        for k = 0:N(i)-1
            cleanedSig(n) = cleanedSig(n) + (Orig_Sig(n-k))/N(i);
        end
    elseif n>length(Orig_Sig)
        for k = 0: length(cleanedSig)-n
        cleanedSig(n) = cleanedSig(n) + Orig_Sig(length(Orig_Sig)-k)/N(i);
        end
    end
end

%repeat process of part e in problem one, this time only graphing the noisy
%signal and the signal we cleaned using our filter
figure(i+4)
titlestring = strcat('PPG Signals over a second at N = ', num2str(N(i)));
sgtitle(titlestring);
subplot(1,2,1);
plot(t2,Orig_Sig);
grid ON;
xlabel('time (seconds)');
ylabel('amplitude');
title('noisy PPG');

subplot(1,2,2);
plot(t3,cleanedSig);
grid ON;
xlabel('time (seconds)');
ylabel('amplitude');
title('cleaned signal');
end

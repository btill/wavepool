
%function output = envelope(filterBank,fs)
function output = envelope(obj)
%envelope.m
%   Takes the output of bandsplit.m (a matrix with FFT data in each column
%   corresponding to a respective frequency band) and produces a waveform
%   envelope. Each band is processed individually. Critical steps:
%       1) Waveform is restored by performing the inverse FFT
%       2) Waveform is rectified
%       3) Rectified waveform is convolved with a 200ms Hanning Window (by
%       simply multiplying the discrete data in the frequency domain)
%       4) Envelope is produced by taking the real part of the inverse FFT of the
%       convolution

bandArray = obj.BandArray;
fs = obj.Fs;

windowPeriod = 200e-3; %[s] as suggested by Scheirer
window = hann(windowPeriod*fs);

for i = 1:size(bandArray,2)
    waveform = real(ifft(bandArray(:,i)));
    rectified = abs(waveform);
    n = length(rectified) - length(window);
    window = [window;zeros(n,1)];
    
    %To frequency domain
    fftWindow = fft(window);
    fftRectified = fft(rectified);
    
    %Convolve
    output(:,i) = real(ifft(fftWindow.*fftRectified));
    
end

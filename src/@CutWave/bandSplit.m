
function bands = bandSplit(obj)
%bandSplit.m
%   Takes .wav file data and splits the sample into a series of frequency
%   bands (filterbank). The output is a matrix where each column holds the
%   Fourier Transform of a respective frequency band.

%Band Limits
band_freqs = [0 200 400 800 1600 3200 4800];

wavSample = obj.WaveData;
fs = obj.Fs;

%FFT processing
fftResult = fft(wavSample);
fftMag = abs(fftResult);
nfft = length(fftResult);

%Output initialize
output = zeros(nfft,length(band_freqs)-1);

%Split FFT data into bands
for i = 1:length(band_freqs)-1
    startIndex = floor((band_freqs(i)/fs)*nfft) + 1;
    endIndex = floor((band_freqs(i+1)/fs)*nfft);
    output(startIndex:endIndex,i) = fftResult(startIndex:endIndex);
end

bands = output;


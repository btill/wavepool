

function [tempoOut energy] = comb(obj,waitHandle)
%comb.m
%   Estimates the tempo based on data passed from deriv.m by implementing a
%   series of comb filters. Comb filters are produced for each possible
%   tempo and convolved with the pre-processed waveforms in each band. For
%   each test tempo, the sum of the energies of all frequency bands is
%   found. The test tempo with the highest energy value is chosen as the
%   actual tempo.

d = obj.DdtArray;
fs = obj.Fs;

%Settings
nSpikes = 3; %as suggested by "Beat This"
tempos = obj.TempoList;

n = size(d,1);
nCols = size(d,2);

for k = 1:length(tempos)
    combfil = zeros(n,1);
    nSamples = floor(1/(tempos(k)*(1/60)*(1/fs)));
    
    for j = 1:nSamples:nSpikes*nSamples
        combfil(j,1) = 1;
    end
    combfil = combfil(1:n);
    
    %combfil = combfil(1:n);
    combfft = fft(combfil);
    
    energy(k) = 0;
    for i = 1:nCols
        sigfft = fft(d(:,i));
        
        %Convolve
        conSig = ifft(sigfft.*combfft);
        energy(k) = energy(k) + sum(real(conSig).^2);
    end
    pct = (k/length(tempos))*100;
    waitbar(k/length(tempos),waitHandle,[int2str(pct),'%',' Complete']);
end

close(waitHandle);

%Find tempo corresponding to max energy
[maxVal ind] = max(energy);
tempoOut = tempos(ind);



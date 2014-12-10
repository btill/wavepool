
%function output = deriv(smoothed,fs)
function output = deriv(obj)
%deriv.m
%   Takes the smoothed waveforms produced by envelope.m and finds the
%   derivative of the discrete data. All negative slopes are thrown out
%   because only rising action is desired (attack).

smoothed = obj.SmoothedArray;
fs = obj.Fs;

nBands = size(smoothed,2);
for i = 1:nBands
    ddt = diff(smoothed(:,i))./(1/fs);
    for j = 1:length(ddt)
        %Throw out negative derivatives
        if ddt(j) < 0
            ddt(j) = 0;
        end
    end
    output(:,i) = ddt;
end
  
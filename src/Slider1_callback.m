function Slider1_callback(hobject,hevent,slider1Handle,slider2Handle,lineHandle,cutWavePlot,waveobj,t)

%based on slider position, a start and finish point in the WaveData are
%   defined
data=[get(slider1Handle,'Value'),get(slider2Handle,'Value')];
start=ceil(min(data)*t(end)*waveobj.OriginalFs);
finish=ceil(max(data)*t(end)*waveobj.OriginalFs);

%start is defined to 1 because 0 is an invalid index
if start==0
    start=1;
end

%plotted line above slider is moved to stay above slider.
x = data(1)*t(end)*[1 1];
set(lineHandle,'XData',x);

%cutData is defined and plot of cutData is refreshed
tnew = t(start:finish);
waveobj.cutData = waveobj.WaveData(start:finish);
plot(cutWavePlot,tnew,waveobj.cutData);axis([tnew(1) tnew(end) -1.5 1.5])
xlabel('Time [s]')
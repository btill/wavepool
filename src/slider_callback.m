
function slider_callback(hobject,hevent,sliderHandle,waveObject,axesHandle)

%Value between 0 and 1
%0.5 --> 1.45 x original tempo
value = get(sliderHandle,'Value');
newFs = floor((.5 + value*.95)*waveObject.OriginalFs);
waveObject.modifyTempo(newFs);

[t data] = waveObject.getPlotData();
plot(axesHandle,t,data);axis([t(1) t(length(t)) -1.5 1.5]);
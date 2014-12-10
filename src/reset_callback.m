
function reset_callback(event,src,tempoSlider,bpmEntry,cw,waveAxes)

cw.modifyTempo(cw.OriginalFs);
set(tempoSlider,'Value',.5);
set(bpmEntry,'String',int2str(cw.BPM));

[t data] = cw.getPlotData();
plot(waveAxes,t,data);axis([t(1) t(length(t)) -1.5 1.5]);
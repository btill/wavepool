
function bpmEntry_callback(event,src,bpmHandle,waveObj,axesHandle)

tempo = waveObj.BPM;
newTempo = str2num(get(bpmHandle,'String'));
scaleFactor = newTempo/tempo;
if scaleFactor >= 1.48
    msgbox('Maximum tempo exceeded!','Error','error');
    set(bpmHandle,'String','(enter BPM)');
else
    newFs = floor(scaleFactor*waveObj.OriginalFs);
    waveObj.modifyTempo(newFs);
    [t data] = waveObj.getPlotData();
    plot(axesHandle,t,data);axis([t(1) t(length(t)) -1.5 1.5]);
end

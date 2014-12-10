
function findTempo_callback(hobject,heventData,waveObj,axesHandle,resultHandle,...
    bpmEntrySelectHandle,bpmEntryHandle)

Hwait = waitbar(0,'0% Complete','Name','Determining tempo...');
[tempos energy] = waveObj.findTempo(Hwait);
plot(axesHandle,tempos,energy);
xlabel(axesHandle,'BPM');ylabel(axesHandle,'Energy');
set(resultHandle,'Enable','on','String',int2str(waveObj.BPM));
set(bpmEntrySelectHandle,'Enable','on');
set(bpmEntryHandle,'String',int2str(waveObj.BPM));
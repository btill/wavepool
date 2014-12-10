
function sliderSelect_callback(hobject,heventData,selectHandle,...
    tempoHandle,bpmSelectHandle,bpmEntryHandle)

state = get(selectHandle,'Value');

if state == 1
    set(tempoHandle,'Enable','on');
    set(bpmSelectHandle,'Value',0);
    set(bpmEntryHandle,'Enable','off');
else
    set(tempoHandle,'Enable','off');
end


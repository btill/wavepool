function bpmSelect_callback(hobject,hevent,selectHandle,sliderSelectHandle,...
    tempoHandle,entryHandle)

state = get(selectHandle,'Value');

if state == 1
    set(tempoHandle,'Enable','off');
    set(sliderSelectHandle,'Value',0);
    set(entryHandle,'Enable','on');
else
    set(entryHandle,'Enable','off');
end
function wpoolui(wpool)
%WPOOLUI Wizard for WavePool
%   Each of the 4 screens exist concurrently as separate panels. 
%   WavePool.FrameArray dictates which panel to display.

%% Initialize UI
if isempty(wpool.Figure)
    % Check to make sure that an existing UI doesn't already exist
    % Set up each screen
    wpool.Figure = figure('Name','WavePool','Units','normalized','Position',[.1 .1 .8 .8],'Visible','off');
    wpool.Screen{1} = uipanel('Parent',wpool.Figure,...
             'Position',[0 0 1 1],...
             'Units','normalized','Title','WavePool - Import  ','FontSize',12);
    wpool.Screen{2} = uipanel('Parent',wpool.Figure,...
             'Position',[0 0 1 1],...
             'Units','normalized','Title','WavePool - Select Cut  ','FontSize',12);
    wpool.Screen{3} = uipanel('Parent',wpool.Figure,...
             'Position',[0 0 1 1],...
             'Units','normalized','Title','WavePool - Tempo and Beat Detection  ','FontSize',12);
    wpool.Screen{4} = uipanel('Parent',wpool.Figure,...
             'Position',[0 0 1 1],...
             'Units','normalized','Title','WavePool - Export  ','FontSize',12);
end
        
%% Panel 1 - % Title, Select File, Import
    if wpool.FrameArray == 1
        logo = axes('Parent',wpool.Screen{1},'Position',[.1 .6 .8 .3],'Units','normalized');
        imshow('logo3.tif','Parent',logo,'Border','tight');
        title1 = uicontrol(wpool.Screen{1},'Style','text','String',['Alean Daniel, McKay Hansen, Brendan Till'],...
            'Units','normalized','Position',[.1 .45 .8 .1],'FontSize',16);
        title2 = uicontrol(wpool.Screen{1},'Style','text','String',['E177 - Spring 2009'],...
            'Units','normalized','Position',[.1 .4 .8 .1],'FontSize',14);
        select_file1 = uicontrol(wpool.Screen{1},'Style','pushbutton','String','Select File...',...
            'Units','normalized','Position',[.05 .3 .2 .1],'FontSize',14,'Callback',{@selectfile_callback});
        select_file_disp = uicontrol(wpool.Screen{1},'Style','edit','String',['Selected File: ' strcat(wpool.Path,wpool.Filename)],...
            'Units','normalized','Position',[.275 .315 .65 .075],'FontSize',16,'Background','white','HorizontalAlignment','left');
        import = uicontrol(wpool.Screen{1},'Style','pushbutton','String','Import   >',...
            'Units','normalized','Position',[.725 .1 .2 .15],'FontSize',14,'Callback',{@import_callback});
    end
%% Panel 2 - % Display wave form and decide what section to work on
    if wpool.FrameArray == 2
        [t song]=wpool.Wave.getPlotData;
        fs=wpool.Wave.OriginalFs;
        % Panels
        wavePanel = uipanel('Parent',wpool.Screen{2},'Position',[0 .5 1 .49],...
            'Title','Full Song  ','FontSize',14);
        cutWavePanel = uipanel('Parent',wpool.Screen{2},'Position',[0 0 1 .49],...
            'Title','Song Sample  ','FontSize',14);
        % Axes and Plots
        waveAxes = axes('Parent',wavePanel,'Position',[.1 .4 .8 .55]);
        songPlot = plot(waveAxes,t,song);hold on
        xlabel('Time [s]')

        cutWaveAxes = axes('Parent',cutWavePanel,'Position',[.1 .2 .7 .75]);
        cutSongPlot = plot(cutWaveAxes,t,song);

        set(waveAxes,'YTickLabel','','XLim',[t(1) t(end)],'YLim',[-1.5 1.5])
        set(cutWaveAxes,'YTickLabel','','XLim',[t(1) t(end)],'YLim',[-1.5 1.5])
        xlabel('Time [s]')
        %User Controls i.e., sliders and buttons
        Slider1 = uicontrol('Style','slider','Parent',wavePanel,...
            'String','Scale Factor','Units','normalized',...
            'Position',[.085 .245 .83 .05],'SliderStep',[.005,.01],'Enable','on','Value',0);

        Data1 = get(Slider1,'Value')*t(end)*[1 1];
        Line1 = plot(waveAxes,Data1,[-1.5 1.5],'r','LineWidth',1.5);

        Slider2 = uicontrol('Style','slider','Parent',wavePanel,...
            'String','Scale Factor','Units','normalized',...
            'Position',[.085 .19 .83 .05],'SliderStep',[.005,.01],'Enable','on','Value',1);

        uicontrol('Style','text','Parent',wavePanel,...
            'String','Use the sliders to select a sample of the song.',...
            'Units','normalized','Position',[.085 0 .83 .1],'FontSize',12);

        Data2 = get(Slider2,'Value')*t(end)*[1 1];
        Line2 = plot(waveAxes,Data2,[-1.5 1.5],'r','LineWidth',1.5);

        set(Slider1,'Callback',@(event,src)Slider1_callback(event,src,Slider1,Slider2,Line1,cutWaveAxes,wpool.Wave,t));
        set(Slider2,'Callback',@(event,src)Slider2_callback(event,src,Slider2,Slider1,Line2,cutWaveAxes,wpool.Wave,t));

        preview_button = uicontrol('Style','pushbutton','Parent',cutWavePanel,'ForegroundColor','blue',...
                        'String','Preview','Units','normalized','FontSize',14,'Position',...
                        [.83 .76 .14 .21],'Callback',(@(event,src)preview_callback(event,src,wpool.Wave)));
        prev_button2 = uicontrol('Style','pushbutton','Parent',cutWavePanel,...
                        'String','<   Previous','Units','normalized','FontSize',14,'Position',...
                        [.83 .175 .14 .12],'Callback',{@prev_callback});
        cut_button = uicontrol('Style','pushbutton','Parent',cutWavePanel,...
                        'String','Cut   >','Units','normalized','FontSize',14,'Position',...
                        [.83 .325 .14 .21],'Callback',{@cut_callback});
    end
    
%% Panel 3 -  % Tempo Slider and Beat Detection
    if wpool.FrameArray == 3
        [t data] = wpool.CutWave.getPlotData();
        tempos = [];
        energy = [];
        % Panels
        analysisPanel = uipanel('Parent',wpool.Screen{3},'Position',[0 .5 .75 .49],...
            'Title','Tempo Analysis  ','FontSize',14);
        wavePanel = uipanel('Parent',wpool.Screen{3},'Position',[0 0 .75 .49],...
            'Title','Tempo Modification  ','FontSize',14);
        navPanel = uipanel('Parent',wpool.Screen{3},'Position',[.75 0 .25 .98],...
            'TitlePosition','centertop','FontSize',14);
        % Tempo Analysis Panel
        bpmResultLabel = uicontrol('Style','text','Parent',analysisPanel,...
            'String','Estimated BPM:','Units','normalized',...
            'Position',[.7 .4 .3 .1],'FontSize',14);
        bpmResult = uicontrol('Style','edit','Parent',analysisPanel,...
            'Units','normalized',...
            'Position',[.8 .35 .1 .075],'FontSize',14,'Background','white',...
            'Enable','off');
        
        analysisAxes = axes('Parent',analysisPanel,'Position',[.075 .1 .6 .8]);

        plot(analysisAxes,tempos,energy);text(.35,.5,'Press "Start BPM Analysis"!');
        % Tempo Modify Panel
        waveAxes = axes('Parent',wavePanel,'Position',[.075 .1 .6 .8]);
        plot(waveAxes,t,data);axis([t(1) t(length(t)) -1.5 1.5]);
        xlabel('Time [s]'),ylabel('Level')
        tempoSlider = uicontrol('Style','slider','Parent',wavePanel,...
            'String','Scale Factor','Units','normalized',...
            'Position',[.725 .7 .25 .1],'Enable','off','Value',.5);
        bpmEntry = uicontrol('Style','edit','Parent',wavePanel,...
            'Units','normalized','String','','FontSize',14,...
            'Position',[.775 .5 .1 .075],'Background','white','Enable','off');
        desBPMSelect = uicontrol('Style','radiobutton','Parent',wavePanel,...
             'String','Set Desired BPM','Units','normalized','Position',[.7 .6 .2 .05],...
             'Enable','off','Value',0);
        tempoSliderSelect = uicontrol('Style','radiobutton','Parent',wavePanel,...
             'Units','normalized','Position',[.7 .85 .2 .05],'String','Tempo Slider',...
             'Enable','on','Value',0);
        resetButton = uicontrol('Style','pushbutton','Parent',wavePanel,...
            'String','Original Tempo','Units','normalized',...
            'Position',[.75 .3 .2 .1],'FontSize',12);
        set(tempoSliderSelect,'Callback',@(event,src)sliderSelect_callback(event,src,tempoSliderSelect,...
             tempoSlider,desBPMSelect,bpmEntry));
        set(desBPMSelect,'Callback',@(event,src)bpmSelect_callback(event,src,...
             desBPMSelect,tempoSliderSelect,tempoSlider,bpmEntry));
        set(tempoSlider,'Callback',@(event,src)slider_callback(event,src,tempoSlider,wpool.CutWave,waveAxes));
        set(bpmEntry,'Callback',@(event,src)bpmEntry_callback(event,src,bpmEntry,wpool.CutWave,waveAxes));
        set(resetButton,'Callback',@(event,src)reset_callback(event,src,tempoSlider,bpmEntry,wpool.CutWave,waveAxes));
        previewButton = uicontrol('Style','pushbutton','Parent',wavePanel,...
            'String','Preview','Units','normalized',...
            'Position',[.75 .1 .2 .2],'Callback',@(event,src)wpool.CutWave.previewSample,...
            'FontSize',13,'ForegroundColor','blue');

        %Needs to go after 'desBPMSelect' initialization
        bpmButton = uicontrol('Style','pushbutton','Parent',analysisPanel,...
            'String','Start BPM Analysis','Units','normalized',...
            'Position',[.75 .6 .2 .2],'Callback',@(event,src)findTempo_callback(event,src,wpool.CutWave,analysisAxes,...
            bpmResult,desBPMSelect,bpmEntry),'FontSize',13);
        % Summary Panel
        exportButton = uicontrol('Style','pushbutton','Parent',navPanel,...
            'String','Export Sample   >','Units','normalized',...
            'Position',[.1 .2 .8 .14],'FontSize',14,'Callback',{@next_callback});
        backButton = uicontrol('Style','pushbutton','Parent',navPanel,...
            'String','<   Previous','Units','normalized',...
            'Position',[.1 .1 .8 .075],'FontSize',14,'Callback',{@prev_callback});
        
        dirPan = uipanel('Parent',navPanel,'Position',[.1 .6 .8 .3]);
        directions = uicontrol('Style','text','Parent',dirPan,'Units','normalized',...
            'HorizontalAlignment','left','String',{'DIRECTIONS:';' ';' - Press "Start BPM Analysis"';'   to find tempo';...
            ' ';' - Modify tempo with slider';'    or manual entry if desired';' ';' - Press "Export Sample"';'  to proceed'},...
            'Position',[.01 .01 .98 .98],'FontSize',13);
    end
%% Panel 4 - % Export, Previous, Startover
    if wpool.FrameArray == 4
        % Export Panel
        expanel = uipanel('Parent',wpool.Screen{4},'Position',[0.5 0 0.49 1],...
            'Units','normalized','Title','Export  ','FontSize',14);
        prev_button3 = uicontrol('Parent',expanel,'Style','pushbutton','String','<   Previous','Units','normalized',...
            'Position',[.325 .35 .35 .075],'Callback',{@prev_callback},'FontSize',14);
        export = uicontrol('Parent',expanel,'Style','pushbutton','String','Save Sample','Units','normalized',...
            'Position',[.175 .65 .65 .2],'Callback',{@export_callback},'FontSize',18);
        select_file_disp2 = uicontrol('Parent',expanel,'Style','text','String','Did you want to save your wave file?','Units','normalized',...
            'Position',[.175 .875 .8 .05],'FontSize',13,'HorizontalAlignment','left');
        startover_button = uicontrol('Parent',expanel,'Style','pushbutton','String','Start Over','Units','normalized',...
            'Position',[.325 .25 .35 .075],'Callback',{@startover_callback},'FontSize',14);
        % Summary Panel
        sumPanel = uipanel('Parent',wpool.Screen{4},'Position',[0 0 0.49 1],...
            'Units','normalized','Title','Summary  ','FontSize',14);
        statsPanel = uipanel('Parent',sumPanel,'Position',[.2 .6 .6 .25]);
        label_2 = uicontrol('Style','edit','Parent',sumPanel,...
            'String',['Duration [s]: ' num2str(wpool.CutWave.SampleDuration)],'Units','normalized',...
            'Position',[.25 .775 .5 .05],'FontSize',13,'HorizontalAlignment','left','Background','white');
        label_3 = uicontrol('Style','edit','Parent',sumPanel,...
            'String',['Sampling Rate [Hz] : ' num2str(wpool.CutWave.OriginalFs)],'Units','normalized',...
            'Position',[.25 .7 .5 .05],'FontSize',13,'HorizontalAlignment','left','Background','white');
        label_4 = uicontrol('Style','edit','Parent',sumPanel,...
            'String',['Output BPM: ' num2str(wpool.CutWave.BPM)],'Units','normalized',...
            'Position',[.25 .625 .5 .05],'FontSize',13,'HorizontalAlignment','left','Background','white');
        sumAxes = axes('Parent',sumPanel,'Position',[.1 .2 .85 .3]);
        [t data] = wpool.CutWave.getPlotData();
        plot(sumAxes,t,data);axis([t(1) t(length(t)) -1.5 1.5]);
        xlabel('Time [s]'),ylabel('Level');
    end
 set(wpool.Figure,'Visible','on');
 whatvisible(wpool);


%% Callbacks for General Interface and Screens 1 and 4

    function selectfile_callback(hObject,eventdata)
        wpool.selectfile;
        set(select_file_disp,'String',['Selected File: ' strcat(wpool.Path,wpool.Filename)]);
    end

    function import_callback(hObject,eventdata)
        if strcmp(wpool.Filename,'')
            msgbox('Please select a wav file','No file selected','warn')
        else
            wpool.import;
            next_callback(hObject,eventdata);
        end
    end

    function export_callback(hObject,eventdata)
        answer = questdlg('Do you want to upgrade to WavePool Pro for only $9.95?','Upgrade!');
        wpool.export;
        disp('Your file has been exported. Start over or exit?');
    end

    function next_callback(hObject,eventdata)
        % Moves the wizard to the next screen
        % Each of the screens is either shown or hidden, using next or
        % previous increments the FrameArray and determines which frame
        % is shown.
        wpool.FrameArray = wpool.FrameArray + 1;
        wpool.wpoolui;
    end
        
    function prev_callback(hObject,eventdata)
        % Moves the wizard to the previous screen
        wpool.FrameArray = wpool.FrameArray - 1;
        wpool.wpoolui;
    end
        
    function startover_callback(hObject,eventdata)
        % Starts the wizard over
        wpool.FrameArray = 1;
        wpool.wpoolui;
    end

    function whatvisible(wpool)
        % Determine which figure to display
        if wpool.FrameArray == 1
            set(wpool.Screen{1},'Visible','on');
            set(wpool.Screen{2},'Visible','off');
            set(wpool.Screen{3},'Visible','off');
            set(wpool.Screen{4},'Visible','off');
        elseif wpool.FrameArray ==2
            set(wpool.Screen{2},'Visible','on');
            set(wpool.Screen{1},'Visible','off');
            set(wpool.Screen{3},'Visible','off');
            set(wpool.Screen{4},'Visible','off');
        elseif wpool.FrameArray ==3
            set(wpool.Screen{3},'Visible','on');
            set(wpool.Screen{1},'Visible','off');
            set(wpool.Screen{2},'Visible','off');
            set(wpool.Screen{4},'Visible','off');
        elseif wpool.FrameArray ==4
            set(wpool.Screen{4},'Visible','on');
            set(wpool.Screen{1},'Visible','off');
            set(wpool.Screen{2},'Visible','off');
            set(wpool.Screen{3},'Visible','off');
        end
    end

%% Callbacks for Screen 2 - Cut the Wave file
    function preview_callback(event,src,waveObj)
    t=length(waveObj.cutData)/waveObj.OriginalFs;
        if t<=10  %makes sure the sample being previewed isn't too long
            sound(waveObj.cutData,waveObj.OriginalFs);
        else
            msgbox('Choose a sample shorter than 10 seconds','Too Long','warn')
        end
    end

    function cut_callback(hObject,eventdata)
        wpool.createcut(wpool.Wave.cutData,wpool.Wave.OriginalFs);
        next_callback(hObject,eventdata);
    end

end


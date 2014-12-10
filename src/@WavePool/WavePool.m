classdef WavePool < handle
    %WAVEPOOL A class for using the Wavepool program
    %   Create an instance and use the START() method to edit a wave file.
    %   wpoolui is the GUI method for this program.
    
    properties
        Wave;
        CutWave;
        Figure;
        Screen = {};      %Stores uipanel handles  
        Filename = '';   %Used for importing
        Path = '';       %Used for importing
        FrameArray = 1;          %Which wizard screen
    end
    
    methods
        %Constructor
        function wpool = WavePool()
            % Creates program workspace
            if nargin == 0
                data = [0 0.25];
                fs = 44100;
                wpool.Wave = Wave(data,fs,wpool.Path);
                wpool.CutWave = CutWave(data,fs,wpool.Path);
            end
        end
        
        function start(wpool)
            % Starts the wizard
            wpool.wpoolui;
        end
        
        function selectfile(wpool)
            [wpool.Filename, wpool.Path] = uigetfile('*.wav','Pick a Wav file');
        end
        
        function import(wpool)
            % Imports wave file
            [data fs] = wavread(strcat(wpool.Path,wpool.Filename));
            wpool.Wave = Wave(data,fs,wpool.Path);
        end
        
        function export(wpool)
            % Exports the final file
            [filename path] = uiputfile('*.wav','Save your Wav file');
            if filename ~= 0
                wavwrite(wpool.CutWave.WaveData,wpool.CutWave.Fs,strcat(path,filename));
            end
        end
        
        function createcut(wpool,data,fs)
            % Creates the cut sample
            wpool.CutWave = CutWave(data,fs,wpool.Path);
        end
    end
    
end


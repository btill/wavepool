classdef Wave < handle
    %Wave class creates wave objects with the following properties:
    %WavePath: the file path of the .wav file
    %WaveData: the vector containing the data contained in the .wav file
    %OriginalFs: the sampling frequency of the .wav file
    %SampleLength: the length of the data vector
    %SampleDuration: the length (in seconds) of the .wav file when played
    %   at its original sampling frequency
    %cutData: a property adjustable by the user within the GUI
   
    properties (SetAccess = 'private')
        WavePath
        WaveData
        OriginalFs
        SampleLength
        SampleDuration
    end
    
    properties (SetAccess = 'public')
        cutData
    end
    
    methods
        
        %Constructor
        function obj = Wave(data,fs,path)
            obj.WavePath = path;
            obj.WaveData = data;
            obj.cutData = data;
            obj.OriginalFs = fs;
            obj.SampleLength = length(data);
            obj.SampleDuration = length(data)/fs;
        end
        
        %Retrieve data for GUI plot
        function [t wavData] = getPlotData(obj)
            t = 0:(1/obj.OriginalFs):(obj.SampleLength-1)/obj.OriginalFs;
            wavData = obj.WaveData;
        end
    end
end
            
        
    
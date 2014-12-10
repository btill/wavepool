classdef CutWave < Wave
    %Class CutWave
    %   Object that represents a "cut" sample of a full .wav file
    %   Child of Wave class
    %
    %   Additional properties NOT present in parent Wave class:
    %       1) Fs - Playback sampling frequency
    %       2) BPM - Detected Beats Per Minute
    %       3) BandArray - bandSplit() output
    %       4) SmoothedArray - envelope() output
    %       5) DdtArray - deriv() output
    %       6) Energy - List of energies (comb filter output)
    %       7) TempoList - Range of tempos searched
    %
    %   Methods:
    %       1) CutWave - constructor (calls parent constructor within)
    %       2) findTempo - runs tempo detection algorithm using external
    %       functions
    %       3) previewSample - callback used to preview (playback) the cut
    %       sample
    %       4) getPlotData - retrieves plot data for GUI
    %       5) modifyTempo - changes playback sampling (changes tempo)
    %   External functions (see m-files for description):
    %       1) bandSplit
    %       2) envelope
    %       3) deriv
    %       5) comb
    
    properties (SetAccess = 'private')
        Fs = [];
        BPM = [];
        BandArray = [];
        SmoothedArray = [];
        DdtArray = [];
        Energy = [];
        TempoList = [80:110];
    end
    
    methods
        
        %Constructor
        function obj = CutWave(data,f,path)
            obj = obj@Wave(data,f,path);
            obj.Fs = f;
        end
        
        %Tempo Detection
        function [tempos energy] = findTempo(obj,waitHandle)
            
            %1) Filter bank
            obj.BandArray = obj.bandSplit();

            %2) Envelope
            obj.SmoothedArray = obj.envelope();

            %3) Derivative
            obj.DdtArray = obj.deriv();

            %4) Comb filter
            [obj.BPM obj.Energy] = obj.comb(waitHandle);
            tempos = obj.TempoList;
            energy = obj.Energy;           
        end
        
        %Preview callback
        function previewSample(obj)
            sound(obj.WaveData,obj.Fs);
        end
        
        %Retrieve data for GUI plot
        function [t wavData] = getPlotData(obj)
            t = 0:(1/obj.Fs):(obj.SampleLength-1)/obj.Fs;
            wavData = obj.WaveData;
        end
        
        %Change tempo
        function modifyTempo(obj,newFs)
            obj.Fs = newFs;
        end
        
        %External method declarations
        output = bandSplit(wavSample,fs)
        output = envelope(filterBank,fs);
        output = deriv(smoothed,fs);
        [a b c] = comb(d,fs);
    end
          
end
        
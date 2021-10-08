classdef TestWaveMarker < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("RM3/hydroData")
        h5Name = 'rm3.h5'
        outName = 'rm3.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestWaveMarker
            obj.testDir = fileparts(mfilename('fullpath'));
        end    
    end
    
    methods (TestMethodSetup)
        function killPlots (~)
            set(0,'DefaultFigureVisible','off');
        end
    end
    
    methods(TestClassSetup)        
        function captureVisibility(testCase)
            testCase.OriginalDefault = get(0,'DefaultFigureVisible');
        end        
        function runBemio(testCase)            
            cd(testCase.h5Dir);
            hydro = struct();
            hydro = Read_WAMIT(hydro,testCase.outName,[]);                 
            hydro = Radiation_IRF(hydro,30,[],[],[],[]);
            hydro = Excitation_IRF(hydro,30,[],[],[],[]);            
            Write_H5(hydro)
            cd(testCase.testDir)            
        end        
    end
    
    methods(TestClassTeardown)        
        function checkVisibilityRestored(testCase)
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
            testCase.assertEqual(get(0,'DefaultFigureVisible'),     ...
                                 testCase.OriginalDefault);
        end
    end
    
    methods(Test)        
        function testRM3_Marker(testCase)
            cd RM3
            wecSim
        end               
    end    
end

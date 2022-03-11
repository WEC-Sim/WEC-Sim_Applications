classdef TestWaveMarkerRM3 < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("RM3/hydroData")
        h5Name = 'rm3.h5'
        outName = 'rm3.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestWaveMarkerRM3
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
            if isfile(testCase.h5Name)
                fprintf('runBemio skipped, *.h5 already exists\n')
            else
                hydro = struct();
                hydro = readWAMIT(hydro,testCase.outName,[]);                 
                hydro = radiationIRF(hydro,30,[],[],[],[]);
                hydro = excitationIRF(hydro,30,[],[],[],[]);            
                writeBEMIOH5(hydro)
            end
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

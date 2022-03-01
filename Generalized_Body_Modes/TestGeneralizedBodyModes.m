classdef TestGeneralizedBodyModes < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("hydroData")
        h5Name = 'barge.h5'
        outName = 'WAMIT/barge.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestGeneralizedBodyModes
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
                hydro = radiationIRF(hydro,100,[],[],[],20);
                hydro = radiationIRFSS(hydro,[],[]);
                hydro = excitationIRF(hydro,100,[],[],[],30);            
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
        function testGeneralized_Body_Modes(testCase)
            wecSim
        end        
    end    
end

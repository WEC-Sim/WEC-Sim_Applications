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
            hydro = struct();
            hydro = Read_WAMIT(hydro,testCase.outName,[]);            
            hydro = Radiation_IRF(hydro,100,[],[],[],20);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,100,[],[],[],30);            
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
        function testGeneralized_Body_Modes(testCase)
            wecSim
        end        
    end    
end

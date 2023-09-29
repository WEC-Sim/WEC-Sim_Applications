classdef TestPassiveYawNWaves < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("hydroData")
        h5Name = 'oswec.h5'
        outName = 'oswec.out'
    end    
    

    methods (Access = 'public')        
        function obj = TestPassiveYawNWaves
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
                bemio
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
        function testPassiveYawNWaves(testCase)
           
            wecSim
        end        
    end    
end

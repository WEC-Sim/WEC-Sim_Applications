classdef TestMOST < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Name = 'Volturn15MW_wamit.h5'
    end    
    
    methods (Access = 'public')        
        function obj = TestMOST
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
        function runMostIO(testCase)
            if isfile(testCase.h5Name)
                fprintf('runMostIO skipped, *.h5 already exists\n')
            else
                mostIO
            end        
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
        function testMOST(testCase)
            wecSim
        end        
    end    
end

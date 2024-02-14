classdef TestMultipleConditionRuns < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../_Common_Input_Files/RM3/hydroData/'
        h5Name = 'rm3.h5'
        outName = 'rm3.out'
    end
        
    methods (Access = 'public')        
        function obj = TestMultipleConditionRuns
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
    
    methods(TestMethodTeardown)
        function returnHome(testCase)
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
        function testRM3_MCROPT1(testCase)
            cd RM3_MCROPT1
            wecSimMCR
        end        
        function testRM3_MCROPT2(testCase)
            cd RM3_MCROPT2
            wecSimMCR
        end        
        function testRM3_MCROPT3(testCase)
            cd RM3_MCROPT3
            wecSimMCR
        end        
        function testRM3_MCROPT3_SeaState(testCase)
            cd RM3_MCROPT3_SeaState
            wecSimMCR
        end        
    end    
end

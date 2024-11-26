classdef TestOWC < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = 'hydroData'
        h5Name = 'test17a.h5'
    end
    
    methods (Access = 'public')
        function obj = TestOWC
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
        function testOWC(testCase)
            wecSim
        end
        function testOWC_MCR(testCase)
            wecSimMCR
        end
    end
end
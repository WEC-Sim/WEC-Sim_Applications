classdef TestOWC < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5DirOrifice = 'hydroData'
        h5NameOrifice = 'test17a.h5'
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
        function runBemioOrifice(testCase)
            cd(testCase.h5DirOrifice);
            if isfile(testCase.h5NameOrifice)
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
        function testOWCOrifice(testCase)
            wecSim
        end
    end
end
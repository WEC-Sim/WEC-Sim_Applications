classdef TestMooring < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../_Common_Input_Files/RM3/hydroData/'
        h5Name = 'rm3.h5'
        outName = 'rm3.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestMooring
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
        function removeProjectFolder(~)
            d = dir('**');
            d = d([d.isdir]);
            d = d(string({d.name})=="slprj");
            for i = 1:length(d)
                rmdir(fullfile(d(i).folder, d(i).name), 's')
            end
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
        function testMoorDyn(testCase)
            isCI = strcmpi(getenv("GITHUB_ACTIONS"), "true");
            testCase.assumeFalse(isCI, "Skipping MoorDyn test on GitHub CI");
            assumeEqual(testCase,                           ...
                        exist("MoorDyn_caller", "file"), 2, ...
                        "MoorDyn is not installed");
            cd MoorDyn
            wecSim
            close_system('RM3MoorDyn',0)
            cd(testCase.testDir)
        end        
        function testMooringMatrix(testCase)
            cd MooringMatrix
            wecSim
            close_system('RM3MooringMatrix',0)
            cd(testCase.testDir)
        end        
    end    
end

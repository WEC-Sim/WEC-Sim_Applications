classdef TestOWC < matlab.unittest.TestCase

    properties
        OriginalDefault
        testDir
        h5DirOrifice = ['OrificeModel',filesep,'hydroData']
        h5NameOrifice = 'test17a.h5'
        h5DirFloating = ['FloatingOWC',filesep,'hydroData']
        h5NameFloating = 'floatingOWC.h5'
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
        function removeProjectFolder(~)
            d = dir('**');
            d = d([d.isdir]);
            d = d(string({d.name})=="slprj");
            for i = 1:length(d)
                rmdir(fullfile(d(i).folder, d(i).name), 's')
            end
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
        function runBemioFloating(testCase)
            cd(testCase.h5DirFloating);
            if isfile(testCase.h5NameFloating)
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
            cd('OrificeModel')
            wecSim
            close_system('OWC_GBM',0)
        end
        function testOWCFloating(testCase)
            isCI = strcmpi(getenv("GITHUB_ACTIONS"), "true");
            testCase.assumeFalse(isCI, "Skipping MoorDyn test on GitHub CI");
            assumeEqual(testCase, exist("MoorDyn_caller", "file"), 2, ...
                "MoorDyn is not installed");
            cd('FloatingOWC')
            wecSim
            close_system('OWC_rigid',0)
        end
    end
end
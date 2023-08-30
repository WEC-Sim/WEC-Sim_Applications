classdef TestMOST < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir = ''
        hydroDataDir = 'hydroData';
        h5Name = 'Volturn15MW_wamit.h5';
        mostDataDir = 'mostData';
        turbSimName = fullfile('turbSim','WIND_11mps.mat');
        openCompare = []  % 1 opens all new run vs. stored run plots for comparison of each solver
        constant
        turbulent
    end
    
    methods (Access = 'public')
        function obj = TestMOST(openCompare)
            arguments
                openCompare (1,1) double = 1
            end

            obj.openCompare = openCompare;
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.OriginalDefault = get(0,'DefaultFigureVisible');            
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
        function runBEMIO(testCase)
            cd(testCase.hydroDataDir);
            if isfile(testCase.h5Name)
                fprintf('runBEMIO skipped, *.h5 already exists\n');
            else
                bemio
            end
            cd(testCase.testDir)
        end
        function runMOSTIO(testCase)
            if isfile(testCase.turbSimName)
                fprintf('runMOSTIO skipped, turbSim/*.mat already exists\n');
            else
                mostIO
            end
        end
        function runConstantTest(testCase)
            cd(fullfile(testCase.testDir,'constant'))
            runLoadConstant;
            testCase.constant = load('constant.mat').("constant");
            cd(testCase.testDir);
        end
        function runTurbulentTest(testCase)
            cd(fullfile(testCase.testDir,'turbulent'))
            runLoadTurbulent;
            testCase.constant = load('turbulent.mat').("turbulent");
            cd(testCase.testDir);
        end
    end
    
    methods(TestClassTeardown)
        function checkVisibilityRestored(testCase)
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
            testCase.assertEqual(get(0,'DefaultFigureVisible'),...
                                 testCase.OriginalDefault);
        end
    end
    
    methods(Test)
        function testMOST(testCase)
            wecSim
        end
    end
end

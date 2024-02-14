classdef TestMOST < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir = ''
        hydroDataDir = '../hydroData';
        h5Name = 'VolturnUS15MW_nemoh.h5';
        mostDataDir = '../mostData';
        turbSimName = fullfile('turbSim','WIND_11mps.mat');
        plotComparison = []  % 1 plots a comparison of new and original cases
        constant = []
        turbulent = []
    end
    
    methods (Access = 'public')
        function obj = TestMOST(plotComparison)
            arguments
                plotComparison (1,1) double = 0
            end
            obj.plotComparison = plotComparison;
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
            cd(testCase.mostDataDir);
            if isfile(testCase.turbSimName)
                fprintf('runMOSTIO skipped, turbSim/*.mat already exists\n');
            else
                mostIO
            end
            cd(testCase.testDir)
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
            testCase.turbulent = load('turbulent.mat').("turbulent");
            cd(testCase.testDir);
        end
    end
    
    methods(TestClassTeardown)
        function plotTests(testCase)
            % Plot Old vs. New Comparison
            if testCase.plotComparison == 1
                plotTests(testCase.constant.newCase,testCase.constant.orgCase);
                plotTests(testCase.turbulent.newCase,testCase.turbulent.orgCase);
            end
        end
        function checkVisibilityRestored(testCase)
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
            testCase.assertEqual(get(0,'DefaultFigureVisible'),...
                                 testCase.OriginalDefault);
        end
    end
    
    methods(Test)
        
        function constant_bodyHeave(testCase)
            % Body heave
            tol = 1e-4;
            org = testCase.constant.orgCase.heave;
            new = testCase.constant.newCase.heave;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Body heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end

        function constant_bodyPitch(testCase)
            % Body pitch
            tol = 1e-4;
            org = testCase.constant.orgCase.pitch;
            new = testCase.constant.newCase.pitch;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Body pitch, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function constant_bladePitch(testCase)
            % Blade pitch
            tol = 1e-4;
            org = testCase.constant.orgCase.bladePitch;
            new = testCase.constant.newCase.bladePitch;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Blade pitch, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function constant_towerBaseLoad(testCase)
            % Tower Base Load
            tol = 3e-2;
            org = testCase.constant.orgCase.towerBaseLoad;
            new = testCase.constant.newCase.towerBaseLoad;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Tower base load, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function constant_towerTopLoad(testCase)
            % Tower top load
            tol = 3e-2;
            org = testCase.constant.orgCase.towerTopLoad;
            new = testCase.constant.newCase.towerTopLoad;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Tower top load, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function constant_windSpeed(testCase)
            % Wind Speed
            tol = 1e-4;
            org = testCase.constant.orgCase.windSpeed;
            new = testCase.constant.newCase.windSpeed;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Wind speed, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end

        function turbulent_bodyHeave(testCase)
            % Body heave
            tol = 1e-4;
            org = testCase.turbulent.orgCase.heave;
            new = testCase.turbulent.newCase.heave;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Body heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end

        function turbulent_bodyPitch(testCase)
            % Body pitch
            tol = 1e-4;
            org = testCase.turbulent.orgCase.pitch;
            new = testCase.turbulent.newCase.pitch;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Body pitch, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function turbulent_bladePitch(testCase)
            % Blade pitch
            tol = 1e-4;
            org = testCase.turbulent.orgCase.bladePitch;
            new = testCase.turbulent.newCase.bladePitch;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Blade pitch, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function turbulent_towerBaseLoad(testCase)
            % Tower Base Load
            tol = 3e-2;
            org = testCase.turbulent.orgCase.towerBaseLoad;
            new = testCase.turbulent.newCase.towerBaseLoad;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Tower base load, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function turbulent_towerTopLoad(testCase)
            % Tower top load
            tol = 3e-2;
            org = testCase.turbulent.orgCase.towerTopLoad;
            new = testCase.turbulent.newCase.towerTopLoad;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Tower top load, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function turbulent_windSpeed(testCase)
            % Wind Speed
            tol = 1e-4;
            org = testCase.turbulent.orgCase.windSpeed;
            new = testCase.turbulent.newCase.windSpeed;
            testCase.verifyEqual(new,org,'RelTol',tol);
            fprintf(['Wind speed, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
    end
end

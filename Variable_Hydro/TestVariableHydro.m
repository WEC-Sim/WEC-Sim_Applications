classdef TestVariableHydro < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5DirPY = ['Passive_Yaw',filesep,'hydroData']
        h5NamePY = 'oswec_0.h5'
        outName = 'oswec.out'
        h5DirVM = ['Variable_Mass',filesep,'hydroData']
        h5NameVM = 'draft1.h5'

    end
    
    methods (Access = 'public')
        function obj = TestVariableHydro
            obj.testDir = fileparts(mfilename('fullpath'));
        end
    end
    
    methods (TestMethodSetup)
        function killPlots (~)
            set(0, 'DefaultFigureVisible', 'off');
        end
    end
    
    methods(TestClassSetup)
        function captureVisibility(testCase)
            testCase.OriginalDefault = get(0, 'DefaultFigureVisible');
        end
        function removeProjectFolder(~)
            d = dir('**');
            d = d([d.isdir]);
            d = d(string({d.name})=="slprj");
            for i = 1:length(d)
                rmdir(fullfile(d(i).folder, d(i).name), 's')
            end
        end
        function runBemioPY(testCase)
            cd(testCase.h5DirPY);
            if isfile(testCase.h5NamePY)
                fprintf('runBemio skipped, *.h5 already exists\n')
            else
                bemio
            end
            cd(testCase.testDir)
        end

        function runBemioVM(testCase)
            cd(testCase.h5DirVM);
            if isfile(testCase.h5NameVM)
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
            set(0, 'DefaultFigureVisible', testCase.OriginalDefault);
            testCase.assertEqual(get(0, 'DefaultFigureVisible'),    ...
                                 testCase.OriginalDefault);
        end 
    end
    
    methods(Test)
        function testPY(testCase)
            cd('Passive_Yaw')
            runCases
            close_system('OSWEC',0)
        end
        function testVM(testCase)
            cd('Variable_Mass')
            wecSim
            close_system('sphereVarMass',0)
        end
    end
    
end

classdef TestPassiveYaw < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../_Common_Input_Files/OSWEC/hydroData/'
        h5Name = 'oswec.h5'
        outName = 'oswec.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestPassiveYaw
            obj.testDir = fileparts(mfilename('fullpath'));
        end    
    end
    
    methods (TestMethodSetup)
        function killPlots (~)
            set(0,'DefaultFigureVisible','off');
        end
    end
    
    methods(TestClassSetup)
        function removeProjectFolder(~)
            d = dir('**');
            d = d([d.isdir]);
            d = d(string({d.name})=="slprj");
            for i = 1:length(d)
                rmdir(fullfile(d(i).folder, d(i).name), 's')
            end
        end
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
        function testPassiveYawOFF(testCase)
            cd('PassiveYawOFF')
            wecSim
            close_system('OSWEC',0)
        end        
        function testPassiveYawON(testCase)
            cd('PassiveYawON')
            wecSim
            close_system('OSWEC',0)
        end        
    end    
end

classdef TestControls < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../_Common_Input_Files/Sphere/hydroData/'
        h5Name = 'sphere.h5'
        outName = 'sphere.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestControls
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
        function testPassive(testCase)
            cd('Passive (P)')
            wecSim
            close_system('passive',0)
        end        
        function testReactive(testCase)
            cd('Reactive (PI)')
            wecSim
            close_system('reactive',0)
        end        
        function testLatching(testCase)
            cd('Latching')
            wecSim
            close_system('latchTime',0)
        end        
        function testDeclutching(testCase)
            cd('Declutching')
            wecSim
            close_system('declutch',0)
        end        
        function testMPC(testCase)
            cd('MPC')
            wecSim
            close_system('sphereMPC',0)
        end     
        function testReactiveWithPTO(testCase)
            cd('ReactiveWithPTO')
            wecSim
            close_system('reactiveWithPTO',0)
        end     
    end    
end

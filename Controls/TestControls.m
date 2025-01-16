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
        end
        function testReactive(testCase)
            cd('Reactive (PI)')
            wecSim
        end
        function testLatching(testCase)
            cd('Latching')
            wecSim
        end
        function testDeclutching(testCase)
            cd('Declutching')
            wecSim
        end
        function testMPC(testCase)
            cd('MPC')
            wecSim
        end
        function testReactiveWithPTO(testCase)
            cd('ReactiveWithPTO')
            wecSim
        end
    end
end

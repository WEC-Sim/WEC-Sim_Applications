classdef TestFreeDecay < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../_Common_Input_Files/Sphere/hydroData/'
        h5Name = 'sphere.h5'
        outName = 'sphere.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestFreeDecay
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
        function testFree_Decay_0m(testCase)
            cd('0m')
            wecSim
            cd(testCase.testDir)
        end        
        function testFree_Decay_1m(testCase)
            cd('1m')
            wecSim
            cd(testCase.testDir)
        end        
        function testFree_Decay_1m_ME(testCase)
            cd('1m-ME')
            wecSim
            cd(testCase.testDir)
        end        
        function testFree_Decay_3m(testCase)
            cd('3m')
            wecSim
            cd(testCase.testDir)
        end        
        function testFree_Decay_5m(testCase)
            cd('5m')
            wecSim
            cd(testCase.testDir)
        end        
    end    
end

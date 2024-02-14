classdef TestB2B < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../_Common_Input_Files/RM3/hydroData/'
        h5Name = 'rm3.h5'
        outName = 'rm3.out'
    end
        
    methods (Access = 'public')        
        function obj = TestB2B
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
        function testB2B_Case1(testCase)
            cd('B2B_Case1')
            wecSim
        end        
        function testB2B_Case2(testCase)
            cd('B2B_Case2')
            wecSim
        end        
        function testB2B_Case3(testCase)
            cd('B2B_Case3')
            wecSim
        end        
        function testB2B_Case4(testCase)
            cd('B2B_Case4')
            wecSim
        end        
        function testB2B_Case5(testCase)
            cd('B2B_Case5')
            wecSim
        end        
        function testB2B_Case6(testCase)
            cd('B2B_Case6')
            wecSim
        end        
    end    
end

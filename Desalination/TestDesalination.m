classdef TestDesalination < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../_Common_Input_Files/OSWEC/hydroData/'
        h5Name = 'oswec.h5'
        outName = 'oswec.out'
        hasH5 = false
    end
        
    methods (Access = 'public')        
        function obj = TestDesalination
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
            % Check for Simscape Fluids
            assumeEqual(testCase,                               ...
                        license('test', 'SimHydraulics'), 1,    ...
                        "Simscape Fluids is not available");            
            cd(testCase.h5Dir);
            if isfile(testCase.h5Name)
                fprintf('runBemio skipped, *.h5 already exists\n')
            else
                bemio
            end
            cd(testCase.testDir)            
            testCase.hasH5 = true;            
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
        function testDesalination(testCase)
            wecSim
            close_system('OSWEC_RO',0)
        end        
    end    
end

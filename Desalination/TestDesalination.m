classdef TestDesalination < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("hydroData")
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
        function runBemio(testCase)            
            % Check for Simscape Fluids
            assumeEqual(testCase,                               ...
                        license('test', 'SimHydraulics'), 1,    ...
                        "Simscape Fluids is not available");            
            cd(testCase.h5Dir);
            hydro = struct();
            hydro = Read_WAMIT(hydro,testCase.outName,[]);            
            hydro = Radiation_IRF(hydro,30,[],[],[],[]);
            hydro = Excitation_IRF(hydro,30,[],[],[],[]);            
            Write_H5(hydro)
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
        end        
    end    
end

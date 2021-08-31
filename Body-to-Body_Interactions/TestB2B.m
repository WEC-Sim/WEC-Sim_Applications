classdef TestB2B < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("hydroData")
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
            hydro = struct();
            hydro = Read_WAMIT(hydro,testCase.outName,[]);
            
            hydro = Radiation_IRF(hydro,60,[],[],[],[]);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,157,[],[],[],[]);
            
            Write_H5(hydro)
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
        
        function removeH5(testCase)
            delete(fullfile(testCase.h5Dir, testCase.h5Name));
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

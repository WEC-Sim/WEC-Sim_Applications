classdef TestPTOSimRM3 < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("hydroData")
        h5Name = 'rm3.h5'
        outName = 'rm3.out'
    end
    
    
    methods (Access = 'public')
        
        function obj = TestPTOSimRM3
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
        
%         function removeH5(testCase)
%             delete(fullfile(testCase.h5Dir, testCase.h5Name));
%         end
        
    end
    
    methods(Test)
        
        function testRM3_cHydraulic_PTO(testCase)
            cd('RM3_cHydraulic_PTO')
            wecSim
        end
        
        function testRM3_DD_PTO(testCase)
            cd('RM3_DD_PTO')
            wecSim
        end
        
        function testRM3_Hydraulic_PTO(testCase)
            cd('RM3_Hydraulic_PTO')
            wecSim
        end
        
    end
    
end

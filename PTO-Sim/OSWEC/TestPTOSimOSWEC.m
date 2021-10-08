classdef TestPTOSimOSWEC < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("hydroData")
        h5Name = 'oswec.h5'
        outName = 'oswec.out'
    end
    
    
    methods (Access = 'public')
        
        function obj = TestPTOSimOSWEC
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
            
            hydro = Radiation_IRF(hydro,30,[],[],[],[]);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,30,[],[],[],[]);
            
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
        
        function testOSWEC_Hydraulic_Crank_PTO(testCase)
            cd('OSWEC_Hydraulic_Crank_PTO')
            wecSim
        end
        
        function testOSWEC_Hydraulic_PTO(testCase)
            cd('OSWEC_Hydraulic_PTO')
            wecSim
        end
        
    end
    
end

classdef TestWECCOMP < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = "hydroData"
        h5Name = 'wavestar.h5'
        outName = 'wavestar.out'
    end
        
    methods (Access = 'public')        
        function obj = TestWECCOMP
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
            hydro = Radiation_IRF(hydro,2,[],[],[],[]);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,2,[],[],[],[]);            
            Write_H5(hydro)
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
        function testWECCCOMP_Fault_Implementation(testCase)
            wecSim
        end        
    end    
end

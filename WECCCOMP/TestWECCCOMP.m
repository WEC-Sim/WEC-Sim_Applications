classdef TestWECCCOMP < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = "hydroData"
        h5Name = 'wavestar.h5'
        outName = 'wavestar.out'
    end
        
    methods (Access = 'public')        
        function obj = TestWECCCOMP
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
                hydro = struct();
                hydro = readWAMIT(hydro,testCase.outName,[]);
                hydro = radiationIRF(hydro,2,[],[],[],[]);
                hydro = radiationIRFSS(hydro,[],[]);
                hydro = excitationIRF(hydro,2,[],[],[],[]);
                writeBEMIOH5(hydro)
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
        function testWECCCOMP_Fault(testCase)
            cd('WECCCOMP_Fault_Implementation')
            wecSim
        end
        function testWECCCOMP_MPC(testCase)
            cd('WECCCOMP_Nonlinear_Model_Predictive')
            wecSim
        end    
    end
end

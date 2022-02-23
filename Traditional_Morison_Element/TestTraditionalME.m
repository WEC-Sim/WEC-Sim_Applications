classdef TestTraditionalME < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = fullfile("hydroData")
        h5Name = 'monopile.h5'
        outName = 'monopile.out'
    end
        
    methods (Access = 'public')        
        function obj = TestTraditionalME
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
            hydro = readWAMIT(hydro,testCase.outName,[]);
            hydro.body = {'monopile'};            
            hydro = radiationIRF(hydro,30,[],[],[],15);
            hydro = radiationIRFSS(hydro,[],[]);
            hydro = excitationIRF(hydro,30,[],[],[],15);            
            writeBEMIOH5(hydro)
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
        function testTraditionalME(testCase)
            cd('morisonElement')
            wecSim
            cd(testCase.testDir)
        end        
        function testHydroBody(testCase)
            cd('hydroBody')
            wecSim
            cd(testCase.testDir)
        end        
    end    
end

classdef TestOSWECNonLinearViz < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = "hydroData"
        h5Name = 'oswec.h5'
        outName = 'oswec.out'
    end
        
    methods (Access = 'public')        
        function obj = TestOSWECNonLinearViz
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
    
    methods(TestClassTeardown)        
        function checkVisibilityRestored(testCase)
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
            testCase.assertEqual(get(0,'DefaultFigureVisible'),     ...
                                 testCase.OriginalDefault);
        end
        function removeVTK(testCase)
            rmdir(fullfile(testCase.testDir, 'vtk'), 's');
        end        
    end
    
    methods(Test)        
        function testParaview_Visualization_OSWEC_NonLinear_Viz(testCase)
            wecSim
        end        
    end    
end

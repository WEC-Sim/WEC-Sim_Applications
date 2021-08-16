classdef TestMoorDynViz < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = "hydroData"
        h5Name = 'rm3.h5'
        outName = 'rm3.out'
        hasH5 = false
    end
    
    
    methods (Access = 'public')
        
        function obj = TestMoorDynViz
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
            
            assumeEqual(testCase,                           ...
                        exist("MoorDyn_caller", "file"), 2, ...
                        "MoorDyn is not installed");
            
            cd(testCase.h5Dir);
            hydro = struct();
            hydro = Read_WAMIT(hydro,testCase.outName,[]);
            
            hydro = Radiation_IRF(hydro,60,[],[],[],[]);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,157,[],[],[],[]);
            
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
        
        function removeH5(testCase)
            if testCase.hasH5
                delete(fullfile(testCase.h5Dir, testCase.h5Name));
            end
        end
        
        function removeVTK(testCase)
            folderPath = fullfile(testCase.testDir, 'vtk');
            if testCase.hasH5 && exist(folderPath, 'dir')
                rmdir(folderPath, 's');
            end
        end
        
    end
    
    methods(Test)
        
        function testParaview_Visualization_RM3_MoorDyn_Viz(testCase)
            assumeError(testCase,                               ...
                        @() run("wecSim"),                      ...
                        'Simulink:Engine:CallbackEvalErr',      ...
                        'Expected failure');
        end
        
    end
    
end

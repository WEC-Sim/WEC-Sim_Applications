classdef TestMoorDynViz < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = '../../_Common_Input_Files/RM3/hydroData/'
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
            % Check for MoorDyn
            assumeEqual(testCase,                           ...
                        exist("MoorDyn_caller", "file"), 2, ...
                        "MoorDyn is not installed");            
            cd(testCase.h5Dir);
            if isfile(testCase.h5Name)
                fprintf('runBemio skipped, *.h5 already exists\n')
            else
                hydro = struct();
                hydro = readWAMIT(hydro,testCase.outName,[]);            
                hydro = radiationIRF(hydro,60,[],[],[],[]);
                hydro = radiationIRFSS(hydro,[],[]);
                hydro = excitationIRF(hydro,157,[],[],[],[]);            
                writeBEMIOH5(hydro)
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
        function removeVTK(testCase)
            folderPath = fullfile(testCase.testDir, 'vtk');
            if testCase.hasH5 && exist(folderPath, 'dir')
                rmdir(folderPath, 's');
            end
        end        
    end
    
    methods(Test)        
        function testParaview_Visualization_RM3_MoorDyn_Viz(testCase)
            wecSim
        end        
    end    
end

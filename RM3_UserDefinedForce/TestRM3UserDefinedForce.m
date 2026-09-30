classdef TestRM3UserDefinedForce < matlab.unittest.TestCase

    properties
        OriginalDefault
        testDir
    end

    methods (Access = 'public')
        function obj = TestRM3UserDefinedForce
            obj.testDir = fileparts(mfilename('fullpath'));
        end
    end

    methods (TestMethodSetup)
        function killPlots(~)
            set(0, 'DefaultFigureVisible', 'off');
        end
    end

    methods (TestClassSetup)
        function captureVisibility(testCase)
            testCase.OriginalDefault = get(0, 'DefaultFigureVisible');
        end
    end

    methods (TestClassTeardown)
        function checkVisibilityRestored(testCase)
            set(0, 'DefaultFigureVisible', testCase.OriginalDefault);
            testCase.assertEqual(get(0, 'DefaultFigureVisible'), ...
                                 testCase.OriginalDefault);
        end
    end

    methods (Test)
        function testRM3UserDefinedForceRuns(testCase)
            currentDir = pwd;
            cleanup = onCleanup(@() cd(currentDir));

            cd(testCase.testDir);

            wecSim
        end

        function testUserDefinedForceInput(testCase)
            F_ext_b1 = testCase.loadUserDefinedForce();

            % F_ext_b1 should be a generalized force/moment vector:
            % [Fx, Fy, Fz, Mx, My, Mz]
            testCase.verifyTrue(isnumeric(F_ext_b1), ...
                'F_ext_b1 should be numeric.');

            testCase.verifySize(F_ext_b1, [1 6], ...
                'F_ext_b1 should be a 1-by-6 force/moment vector.');

            testCase.verifyTrue(all(isfinite(F_ext_b1(:))), ...
                'F_ext_b1 should contain only finite values.');

            testCase.verifyTrue(norm(F_ext_b1) > 0, ...
                'F_ext_b1 should define a nonzero external force or moment.');
        end

        function testEquivalentForceMomentCouple(testCase)
            F_ext_b1 = testCase.loadUserDefinedForce();

            % Split generalized force into translational force and moment.
            % F_ext_b1 = [Fx, Fy, Fz, Mx, My, Mz]
            F = F_ext_b1(1:3).';
            M = F_ext_b1(4:6).';

            testCase.verifyTrue(norm(F) > 0, ...
                'F_ext_b1 should include a nonzero translational force.');

            applicationPoints = testCase.getApplicationPoints();

            for i = 1:size(applicationPoints, 1)
                % r_CG_P is the vector from the body CG to the force
                % application point P.
                r_CG_P = applicationPoints(i, :).';

                % Force applied at P, represented as an equivalent wrench
                % about the body CG.
                wrenchFromForceAtPoint = ...
                    testCase.forceAtPointToWrenchAtCG(F, M, r_CG_P);

                % Same force applied at the body CG, plus equivalent moment
                % r_CG_P x F.
                equivalentForceMomentCoupleAtCG = [
                    F
                    M + cross(r_CG_P, F)
                ];

                testCase.verifyEqual(wrenchFromForceAtPoint, ...
                                     equivalentForceMomentCoupleAtCG, ...
                                     'AbsTol', 1e-12);
            end
        end
    end

    methods (Access = private)
        function F_ext_b1 = loadUserDefinedForce(testCase)
            currentDir = pwd;
            cleanup = onCleanup(@() cd(currentDir));

            cd(testCase.testDir);

            run('wecSimInputFile.m');

            testCase.assertTrue(exist('F_ext_b1', 'var') == 1, ...
                'F_ext_b1 should be defined in wecSimInputFile.m.');
        end

        function applicationPoints = getApplicationPoints(~)
            % Representative application points in the model Cartesian
            % coordinate system. Each row is [x, y, z] in meters and
            % represents an offset from the body CG to force application
            % point P.
            %
            % These are not RM3-specific geometry points. They are used to
            % verify the equivalent force-moment relationship for multiple
            % possible offsets.
            applicationPoints = [
                 0.0,  0.0,  0.0
                 1.0,  0.0,  0.0
                 0.0,  1.0,  0.0
                 0.0,  0.0,  1.0
                -1.0,  0.0,  0.0
                 0.0, -1.0,  0.0
                 0.0,  0.0, -1.0
                 1.0,  1.0,  0.0
                 1.0,  0.0,  1.0
                 0.0,  1.0,  1.0
                 2.0, -1.0,  0.5
                -0.5,  3.0, -1.0
            ];
        end

        function wrench = forceAtPointToWrenchAtCG(~, F, M, r_CG_P)
            % Equivalent wrench at the body CG for a force F applied at
            % point P:
            %
            % M_CG = M + r_CG_P x F

            wrench = [
                F
                M + cross(r_CG_P, F)
            ];
        end
    end
end
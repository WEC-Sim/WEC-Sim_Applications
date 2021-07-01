function results = runTests(testsPath)

    arguments
        testsPath string = "."
    end
    
    import matlab.unittest.TestSuite;
    import matlab.unittest.TestRunner;
    
    suite = TestSuite.fromFolder(testsPath, ...
                                 'IncludingSubfolders', true);
    
    % Build the runner
    runner = TestRunner.withTextOutput;
    
    % Run the tests
    results = runner.run(suite);
    
end

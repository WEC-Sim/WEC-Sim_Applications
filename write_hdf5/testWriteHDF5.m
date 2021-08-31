function tests = testWriteHDF5
    tests = functiontests(localfunctions);
end

function testcreate_hdfile(testCase)
    run('create_h5File.m')
end

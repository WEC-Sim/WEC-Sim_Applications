function tests = testWriteHDF5
    tests = functiontests(localfunctions);
end

function testcreate_hdfile(testCase)
    run('writeCustomH5.m')
end

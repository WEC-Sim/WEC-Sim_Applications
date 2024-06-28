# WEC-Sim_Applications

Branch `main`:

[![main build status](https://github.com/WEC-Sim/WEC-Sim_Applications/actions/workflows/process-events.yml/badge.svg?branch=main)](https://github.com/WEC-Sim/WEC-Sim_Applications/actions/workflows/process-events.yml)

Branch `dev`:

[![dev build status](https://github.com/WEC-Sim/WEC-Sim_Applications/actions/workflows/process-events.yml/badge.svg?branch=dev)](https://github.com/WEC-Sim/WEC-Sim_Applications/actions/workflows/process-events.yml)

This repository contains applications of the WEC-Sim code, including tutorials by the WEC-Sim team as well as user-shared examples.

To contribute an example follow these guidelines:

* Create a new branch off the `dev` branch.
* Create a folder on the top level with a single example (folders starting with a dot or underscore are ignored).
* Do not include results as these take up space and can easily be generated by running the example.
* Using the *README_template.md* file create a *README.md* file for your example. Include the example name, the author, WEC-Sim version, and description.
* Using the TestB2B.m test as a template, create a *TestCASE.m* file that will run BEMIO and check the functionality of your application when changes are made to the WEC-Sim source code.
* Include any required MATLAB toolboxes in a text file called `products.txt`. Use one line per toolbox and use the same naming conventions as described for the `products` input to the [Setup MATLAB][106] action.
* Create a [pull request][101] against the `dev` branch. The WEC-Sim team will review your example and add it to the repo.

## Testing Applications

Tests are provided for the applications using the MATLAB [unit testing 
framework][102].

Individual test files are typically found at the same level as a `hydroData`
directory, with a file name like `Test<Something>.m`. These test files may test 
multiple application cases that use the same hydrodynamic data.

For the latest release of WEC-Sim_Applications, or the `main` branch, it is 
assumed that the latest release or `main` branch of [WEC-Sim][103] is 
installed. For tests containing the name "MoorDyn", it is also necessary to 
install the [MoorDyn][104] module into WEC-Sim. The tests in the 
`Desalination` folder require the [Simscape Fluids][105] toolbox.

Assuming that the WEC-Sim_Applications source code is located at some path
`\path\to\WEC-Sim_Applications`, then to test the Body-to-Body Interaction
application cases, the following commands can be given in the MATLAB interface:

```
>> cd \path\to\WEC-Sim_Applications\Body-to-Body_Interactions
>> runtests("TestB2B.m")
...
```

Alternatively, the `TestB2B.m` file can be opened in the MATLAB editor and 
then the tests can be run by selecting the `Run Tests` action in the `EDITOR` 
ribbon.

A shortcut for running all the tests in the repository is provided at the 
root level with the `wecSimAppTest.m` function. This function can be run from 
the root directory, as follows:

```
>> cd \path\to\WEC-Sim_Applications
>> wecSimAppTest
...
```

Alternatively, the function can also be used to run tests in a particular 
directory. For instance, run the tests in the `End_Stops` directory as follows:

```
>> wecSimAppTest End_Stops
...
```

[101]: https://help.github.com/articles/using-pull-requests/
[102]: https://uk.mathworks.com/help/matlab/matlab-unit-test-framework.html
[103]: https://github.com/WEC-Sim/WEC-Sim
[104]: https://github.com/WEC-Sim/MoorDyn
[105]: https://www.mathworks.com/products/simscape-fluids.html
[106]: https://github.com/matlab-actions/setup-matlab?tab=readme-ov-file#set-up-matlab

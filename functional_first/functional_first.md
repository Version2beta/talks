# Functional first refactoring for issue tickets

0. Identify the suspected problem code.
0. Isolate business logic from side effects by moving the logic as completely as possible to its own function.
0. Make the function as pure as possible within the limitations of the language.
0. Write a failing regression test that demonstrates the issue.
0. Write characterization tests that demonstrate the expected behaviors of the new function.
0. Modify the function to resolve the issue and pass the regression test.
0. Follow the replication steps to ensure that the issue is resolved.
0. Refactor the function to reduce complexity and improve maintainability.
0. Verify the regression and characterization tests are passing.
0. Ship it!

From "Don't Comment Your Code":

> 

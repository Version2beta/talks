# Functional first development

* Functional first development is basically the application of some functional programming principals to languages that aren't typically considered "functional".
* We can use these low hanging fruit in both greenfield and brownfield projects, with one of the best benefits coming in refactoring.
* Functional first development offers a lot to our programming:
  * Reduces complexity, makes it easier to reason about our code
  * Makes testing easier, faster, and more reliable
  * Teaches the fundamental concepts behind functional programming
  * Moves us closer to the benefits of functional programming

## Why be functional?

* Simple, demonstrably correct code
* What is complexity?
  * Complexity is code that can be, but hasn't been, decomposed into simpler components
  * Complexity is the degree to which one software component is dependent on other software components.
  * Complexity is the enemy of reliability. Complexity and reliability are inversely proportional.
  * Complexity is the part of our code that isn't beautiful. Beauty is the ultimate defense against complexity.
  * Complexity is code, all code. Fred Brooks split code into "accidental" and "essential" complexity, but that just demonstrates that all code is complexity. If we could meet our goals without code, we would.
* Why is complexity bad?
  * Two kinds of reasoning:
    * Informal reasoning, where we get into the code and poke around, try to figure out what it does
    * Formal reasoning, where we apply math and logic to prove that code will always produce a correct result
  * Complex code is difficult to reason about informally.
    * We spend more time and money maintaining code than writing it.
    * Complexity dramatically increases the cost of maintenance.
    * Complexity builds on complexity. If we can't understand the code we're maintaining, our work on that code will almost always increase the complexity of the code.
  * It's difficult or impossible to demonstrate that complex code is correct.
    * The testing story is convoluted by stubs, fakes, and mocks
    * Our typical methods of testing focus on proving a few data points, and count on us to pick the right ones.
    * Maybe we have the benefit of a type system, and compile-time checks.
    * Proving correctness can go further. Pure functions give us the benefit of math and logic, where mutable and global state make the math too complex.
* The simplicity test
  * The inverse of "why complexity is bad"
  * Works for thinking about code, patterns, languages, even paradigms like OO and FP
  * Can we reason - informally - about our code?
  * Can we demonstrate the correctness of our code?
* Functional programming
  * Not the only way to write simple code.
    * OO code trends toward complexity.
    * Even well written OO code rots. Encapsulation offers a convenient hiding place for complexity, especially with production code, under deadline, and without tests.
  * Functional programming makes simple easier.
    * FP programs resist the trend toward complexity.
    * 
* Functions
  * 

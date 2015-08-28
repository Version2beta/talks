**Outline**

* Major premise: All programming should drive toward simplicity, and functional programming is simpler.
* Approach: Define complexity and simplicity. Attach them to the design of programming languages. Demonstrate that functional programming languages offer simplicity.

1. Complexity is the enemy of good programming. Simplicity is the goal.

  * Complexity
    * What is complexity?
      * Complexity is the morphology of software - that is, its form and structure.
      * Complexity is the interrelationships and dependencies of software components, demonstrated by the impact one component may have on another.
      * Complexity is any code that can be, but hasn't been, decomposed into simple components.
      * Complexity is the part of our code that isn't beautiful. Beauty is the ultimate defense against complexity.
      * Complexity is the enemy of reliability.
    * Why complexity is bad
      * We can't reason about our software.
      * We can't test our software.
      * We can't prove our software.
      * Ergo, we can't trust it.
    * Types of complexity
      * Essential complexity - The required inputs and outputs
      * Accidental complexity - Everything else, including the program itself

  * Informal reasoning
    * Understanding a system from the inside
    * Concerned with function
    * Leads to fewer errors being created

  * Testing
    * Understanding a system from the outside
    * Leads to more errors being detected
    * Some limits of testing
      * Each test demonstrates correctness for only one set of inputs*
      * State complicates testing drastically. A mere 24 bytes of state, 6 32-bit words, contains more possible states than there are atoms in the earth.
      * Testing only demonstrates correctness in the code, not in the specification

  * Formal reasoning
    * Concerned with form; formal proof
    * "Form follows function"
    * Correctness
      * Functional correctness: inputs and outputs
      * Partial correctness: If the program terminates, it will give the correct answer.
      * Total correctness: The program will terminal and will return the correct answer.
      * Formal proof of correctness can only be proven mathematically if both the algorithm and the specification are also given formally; i.e. mathematically.
    * Formal methods for proving correctness exist, but are outside the scope of this presentation.

  * So what is simplicity?
    * We can reason about it
    * We can test it
    * We can prove it

2. Programming languages inform the design of programs.
  * Imperative versus declarative languages
    * Imperative and declarative communication patterns
    * Imperative programming changes the state of something
    * Declarative programming describes relationships and then answers questions about them
  * Control
    * All control is complexity
    * Behaviors and functions
  * State across time
    * In imperative languages, the current state typically defines identity. That state is changed by code. Identity is timeless; the only state we can get from it is "now". When we have multiple parts of the code changing state, as complexity increases it can be difficult to guess what values we'll get.
    * In declarative languages, state doesn't change because values don't change. We don't say that the value of a variable changes any more than we'd say the value of 1 changes. Identity is a collection of states, each transformed into the next, passed to a function or an actor only when a transformation is needed. Time is inherent; even if we throw out previous states, they still existed as separate entities.
  * Languages and simplicity
    * We don't move from simple to complex. Our job is to control complexity, to model an inherently complex world in the simplest possible ways. Languages can help us do that.
    * The simplicity test for languages
      * Does it help us to create code we can reason about?
      * Does it help us to create code we can test?
      * Does it help us to create code we can prove?
    * Some corollaries
      * Power corrupts. The ability to allocate memory, manipulate pointers, or manage garbage collection is sometimes needed, but on the whole it leads to a more complex system, not a simpler one.
      * Flexibility is a slippery slope. An unopinionated programming language might let you choose to be declarative or imperative, to mutate or not, to use functions or classes. The result is that you have the flexibility to build more complex systems.
      * There are exceptions, of course. We typically use lower level, flexible, powerful languages to build opinionated, more restrained languages.

3. Functional programming is an effective tool for writing simpler programs.
  * First, a little about functions
    * Almost every programming language has functions. In functional programming, functions are the stars, not the supporting players.
    * Pure functions have exactly one result for any given input and do not generate side-effects. The result of a call to a pure function can replace the call itself for any given value (referential transparency).
    * Functions can be made of functions (composition), and have functions passed to them as inputs (higher order functions).
    * Testing pure functions is super easy.
    * Distributing pure functions is super easy. Because a pure function will always return the same value when given the same inputs, it makes no difference where we run it.
    * Parallelizing pure functions is super easy. Two functions that don't rely on the output from each other can always run in parallel.
    * Even faster than parallizing functions is to never run them. We don't have to evaluate a function before it's needed.
    * Simplicity test
      * Can we reason about it? Yes. You have an input, and you have an output, and the same input always generates the same output. If the essential complexity of a function is significant, we can build that function out of smaller, simpler functions.
      * Can we test it? Yes. You have an input, and you have an output, and the same input always generates the same output.
      * Can we prove it? Maybe. Functional programming is based on Lambda calculus and as such, follows a provable theorem. In fact, both Lambda calculus and Turing machines were created in large part as a way to determine whether a calculation is computable. Turns out it is possible to write functions that will never return, and it isn't always be possible to tell the difference between a function that will never return, and one that just hasn't returned *yet*. Then there's the complexity of the software itself still. A short function may be provable. A long program may also be provable, given infinite amount of time and effort.

  * State
    * Immutable state and transformations
    * Simplicity test
      * Can we reason about it? Yes, because state is typically an input to, and an output from a function, and we can reason about the functions.
      * Can we test it? Yes, see above.
      * Can we prove it? Yes, to the extent we can prove our functions are correct.

  * What about side effects?
    * We need side effects. To have side effects is to change the world. Sooner or later we want to change the world. (Later is better.)
    * Functional core, imperative shell. Remember the communication patterns, 80% declarative, 20% imperative?
    * Simplicity test
      * Can we reason about it? Yes, we can often reason about it. 
      * Can we test it? Not really, but we can mock up how we think the external world is going to work and see how our programs interact with that. By isolating our side effects and imperative programming, we limit the amount of work we need to do mocking the real world. 
      * Can we prove it? Nope. This is a characteristic of imperative anything. You can imperatively insist on stuff all day long, but in the end, we don't run the world. 

  * Functional programming metaphors
    * Pipeline or assembly line
      * Really just function composition
      * This is the basis of functional programming, build programs from larger functions built of smaller functions. It's functions all the way down.
        * `c ( b ( a ) )`
        * c, b, a are factors, btw, as in the things we refactor
        * Easy to parallelize, easy to be lazy
        * Sometimes done by concatenation
          * `a b c` in Forth
          * `a |> b |> c` in Elixir
    * Concurrency-oriented programming (Robert Armstrong)
      * My summary
        * The world is a stage, and we are but actors upon it.
        * We can't change the past.
        * We are hopelessly separate from each other, but we connect by passing messages between us.
        * We can't pick ourselves up when we crash, but we can watch out for each other.
      * Characteristics of concurrency oriented programming languages
        * COPLs must support processes, which can be thought of as a self-contained virtual machine.
        * Several processes operating on the same machine must be strongly isolated, so that a fault in one process shouldn't adversely affect another process unless that's the behavior we want - one process to detect failure in another process, and know why.
        * Each process must be identified by a unique unforgeable identifier. We will call this the Pid of the process.
        * Processes don't share state, they send messages. If you know the Pid of a process then you can send a message to the process. BUT message passing is assumed to be unreliable with no guarantee of delivery.
    * River (Rich Hickey, http://clojure.org/state and other places online)
      * "What I love most about rivers is / You can't step in the same river twice / the water's always changing, always flowing." - Rich Hickey (Pretty sure he said that.)
      * Many programs model things in the real world, so they need to support identity.
        * (One of) Rich Hickey's definitions for Identity: "A putative entity we associate with a series of causally related values or states over time."
        * My definition, as inspired by Rich Hickey: "Identity is a bunch of states over time that we associate with a thing."
          * Hickey's metaphor doesn't see the world as "becoming" in the way the catepillar becomes a beautiful butterfly. I think he sees it as being a series of unchangeable states over time, that we for our own convenience as beings stuck moving in a single direction and constant speed along the 'time' axis tend to think of as discrete objects. In Hickey's universe, not only is he unbound by time, but he can see how each thing can have its own timeline.

    * Mathematics (usually lambda calculus)
      * Lambda calculus and to a lesser extent, combinatorial logic are the mathematical basis of functional programming languages
      * Lisp (McCarthy, 1958; implemented by Steve Russell, who incidentally created the world's first video game) was basically an implementation of lambda calculus in a machine.


# Why we should programming more functionally





**Complexity**
~~~~~~~~~~~~~~

"The purpose of software engineering is to control complexity, not to create it." - Dr Pamela Zave, AT&T Labs

"Those who want really reliable software will discover that they must find means of avoiding the majority of bugs to start with." Djikstra, 1972

"[W]e have to keep it crisp, disentangled, and simple if we refuse to be crushed by the complexities of our own making." Djikstra, 1996, EWD1243a

**Simplicity**
~~~~~~~~~~~~~~

"Simplicity does not precede complexity, but follows it." - Alan J. Perlis

"Simplicity, carried to the extreme, becomes elegance." - Jon Franklin

"Those who want really reliable software will discover that they must find means of avoiding the majority of bugs to start with." Edsger Djikstra, 1972

"The price of reliability is the pursuit of the utmost simplicity.” - C. A. R. Hoare, 1980

"I conclude that there are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult." C. A. R. Hoare, 1980

"Our response to mistakes should be to look for ways that we can avoid making them, not to blame the nature of things." O’Keefe, 1990


**Reasoning**
~~~~~~~~~~~~~

"It is easier to write an incorrect program than understand a correct one." - Alan J. Perlis

"Software is like entropy: It is difficult to grasp, weighs nothing, and obeys the Second Law of Thermodynamics; i.e., it always increases." - Norman Augustine

"Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it." - Brian W. Kernighan

"[A] computer is a stupid machine with the ability to do incredibly smart things, while computer programmers are smart people with the ability to do incredibly stupid things.  They are, in short, a perfect match." - Bill Bryson

"If debugging is the process of removing bugs, then programming must be the process of putting them in." - Edsger Djikstra

**Testing**
~~~~~~~~~~~

"Trying to improve software quality by increasing the amount of testing is like trying to lose weight by weighing yourself more often." - Steve McConnell, *Code Complete*

"Program testing can be a very effective way to show the presence of bugs, but is hopelessly inadequate for showing their absence." - Edsger Dijkstra

**Languages**
~~~~~~~~~~~~~

"A language that doesn't affect the way you think about programming, is not worth knowing." - Alan J. Perlis

"The tools we use have a profound (and devious!) influence on our thinking habits, and, therefore, on our thinking abilities." - Edsger Dijkstra

"The fact is, programming language design revolves around program design. A language’s design reflects the opinions of its creators about the proper design of programs." - Reginald Braithwaite, http://raganwald.com/2014/12/20/why-why-functional-programming-matters-matters.html

"OO makes code understandable by encapsulating moving parts. FP makes code understandable by minimizing moving parts." - Michael Feathers, 2010 via Twitter

"Software is a gas; it expands to fill its container." - Nathan Myhrvold

"Lisp doesn't look any deader than usual to me." - David Thornley

"Lisp is still #1 for key algorithmic techniques such as recursion and condescension." - Verity Stob

"Take Lisp, you know it's the most beautiful language in the world -- at least up until Haskell came along." - Larry Wall (creator of Perl)



**Functional programming**
~~~~~~~~~~~~~~~~~~~~~~~~~~

"To iterate is human, to recurse divine." - L. Peter Deutsch

"In order to understand recursion, you must first understand recursion."

“Just pay me your money and hop right aboard!”
So they clambered inside. Then the big machine roared
And it klonked. And it bonked. And it jerked. And it berked
And it bopped them about. But the thing really worked!
When the Plain-Belly Sneetches popped out, they had stars!
They actually did. They had stars upon thars! 
...
“Belly stars are no longer in style,” said McBean.
“What you need is a trip through my Star-off Machine.
This wondrous contraption will take off your stars
So you won’t look like Sneetches who have them on thars.”
And that handy machine Working very precisely
Removed all the stars from their tummies quite nicely. 
~~~

"In the end, any program must manipulate state. A program that has no side effects whatsoever is a kind of black box. All you can tell is that the box gets hotter." - Simon Peyton-Jones, Haskell contributor and lead developer of GHC (Glasgow Haskell Compiler)


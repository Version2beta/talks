# That's My Monkey

Let's talk about simple, demonstrably correct code

-> What is simple?
-> What is correct?
-> The simple, demonstrably correct code review

Let's talk about programmers

-> The 10x programmer
-> Intern to senior in four years
-> Keep this in mind for everything coming

Let's talk about functions - Functional first refactoring

-> Isolate side effects and extract pure functions

Let's talk about programs - Functional first programming

-> Push side effects to the edges
-> Manage a pipeline

Let's talk about program architecture

-> Side effects are mostly IO - API endpoints, database calls
-> The pipeline in the middle is business logic
-> Changing or adding side effect layers is much more trivial

Let's talk about programming languages

-> Abstractions, garages, laws of the universe
-> Constrained languages, cognitive load, mastery, intern to senior in four
years

Let's talk about functional programming languages

-> Abstractions used in functional programming
-> Why is functional programming simple and demonstrably correct
-> Teaching functional programming to n00bs vs seniors
-> Migrating a team to functional programming

Let's talk about identity

-> Identity in OOP is the current state of an object's properties
-> Identity in FP is a collection of state over time

Let's talk about domains

-> The basics of Domain Driven Design
-> Front end domain problems
-> Back end domain problems

Let's talk about databases

-> CAP Theorem
-> Most databases are mutable
  - Relational databases treat data like OOP treats identity, and they tend to introduce complexity both in
normalization and in deployment (CA)
  - Most NoSQL also treat data like OOP treats identity, but they give us tunable CAP settings, denormalization, speed, and "web scale"
-> There are also immutable databases
  - See Nathan Marz' "How to beat the CAP theorem"
  - CR not CRUD
  - CRDTs?
  - Event stores and DDD
  - Event stores and command query responsibility segregation

Let's talk about architecture

-> Microservices
-> Reactive microservices
-> Composed reactive microservices
-> Interfaces as contracts

Let's talk about distributed computing

-> Distributed computing is hard, but it's also well researched and documented
-> Pure services are stateless, trivially distributed, highly available
-> Push the consistency problems to the experts - thin database layer
-> Push the partition tolerance problems to the experts - thin database layer
-> Consistency and partition tolerance also apply to messaging between services,
  so push that to the experts too, with a message broker
-> CAP theorem applies to our applications just as much as it applies to
databases

Let's talk about simple, demonstrably correct systems

-> Simple
  - Services as pure functions
  - Composable services
  - Immutable, no side effects
  - Contracts, DDD ubiquitous language and mental models
  - Easier to reason about the system as a whole
-> Demonstrably correct
  - Integration tests of a service are unit tests
  - Integration tests of composed services are unit tests
  - Thin side effect layers should only need contract testing
  - Easier to demonstrate the correctness (read: can be maintained more cheaply!) 

~~~~~~~~~~

Simple, demonstrably correct code

* Simple:
  * Single responsibility principle
  * Decoupled
  * Composable
  * Beautiful
  * Easy to reason about informally
* Demonstrably correct:
  * Easy to test, including generative and property-based testing
  * Easier to prove correctness
  * Easy to monitor

The 10x Programmer

* 10x the value, not 10x the code
* Value comes from good judgement
* Good judgement is compounding
* 25% more value per decision yields 10x the value

Programming languages

* What's an abstraction?
  * A technique for arranging complexity
* Some languages feel like they were built in someone's garage, because they
were
  * Multiple abstractions, like objects in Javascript, or Perl's TMTOWTDI
  * System languages are powerful, but who should wield that power?
  * Mastering the language requires mastering the various abstractions
  * Most developers have difficulty getting the best value out of the language
  * Solid practices mitigate complexity, but they don't eliminate it
* Some languages feel like they are based on laws of the universe, because they were. Very many of these are functional programming languages
  * Functional languages are based on mathematical abstractions: algebraic composition and typed lambda calculus plus some combination of combinatorial logic, set theory, type theory, and category theory.
  * As a result, functional programming typically implements these abstractions:
    * Pure functions, including referential transparency and no side effects
    * Immutability (or, are variables really just pure functions?)
    * Composability
    * Higher order (and first class) functions
    * Recursion
    * Some kind of type system
  * Functional programming languages are declarative (using expressions), and not a mixture of declarative and imperative (using expressions and statements).
  * "Pure" functional programming languages are constrained by these abstractions.
* Constrained languages maximize value from the whole team
  * Fewer abstractions to master
  * Fewer brain cycles spent remembering weird abstractions, inconsistencies, and gotchas
  * More energy available to spend on solving the problem

DDD:

* Quick overview of DDD
* The front end and the back end solve different domain problems
* Following the common model
* Using the ontology
  * Entities in our domain
  * Aggregate roots
  * Events and how to handle them

Event stores:

* The nature of identity in FP and OO
* Events in a DDD context
* Canonical, time-variant data
* Immutable (Create-Read) data
* Reductions and projections
* Projections as cache
* Quick overview of CQRS

NoSQL and Message Brokers:

* Distributed computing is hard
* Stateless applications, distributed data stores - don't reinvent the distributed computing wheel
* Denormalization as an optimization strategy

Functional first programming:

* Strategy:
  * First, program everything you can without side effects
  * Then, program your side effects
* Purely pure business logic
* Isolating side effects as a testing strategy
* Why not mutate?
* Feature workflow: Front end is all about the user's experience
  * Sketch out the user interface
  * Test it with mock data
  * Move the mock data to a side-effecting function (always at the edge)
  * Implement the service call
* Feature workflow: Back end is all about the integrity of the data
  * Implement the business logic
  * Test it with mock data
  * Move the mock data to the edge, and then to the database
  * Replace the mock data at the service edge with the business logic

Value:

* Functional first programming
  * Easy to reason about
  * Easy to demonstrate correctness
  * Delivers features iteratively for fast user feedback
  * Composable back ends
  * Separates domain problems for clearer focus
  * Back end supports any front end requiring the service (not isometric to front end)
* NoSQL and Message Brokers
  * Easy to reason about
  * Tested, demonstrably correct services
  * Distributed computing is probably not our core competency, so we have someone else do that
  * Buy Don't Build
* Event Stores
  * Easy to reason about
  * Easy to demonstrate correctness
  * Comparable performance to straight up cacheing
  * Isometric to identity in functional programming
  * Time variant data delivers more features
  * Very rich source of data for future value
* DDD
  * Easy to reason about
  * Collaboratively demonstrate correctness in the ubiquitous language and common model
  * Easy to identify where to deliver value
* All combined
  * Composable, reliable, correct, reasonable design
  * Dramatically reduce ongoing maintenance costs (long tail)


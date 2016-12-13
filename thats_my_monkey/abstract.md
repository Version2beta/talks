Title: That's My Monkey: A Functional, Reactive, Domain Driven Design, and Common Sense Approach To Architecture

Presenter: Rob Martin / version2beta

Abstract: Architecture is something we usually get for free from our web frameworks, and then struggle with as we try to keep servers standing when our projects succeed. There's a reason for this: the vast majority of our frameworks are based on patterns that worked in 2007 but don't match today's need for highly reliable, highly scalable applications. That's My Monkey explores an architecture based on domain driven design, event stores, distributed databases, message queues, and functional programming principles; then looks at how this architecture affects workflow, design, and the value delivered to the user and the business.

Notes:

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

DDD:

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

The 10x Programmer

* 10x the value, not 10x the code
* Value comes from good judgement
* Good judgement is compounding
* 25% more value per decision yields 10x the value

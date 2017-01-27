# That's My Monkey

## Let's talk about code

My mantra is "simple, demonstrably correct code". This entire article describes the tools and patterns we use to produce simple, demonstrably correct code. The reason for this mantra is also simple: I want to know that I can trust our code.

### What is complexity?

Before we explore what it means to be simple, here are some ideas about what it means to be complex.

**Complexity is any code that can be, but hasn't been, decomposed into simpler components.** "Methods can be no longer than five lines of code." (Sandi Metz' rules for developers)

**Complexity is the interrelationships and dependencies of software components.** Complexity is the degree to which on piece of software is dependent on any others.

**Complexity is the enemy of reliability.** Complexity and reliability are inversely proportional. "Simplicity is prerequisite for reliability." (Edsger W. Dijkstra) "The central enemy of reliability is complexity." (Dan Geer) "The price of reliability is the pursuit of the utmost simplicity." (Tony Hoare)

**Complexity is the part of our code that isn't beautiful.** "[W]hen I have finished, if the solution is not beautiful, I know it is wrong." (Buckminster Fuller) "Beauty is the ultimate defence against complexity." (Dan Gelertner)

**Complexity is code.** "The complexity of software is an essential property, not an accidental one." (Fred Brooks) "If we could accomplish our goals just as well without programming, we probably would." (Me.)

## Why is complexity bad? 

Complex code is difficult to reason about, either formally or informally. It's difficult to test, and difficult to tell whether we tested the right stuff. We might think our code is correct, but it's very difficult to trust complex code.

Tony Hoare said it much better than I can. "I conclude there are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult."

## What is simplicity?

The obvious answer to this is that simple code is code that isn't complicated. And that's a pretty good answer.

I have a test I use for evaluating code, whether it's code I wrote or my team wrote, or library code, or framework code, or a programming language, or even an entire programming paradigm, like object oriented programming or functional programming. My test goes like this:

1. Can I reason about this code?
2. Can I demonstrate this code is correct?
3. Can I trust this code?

If I can answer yes to all three of these questions, I feel confident my code won't only be simple, it will be less fragile and more maintainable (and significantly less expensive to maintain). The programming languages and techniques we tend to use produce code that rarely rots. The architectures that come out of the pursuit of simplicity also tend to scale well.

Our code reviews are based on the simplicity test. They have two steps:

1. We look at the tests, and see whether they demonstrate that the business objective has been met.
2. We look at the code under test, and see whether it is easy to reason about.

The simplicity test is useful for evaluating code, but I think it's even more useful for choosing the tools we use to create that code. For example, here is the simplicity test applied to functional programming:

**Can I reason about this code?** Yes. Functional programming can make it easier to reason about our code.
Referential transparency promises us that we can trust the result of our function calls. The results won't change based on anything but the arguments right in front of us. Function composition gives us a way to look at our code in different levels of abstraction, from the implementation details of each step, to the way the steps are put together. Immutable state ensures that we always know the value of things. If we transform data, we always get new data back. Side effects are isolated, leaving us with a very stable view of our system.

**Can I demonstrate this code is correct?** Yes. Yes. Functional programming makes unit testing very easy, and integration testing easier, and proving correctness possible. Referential transparency promises us that nothing but the arguments to a function will change the result of a function. If we write pure functions, we should never have to use mocks in our unit tests. Function composition with referential transparency gives us confidence that a program tested at a unit level will perform predictably. Side effects are isolated, and they're almost always limited to IO libraries. We don't need to unit test IO when it's isolated; the IO libraries come with their own unit tests. Functional programming is based on math, and math wouldn't be math if we couldn't prove it. "Programming is one of the most difficult branches of applied mathematics; the poorer mathematicians had better remain pure mathematicians." (Edsger Dijkstra)

**Can I trust this code?** If I can reason about it, and I can demonstrate it's correct, I'm far more likely to be able to trust this code.

## Let's talk about programmers

Alan Perlis said, "Everyone can be taught to sculpt: Michelangelo would have had to be taught how not to. So it is with great programmers." Henri Cartier Bresson said "Your first 10,000 photographs are your worst." So which is it? What makes a great programmer? What makes a senior programmer?

I don't think the answer has to do with the years of programming, or the hours, or the number of languages or projects or lines of code written. To me, what makes a good senior should be measured by how much value they can deliver.

### What is value?

Programming is a practical art. Very few of us do it for aesthetic reasons; by and large we create tools other people use to build richer lives.

The degree to which our tools meets that goal is how I define "value". How we as programmers deliver this value varies depending on where our product is in it's lifecycle.

For example, I have a theory that such a high percentage of software startups fail that it's useful to just round it up to "all". Under that presumption, it's good to fail as cheaply as possible, so we want to deliver value quickly and frequently so that we can validate it with real users - or toss it in the bin and take a different tact. The tools we use to deliver this value quickly are typically rapid application development environments built in scripting languages like Ruby, Python, and Javascript; monolithin frameworks; and readily available libraries. The code produced by this effort is often most charitably described as "expedient". But we can deliver value to a potential market quickly.

Once a product is proven in the market and we start to develop a significant user base, the short cuts we took up front start to matter. The code is hard to maintain. Bug fixes create new bugs. Our systems are fragile. We can't scale to meet demand. Getting through this phase is called "surviving our success".

At this point, our system architecture, application design, and software tests really start to matter. We need the architecture to remain stable. We need the design to allow us to scale horizontally. We need the tests to have confidence in the code we ship. The value we deliver in this phase tends to lean towards delivering the tool to many users more than creating the tool.

Assuming we have survived our success and refactored our application (sometimes rebuilding it from the ground up), we may have a mature application with a loyal base of users depending on it. The value we deliver in this phase tends toward delivering new features, solving issue tickets, incrementally refactoring problem areas, and removing our accumulated technical debt.

- The value of value
  * What is value when it comes to software?
  * Delivering value frequently
    * Value in a MVP
    * Value in an established application
    * Value in code maintenance, impact on lifecycle cost
  * Not delivering anti-value
    * Technical debt as a byproduct of Agile
    * Complexity
    * Untested code
- The 10x programmer
  * Ten decisions that compound
  * The average developer, 1.0^10
  * The 1.25x developer, 1.25^10
  * The 0.75x developer, 0.75^10

## Let's talk about functions

- Functions are referentially transparent.
- Functions can be composed of functions.
- Functions can be distributed.
- Functions can be arguments to other functions.
- Functions can be recursive.
- Functions can be evaluated lazily.

## Let's talk about functional first refactoring

- The big picture: Isolate side effects and extract pure functions
- Managing issues with legacy code
  * Extract business logic into a function, leaving behind side effects
  * Pass any variables need as arguments to the function
  * Write a failing test demonstrating the problem
  * Write passing characterization tests
  * Change the code to fix the failing test
  * Refactor to reduce complexity and improve maintainability

## Let's talk about functional first programming

- The plan
  * First, code everything you can without side effects
  * Then, code your side effects
- Advantages
  * Our business logic is purely functional, mostly written in the core language, and have fewer dependencies.
  * Our business logic is easy to unit test, and the tests run fast.
  * It's exceptionally easy to distribute (horizontally scale) our business logic.
  * Our side effects layer is *only* side effects. It doesn't need unit tests. It's easy to swap out. It's easy to add another interface.

## Let's talk about programming languages

- Abstractions, garages, laws of the universe
- Constrained languages, cognitive load, mastery, intern to senior in four
years

## Let's talk about functional programming languages

- Abstractions used in functional programming
- Why is functional programming simple and demonstrably correct
- Teaching functional programming to n00bs vs seniors
- Migrating a team to functional programming

## Let's talk about identity

- Identity in OOP is the current state of an object's properties
- Identity in FP is a collection of state over time

## Let's talk about domains

- The basics of Domain Driven Design
- Front end domain problems
- Back end domain problems

## Let's talk about program architecture

Here's an example. Let's say you're writing the back end of a website. The first thing I'd say is, "Don't do that." The domain problem we want to solve on the front end is different than the domain problem we're solving on the back end. The front end is strictly responsible for the experience of the user as they try to accomplish their goal. The back end is responsible for the integrity of the data, including the business logic.

Of course, there's no need to have only one back end. We can (and should) create one back end for each domain problem we need to solve, and group them within bounded contexts. There's also no reason to have only one front end. By decoupling the domains, we've made it so that the consumer of our back end services can be arbitrary. We can add a native mobile app to our web application, or innovate around our core competencies.

There's also no reason to have only one interface. Now that we've decoupled the back end from the front end, you can also abstract how the service is consumed. It may be HTTPS now, but later you might want to connect in other ways too. Queue worker. Websockets. Pubsub. Ports. Because our interface is all side effects, and our side effects are implemented using the thinnest possible wrapper around our business logic, it's trivial to add a new interface.

Pushing our side effects to the edges gives us many of the advantages of functional programming at an application scale:

* Our business logic is purely functional: referentially transparent and composable.
* It's exceptionally easy to distribute (horizontally scale) our business logic.
* Our business logic is *very* easy to unit test, and the tests run fast.
* Our side effects layer is *only* side effects, and since they are pretty much always implemented using someone else's library that has it's own unit tests, we don't write unit tests for the I/O layer, only integration tests. (Look Mom, no mocks!)
* Switching out how a side effect is implemented requires the absolute minimal amount of code. Adding another interface is just adding the interface, not refactoring logic. Changing a database is just a new library, not a complete rewrite of your models.

In short, we've created a back end service that is both simple and demonstrably correct.

## Let's talk about the front end

What about the front end? To start with, we can reiterate that the front end solves a different domain problem than the back end. The front end is strictly responsible for the user's experience as they meet the need that brought them to your application.

I've used two different patterns here that are very interesting:

### No Back End

If the front end is strictly responsible for the user's experience, and the user's experience is the most important thing in validating a new application, then why build a back end at all, before you know you're going to need it?

I hope it's not controversial to say that architecture and code quality sometimes suffer during the ideation and validation phases of product development. For a while I wanted to argue against this. After all, so many successful startups go through a phase I call "surviving their success", where they suddenly have lots of very interested users and the crappy code they wrote falls down, day after day, while they scramble to rewrite it in a more stable way. Typically, the original train wreck is built on a monolithic platform that's been around since 2005 or so. Often the rewrite is done in functional programming languages following functional architecture patterns.

When we start on a new application, or even a new company, there are some factors worth considering:

* The app isn't worth anything unless the target audience chooses to use it. We need their feedback.
* While we're figuring out what the users want, we may pivot the app multiple times. We may pivot the whole company multiple times.
* Most startups fail. Enough startups fail that I find it useful to round up to "all startups fail". We want to fail as quickly and as cheaply as possible.

We typically break new applications into three phases: ideation, validation, and growth.

* The ideation phase produces enough of an application to support discussion, but may or may not produce any code.
* The validation phase almost always produces code. We code the idea, put it in front of a potential user for feedback, and then either iterate or pivot. That is, we're building our application while we're figuring out what our application even does.
* The growth phase takes the product of the validation phase and tries to scale it out to meet business goals.

Have you noticed how the application is developed before we know what we're building, and the validation phase usually blends directly into the growth phase? I see a problem there. I think we build too much in the validation phase, and too little in the growth phase.

Some of my teams have started building applications without a back end at all until after the application been validated, which has some neat advantages. For example, we use only front end developers for the validation phase, and they focus almost exclusively on the user's experience - ignoring large parts of business logic that's not needed for validation, mocking business logic where we can, and being very expedient about the business logic we absolutely need in order to prove out an idea. Once the idea is validated and it comes time to write the back end for real, we get to focus on design and architecture that makes sense in the longer term.

In a more mature company, this pattern changes a little. Established companies have core competencies, and I like to see those competencies expressed as services. The last place I worked specialized in "Appreciation" - creating workplaces where employees feel appreciated. The place I work at now does machine learning, primarily targeting your typical business power user rather than for data scientists. In both cases, we built services that expose our core competencies, and deployed other services that provide more mundance functionality like authentication and messaging.

When our business already exposes our core competencies, we can innovate around them primarily by building new user experiences that remix our existing services.

### Building a house from the roof down

I lived for 18 years in Milwaukee, Wisconsin, a city known for a particular style of architecture called the "Polish flat". These houses were built primarily by Polish immigrants in the early 20th century in a curious way. When a couple could afford it and the family was young, they would build a one-storey house that met their current needs. Later, when they could afford more, they would jack that house up and build another storey underneath the first. They built their homes from the roof down.

We've started building back end services and front end applications from the top down. On front end applications, we start with the user's experience and work our way down to the API calls. On back end services, we start at the API and work into the business logic. On some projects with a team responsible for the full stack, we start building a new feature at the UX end and move down the stack to the service.

We build these applications "from the roof down".

Starting on the front end:

* We implement the user's experience of a new feature, backing it up with dummy data.
* Next, we replace the dummy data with application logic. The application logic fills out the user experience but relies on dummy data rather than real data coming from a service.
* Then we move the dummy data coming into our application logic to a stub function that will returns that same dummy data but will ultimately be responsible for calling the service and getting the real data.
* After that, we move the dummy data to a new HTTPS route that will ultimately be responsible for delivering the real data. Now we can implement a real call to the service from our application, and the feature is complete on the front end.

On the server side:

* Our last step above created a stubbed API route that returns dummy data.
* If our service has a persistence layer, our next step is to either retrieve whatever state we need from our data store, or create some dummy data as if it came from our data store.
* Next, we stub a pure function that takes information from the request and the stored state (which we may have mocked), and returns the dummy data. 
* Then we build out the business logic as a pure function, or a pipeline of pure functions, that accepts the request information and stored state (which we may have mocked), and returns the meaty part of our response and any new state data to store in the database.
* Finally, we implement whatever is left in persisting and retrieving our data, and our service is complete from data store to the user's eyeballs.

At the end of this process, we have one complete feature ready to deliver on the front end, and a related (but not tightly coupled) complete feature ready to deliver on the back end. We've built the minimum necessary to implement our feature, while staying within an architecture we can trust and reason about.

## Let's talk about databases

- CAP Theorem
- Most databases are mutable
  - Relational databases treat data like OOP treats identity, and they tend to introduce complexity both in
normalization and in deployment (CA)
  - Most NoSQL also treat data like OOP treats identity, but they give us tunable CAP settings, denormalization, speed, and "web scale"
- There are also immutable databases
  - See Nathan Marz' "How to beat the CAP theorem"
  - CR not CRUD
  - CRDTs?
  - Event stores and DDD
  - Event stores and command query responsibility segregation

## Let's talk about architecture

- Microservices
- Reactive microservices
- Composed reactive microservices
- Interfaces as contracts

## Let's talk about distributed computing

- Distributed computing is hard, but it's also well researched and documented
- Pure services are stateless, trivially distributed, highly available
- Push the consistency problems to the experts - thin database layer
- Push the partition tolerance problems to the experts - thin database layer
- Consistency and partition tolerance also apply to messaging between services,
  so push that to the experts too, with a message broker
- CAP theorem applies to our applications just as much as it applies to
databases

## Let's talk about simple, demonstrably correct systems

- Simple
  - Services as pure functions
  - Composable services
  - Immutable, no side effects
  - Contracts, DDD ubiquitous language and mental models
  - Easier to reason about the system as a whole
- Demonstrably correct
  - Integration tests of a service are unit tests
  - Integration tests of composed services are unit tests
  - Thin side effect layers should only need contract testing
  - Easier to demonstrate the correctness (read: can be maintained more cheaply!) 

~~~~~~~~~~


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


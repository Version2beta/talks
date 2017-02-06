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

Delivering the right value at the right time gets us into the market, but our current methods also tend to deliver a fair amount of "anti-value". It's as if the decisions we make at each phase create the challenges we must solve in the next phase of our product's life.

* Monolithic code is rigid, tightly coupled between the front and back ends, often fragile, and tends toward complexity.
* Untested (or inadequately tested) software is harder to work with and tends to get shipped with more bugs.
* Agile methodologies focus on prioritizing features through an iterative (and explorative) process that also creates technical debt. Resolving that technical debt tends to have a much lower priority than delivering the next new feature.

Over the past decade, we've been creating (and rediscovering) tools and methodologies that help us deliver the same value with similar levels of effort while not creating anti-value. Architects and developers who find ways to deliver the same value for the cost in time and labor, while also delivering less anti-value, are hot commodities. By my reckoning, these are our seniors.

### The 10x developer

In fact, a developer who can deliver a little more value than average, and deliver a little less anti-value than average, might not just be a senior. She might be a 10x developer.

"10x developer" is a term based on research done in 1968 by Sackman, Erikson, and Grant, and restated by Fred Brooks in *The Mythical Man-Month*. What it means to be a 10x developer, however, is open to interpretation.

The 1968 research studied professional developers with an average of 7 years experience, and found variations in coding time of 20:1, debugging time of 25:1, program size of 5:1, and program execution time of 10:1. There's some valid criticism of the study, but even adjusting for factors the study failed to consider, the data still seems to show a ten-fold (10x) difference in productivity between the best and the worst developers.

This study was done a long time ago, but demonstrating an order of magnitude variation between the most- and least-productive software developers has been reproduced over and over again in peer reviewed studies. The conclusions of these studies are often misstated as "some programmers are ten times as productive as the *average* developer" instead of "there's a ten-fold difference in productivity between the *most* and *least* productive developers". Many of these studies focus on metrics like "KSLOC" - thousand lines of source code produced. Others have focused on function points, cyclomatic complexity, and constructive cost modeling. A few focus on the ratio between the value delivered and the cost of producing the code.

Value delivered per developer is hard to measure objectively, and hard to normalize across different projects. But I think it's relatively easy to compare developers based on the value they deliver, and that this is where we find our 10x developers.

It's my opinion that the primary difference between our most- and least-productive developers is the judgement they bring to their work. By focusing on developing judgement, we can increase the productivity of our developers both individually and in teams exponentially.

Here's a thought experiment. Let's say that Developer A consistently makes decisions on a project that deliver 25% more (1.25) value per unit of effort. Developer B makes average decisions, delivering an average (1.0x) value per unit of effort. Developer C, one of our least productive developers, makes decisions averaging 25% less value per unit of effort. If we accept as a given that these decisions compound (each decision affects subsequent decisions) and that there are ten compounding decisions that must be made in a given software project, then we can demonstrate not only an order of magnitude difference between Developer A (our developer with the best judgement) and Developer B (an average developer), we can demonstrate two orders of magnitude difference in value delivered per unit of effort between Developer A and Developer C.

* Developer A, a developer with excellent judgement, delivers 1.25x as much value for each of ten compounding decisions on a project. (1.25^10 = 9.31x as much value)
* Developer B, an average developer, delivers and average amount of value for each of the ten compounding decisions on a project. (1.0^10 = 1.0 as much value)
* Developer C, a developer with under-developed judgement, delivers 0.75 as much value for each of ten compounding decisions on a project. (0.75^10 = 0.056x as much value)

Of course, we all know that Developer C is not only capable of delivering an order of magnitude less value, he is capable of delivering negative value.

But let's not dally on Developer C. The point is that Developer A, with her excellent judgement, can deliver a lot more value for the amount of effort expended than the average developer.

## Let's talk about pure functions

Pure functions are the best tool I've identified for consistently creating simple, demonstrably correct code. The concepts behind pure functions are valuable in almost any language, in how we approach writing and refactoring code, in how we build systems, maybe even in how we live our lives.

Let's look at pure functions and see how we can apply them to different situations.

* **Referential transparency.** When I call a pure function with a given set of arguments, it's always going to give me the same answer.
* **Immutability.** Immutability usually refers to variables, right? "Immutable variables" always sounds to me like "invariable variables" and that makes me want to gag. I think of immutable variables as if they're functions that don't take any arguments, which means they always, always return the same value.
* **Function composition.** The output of one function can serve as the input to another function. That way we can build functions out of functions, and move up and down through levels of abstraction that take into account the big picture, or the details.
* **Laziness.** Because functions have referential integrity, and one way of looking at referential integrity is that nothing outside of a function (like global state, or class properties in OO programming) can affect the result of a function call, it really doesn't matter when we calculate a result. We can wait until we need it.
* **Distribution.** Again, because functions have referential integrity and nothing outside of the function can change the meaning of the function within a program, once we know a function's arguments, it doesn't matter *where* we run the function.
* **Higher order functions.** Functions can be arguments to other functions, so we can have functions that'll do something later, even if we don't know yet what it will be.

## An side: Let's talk about functional first life

Just for the heck of it, how do we feel about applying the low hanging fruit of pure functions to our lives, and how we relate to other people?

I want to tell you about my amazing group of friends. First off, they have so much integrity, It doesn't matter what's going on in my life or theirs, if I ask for their help, I get it and their results are infallably consistent. I know that trusting them about little things means I can trust them about big things - for my friends, the big things are really just a bunch of little things strung together, and I know that the way they approach our lives together is the same as how they approach each day together: with integrity and competence and empathy. I can count on my friends when I need them. I don't need to worry about whether I need to ask them for their time and effort right now because I may not be able to count on them later when I really need them. And I'm not talking about one or two friends, either. I have many friends I can rely on like this, and together we can all pull together and do what needs to be done to make the world a better place. I have many friends, they work so well together, and the keep working together until we have created a rich, fulfilling life for all of us.

How do my friends compare to pure functions?

* **Referential transparency.** In life, referential transparency is a lot like *integrity*. These are trustworthy people.
* **Immutability.** Immutability is a lot like integrity combined with reliability. These people are stalwart. They are steadfast.
* **Function composition.** If I trust you in little ways, I can probably trust you in big ways, because our big things are made up of little things. If you act with stalward integrity about the little things, I know it will be the same no matter how big a thing is.
* **Laziness.** I don't need to demand everything up front in order to feel like I can trust you. You'll be there and ready to work when I need you.
* **Distribution.** If I am lucky enough to know many people with these characteristics, I have a really good group of friends who can accomplish a lot more together.
* **Higher order functions.** Not only do I have a good group of friends, but they are really good at working well together.

## Let's talk about functional first programming

Applying pure functions to life is perhaps the epitome of practicality, but it can also apply to how we code in any programming language.

Simon Peyton-Jones points out that "In the end, all programs must manipulate state. A program that has no side effects whatsoever is a kind of black box. All you can tell is the box gets hotter." Despite his venerable position in our field, I disagree with him. Heat is a side effect.

Other side effects include telling what time it is, getting requests at an HTTPS API route, reading data from a database, assigning variables, writing to a database, and responding to an API client. Depending on the kind of programming you're doing, side effects can be even more interesting. Rendering on the screen, buzzing when the coffee is brewed,  applying anti-lock brakes, adjusting the aerilons on an intercontinental missile.

Side effects are the opposite of pure functions. A pure function gives you the same result to the same request, every time. A side effect can give you a different result to the same request.

The Functional First Programming plan is very, very simple:

* First, code everything you can without side effects.
* Then, code your side effects.

There's an advanced mode too:

* First, code your side effects, and only your side effects. 
* Then, code your business logic using pure functions.

Either way, we get significant advantages when we follow this plan, regardless of what programming language we use - imperative, procedural, object oriented, declarative, functional. I've used this plan in OO class definitions, Elixir + Phoenix apps, and concatentative programming languages.

Our business logic is purely functional. This generally means we can write it in our core language with few dependencies. We don't need a web framework, an object relational mapper, or any other library that manages IO. Our code base is smaller, easy to reason about, and has very few interdependencies. Because our functions are pure, they're very easy to test, our tests don't need to mock any IO, and our tests run almost instantaneously. Our business logic is stateless, so we can run it anywhere. Horizontal scaling is trivial.

Our side effects layer is *only* side effects, ideally lacking entirely in business logic. Our side effects are almost entirely IO, and we don't usually write our own IO libraries, we use libraries other people have written. That means our side effects layer *doesn't need unit tests*, because the libraries we use have their own unit tests.

Should we make changes around our side effects layer, we've already reduced it to the thinnest possible layer, which means that changing our IO is as trivial as possible. Maybe we wrote our original app with an API layer in Flask on Python, but our business logic might also answer requests over a message bus. Adding an interface to RabbitMQ does only that - it plumbs messages from RabbitMQ to our logic. Similarly, we can add or replace our persistence layer, our rendering library, our hardware abstraction layer - anything that provides side effects.

Most of our "modern" (within the last 12 years) web frameworks do more than side effects, they provide abstractions for entire web applications. These abstractions take our core language and add complexity. Useful complexity, sure, but it's still complexity. Using the framework well often requires mastering both the language and the framework. With functional first programming, we can simplify our use of the framework to managing our IO, and rely on our mastery of the underlying language for doing our core work.

Earlier, we talked about simple, demonstrably correct code, and the compounding value and the 10x programmer. Functional first programming is one of the ways a developer can simplify their code, more readily demonstrate that it is correct, and deliver more value across a hexagonal architecture with less effort.

## Let's talk about functional first refactoring

In my ideal world, my team of functional programmers on a greenfield project can --

Wait a second. Ideal worlds are hard to come by. Let's talk about the real world. Most of us have teams of programmers skilled in an object-oriented language developed sometime in the last 20 to 30 years, working on a legacy code base (usually without tests), lacking significantly in alignment with best practices - even the best practices from a decade ago. 

A couple of years ago, I reported to a VP Engineering who suggested I create an internship program around refactoring legacy code, since code maintenance is a good, solid job for new juniors. I'd like to tell you that our legacy code was "the worst" - Java code two major versions out of date, based on painful frameworks and rendering libraries based on technologies that browsers had long since deprecated. Yes, I had it good actually, but I'm an idealist. 

When he suggested I put interns on that code base, I laughed. "This is the worst possible code for a new developer to work from. We have methods running 5,000 lines in classes 5 times that long. The code horrible, the language and libraries are no longer relevant. The interns will hate the code, hate the work, hate the job, hate getting up in the morning, hate me, hate themselves, and if they're lucky, decide to go into hairdressing instead of coding."

My VPe laughed too. And then he said, "Do it anyway."

Fortunately, he quit before I had to make good on that directive. But he was right about the idea, and although it took me months to figure out how, we created an internship around legacy code maintenance that was good for the company and good for the intern. And by "good for the intern", I mean they learned relevant skills around delivering value by creating simple, demonstrably correct code.

Here's how we did it: I created something called "Functional First Refactoring". You could say I stole it from Michael Feathers, but I wasn't smart enough to go learn it from him first.

The big picture goes like this. First, you isolate your side effects and then your extract your business logic. This means that we can identify a hot section of code, preferably one with an open bug report, and fix it. While we're fixing it, we can hopefully make the code base simpler, demonstratively correct, and get us closer to a code base we would have created if we'd started from scratch.

The process is more detailed but can be described in this process, at least when working from issues tickets:

* Given an issue ticket, make sure you can reproduce it.
* Find the likely spot in the code that hurts.
* Extract usiness logic suspected of causing the issye into a function, leaving behind side effects
* Pass any variables need as arguments to the function; i.e. let's make it purer.
* Write a failing test demonstrating the problem
* Write passing characterization tests
* Change the code to fix the failing test
* Refactor to reduce complexity and improve maintainability

This is a little more involed than Functional First Programming, but it yields, given enough time and issue tickets, the same result. Our business logic is pure and easy to test. Our side effects are isolated in the calling method. Every ticket results in a "clean and tested" side and a "dirty side effects" side. We test the former and make sure that the integration tests can catch any errors in the calling method.

Over time, we can begin to treat our refactored code base the same way we'd treat code written using Functional First Programming, with the ability to move add and replace IO interfaces and APIs, databases, create services, and even apply different architectures. 

## Let's talk about programming languages

I've shipped production code in over 35 languages. Some of those languages feel like they were created in someone's garage. There's a reason for this. They were created in someone's garage. Some of those garages were really big, but still they were basically a garage.

You can tell which languages these are, because they tend to do a lot, and sometimes in these languages we go so far as to say There's More Than One Way To Do It. These languages provide a lot of abstractions that feel almost concrete in how you use them. Want to instantiate an object? Some languages offer three choices on how to do that. Skipping OO altogether? That's okay, we're also procedural. Or functional. Or both.

When we use these languages, we often add frameworks and libraries that tack even more abstractions that do even more concrete things for us. Need a web framework? Our framework can rack that up for us, like magic. Want to connect to a database? Our framework will hide the complexity of mapping objects directly to our relational database.

That's what I see in these languages: the illusion of choice, hidden complexity, loosely wrapped in abstraction, held together tenuously.

Lest I sound too ivory tower, I've used and loved these languages. I've met the creators of these languages, and they are my heroes. I've written easily more than two million lines of code combined in languages like these. Bad code, mostly, but that's on me. One thing I've found is that using these languages well requires mastery of the whole language, and the frameworks you're using, because without that level of experience you're stuck using only the parts you know, and there are lots of parts to know. This massive flexibility feels like freedom for a while, but to borrow a phrase from George Orwell, freedom is slavery.

On the other hand, there are languages I've used that feel like they're based on the laws of the universe. There's a reason for this. It's because they are based on the laws of the universe. These languages don't offer a bunch of different abstractions; they offer very few, but the abstractions are *more* abstract, and apply to more of the problems we need to solve. Thse abstractions are mathematical, logical, philosophical in nature. Very often, the base abstraction is lambda calculus, although in some cases it's combinatorial logic. If we add to that, we tend to add things like type theory, set theory, and category theory.

These "laws of the universe" languages have fewer abstractions that go farther. There is less to master, so we can accomplish more, more quickly. We can focus on mastering our problem domain rather than the vagaries of our language and libraries. The languages tend to be much more constrained than the typical garage language, so even our more junior developers can focus sooner on delivering value rather than figuring out new abstractions.

Most of the "laws of the universe" languages fall under the category of pure functional programming. That's one of the really cool things about doing functional programming. There are languages designed for it.

## Let's talk about functional programming languages

This seems to be a good time to repeat what we said about functions, because pure functional programming languages are based - not surprisingly - on pure functions.

* **Referential transparency.** In functional programming, functions are going to give me the same answer whenever I call them with the same arguments.
* **Immutable state.** Pure functional programming languages don't have mutable variables, and I find it convenient to think of variables in pure functional programming languages as functions that don't take any arguments. (In fact, under untyped lambda calculus, we can use Church encoding to represent even data, so that the only primitive data type is the function.)
* **Function composition.** A common pattern in pure functional programming languages is to "compose" functions - that is, to create a pipeline of functions that work together, in order, to accomplish a higher level goal.
* **Laziness.** While not all functional programming languages use lazy evaluation, many do - especially when we're working with streaming data, because as we know, large data sets are nearly impossible to work with, but infinite data sets are easy.
* **Distribution.** Because nothing outside of a function can change the meaning of the function within a program, once we know a function's arguments, it doesn't matter *where* we run the function.
* **Higher order functions.** In functional programming languages, functions are a primitive data type and can be passed around like any other data type.

These characteristics of pure functions, and by extension, pure functional programming are the reason why it is both simple and demonstrably correct. 

* Because state is immutable, it cannot change on us arbitrarily. An equals sign declares that two things are equal, rather than destructively making them so.
* Because the arguments to our functions and their return values are strongly typed, and state is immutable, the type checking performed by the compiler is much more likely to suggest a correct program.
* Because our programs are a composition of functions, it's easy to deduce that the correctness of each member function will lead to the correctness of the composition.
* Because functions are declarative and state is immutable, it's easy to induce how a function will transform a current state.
* Because our functions are mathematical in nature, we can identify properties of these functions and test that the properties are true (or rather, search for counter-examples using random input data.)

These are just some of the reasons why functional programming tends to be simpler and easy to demonstrate that it's correct. If we go back to our simplicity test - "Can I reason about this code?" and "Can I demonstrate this code is correct?" - functional programming is a winner.

For me, the real winner is that functional programming works well as a programming language for less experienced developers. I've had seniors tell me "You need a PhD to understand this stuff" and I've have brand new developers tell me "This makes so much sense!" The beautiful part of this is that the juniors produce code that simpler, more correct, and substantially smaller than the hybrid and object oriented code produced by those same seniors.

## Let's talk about identity

Very often we use state as a way to model things that exist in the real world. In object oriented languages, this is typically the properties of an object that distinguish any one object from another. In functional programming, we may do the same thing using purely functional data structure. There's an important distinction between these two ways of managing identity.

In OO programming, identity is the current state of an object. We can also say that the current properties of an object are the identity of that object. The object oriented abstraction gives us only one identity, the current snapshot of an object's state. That's not to say we couldn't maintain a journal of changes to state, only that we don't get that for free with object oriented programming.

In pure functional programming, state is immutable. We *transform* state from one version to the next using pure functions. As a result, we can always access at least two versions of our state - the one before a transformation, and the one after a transformation. By extension, we actually have *every* version of state, because we choose what to discard. So in functional programming, identity is a collection of states over time.

This makes sense to me. I have identity, and my identity is not a based on an isolated moment in time. To flatten my identity so completely loses so much richness.

To summarize, object oriented programming gives us identity as the current state of an object, and functional programming gives us identity as a collection of states over time. We're going to use this in discussion about data and architecture coming up.

## Let's talk about databases

When we introduce identity to our programs, very often we also need to introduce persistence. We want to be able to remember, and recall, the state of our entities. We have many options for persisting this state. Let's look at some, and compare them to our understanding of identity.

**Relational databases** treat data like object oriented programming treats identity. A query returns the current state of an entity. Updates to that entity are destructive because the database mutates its data. The concepts behind relational databases were brilliant for their time (the 1970's) but they often fail to match our current needs. Worse, modeling complex data sets in a relational database dramatically increases complexity, rather than keeping it as simple as possible.

Most **NoSQL databases** also treat our data like OOP treats identity. Updates are destructive. Data is mutable (or at least presented to us that way). We still are getting a point-in-time snapshot of our data, even if NoSQL is getting us eventual consistency, denormalization, and speed at "web scale" that relational databases can't. Changes to our data are incremental and shared across multiple devices, necessitating conflict resolution strategies. 

Although much harder to come by, we have the option of **immutable databases**. As the name suggests, these databases do not destructively update our data. In fact, it's reasonable to say there are no updates with immutable databases. Where a typical system might support CRUD operations (create, read, update, delete), an immutable database only supports the create and read operations.

Immutable databases provide our persistence layer with many of the same benefits immutable state provides us in our programs. We can reason about our data. Changes to our data are idempotent. We have an audit trail showing when and how our data changed. We can ask questions about our data over time. Our queries are essentially pure functions run against a bunch of events that affect our understanding of identity.

## Let's talk about domains

Domain Driven Design (DDD) is an approach to developing software based on a collaboration between technical experts (us) and domain experts (people who know a lot about the problems our code will solve). In DDD, we organize our code around the organization of the domain and how the domain problems are modeled.

Here are some core concepts:

* A **domain** is an area of activity, a subject area, or a sphere of knowledge.
* A **model** is how people who work in a domain think about their work.
* A **ubiquitous language** is how people who work in a domain talk about their work.
* An **entity** is something that has *identity* as described in the previous section, in the context of a domain.
* A **domain event** is something that happens that's important to the domain experts, within the context of the domain model, and affecting one or more entities within that domain.
* A **bounded context** is a collection of related domains that tend to share a model, ubiquitous language, and many of the same entities, but tend to have their own domain events.

A skillful application of Domain Driven Design will result in code that is limited to a particular domain, depends on data structures describing entities based on the models in that domain, and use the same language as our domain expert partners. It is entirely reasonable to expect that a domain expert who is not a developer to be able to read our code and understand what it is supposed to be doing, because we are all sharing the same models and language.

With these six concepts, we can build software systems that are dramatically simpler to understand and better at correctly solving our business problems than our historic monolithic approach to development. 

## Let's talk about the back end

Here's an example. Let's say you're writing the back end of a website. The first thing I'd say is, **"Don't do that."** The domain problem we want to solve on the front end is different than the domain problem we're solving on the back end. The front end is strictly responsible for the experience of the user as they try to accomplish their goal. The back end is responsible for the integrity of the data, including the business logic.

Of course, we won't have only one back end. We will create one back end for each domain, and group them within bounded contexts. There's also no reason to have only one front end. By decoupling the client from the back end service, we've made it so that the consumer of our back end services can be arbitrary. We may start with a web application, but we can just as simply produce a public API, a native mobile app, or even new web applications that innovate around our core competencies.

Following the design advice from functional first programming, we'll also push all of our side effects to the edges. This gives our architecture the advantages of functional programming at an application scale:

* Our business logic is purely functional: referentially transparent and composable.
* It's exceptionally easy to distribute (horizontally scale) our business logic.
* Our business logic is *very* easy to unit test, and the tests run fast.
* Our side effects layer is *only* side effects, and since they are pretty much always implemented using someone else's library that has it's own unit tests, we don't write our own unit tests for side effects, we only write integration tests.

Now there's no reason to have only one interface. When the back end is decoupled from the front end, you can also abstract how the service is consumed. It may be HTTPS now, but later you might want to connect in other ways too. Queue worker. Websockets. Pubsub. Ports. Because our interface is all side effects, and our side effects are implemented using the thinnest possible wrapper around our business logic, it's trivial to add a new interface.

In short, we've created a back end service that is both simple and demonstrably correct.

## Let's talk about the front end

What about the front end? To start with, we can reiterate that the front end solves a different domain problem than the back end. The front end is strictly responsible for the user's experience as they meet the need that brought them to your application.

We've used two different patterns here that are very interesting:

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

## Let's solve for an architecture

Let's assume we have a bounded context - a collection of domains that each have their own domain events, but share much of the modeling, language, the entities - and that our bounded context includes a web application that will be used by clients. Given the influence of pure functional programming and domain driven design, how might we architect our system?

[ diagram ]

On the user's side, we generate domain events when the user does something noteworthy within our domain. The event gets persisted to an immutable event store. Once it's persisted, the event is published to a message bus. Any service that pays attention to the domain, the entity in question, and the event type can pick up the event and use it to update their internal representation of a domain model.

Our events are represented using a structure based on domain driven design. We send them to our event store like this:

```
POST http://[ eventstore ]/[ realm ]/[ domain ]/[ entity ID ]/[ event type ] -d { [event data ] }
```

We've added a "realm" concept to provide for authentication and authorization, which might map to the bounded context. Then we have the domain in which the event occurs. Events relate to an entity, which is represented with a globally unique ID. Every event has an event type, so services can listen only for events they handle.

All of this information, except for the realm, is arbitrary. The event store doesn't know or care what domains are out there, what entities exist, or what types of events are stored. 

Once the event store has persisted the event (we use Cassandra for that), it can either publish the event to a message bus or deliver it via HTTP request or web socket. Each event gets stored with a type 1 UUID that can be used as a definitive "last seen" for a query. Likewise every request can be filtered by domain, entity, and event type.

Services within our bounded context are usually organized by domain, but can be subdivided to specific types of events. The events a service receives are mapped to a command within our business logic, which then updates the service's internal representation of the domain model. Then, the service can answer questions about the domain model.

In most cases, we want a domain to keep an up to date representation of its domain model for immediate response to any questions. This is very useful when queries happen more frequently than new events are processed. For example, a service that maintains the state of a shopping cart for an ecommerce store will be queried much more frequently than it's changed. But sometimes, things happen the other way around. In the shopping cart example, we may have a number of questions we ask about shopper behavior - how old is each cart, how long since it's been used, which items are added to carts but removed before checking out. These queries happen much less frequently than events affecting the model, so we may update these models on a schedule, or on demand.

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
  - Service as pure functions
  - Composable services
  - Immutable, no side effects
  - Contracts, DDD ubiquitous language and mental models
  - Easier to reason about the system as a whole
- Demonstrably correct
  - Integration tests of a service are unit tests
  - Integration tests of composed services are unit tests
  - Thin side effect layers should only need contract testing
  - Easier to demonstrate the correctness (read: can be maintained more cheaply!) 



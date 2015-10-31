to do

change us to you whenever I'm not included

change me to us



# From irrational configuration system to functional data store

This is my talk for Code Mesh 2015 in London. The abstract I submit reads as such:

> We started with 42 Oracle tables, 5200+ configuration values, no default values or templates, logical inconsistencies and circular dependencies, on-boarding times running as long as 10 months, a 1.5 million lines of legacy code, and advice that anyone who tries to redesign our configuration system will be gone within six months. Our solution is a custom-built functional data store with inheritance, flexible projections, backward compatibility with the legacy code, and a Lego™-like framework for building tools. Plus, I still work there. Come learn how we did it.

> Talk objectives:

> > I'd like to share how we replaced a complex, "organically-designed" configuration system that we couldn't reason about with a immutable, accretive, functional, time-variant data store based on event sources and command query responsibility segration. We're particularly happy with our choices to project views into Oracle and to treat Oracle as an event source (which gives us backward compatibility with our legacy code), and to allow queries that compile data from multiple documents (which gives us reusable configuration templates).

> Target audience:

> > Programmers and managers interested in applying functional programming concepts to data stores.

## Key concepts

Will Byrd (@webyrd) suggested an important idea to me. When preparing a talk, perhaps a case study in particular, consider what you would want someone who attended your talk to reflect back to you afterward. If you were to ask what someone got from your talk, what do you want to hear in their reply?

Here are the concepts I most want to hear reflected:

* Manage complexity first. Functional first programming reduces complexity.
* Patterns bring surprising wins.
* Servers manage the integrity of data, and client-side apps focus on the user's experience.

---

[ slide:

From irrational configuration system to functional data store
Code Mesh London 2015

Rob Martin, OC Tanner Company, Salt Lake City, Utah USA
rob@version2beta.com || rob.martin@octanner.com
@version2beta

]

OC Tanner does employee engagement through recognition and appreciation awards. Before I uncover some warts, let me just say we do appreciation well. In fact, we created the field when Obert Tanner went off to Berkeley in the 1930's and earned a Ph.D. in the philosophy of appreciating people. We're not only the largest company of our kind in the world, with offices from Singapore to Brazil to 35km away from here in Essex. 27 of our customers are on the Fortune 100 Best Places to Work list, and we are too.

[ slide:

Basement, Terrace, and Courtyard floor plan

]

OC Tanner has grown over the years primarily by saying yes to customers. As revenues and capabilities have increased, they've tacked additions on to our facilities like an old house that gets more bedrooms as the family grows. Our basements are a good example: we have seven, and they aren't connected to each other.

I heard a story about a woman who started her first day of work by going through our half-day orientation session, and then asked if she could skip lunch and go say thank you to the friend who had recommended her. She got directions to find her friend's team, down in one of the basements. The person leading the orientation didn't expect to see her again, since she was supposed to report to her manager after lunch. When she didn't report for work after lunch, her manager assumed she had been a no-show for the whole day. Late that afternoon someone found the poor woman in one of the basements, hopelessly lost and crying.

This is what our software is like too.

[ slide:

"[T]hings which grow shape themselves from within outwards – they are not assemblages of originally distinct parts; they partition themselves, elaborating their own structure from the whole to the parts, from the simple to the complex.”

Alan Watts 1958

]

I mean, our software has grown organically over the years, by saying yes to customers. Can I have this new feature? Yes. Can you make the software do things our way? Yes. What if we want this to be royal blue? Yes. Option by option, tacked on like a new tower on the castle, with a royal blue turret on top. Or purple. We can do purple too.

This is where much of the complexity in our software came from. I suspect we're far from unique in this. In fact, complexity introduced by organic growth is universal. At least that's what Alan Watts says.

When I came along, my new boss put me in charge of the team responsible for configuration tools on the second of the two largest software platforms we offer. He explained to me that there were umpteen hundred settings, and onboarding required individually setting every one of them correctly, and that was a big reason why our onboarding process was running as long as ten months. My team is responsible for the monolithic web app used by 175 internal customers to manage those settings. Oh, and the only developer on that team was out on maternity leave and we didn't know when she'd be back.

He also told me that there is a standing prediction in the office that anyone who takes on configuration would be gone within six months.

[ slide:

Initial findings

* > 5250 configuration settings
* 42 tables
* 25% of settings have no effect
* ~20 systems mucking around directly in the database
* ~2,000,000 lines of Java just in our product
* Few tests

]

Updating our configuration system is far from the only project we're working. Our biggest initiative is breaking up our monolith into microservices, a very common practice over the past half dozen years. Our software was complex, but you've probably seen software just as bad.

My team is working on a better system for configuration and configuration management, but we would have followed many of the same steps no matter what the problem was.

Our configuration data is poorly organized, hard to find and hard to reason about. It's like a kitchen junk drawer, you know the drawer where things that don't have a home go to live? That's how common our problem are. Most kitchens have a drawer full of these problems.

Our legacy code is written Java, but that doesn't matter. What matters is there is a lot of it, and it doesn't have many automated tests. We can't fix it all at once, so we have to work with it. We have to support the legacy system.

[ slide:

Design goals

* Reduce complexity

How we did it

  * Design patterns
  * Functional-first programming

]

My goal on this system, and on every other system, is to reduce complexity. It's my "zeroeth law" of programming.

I use two tools extensively to manage complexity: design patterns and functional data stores. In fact, choosing to use these tools did just as much to influence our design goals as talking to our users did. Just by picking the right patterns we got surprising wins out of this system.

Before we talk about other design goals, let's explain what these tools are. Then we can talk about how we used them.

[ slide:

Design patterns

Design patterns are abstract solutions for abstract problems.

]

If I had to guess, I'd say you're here because you think you might problems that look something like our problems. If we're all lucky, I might have solutions that look something like the solution that's going to solve your problems.

That's what a design pattern is. Design patterns are generalized solutions to generalized problems. Design patterns help us understand our problems quickly, and the give structure to our solutions early in the process. Design patterns help us reason about our project right away.

Pretty much everything I'm going to talk about is a design pattern. Event stores, command query responsibility segregation, hash array mapped tries, static site generators, even dependent data types. We didn't do anything new. We looked at the problem we were trying to solve and identified which patterns fit well.

[ slide:

Functional-first programming

1. Code everything that can be done without side-effect.
2. Code the side-effects.

]

I stole the term "functional first programming" from Doug Syme, without asking him and without checking to see if I'm using it the way he intended. It might be time for me to apologize to him.

My version of functional first programming goes like this: First code everything that's possible to do without side effects. Then code the side effects. The first part should be purely functional, easy to test, easy to reason about, and maybe even provably correct. The second part is *just* side effects, which probably means it all depends on IO libraries that someone else wrote and tested. There's a good chance you won't even need to unit test your side effect code, which is a good thing because all developers hate writing mocks. Plus, your interfaces to the outside world are now strictly modular, so changing an interface or a database is very concise.

You can do functional first programming in almost any programming language. You can do functional first programming in imperative and object-oriented languages.

Using a functional programming language makes it easier, though. A powerful language might let you do all sorts of amazing manipulations in a computer, and a flexible language might give you tremendous choice in how you solve any given problem. Those languages have their place, but for managing complexity I always prefer a strict, constrained, opinionated language.

[ slide:

Design goals:

* Multi-tenant - not just our product and not just configuration data.
* Hierarchical key-value store with metadata.
* 10^7 keys with <10ms response time for most queries.

How we did it:

* Data structure

]

Let's get into some specifics for our project. One of the first things I realized when I was putting together this talk is that our specific needs are actually pretty common, and not just for managing complex configurations.

When we started, I thought we were building a specialized configuration service. It took me a month to see that we were actually building a NoSQL database. When I finally realized this, I went to my CTO and asked him why he approved a project so full of hubris.

If I'd realized this sooner, I'm sure I would have dropped the project and tried to figure out how to do it with a generic NoSQL database. The jury is still out on whether that would have been a better move, but by the time I realized what we were doing we already had design goals I couldn't meet with any of the NoSQL databases on the market.

I know this slide says "How we did it" but we haven't tested at anything near this much data yet. All the same, we're confident it'll scale.

[ slide:

data structure

]

One underlying concept of our data structure is a *trie*, which is actually called a "trie" but I prefer to distinguish it from a "tree". Trie is short for "retrieval".

Tries help you find things quickly and store things compactly by building a tree that shares prefixes. In our case, nodes can represent a dotted-notation key. We map each node to an Elixir process and give it responsibility for processing events regarding its state, persisting new events to a disk or database, and sharing new events with other machines in a cluster, and ultimately other clusters distributed globally.

[ slide:

Design goals:

* Composable data.
* Time variant for version control.

(composable data example)

]

Our old system doesn't have the concept of default settings or settings templates. Every new customer needs to have every configuration setting established by an implementation specialist. With our new system, we want to get most settings from default settings, and only put in the settings that have changed from the default.

This is where the book metaphor comes in handy. We have a book with system-wide default settings. We have books with the default settings for various option packages available by subscription. Then the customer has a book, and each user can have a book. 

Composable data is like stacking those books. The user's book overrides the customer's book, which overrides the books of default settings. Conflicting values from less specific books are ignored.

We have a special situation though. Although many of our customers can simply use the default values in the current version of each book, some of our customers want to go through a change review process, so we can't willy-nilly update the default books without warning them. That's one of the reasons we use an event store, to keep every version of every book.


[ slide:

Design goals:

* Single point of specification (the team creating the setting).
* Discoverable. Documented.
* Expose settings anywhere.
* A useful metaphor: books of definitions, like dictionaries.

How we did it:

* Metadata

]

Under the old system, when we needed new configuration settings, the developer created a row, or maybe a table, and stored what they needed there. The documentation typically consisted of the name of the table and the name of the column along with the code. Other developers that interact with that setting, for instance building a configuration management tool, have to infer how it's used.

In our new system, when a developer creates a new setting, they store alongside it any information needed to find, understand, change, and validate that setting. So our system contains not just data but metadata - a title, a description, and a schema at least, but it can also include tags that identify where the data should be exposed, and access control information defining who can view and change it. The metadata tells us everything we need to know to expose the setting anywhere we'd like, with documentation that comes straight from the creator.

[ slide:

Metadata

]

Our trie datastructure holds metadata in each node, and when we query the configuration service we can request just data or data and metadata. When we request metadata, it will respond with the metadata for the key we requested, composed with metadata from all of its parents. This is useful for defining properties associated with classes of data, like data types or tags.


[ slide:

Design goals:

* Don't require changes to legacy code.
* Foreign views.

How we did it:

* Functional data stores
* Data coordinator

]

We've been carving up our original monolithic code base into microservices, but we're only half way there and have a year or two to go. I knew if we delivered a configuration system that required other teams to drop their work on microservices and rewrite legacy code, I wouldn't get the buy-in we need to make the project successful.

On the other had, if we chose to only support new code and ignored legacy code, then our internal customers would be stuck with the old configuration management tools running alongside a few shiny new tools, and they would hate us for it.

We addressed using a functional data store based on two patterns, Event Stores and Command Query Responsibility Segregation.

[ slide:

Functional data stores

* Event stores
* Command Query Responsibility Segregation (CQRS)

]

A functional data store is a pretty broad label that means a database that doesn't let you change any data, and does let you interact with your data by transforming it.

For comparison, we're all probably familiar with a CRUD database. It lets you Create, Read, Update, and Delete data.

Functional data stores don't do updates or deletes. Instead of updates, we create a new state for an existing record. Instead of deletes, we can mark things as "gone" beginning at a certain time. Things change over time, and very often we want to know what data we had before the current data.

Our functional data store is based on two design patterns that work really well together, Event Stores and Command Query Responsibility Segregation.

Event stores are like your checkbook register. We record every transaction, not just our current balance. We keep a list of every transactions going back to the first deposit we made when we opened the account. From that list we can figure out what our current balance is, or even what our balance was at any point in time.

Command Query Responsibility Segregation is the difference between the checkbook register and the running balance for our accounts. When we make a deposit or draft a check, that's a command applied to our that gets recorded as an event that happened at a given point in time. When we want to know our balance, when we query our balance, we don't start at the first event and calculate it. We simply look at the running total column, because we keep that up to date just so that we can quickly know how much money we have.

We're doing the same thing with our configuration system, but these patterns are generally very useful - and they can give you design wins you weren't expecting.

Take a shopping cart application for example. If you track just the current state of the cart, you can get a customer through your store and checked out. But if you track each event along with when it happened, you can still get the current state of the cart but you can also look at the customer's shopping behavior. From that behavior, you can learn a lot about your ecommerce site, your customer's preferences, the problems with your user experience. That kind of business intelligence is hot right now.

[ slide:

Data coorindators

]

Our initial and perhaps naive view of foreign data was two-fold. On the configuration service side, when we build a projection we might run a SQL statement that is stored in the metadata, updating the setting in the database. On the database side, we could set up triggers on each of the configuration tables that would post the updated data to an API.

But now my team is bigger and a new developer got a hold of this and squeezed out a very nice abstraction. He suggested we publish data updates on RabbitMQ channels, so that you can not only query a key, but subscribe to it. On the configuration side, this is relatively trivial. We're already using RabbitMQ as our message bus. The key-value store can be it's own publisher and send updates directly to RabbitMQ.

On the other side of the pub-sub-sub-pub equation, we have our database, and a map connecting keys and rows that's basically just a secondary index on metadata. When we get an update that's in our map, we project it into the database.

Going the other way, treating changes to the database as an event source for the configuration service, is a little more tricky. After considering several options, we settled on processing the Oracle redo log. We get change vectors by watching that log, and if the item is in our foreign data map, we create a new event and send it to the configuration service.

[ slide:

Data coorindators: Danger, Will Robinson!

]

It is important to note that we are not actually trying to keep two canonical data sources in sync here. Even though the legacy code may believe that Oracle is the source of Truth for its configuration values, I don't. I think the database is one of several places I might project a view of the data, and just another way of recognizing a configuration change event.

Taking a step back, the idea of being able to subscribe to changes in data from almost any source *is* kind of exciting - and probably too good to be true. Since our primary use is configuration data that doesn't actually change all that often, I think we can get away with it, but in the bigger picture it feels like a three-legged stool at best. If we want streaming data, we probably should get it as it's entering the system, not as a reflection of what's changed within the system. I have questions in this area if anyone wants to talk about it after the session.


[ slide: 

Design goals: Configuration management tools

* Build tools that support workflow, rather than workflows to support the tools.
* Expect internal customers to design their own tools.
* Deliver new tools the same day and iterate quickly.
* Make the tool building process lego-block simple. Juniors should do it.

How we did it:

* Separation of concerns, user-side and server-side
* Keep data sane
* config-tool-tool

]

Our work on this project covers the whole spectrum of configuration and configuration management. We're not only building a configuration service, we're building the tools to manage it, and we have a lot of opportunity to improve on our current tools. In fact, our software engineering department used to promise new hires that they can't do worse than has already been done.

Rather than building a new configuration management tool, we chose to build a tool that will build tools. Actually, build a tool that would build and manage collections of tools.

It was important to us that our system didn't dictate up front how our internal customers work. Since we launched the monolithic platform, they've had one main tool that exposed all available settings, and they built their workflows around that tool. Under the new system, we want to turn that upside down. Instead of designing their workflows around the tool, we want to build tools designed around their workflows. We want our internal customers to bring us lots of pages to build, and we expect to be able to turn those tools around quickly - possibly even the same day. If we make it simple for them to work with us, and we deliver new workflows quickly, then they will be able to iterate on their own processes.

My final design goal for configuration management is that juniors should be building these tools. That's how I'll know that we eliminated enough complexity.

But for me, it goes deeper than that. As a manager, I'm trying to solve a number of problems both within my team and within the tech community. One of them is that our team, when I started, had no work available that juniors could do, so we weren't able to hire any juniors. If we can't hire juniors, then we can't help build the market of future seniors. We can't get juniors started with the skills we consider best practices. We can't contribute to the growth of our community in that way.

Another factor is that most places, OC Tanner included, seems to treat functional programming as something senior developers do, and maybe even just the best senior developers. It's almost as if we don't trust someone with the power of functional programming and functional data stores until they've proven they can go ten years or more with object oriented programming and still not murder anyone. We're telling new developers they can't use languages that reduce complexity until they learn to live with complexity.

As an industry, we should be teaching new developers functional programming. At OC Tanner, we're doing that.

[ slide:

Separation of concerns:

Server-side code guarantees the integrity of data by applying business logic and using a competent persistence scheme.

User-side code empowers the user to meet their needs and guarantees their positive experience.

]

It used to be that we used the server to dynamically generate client-side HTML, CSS, and even Javascript. We were doing it wrong.

Sure, we had limitations in the power of the client's browser and programming environment then, and we had a focus on controlling everything from one large application. One monolithic application responsible for everything. We quite literally designed for complexity.

I've been guilty of this. Our monolithic code at OC Tanner is guilty of this. You've probably been guilty of this. I suggest we all stop doing that.

Data lives on the server, and we apply business logic to assure the integrity of the data within our systems, whatever those systems do. I think that's all that servers should do - they should provide views the data to the right people, and expose functionality that allows the right people to modify the data in a way that makes sense within the language of our data domain.

In contrast, our client-side code should be focused exclusively on the user's needs, making it a joy to use the software to accomplish their goals. We do this by translating the user's goals, the user's language for thinking about the problem, to the server's interface.

When we used to couple these two disparate objectives, we introduced tons of complexity. We talked about data in terms of what users want in some places and what the business needs in other places. We translated between the goals on the fly, throughout the code base.

Now that we respect this separation of concerns, by creating separate applications that interact with each other through well-defined interfaces, we have eliminated massive amounts of complexity. I highly recommend you do the same.

[ slide:

Keep data sane: the command side of command query responsibility segregation

]

This is the other side of the command query responsibility segregation pattern, too. When we put a form element on a page, we're giving the user ability to issue a command to change that value. Commands happen in user-space. Commands are imperative. Commands are part of our shared reality, what we might call "the real world". Commands mutate shared state in the Big Blue Room.

Events are how the server tries to maintain a consistent model of the real world.

Here's another way to look at it. We can call it "sanity". In psychology we consider someone to be sane when their internal view of the world matches our shared external view of the world. Our data is sane when we manage to maintain that same consistency between our user's experience of the world, and the model of the world we keep in our database.

Because of this, we had to consider what happens when someone sends us something that doesn't validate. If we were just a regular database, we could reject it. Of course, if we were just a regular database, we'd be keeping only the current state and it would break our contract with our users to provide them data that lacks integrity. As an immutable and time-variant database, I think we have a responsibility to handle all events, not just the ones we like, because events happen in the real world and it's not like we can just reject reality. Even if it means our data is in an exceptional state. The decision we made was to use the metadata to flag states that are invalid. If you ask for a key without metadata, we'll send you the most current valid state. But if you ask for the data and metadata, it'll give you the current invalid state. And we can use the "invalid" flag to create a report showing which keys are broken, and ask some human being for help.



[ slide:

config-tool-tool

]

Up to this point, we've mostly talked about the back end of the configuration service. Quite separately - another team altogether - we've created a slick, functional system for building configuration management tools. And it's bone simple to use.

As you recall, one of our design goals was for a single point of specification. That is, when a developer or team creates a new configuration setting, we want them to tell us all about that setting. What it's called. How it's used. Who can use it. How to tell if it's valid. All of this information is stored in the metadata for the key, which means that each key can tell us everything we need to know about how to manage that key.

Metadata is the basis of our configuration management tools. Because the metadata tells us so much about the data, we can use it to automatically render a form element for changing the data. If we want to expose a setting in a configuration management screen, we simply insert one line of javascript and pass it the key. The javascript renders a form element.

It doesn't matter what kind of configuration management tool it is, either. It can be our internal tools, or tools we expose to our customers to administer their programs, or even tools for users to manage their experience.

We can compose some number of configuration settings in one form, and send each update as it's saved. Or we can allow implementation specialists to build and commit atomic transactions. Either way, you've got one line of javascript per key, and maybe another line to show a transaction manager.

[ slide:

config-tool-tool build stack

]

Of course, our implementation specialists and customer service teams will ultimately need richer, more sophisticated tools than just this. Right now, their main tool is an app that exposes all of the configuration settings ever for any customer in one long list. They designed their workflows around that list. We are doing better than that. We want tools designed around their work, and we're going to do it so efficiently that they can iterate on their own processes.

To accomplish this, we put together a build process using Markdown source files, a collection of templates that turn a pile of workflows into a collection of tools, static files for a consistent and usable look and feel, and a static site generator called Metalsmith.

Metalsmith is Node.js, functional, pipelined build tool that works well as static site generator. The main loop is one long filter chain operating on all the files in any given directory.

We start with Markdown files that have some content about the tool and specify what settings are exposed on each page. In one pass, a filter wraps the configuration keys in a form element and rewrites them as javascript calls. In the next pass, a filter converts the markdown to HTML. In another pass, a filter calculates navigation for the site. In another pass, a filter applies our layouts, including calling all the appropriate javascript libraries and stylesheets.

The output from each filter step is the input for the next filter, until all the filters are applied and the resulting files are written to a build directory containing all of the HTML, javascript, and CSS files for the tool site.

One of the particularly shiny things about this system is that the work of building new tools can be done by juniors, or possibly even the users themselves. Our tool building stack is actually being built by a team of interns in our women's internship program.


[ slide:

Not a design goal:

Our first application wasn't configuration data

How we accomplished it:

* It just worked.

]

About the time we finished our design goals and were starting to code, we were almost thrown for a loop. Another team came to us and said "We have a problem that's not about configuration, and we wonder if we can use the new configuration service to solve it."

Our software is used world-wide. Our software is translated into I-don't-even-know-how-many languages, and each customer's platform is customized and translated into the languages their employees need. That means we have default translations to many different languages, each of which can be overridden by the customer.

We spent two hours reviewing the translation service's needs, looking for the gaps between what we were already building and what they required. We didn't find any. Our design goals fit their needs exactly.

I think that was the moment I realized that what we were building was actually a database.

[ slide:

Iterative approach:

Java spike vs. Elixir version

]

At this point I want to come clean on something. By the time we started work on this, I had one excellent programmer available, but he is a Java developer with little functional programming experience. Our first release of this system is not exactly as described. We built it in a lean-development sort of way, to get the interface and functionality into the hands of the developers who who are going to use it and see where our abstractions are falling short. Our current production version is written in Java 1.8 and uses one process per book rather than one actor per key. Because of this, a book is distinct from a key. Instead, it's a container for a set of keys. Data composition can only happen across books. Our development version is written in Elixir and is actor-based. In the development version, there is no difference between a book and a key - a book simply denotes the root key, any key can be considered a book, and compositions can happen at any level.

Obviously there are a lot of interesting implementation details behind a database like this, and I don't have time to go into all of it, but I can talk about some of our development strategies. For example, in the current production version, disk persistence uses S3 buckets from Amazon Web Services. We get redundancy and availability with a super-simple interface, but once we start measuring performance this will be low hanging fruit. What we got was a persistence layer that brings something extra to the table, and we will continue to look for ways to leverage other technologies to meet our needs rather than build it all in house. Another example of this is our message bus. Instead of tacking an HTTP interface onto our service, the service is configured to use RabbitMQ channels for receiving and sending messages.

[ slide:

What's next?

]

That's the system, end to end, from the functional data store with immutable, time-variant data to a pipelined static site generator building the management tools. We haven't done anything in here that's actually novel, except for how it's all put together. We're in the process of moving configurations onto the new service now, and we're learning from our internal customers and their patterns of use. We're changing things, like moving to an actor model and Elixir for the data store. We already have permission to open source the code, but being stubborn and egotistical we'll likely wait until it's proven under heavier production load.

In this project we're fixing problems with how configuration is managed, but we haven't fixed the consistency problems present within our configurations. That is, we've got great new tools for writing buggy configurations that are impossible to reason about. Moving forward we want to provide a way to make declarative statements about relationships between configuration values. For instance, we could introduce a dependent type system that gets us provably correct configurations.

In the meantime, our new functional configuration service is not perfect, and it's definitely not a general purpose database, but it's proving to meet our needs.

[ slide:

"If debugging is the process of removing bugs, then programming must be the process of putting them in.”
- Edsger Djikstra

version2beta.com/articles/irrational_to_functional

Rob Martin from OC Tanner Company is @version2beta rob.martin@octanner.com ⤄ rob@version2beta.com

Appreciation to Michael Whitehead and our coworkers at OC Tanner Company, and to my bosses for supporting this opportunity to share our work with you.

]

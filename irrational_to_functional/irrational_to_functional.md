# From irrational configuration system to functional data store

This is my talk for Code Mesh 2015 in London. The abstract I submit reads as such:

> We started with 42 Oracle tables, 5200+ configuration values, no default values or templates, logical inconsistencies and circular dependencies, on-boarding times running as long as 10 months, a 1.5 million lines of legacy code, and advice that anyone who tries to redesign our configuration system will be gone within six months. Our solution is a custom-built functional data store with inheritance, flexible projections, backward compatibility with the legacy code, and a Lego™-like framework for building tools. Plus, I still work there. Come learn how we did it.

> Talk objectives:

> > I'd like to share how we replaced a complex, "organically-designed" configuration system that we couldn't reason about with a immutable, accretive, functional, time-variant data store based on event sources and command query responsibility segration. We're particularly happy with our choices to project views into Oracle and to treat Oracle as an event source (which gives us backward compatibility with our legacy code), and to allow queries that compile data from multiple documents (which gives us reusable configuration templates).

> Target audience:

> > Programmers and managers interested in applying functional programming concepts to data stores.

## Narrative form

OC Tanner does employee engagement through recognition and appreciation awards. Before I uncover some warts, let me just say we do appreciation well. In fact, we created the field when Obert Tanner went off to Berkeley in the 1930's and earned a Ph.D. in the philosophy of appreciating people. We're not only the largest company of our kind in the world, with offices from Singapore to Brazil to 35km away from here in Essex. 27 of our customers are on the Fortune 100 Best Places to Work list, and we are too.

### The way things were

OC Tanner has grown over the years primarily by saying yes to customers. As revenues and capabilities have increased, they've tacked additions on to our facilities like an old house that gets more bedrooms as the family grows. Our basements are a good example: we have seven, and they aren't connected to each other.

I heard a story about a woman who started her first day of work by going through our half-day orientation session, and then asked if she could skip lunch and go say thank you to the friend who had recommended her. She got directions to find her friend's team, down in one of the basements. The person leading the orientation didn't expect to see her again, since she was supposed to report to her manager after lunch. When she didn't report for work after lunch, her manager assumed she had been a no-show for the whole day. Late that afternoon someone found the poor woman in one of the basements, hopelessly lost and crying.

This is what our software is like too.

I mean, our software has grown organically over the years, by saying yes to customers. Can I have this new feature? Yes. Can you make the software do things our way? Yes. What if we want this to be royal blue? Yes. Option by option, tacked on like a new tower on the castle, with a royal blue turret on top. Or purple. We can do purple too.

When I came along, my new boss put me in charge of the team responsible for configuration tools on the second of the two largest software platforms we offer. He explained to me that there were umpteen hundred settings, and onboarding required individually setting every one of them correctly, and that was a big reason why our onboarding process was running as long as ten months. My team is responsible for the monolithic web app used by 175 internal customers to manage those settings. Oh, and the only developer on that team was out on maternity leave and we didn't know when she'd be back.

He also told me that there is a standing prediction in the office that anyone who takes on configuration would be gone within six months.

I didn't have a team yet, and I did have some time on my hands, so I scoped out the problem. Here are some of my findings:

* We had about 5250 configuration settings for our application alone.
* 42 tables in the database were used for storing settings.
* The legacy software dependent on the settings typically read them directly from the database.
* The primary configuration management tool also read directly from, and write directly to the database.
* The primary configuration management tool was a monolithic mess.
* There were secondary, tertiary, quaternary, and possibly quinary tools that read and write settings in the database.
* About a quarter of the settings seemed to be represented in code, but didn't do anything anymore.
* Anecdotally, some settings needed to be in "logically exceptional" states in order to make workarounds work.

This was on our product alone. We had three other products that I wasn't responsible for, at least one of which probably had similar issues, and all of which could, and probably should, use the configuration service we were going to build.

It is worth mentioning that the product I work on was built on a monolithic code base of about 2 million lines of Java by a relatively large team of subcontractors who didn't write very many tests. That had been our largest software engineering initiative up to that time. Since then, our largest engineering initiative has been to fix that code - by carving it up into well-tested microservices.

So that's what I set out to do with configuration, too, knowing that in six months I could always retrain as a hairdresser, because out of all the careers we can choose from, hairdressers have the highest job satifaction.

### Design goals

I would love to say that my next step was to make a list of design goals for the project. And I did make some design goals, but I also had an inclination to use purely functional programming as much as possible, a functional data store, and a CQRS pattern, command-query responsibility segregation. Some of our most impressive design goals came out of thinking about patterns, rather than looking at our application.

Here are some of the design goals we settled on for our new configuration service.

* Zeroeth law: Reduce complexity.

I'm putting this up here, maybe just as a reminder to myself. On any project, my first goal is to reduce complexity.

But let's look at complexity more closely. We have some complexity inherent in our configurations as a whole that we could reduce.

We have a lot of settings. It might be nice to have fewer, maybe delete the ones that aren't used.

We can touch fewer settings by creating templates and defaults, and only changing the settings that aren't well represented in the defaults.

We can prevent everyone from mucking around in the database.

We can try to make sure that our configuration settings comply with logical constraints.

Of course, there's much, much more we were able to do. This is just some of the complexity from my intial findings.

* Multi-tenant - not just our product and not just configuration data.
* Hierarchical key-value store with metadata.
* 10^8 keys with <10ms response time for most queries.

Let me stop here and explain that it took me about a month to finally see that we were building a database, not a specialized configuration service. I can be kinda slow, but once I got it I kicked myself. Building your own database is so 2012! I even went to my CTO and asked him why he approved a project to build our own database.

If I'd realized this sooner, I'm sure I would have dropped the project and tried to figure out how to do it with a generic NoSQL database. The jury is still out on whether that would have been a better move, but by the time I realized what we were doing we already had design goals I couldn't meet with a general purpose database.

* Single point of specification (the team creating the setting).
* Discoverable. Documented.
* Expose settings anywhere.
* A useful metaphor: books of definitions, like dictionaries.

Under the old system, when we needed new configuration settings, the developer created a row, or maybe a table, and stored what they needed there. The documentation typically consisted of the name of the table and the name of the column along with the code. Other developers that interact with that setting, for instance building a configuration management tool, have to infer how it's used.

In our new system, we want the developer to create a new configuration setting and store alongside it any information needed to find, understand, change, and validate that setting. So our system contains not just data but metadata - a title, a description, and a schema at least, but it can also include tags that identify where the data should be exposed, and access control information defining who can view and change it. The metadata tells us everything we need to know to expose the setting anywhere we'd like, with documentation that comes straight from the creator.

* Composable data.
* Time variant for version control.

Our old system doesn't have the concept of default settings or settings templates. Every new customer needs to have every configuration setting established by an implementation specialist.

We want the new system to take this to another extreme, with something I call "composable data".

This is where the book metaphor comes in handy. We have a book with system-wide default settings. We have books with the default settings for various option packages available by subscription. Then the customer has a book, and each user can have a book.

Imagine that you stack those books in that order, with the system wide defaults on the bottom and the user's book on the very top. Each book contains only the information that needs to supercede information in a book beneath it, and when you go looking for any given setting, you can start in the topmost book and work your way down but then stop when you first find the key you need.

That's how composable data works. You can specify a query across multiple books in order of priority. The highest priority book with the key wins.

We have a special situation though. Although many of our customers can simply use the default values in the current version of each book, some of our customers want to go through a change review process, so we can't willy-nilly update the default books without warning them. To accomodate this situation, we keep every version of every book, and we can reference any version by an identifier that is a hash of that book in that version. We stole the idea from Git, and along with it we made sure you can also name (or tag) a version so that we can reference it intuitively.

* Don't require changes to legacy code.
* Foreign views.

Composable data and time variance are two features that we didn't think we could get from any available database. Foreign views are another.

The original monolith had about 2 million lines of Java, and we still have about a million left, spread across a half dozen teams that are working to move that code to microservices. I knew if I delivered a configuration system that required those other teams to rewrite legacy code, the system would be a non-starter - I wouldn't get the buy-in we need to make the project successful. On the other had, if we chose to only support new code, then we'd be stuck with the old configuration management tools running alongside shiny new tools, and our internal customers would hate us.

We addressed this with foreign views, or foreign projections. That is, when something changes in a book, we want to be able to map that change to a row in a database table and update it there as well. This means we need to treat the database as a view of the current state of a configuration setting, not the canonical source of that state. On the side, all of our legacy code including the tool used internally to manage customer configurations, write directly to the database. So we also need to treat the database as a source for configuration events - a proxy, if you will.

Configuration management tools

* Build tools that support workflow, rather than workflows to support the tools.
* Expect internal customers to design their own tools.
* Deliver new tools the same day and iterate quickly.
* Make the tool building process lego-block simple. Juniors should do it.

Our work on this project covers the whole spectrum of configuration and configuration management. We're not only building a configuration database, we're building the tools to manage it, and we have a lot of opportunity to improve on our current tools. Our software engineering department used to promise new hires that they can't do worse than has already been done.

Rather than figuring out how to build a new configuration management tool, we decided to figure out how to build a tool that will build tools. Actually, build a tool that would build collections of tools. It was important to us that our system didn't dictate up front how our internal customers work. Since we launched the monolithic platform, they've had one main tool that exposed all available settings, and they built their workflows around that tool.

Under the new system, we want to turn that upside down. Instead of designing their workflows around the tool, we want to build them tools designed around their workflows. We want our internal customers to bring us lots of pages to build, and we expect to be able to turn those tools around quickly - possibly even the same day. If we make it simple for them to work with us, and we deliver new workflows quickly, then they will be able to iterate on their own processes.

My final design goal for configuration management is that juniors should be building these tools. That's how I'll know that we eliminated enough complexity.

But for me, it goes deeper than that. As a manager, I'm trying to solve a number of problems both within my team and within the tech community. One of them is that our team, when I started, had no work available that juniors could do, so we weren't able to hire any juniors. If we can't hire juniors, then we can't help build the market of future seniors. We can't get juniors started with the skills we consider best practices. We can't contribute to the growth of our community in that way.

Another factor is that most places, OC Tanner included, seems to treat functional programming as something senior developers do, and maybe even just the best senior developers. It's almost as if we don't trust someone with the power of functional programming and functional data stores until they've proven they can go ten years or more with object oriented programming and still not murder anyone. We're telling new developers they can't use languages that reduce complexity until they learn to live with complexity.

Anyway, that's a soapbox. As an industry, we should be teaching new developers functional programming. At OC Tanner, I intend to have new developers build our tools.

### Our first application wasn't configuration data

About the time we finished our design goals and were starting to code, and unexpected thing happened. Another team came to us and said "We have a problem that's not about configuration, and we wonder if we can use the new configuration service to solve it."

Our software is used world-wide. Our software is translated into I-don't-even-know-how-many languages, and each customer's platform is customized and translated into the languages their employees need. That means we have default translations to many different languages, each of which can be overridden by the customer.

We spent two hours reviewing the translation service's needs, looking for the gaps between what we were already building and what they required. We didn't find any. Our design goals fit their needs exactly.

I think that was the moment I realized that what we were building was actually a database.

### A time-variant key-value store

We were able to meet all of our design goals by basing our design on two relatively well known patterns: event stores, and command query responsibility segregation. In fact these two patterns influenced our design goals and exposed some wins we might not have asked for otherwise.

The basic idea goes like this. Our event store is a functional data store. That means that all the data in it is immutable. If you think of a CRUD system, create - read - update - delete, our system only does creates and reads.

A book is made up of all of the events that define that book. Any specific version of that book is made up of all of the events that define that book up to any given point in time. By sequentially processing the events recorded in the event store, we can create a view of the current state (or any previous state) of that book. We create these views by running a reduction on the events in the event store, and then we project that view where we want it. So we call any given view of our data a "projection".

In order to get excellent query performance, when we get a request for a key, we run the reduction and store the view in a projection in memory. Both the reduction and the projection are done by an actor, the process ID of which is registered to the key and hash.

Foreign views work the same way. After a full view is produced, the metadata indicates whether the data is also projected somewhere else. If it is, we use another service called a data coordinator to do that.

At this point I want to come clean on something. By the time we started work on this, I had one excellent programmer available, but he is a Java developer with little functional programming experience. Our first release of this system is not exactly as described. We built it in a lean-development sort of way, to get the interface and functionality into the hands of the developers who who are going to use it and see where our abstractions are falling short. Our current production version is written in Java 1.8 and uses one process per book rather than one actor per key. Because of this, a book is distinct from a key. Instead, it's a container for a set of keys. Data composition can only happen across books. Our development version is written in Elixir and is actor-based. In the development version, there is no difference between a book and a key - a book simply denotes the root key, any key can be considered a book, and compositions can happen at any level.

Obviously there are a lot of interesting implementation details behind a database like this, and I don't have time to go into all of it, but I can talk about some of our development strategies. For example, in the current production version, disk persistence uses S3 buckets from Amazon Web Services. We get redundancy and availability with a super-simple interface, but once we start measuring performance this will be low hanging fruit. What we got was a persistence layer that brings something extra to the table, and we will continue to look for ways to leverage other technologies to meet our needs rather than build it all in house. Another example of this is our message bus. Instead of tacking an HTTP interface onto our service, the service is configured to use RabbitMQ channels for receiving and sending messages.

I'd love to discuss other implementation details. The data structure, for example, is fascinating and would require its own talk. Memory management is really simple - we just kill the least recently used actors when we're running low on memory. And the API is just an API.

I sound like a manager. We got to implementation details, and I got all hand-wavey.

Before we move on, however, there is a design detail that I think is significant. We had to consider what happens with invalid data - what happens if someone sends us something that doesn't validate. If we were just a regular database, we could reject it. Of course, if we were just a regular database, we'd be keeping only the current state and it would break our contract with our users to provide them data that lacks integrity. As an immutable and time-variant database, I think we have a responsibility to handle all events, not just the ones we like, because events happen in the real world and it's not like we can just reject reality. Even if it means our data is in an exceptional state. The decision we made was to use the metadata to flag states that are invalid. If you ask for a key without metadata, we'll send you the most current valid state. But if you ask for the data and metadata, it'll give you the current invalid state. And we can use the "invalid" flag to create a report showing which keys are broken, and ask some human being for help.

### Data coorindators

Our initial and perhaps naive view of foreign data was two-fold. On the configuration service side, when we build a projection we might run a SQL statement that is stored in the metadata, updating the setting in the database. On the database side, we could set up triggers on each of the configuration tables that would post the updated data to an API.

But now my team is bigger and a new developer got a hold of this and squeezed out a very nice abstraction. He suggested we publish data updates on RabbitMQ channels, so that you can not only query a key, but subscribe to it. On the configuration side, this is relatively trivial. We're already using RabbitMQ as our message bus. The key-value store can be it's own publisher and send updates directly to RabbitMQ.

On the other side of the pub-sub-sub-pub equation, we have our database, and a map connecting keys and rows that's basically just a secondary index on metadata. When we get an update that's in our map, we project it into the database.

Going the other way, treating changes to the database as an event source for the configuration service, is a little more tricky. After considering several options, we settled on processing the Oracle redo log. We get change vectors by watching that log, and if the item is in our foreign data map, we create a new event and send it to the configuration service.

It is important to note that we are not actually trying to keep two canonical data sources in sync here. Even though the legacy code may believe that Oracle is the source of Truth for its configuration values, I don't. I think the database is one of several places I might project a view of the data, and just another way of recognizing a configuration change event.

Taking a step back, the idea of being able to subscribe to changes in data from almost any source *is* kind of exciting - and probably too good to be true. Since our primary use is configuration data that doesn't actually change all that often, I think we can get away with it, but in the bigger picture it feels like a three-legged stool at best. If we want streaming data, we probably should get it as it's entering the system, not as a reflection of what's changed within the system. I have questions in this area if anyone wants to talk about it after the session.

### A stack for building configuration management tools

We've covered getting events into the system, projecting them to in-memory views and to foreign locations, composing data, and answering queries. That pretty much covers the back end of the configuration service. We also designed a slick, functional system for building configuration management tools. And it's bone simple to use.

As you recall, one of our design goals was for a single point of specification. That is, when a developer or team creates a new configuration setting, we want them to tell us all about that setting. What it's called. How it's used. Who can use it. How to tell if it's valid. All of this information is stored in the metadata for the key, which means that each key can tell us everything we need to know about how to manage that key.

Metadata is the basis of our configuration management tools. Because the metadata tells us so much about the data, we can use it to automatically render a form element for changing the data. If we want to expose a setting in a configuration management screen, we simply insert one line of javascript and pass it the key. The javascript renders a form element.

It doesn't matter what kind of configuration management tool it is, either. It can be our internal tools, or tools we expose to our customers to administer their programs, or even tools for users to manage their experience.

We can compose some number of configuration settings in one form, and send each update as it's saved. Or we can allow implementation specialists to build and commit atomic transactions. Either way, you've got one line of javascript per key, and maybe another line to show a transaction manager. Upon submit, it sends one or more new events to RabbitMQ using the Stomp javascript library.

Of course, our implementation specialists and customer service teams will ultimately need richer, more sophisticated tools than just this. Right now, their main tool is an app that exposes all of the configuration settings ever for any customer in one long list. They designed their workflows around that list. We are doing better than that. We want tools designed around their work, and we're going to do it so efficiently that they can iterate on their own processes.

To accomplish this, we put together a build process using Markdown source files, a collection of templates that turn a pile of workflows into a collection of tools, static files for a consistent and usable look and feel, and a static site generator called Metalsmith.

Metalsmith is Node.js, functional, pipelined build tool that works well as static site generator. The main loop is one long filter chain operating on all the files in any given directory.

We start with Markdown files that have some content about the tool and specify what settings are exposed on each page. In one pass, a filter wraps the configuration keys in a form element and rewrites them as javascript calls. In the next pass, a filter converts the markdown to HTML. In another pass, a filter calculates navigation for the site. In another pass, a filter applies our layouts, including calling all the appropriate javascript libraries and stylesheets.

The output from each filter step is the input for the next filter, until all the filters are applied and the resulting files are written to a build directory containing all of the HTML, javascript, and CSS files for the tool site.

One of the particularly shiny things about this system is that the work of building new tools can be done by juniors, or possibly even the users themselves. Our tool building stack is actually being built by a team of interns in our women's internship program.

### What's next

That's the system, end to end, from the functional data store with immutable, time-variant data to a pipelined static site generator building the management tools. We haven't done anything in here that's actually novel, except for how it's all put together. We're in the process of moving configurations onto the new service now, and we're learning from our internal customers and their patterns of use. We're changing things, like moving to an actor model and Elixir for the data store. We already have permission to open source the code, but being stubborn and egotistical we'll likely wait until it's proven under heavier production load.

In this project we're fixing problems with how configuration is managed, but we haven't fixed the consistency problems present within our configurations. That is, we've got great new tools for writing buggy configurations that are impossible to reason about. Moving forward we want to provide a way to make declarative statements about relationships between configuration values. For instance, we could introduce a dependent type system that gets us provably correct configurations.

In the meantime, our new functional configuration service is not perfect, and it's definitely not a general purpose database, but it's proving to meet our needs.

## Slides

[ slide:

From irrational configuration system to functional data store
Code Mesh London 2015

Rob Martin, OC Tanner Company, Salt Lake City, Utah USA
rob@version2beta.com || rob.martin@octanner.com
@version2beta

]



[ slide:

"If debugging is the process of removing bugs, then programming must be the process of putting them in.”
- Edsger Djikstra

rob@version2beta.com
@version2beta
github.com/version2beta

Acknowledgements and appreciation to my engineering teams at OC Tanner Company for building such cool software with me, and to my bosses for supporting this opportunity to share our work with you.

]


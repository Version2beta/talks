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

OC Tanner has grown over the years primary by saying yes to customers. As revenues and capabilities have increased, they've tacked additions on to our facilities. Our basements are a good example: we have seven, and they aren't connected to each other.

I heard a story about a woman who started her first day of work by going through our half-day orientation session, and then asked if she could skip lunch and go say thank you to the friend who had recommended her. She got directions to find her friend's team, down in one of the basements.

The person leading the orientation didn't expect to see her again, since she was supposed to report to her manager after lunch. When she didn't report for work after lunch, her manager assumed she had been a no-show for the whole day. Late that afternoon someone found the poor woman in one of the basements, hopelessly lost and crying.

This is what our software is like too.

I mean, our software has grown organically over the years by saying yes to customers. Can I have this new feature? Yes. Can you make the software do things our way? Yes. What if we want this to be royal blue? No problem. Option by option, tacked on like a new tower on the castle, with a royal blue turret on top. Or purple. We can do purple too.

When I came along, my new boss put me in charge of the team responsible for configuration on the second of the two largest software packages platforms we offer. He explained to me that there were umpteen hundred settings, and onboarding required setting every one of them correctly, and that was a big reason why our onboarding process was running as long as ten months. And my team was also responsible for the monolithic web app used by 175 internal customers to manage those settings. Oh, and the only developer on that team was out on maternity leave and he didn't know when she'd be back.

He also told me that there is a standing prediction in the office that anyone who takes on configuration would be gone within six months.

Since I had no team to speak of yet, and some time on my hands, I scoped out the problem. Here are some of my findings:

* We had about 5250 configuration settings for our application alone.
* 42 tables in the database were used for storing settings.
* The legacy software dependent on the settings typically read them directly from the database.
* The primary configuration management tool also read directly from, and write directly to the database.
* There were secondary, tertiary, quaternary, and possibly quinary tools that read and write settings in the database.
* About a quarter of the settings seemed to be represented in code, but didn't do anything anymore.
* Anecdotally, some settings needed to be in "logically exceptional" states in order to make workarounds work.

This was on our product alone. We had three other products that I wasn't responsible for, at least one of which probably had similar issues, and all of which could, and probably should, use the configuration service we were going to build.

It is worth mentioning that the product I work on was built on a monolithic code base of about 2 million lines of Java by a relatively large team of subcontractors who didn't write very many tests, and our largest engineering initiative for the last two years has been to carve that code base up into well-tested microservices.

So that's what I set out to do with configuration, too, knowing that in six months I could always retrain as a hairdresser, because out of all the careers we can choose from, hairdressers have the highest job satifaction.

### Design goals

I'd love to say that my next step was to make a list of design goals for the project. And I did make some design goals, but I also had an inclination to use command-query responsibility segregation pattern and some of our most impressive design goals came out of thinking about patterns, rather than looking at our application.

This seems important to me. I've read that the typical user of enterprise software can't imagine software being a joy, only that the software can be less of a pain. I suspect this is true of many software projects, that the requirements documents will get you good software, but truly inspired software comes from finding a different vantage point.

Here are some of the design goals we settled on for our new configuration service.

* Multi-tenant - not just our product and not just configuration data.
* Hierarchical key-value store with metadata.
* 10^8 keys with <10ms response time for most queries.

Let me stop here and say that it took me about a month to finally see that we were building a database, not a specialized configuration service. I can be kinda slow, but once I got it I kicked myself and went to my CTO and asked him why he approved a project to build our own database. Didn't he know that's so 2012?

If I'd realized this sooner, I'm sure I would have dropped the project and tried to figure out how to do it with a generic NoSQL database. The jury is still out on whether that would have been a better move, but by the time I realized what we were doing we already had design goals I couldn't see doing with a general-purpose database.

* Single point of specification (the team creating the setting).
* Discoverable. Documented.
* Expose settings anywhere.
* A useful metaphor: dictionaries with definitions.

Under the old system, when we needed a new configuration settings, the developer created a row, or maybe a table, and stored what they needed there. The documentation typically consisted of the name of the table and the name of the column along with the code. Other developers that interact with that setting, for instance building a configuration management tool, have to infer how it's used. Finding all of the settings can be difficult.

In our new system, we want the developer to create a new configuration setting and store alongside it any information needed to find, understand, change, and validate that setting. So our system contains not just data but metadata - a title, a description, and a schema at least. From that we can expose the setting anywhere we'd like, with documentation that comes straight from the creator.

This metadata can also include tags that identify where the data should be exposed, and access control information defining who can view and change it.

* Composable data.
* Time variant for version control.

Our old system doesn't have the concept of default settings or settings templates. Every new customer needs to have every configuration setting established by an implementation specialist.

We want the new system to take this to another extreme, with something I - perhaps erroneously - call composable data.

This is where the metaphor comes in handy, although instead of dictionaries, we seem to have settled on the term "books". We have a book with system-wide default settings. We have books with the default settings for various option packages available by subscription. Then the customer has a book, and each user has a book. 

Imagine that you stack those books in that order, with the system wide defaults on the bottom. Each book contains only the information that needs to supercede information in a book beneath it, and when you go looking for any given setting, you can start in the topmost book and work your way down but then stop when you first find the key you need.

If you wanted, you could create a book with all the settings for any given user at any given customer by composing the books. It's like a document that adds new keys when it finds new data in each new book, but never overwrites the keys it already found.

We have a special situation though. Although many of our customers can simply use the default values in the current version of each book, some of our customers want to go through a change review process, so we can't willy-nilly update the default books without warning them. To accomodate this situation, we keep every version of every book, and can reference it by a version identifier that is a hash of that book in that version. Like the git system we shameless stole this idea from, we can also tag that version, name that book, so that we can reference it intuitively.

* Don't require changes to legacy code.
* Foreign views.

Composable data and time variance are two features that we didn't think we could get from any available database, at least not without introducing a lot of complexity and breaking our requirement for a useful metaphor. Foreign views are another.

The original monolith had about 2 million lines of Java, and we still have about a million left, spread across a half dozen teams that are dilligently working to move that code to microservices. I knew if I delivered a configuration system that required those other teams to go rewrite legacy code, the system would be a non-starter - I wouldn't get the buy-in we need to make the project successful. On the other had, if we chose to only support new code, then we'd be stuck with the old configuration management tools running alongside shiny new tools, and our internal customers would hate us.

We addressed this by supporting foreign views, or foreign projections. That is, when something changes in a book, we want to be able to map that change to a row in a database table and update it there as well. This means we need to treat the database as a view of the current state of a configuration setting, not the canonical source of that state. Because legacy code, including the tool that our internal customers are currently using to manage customer configurations write directly to the database, we also need to treat it as a source for configuration events.

### Our first application wasn't configuration data

About the time we finished our design goals and were starting to code, and unexpected thing happened. Another team came to us and said "We have a problem that's not about configuration, and we wonder if we can use the new configuration service to solve it."

Our software is used world-wide. The default version is translated into I-don't-know-how-many languages, and each customer's platform is customized and translated into the languages they need to support their employees. That means we have default translations to many different languages, each of which can be overridden by the customer.

The translation service was the first internal consumer of the configuration service. We sat down and spent two hours reviewing their needs, looking for the gaps between what we were already building and what they needed. We didn't find any. Our design goals fit their needs exactly.

I think that was the moment I realized that what we were building was actually a database.

### A time-variant key-value store

We were able to meet all of our design goals by basing our design on two relatively well known patterns: event stores, and command query responsibility segregation. In fact these two patterns influenced our design goals and exposed some wins we might not have asked for otherwise.

The basic idea goes like this. Our event store is a functional data store. That means that all the data in it is immutable. If you think of a CRUD system, create - read - update - delete, we've thrown away the update and delete. I love reducing complexity.

A book is made up of all of the events that define that book. Any specific version of that book is made up of all of the events that define that book up to any given point in time. By handling the events recorded in an event store, in the order they were received, we can create a view of the current state (or any previous state) of that book. We create these views by running a reduction on the events in the event store, and then we project that view where we want it. So we call any given view of our data a "projection".

In order to get excellent query performance, when we get a request for a key (which could be the root key of a book, but more on that later), we run the reduction and store the view in a projection in memory. Both the reduction and the projection are done by an actor, the process ID of which is registered to the key and hash.

Foreign views work the same way. After a full view is produced, the metadata indicates whether the data is also projected somewhere else. If it is, we use another service called out data coordinator to do that. Of course when we project into the database, we only project the single value for the key, none of the metadata, although that's actually customizable with the data coordinator.

At this point I want to come clean on something. When we started work on this, I had one excellent programmer available, but he is a Java developer with an interest but little experience with functional programming. Our first release on this system is not exactly as described. We built it in a lean-development sort of way, to get the interface and functionality into the hands of the developers who need it and see where our abstractions are falling short. Our current production version is written in Java 1.8 and uses one process per book rather than one actor per key. Because of this, a book is distinct from a key. Instead, it's a container for a set of keys. Data composition can only happen across books. Our development version is written in Elixir and is actor-based. In the development version, there is no difference between a book and a key - a book simply denotes the root key, any key can be considered a book, and compositions can happen at any level.

MAKE SURE THAT DATA COMPOSITION INCLUDES METADATA.

I'm sure someone will be interested in some of the trickier implementation details here, so let's talk about two of them: disk persistence and memory management.

Disk persistence was easy in our first version. We simply push every update into an Amazon Web Services S3 bucket, thereby getting all the redundancy and availability we need at the cost of performance. It's a spike, and we never intended to leave it that way, but it does expose our primary strategy, that we want to use a persistence layer that brings something to the table. In the case of S3 buckets, we get fourteen-nines of calculated uptime and a super simple implementation. Long term, we'll probably want to use a persistence strategy that also helps us resolve conflicts with simultaneous and contradictory updates. But that's actually up to the developer who's building the new version, and he may decide that making our interface WHAT'S THE ALGORITHM FOR THIS?? is a more elegant solution.

Memory management is similarly simple. When we run low on memory, we kill the least-recently-used actors. Should someone request that data again, we'll recreate the projection from the event store.

SHOULD I DESCRIBE THE API? In the interest of getting this talk done on time, I'm going to skip over the API, and just call it an implementation detail. I think we made some good choices in this area, but we're still learning from our users.

SHOULD I DESCRIBE THE DATA STRUCTURE? I'm also skipping over the data structure, even thought that may be the most interesting implementation detail. I want to be able to cover our data coordinator at least briefly, and our system for developing configuration management tools too. PROBABLY HAVE TIME TO DISCUSS THIS BUT NEED TO TALK WITH MICHAEL.

Before we move on, however, there is a design detail that I think is significant. We had to consider what happens with invalid data - what happens if someone sends us something that doesn't validate.

If we were just a regular database, we could reject it. Of course, if we were merely a database, we'd be keeping only the current state and it would be break our contract with our users to provide them data that lacks integrity. As an immutable and time-variant database, I think we have a responsibility to respond to all events, not just the ones we like, even if it means our data is in an exceptional state. The decision we made was to use the metadata to flag states that are invalid. If you ask for a key without metadata, we'll send you the most current valid state. But if you ask for the whole shebang, you'll get the current invalid state. Also, we can use the flag to create a report showing which keys are in an invalid state, and ask some human being for help.

### Data coorindators

Our initial and perhaps naive view of foreign data was two-fold. On the projection side, when we built a projection we might spawn an actor process that would run a SQL statement stored in the metadata, updating the setting in the database. On the event source side, we'd set up triggers on each of the configuration tables that would post the updated data to an API.

Once my new developer got a hold of that idea, he squeezed a very nice abstraction. He suggested we publish data updates on RabbitMQ channels, so that you can not only query a key, but subscribe to it.

For our key-value store, this is relatively trivial. We're already using RabbitMQ as our message bus, for both receiving events and answering queries. The key-value store can be it's own publisher and send updates directly to Rabbit without the need for a data coordinator. When it comes to receiving messages from a subscribed channel, it's a little more complicated because we need to build a map from each foreign data source to a key in our store. This map is essentially a secondary index one item of metadata.

On the other side of the pub-sub-sub-pub equation, we have foreign event sources and projections. Our initial case is the Oracle database. We start by using our metadata to create a map of keys to rows. In the case of a foreign data projection, we subscribe to the mapped data from the key-value store and if we see a change, we run an SQL update on the row.

Going the other way, treating changes to the database as an event source was a little more tricky. After considering several options, we'll settled on processing the Oracle redo log. ASK MICHAEL IF I EVEN HAVE A CLUE. We get change vectors by watching that log, and if the item is in our foreign data map, we can create a new event and send it to the key-value store.

It is important to note that we are not actually trying to keep two canonical data sources in sync here. Even though the legacy code may believe that Oracle is the canonical source for its configuration values, I don't. I think the database is one of several places I might project a view of the data, and just another way I can recognize an event related to configuration data. A proxy, if you will, for the actions a configuration manager might take.

As you can imagine, the idea of being able to subscribe to changes to data from almost any source is kind of exciting. Deep down inside, I suspect it's also naive, and probably doomed. Since our primary use is configuration data that doesn't actually change all that often, I think we can get away with it, but in the bigger picture it feels like a three-legged stool at best. I'm sure some of you could set me straight, and I'd be happy to hear about it after the session.

### A stack for building configuration management tools

So far we've covered getting events into the system, projecting them both locally and to foreign locations, composing data, and answering queries. That pretty much covers the back end, for both the configuration service and for the clients of the configuration service.

We also designed a slick, functional system for building configuration management tools. And it's bone simple to use.

As you recall, one of our design goals was for a single point of specification. That is, when a developer or team creates a new configuration setting, we want them to tell us all about that setting. What it's called. How it's used. How to tell if it's valid. Who can use it, and how. All of this information is stored in the metadata for the key, which means that the key can tell us everything we need to know about how to manage it.

That metadata is the basis of our configuration management. We can query the key-value store for both the data and the metadata. The metadata tells us how to present the data. In the case of a configuration management form (or screen or workflow, however you want to look at it), we can automatically render a form element based on the information provided in the metadata.

If we want to expose a setting in a configuration management screen, we simply insert a line of javascript and pass it the key. Our javascript renders a form element.

If we want to expose the same setting to a user in their profile editor, we can do the same thing. If for some reason we want to render it a little differently, maybe two radio buttons instead of a checkbox, we also provide an object that overrides the default behavior.

In a simple form, we might compose some number of configuration settings in one form, and pass the group of them back to the key-value store to be applied. In a configuration management screen, we might allow the implementation specialist to save a number of changes into a single atomic transaction that can be committed together.

Either way, you've got one of javascript per key, and maybe another line showing the transaction manager. When you submit, it sends a new event to RabbitMQ using the stomp.js library.

Of course, our implementation and customer service teams need richer, more sophisticated tools than this. Right now, their main tool is an app that exposes all of the configuration settings ever for any customer in one long list. They design their workflows around that list. We wanted to do better than that. We wanted to design the tools around their workflows, and do it so efficiently that they can iterate on their own tools.

To accomplish this, we're building their tools using a static site generator called Metalsmith, the javascript library for rendering and managing updates, and a set of templates that put it all together in a navigable, discoverable, usable set of workflows that they design.

Metalsmith is Node.js, functional static site generator. Actually, that's just one use for it. Essentially, Metalsmith is a pipelined build tool. The main loop is one long filter chain operating on all the files in a given directory.

We start with Markdown files that have some content about the tool and specify what settings are exposed on each page. In one pass, the settings are wrapped in a form element and rewritten as javascript calls. In the next pass, the markdown is converted to HTML. In another pass, navigation is constructed. In another pass, the layouts are applied, including HEAD references to the appropriate javascript libraries and stylesheets. Each source file is transformed and used as an input for the next filter, until all the filters are applied and the resulting file is written to a build directory containing all of the HTML, javascript, and CSS files for the tool site.

One of the particularly shiny things about this system is that the work of building new tools can be done by juniors. Heck, it can probably be done by some of the users themselves. The build stack is actually being built by a team of interns. Great interns, by the way. One of my teams is a women's internship program, primarily made up of women returning to the workforce after raising kids, and retraining.

That's the system, end to end, from the functional data store with immutable, time-variant data to a pipelined static site generator building the management tools. We haven't done anything in here that's actually novel, but hopefully we've applied it in novel ways. We're in the process of moving configurations onto it now, and we're learning from our internal customers and their patterns of use. We're changing things, like moving to an actor model and Elixir for the data store. We already have permission to open source the code, but being egotistical programmers we're likely to wait until it's proven under heavy production load.

It's not perfect, and it's not a general purpose database, but we hope it's going to meet our needs.

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

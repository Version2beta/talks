

## Let it crash

"First of all you make systems right, that means fault tolerant, and then you make them fast. The consequence of making them right is that you can't have lazy data structures."

In a talk he titled "Systems that run forever, self-heal, and scale", Joe Armstrong lays out six rules for creating a fault tolerant system. Spoiler alert: Erlang is designed around these.

[ slide

1. **Hot code upgrades** Need to be able to maintain the code without shutting down the system.

2. **Stable storage of data** Stable storage means we don't need backups. If data systems are also fault tolerant, then the data is already distributed in multiple copies on multiple machines.

]

While Erlang does hot code swapping and the Erlang ecosystem has strong support for fault tolerant data persistence, both of these topics are out of scope for this talk.

I'm pretty good at scope creep though, so I will add just a couple things here.

On the surface, Erlang's hot code swapping is cool, but feels like something they forgot to update over time. Erlang lets you load code in two versions, the running version and the new version. You switch from the running version to the new version by just calling the code. It's an implicit reload. When you want to run explicit code swapping, Erlang has some functionality that'll help with a lot of that. It's a little bit like Ruby's Rake, but it's also sometimes referred to as the 9th Circle of Erl.

So yeah, Erlang isn't perfect. In fact, a lot of people complain about Erlang's tool chain. As it happens there are a lot of incredibly powerful tools for Erlang, but the community around them is small and it can be hard to find and learn them.

Fault tolerant data storage is solid, though. Besides the Erlang-specific ETS, DETS, and Mnesia, my two favorite NoSQL databases are written in Erlang - CouchDB and Riak. Plus there's RabbitMQ, which is also written in Erlang, and while a message broker is very different from a database, RabbitMQ is a fault-tolerant, stable method for storing and distributing messages.

[ slide

**Isolation** computations must be isolated. We can test it, prove it, and another process can't crash it. Well isolated processes are more fault tolerant, scalability, testability, comprehensibility, and code upgrade.

**Concurrency** processes must run concurrently. The world is concurrent, parallel, and distributed. We need at least two computers to make a fault tolerant system, but a few hundred are better.

]

Isolation and concurrency are the foundation for Erlang processes, as we've already discussed.

When I started thinking about which features of Erlang are idiomatic, which features are so integral that removing them would denature the language, concurrency was first on my list. Joe Armstrong talks about Concurrency Oriented Programming Languages and a style of programming he calls Concurrency Oriented Programming. Robert Virding teaches about the fundamental difference between concurrency through shared memory, the way most programming languages do it, and share nothing concurrency. Erlang, of course, shares nothing and this is the foundation of isolation in the language.

[ slide

**Failure detection** Machines are going to die. Processes are going to die. You've got to know when this happens, even across machine boundaries. Crossing machine boundaries means you have to have pure message passing where you copy everything. You can't share dangling pointers across different machines.

**Fault identification** It's not enough to know that something crashed. You have to know what crashed, and why it crashed.

]

Every program has bugs. Extremely stable systems don't expose their bugs during the useful lifetime of the software.

Erlang does it different. It crashes. All the time.

Marvin Minsky, the founder of the MIT Media Lab, wrote a paper once called "Why programming is a good medium for expressing poorly understood and sloppily formatted ideas." In the real world, it's a lot harder to know what we're supposed to do as programmers than it is to tell computers how to do it. We can specify the parts we know pretty easily. It's the vast universe of unknowns that bite us in the ass.

I have a guideline I use for programming that I call "de Raadt's Rule". I'm pretty sure I heard it from Theo de Raadt directly, but I haven't found anyone else attributing this to him so maybe I have it wrong.

Theo de Raadt is the founder and leader of a couple of highly secure software development projects, OpenBSD and OpenSSH. He taught me that the first rule for writing secure software is to make it do what it's specified to do, and only what it's specified to do. Security exploits rarely take advantage of properly functioning code; they exploit software that's doing something it wasn't supposed to do.

Here's another quote from Joe Armstrong: "Exceptions occur when the runtime system doesn't know what to do. Errors occur when the programmer doesn't know what to do."

In some ways, you could say Erlang embodies this approach. In Erlang we can code to the specification, and simply let anything outside of that specification be an exception that crashes the process. We don't have to defend against every exceptional condition; we can simply tell Erlang what's acceptable and let everything else crash.

If it's not right, we can let it crash.

[ slide

Erlang's strengths:

* Uptime?
* Efficiency and speed?
* Network programming?

]

This was a difficult concept for me. I've heard about the telephone switch at British Telecom programmed in Erlang that reportedly achieved nine nines of uptime. Impressive, right?

I've heard about the case study that says Erlang programs are 80% smaller than the same functionality written in C++. That also sounds amazing, like I can do five times as much in the same amount of time.

I also knew that Erlang came from Ericsson and the telecom industry. With amazing pattern matching in a functional programming language, it seems like Erlang would be a great choice when I'm doing heavily network-oriented programming. An API router. A proxy server. Messaging.

I had trouble seeing how amazing uptime and code base reduction fit into the bigger picture. It's like this: a big part of the savings (27% in the study I just referenced) comes from coding for the successful case. And a big part of the uptime is that we let it crash when we don't get the successful case. It's what we do after the crash that makes the system fault tolerant, and not just incredibly stable. And sure, Erlang is good at network programming, but that is a side effect of Erlang being good at a lot of things.

[ slide

Erlang's strength:

The world is concurrent, people are isolated, and we get things done by passing messages between us.

So does Erlang.

]

Now I see that this is the big picture, the parts of Erlang that make it Erlang.

At the lowest level, we have Erlang's functional foundation with immutable data and program flow from pattern matching for the successful case.

A layer up from that we have Erlang's concurrency, with supervisors watching workers and cleaning up any messes they leave behind, and OTP providing boilerplate implementation of our most useful concurrent patterns.

Finally, there is Erlang's "Let It Crash" mentality - an acknowledgement that failures happen, and we can deal with them.

The world is a stage and we are all actors upon it. We talk, we grow, we fail, we heal. We can't change the past, but we can take care of each other.

# Idiomatic Erlang in 42 minutes

## Pattern matching and functional programming

Why functional programming and Erlang? Programs start clean, and as they grow and evolve they are much easier to keep clean.

Functional programming is *right*. That is, functional programming is math, which means we can be concerned about correctness and program integrity. By "concerned", I mean we can prove correctness.

With object oriented programs, objects encapsulate behavior within the context of a stateful environment. You can't reason about the things an object is doing unless you can nail down the object's environment. If you change how an object is implemented (the logic it encapsulates) you can change the behavior without changing the interface. If you change the object's environment, you can change the behavior without changing the interface. 

With functional programming, functions compute things. It's hard to break things and not know it. Complexity still happens, but in functional programs complexity happens horizontally - more functions, not larger functions.

* Immutable data -> Easy to test, easy to reason, stateless, concurrent
* Referential transparency (same input, same output) -> Easy to test, easy to reason, stateless, concurrent
* Pure functions (no side effects) -> Easy to test, easy to reason, stateless, concurrent

Let's start Erlang here, with some functions and pattern matching.

```
> A = 1.
> A.
1
```

Erlang does assignment a little differently than we learn in imperative programming languages. In a simple assignment, I tell Erlang that A is equal to one. That's not an instruction, though. I'm not saying "Set A equal to one." I'm merely information Erlang that A is equal to one.

```
> A = 2.
** exception error: no match of right hand side value 2
> A.
1
```

If I then try to tell Erlang that A is not equal to one, that it's actually equal to two, Erlang will politely inform me that my statement is incorrect, that the value on the left and the value on the right don't match. In fact, the only reason Erlang let me do it the first time is because A was "unbound". Given a match statement, Erlang is willing to infer the value of variables it doesn't recognize based on the match I provide.

```
> {B, 1} = {2, 1}.
> B.
2
```

Erlang will do matching even when it needs to unpack the match. However, it's important to note that an unbound variable has to appear on the left side of an equals sign.

```
> zero_is_okay(0) -> ok.
> zero_is_okay(0).
ok.
> zero_is_okay(1).
** exception error: no function clause matching idiomatic:zero_is_okay(1) (idiomatic.erl, line 12)
```

Erlang does the same kinds of pattern matching and variable binding when defining functions as well. If we define a function with a parameter that's constant, Erlang will only recognize that function when there is a match. Anything else will crash and burn.

Just as an aside, the zero_is_okay example returns an atom called 'ok'. Erlang's atom data type is a 'literal', the name and the value are the same. Ruby has a similar data type called a 'symbol'.

```
> factorializer(0) -> 0;
> factorializer(1) -> 1;
> factorializer(N) when N > 1 -> N * factorializer(N-1).
> factorializer(10).
3628800
```

This pattern matching becomes more useful when we add in Erlang's conditional dispatch. We can define the same function name with the same number of parameters in several different ways, and Erlang will use the one that matches.

```
> factorializer(-1).
** exception error: no function clause matching idiomatic:factorializer(-1) (idiomatic.erl, line 8)
```

The factorial example shows another pattern matching offered by Erlang, called a guard. In this case, our guard ensures that the value passed to the factorial function is always a positive number. If we pass a negative number, Erlang responds with an error saying we haven't defined a matching function.

```
> factorializer_test() ->
    120 = factorializer(5).
```

We also use pattern matching for simple unit testing with Erlang's eunit and common test frameworks.

## Concurrency-oriented programming

Rather than tossing around terms, let's start with some definitions:

**Distributed computing** is when our concurrent processes work together to solve a problem. This can happen on multiple machines with multiple processing cores.

**Concurrency** is when more than one process is running. We do this all the time at an operating system level, and often do it at a programming level.

**Symmetric multiprocessing** means that we can schedule processes and threads across more two or more processor cores.

A **process** is also a sequence of programmed instruction that a computer executes, but we typically allow that processes behave like programs. In fact, programs are typically processes. They can be single threaded or multithreaded. They don't share memory with each other, but they can send messages to each other. Because processes often 

A **thread** is one sequence of programmed instruction that a computer executes. Most programming is single-threaded, which means that a program runs sequentially through all of its instructions. When we want programs to do more than one thing at a time, we call that multithreading. Usually, threads in a multithreaded environment share program state. This means they share memory, and can change memory that's being used by other threads. Because threads don't carry their own memory and application state, they are often small and fast.

Erlang provides a powerful and concise set of tools for concurrency and distributed computing.

* Erlang is multithreaded, but in Erlang threads share nothing, so in Erlang we refer to threads as processes.
* Processes are isolated from one another. They share no mutable state. A failure in one process cannot affect another process in any unexpected way.
* Processes are extremely lightweight, weighing in at about 600kb minimum. It's not unusual to run tens of thousands of processes on one server, and it's possible to run millions of processes.
* Erlang provides a library called OTP that's very widely used for doing the boilerplate part of the most popular concurrent programming patterns.
* Processes share data explicitly, using message passing rather than shared memory. It's trivial to scale from one server to many.

Joe Armstrong, one of the creators of Erlang, has said that Erlang is more object-oriented than most object oriented languages because of this message-passing protocol. I asked Robert Virding, one of the other creators of Erlang, about this and he rolled his eyes. All the same, message passing is consistent with Alan Kay's statements on the primacy of messaging in object oriented programming, and combined with function closures and Erlang modules, and I think one can make an argument that Erlang has a lot in common with Object Oriented Programming.

Really though, Erlang's primary abstraction is not the object, it's concurrency. Joe Armstrong calls it Concurrency Oriented Programming, and that Erlang is a Concurrency Oriented Programming Language.

Concurrency Oriented Programming Languages have these characteristics:

* We can create large numbers of processes.
* Creating and destroying processes are efficient operations.
* Passing messages between processes is easy and cheap.
* Processes share nothing, so much so that they might as well run on separate machines.

Languages with these characteristics allow for some interesting benefits:

* It's easy to distribute our systems across multiple machines, simply by allocating parallel processes to different servers.
* It's easy to scale a system simply by adding more hardware and redistributing our processes.
* It's easy to make systems fault tolerant by breaking our processes into supervisors and workers. Workers execute our code, while supervisors watch. If anything goes wrong with a worker, the supervisor performs error recovery.

Erlang natively does all of this, and bonus, it even includes the Open Telecom Platform, or OTP for short.

OTP was created by Ericsson for programming massively parallel applications within phone networks, but the patterns are abstracted and useful for all sorts of applications, not just telecom. OTP provides concurrent versions of three primary patterns, implementing the boilerplate parts and leaving the business logic to the developer.

* A generic client-server.
* An event handler.
* A finite state machine.

OTP also provides tools for building concurrent libraries and implementing your own concurrent patterns.

Examples?

## "Let It Crash" offensive programming paradigm

"Exceptions occur when the runtime system doesn't know what to do. Errors occur when the programmer doesn't know what to do." - Joe Armstrong, co-creator of Erlang

"Programs should do what they are specified to do, and only what they're specified to do." - attributed to Theo de Raadt, founder and leader of OpenSSH and OpenBSD


Once started, Erlang applications are expected to run forever.

I've read that every program has bugs, and the best we can do is write programs that don't expose the bugs during the life of the software. But if the software is expected to run forever, then surely bugs will be exposed and something's going to crash. Our job is to write applications that know how to crash well.

I grew up with single threaded imperative programming. If something goes wrong, the program goes down. When this is our environment, we need to program defensively. We needed to catch errors and recover in our program, or we needed to do it in person. Today, we can restart crashed programs automatically, but imperative and object oriented programming languages still want us to program defensively. Plus, what happens when your program has crashed and your data is corrupt? We need to not only defend against the failure, but also clean up the mess the next time we start up.

In Erlang, we're not trying to make software that never has problems. Instead, we're building software that is fault tolerant. We want to fail fast, crash the process, and even kill other processes that might be affected if that's what will contain the issue. Then we let a supervisor process clean up the mess. This pattern does great things for fault tolerance.

Rather than building defensive code, Erlang expects us to write code that covers our specifications and let anything outside of that specification crash in a known and safe manner. As a result, Erlang code is much smaller than similar applications in Object Oriented languages. Smaller code is faster to write, more understandable, and easier to maintain.

When we try to handle an error and fail, our stack traces can be convoluted and sometimes even useless. In Erlang, we crash at the point of failure, so it's easy to know where and why the system went down.

We often have multiple processes that work together on a problem, and if one of them crashes we may need to maintain system integrity, or data integrity, by killing off all the processes in a group. This is easy to do in Erlang.

Process failure is definitely better than performing an erroneous operation. 




"First of all you make systems right, that means fault tolerant, and then you make them fast. The consequence of making them right is that you can't have lazy data structures."

Six rules of fault tolerant systems. (Spoiler alert: Erlang is designed around these.)

**Isolation** computations must be isolated. We can test it, prove it, and another process can't crash it. Well isolated processes are more fault tolerant, scalability, testability, comprehensibility, and code upgrade.

Processes are isolated in Erlang. 

**Concurrency** processes must run concurrently. The world is concurrent, parallel, and distributed. We need at least two computers to make a fault tolerant system, but a few hundred are better.

**Failure detection** Machines are going to die. Processes are going to die. You've got to know when this happens, even across machine boundaries. Crossing machine boundaries means you have to have pure message passing where you copy everything. You can't share dangling pointers across different machines.

**Fault identification** It's not enough to know that something crashed. You have to know what crashed, and why it crashed.

**Hot code upgrades** Need to be able to maintain the code without shutting down the system.

**Stable storage of data** Stable storage means we don't need backups. If data systems are also fault tolerant, then the data is already distributed in multiple copies on multiple machines.





## Notes

https://medium.com/@jugoncalves/functional-programming-should-be-your-1-priority-for-2015-47dd4641d6b9

https://michaelochurch.wordpress.com/2012/12/06/functional-programs-rarely-rot/

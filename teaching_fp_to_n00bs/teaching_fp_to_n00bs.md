# Teaching Functional Programming to n00bs in mobs

This is the source material for my talk "Teaching Functional Programming to n00bs in mobs", initially presented at [LambdaDays](http://lambdadays.org) in February 2016.

## Goals for this talk

The purpose of this talk is to discuss three things.

* functional programming.
* n00bs.
* mobs.

My current goals for this talk are too fractured. Here's the list of things I want people to take away:

1. New developers should learn, and use, a functional programming language before an imperative language.
2. New developers can learn functional programming, especially if they do it before OO.
3. Juniors should be an asset to a development team, and maybe even most of the team.
4. Startups built on a functional language are more likely to survive their success.
5. Functional programming languages reduce complexity, and that is a worthwhile primary technical goal.
6. "Pure" functional programming languages are not flexible, and this is good.
7. Elixir is a good functional programming language for n00bs.
8. Elixir is a good functional programming language for startups.
9. Mob programming is a useful tool for developing developers and development teams.
10. Mob programming produces code that is less complex and more correct than solo or pair programmed code.

Really though this talk is one part of an opus, a unified theory for team building, including startup teams.

* Use functional programming.
* Hire juniors, as many as you can.
* Throw everyone together.

But that's really the three items, right? Reworded as takeaways?

There are lots of facets to this we could explore, like -

* How do you move a code base to a functional language?
* How do you retrain a team of OO programmers?
* Is this only for startups?
* Where do we find functional programmers?
* etc.

Fortunately, the proposed talk is called "teaching functional programming to n00bs in mobs" so I can limit to that. For now, anyway.

## Stats, from Nick Baguley

0.5% unemployment for technology positions in the Salt Lake Valley and Wasatch Front

Some roles (including Javascript and Scala developers) have no identified unemployed candidates. Similar with Austin, TX for pretty much all dev jobs.

Regarding women in tech, far less than 20%.

All high level education, less than 2,000 grads in CS. 

Only one young woman took the AP CS exam in 2014.

In 2014, there were 50,000 softwares engineers in Utah. In 2014, there were 14,000 open jobs. A little over 7,000 tech companies, 4,300 of them are startups.

Salaries go up 11 - 12% a year.

Most companies that hire juniors are hiring boot camp grads and put them into manual QA. $50-60k for QA, $65k when they make junior.

Neumont grads making $60-85k a year. Experience plus skills make the difference.

Ability to network, communications skills.

MX.com, Mastery Connect, Kualico, Crowd Engine: Apprenticeship. Paired programming. Manual QA, not even SET.

Javascript, 150,000% growth according to gunDB. 

$120k offers on two years of JS + 6 mos Java or C#.

Angular or React, Node, Mongodb

Utah.gov stats

Hiring non-devs for dev jobs? Apprenticeships? 

Seniors understand how to deliver value better. That's the major thing that distinguishes a senior. Tied to value.

## Random notes

379,898 cars registered in San Francisco, 320,000 street parking spaces (including meters) in SF

Competing for 10x programmers, guessing at who they are, entrusting so much to them, it all feels too much like tossing bones.


## Quotes

Once spirit was God, then it became man, and now it is even becoming mob. --Friedrich Nietzsche

An individual developer, if they're really lucky, will code one feature a year that makes a real difference to the user. The rest is busy work. -- Scott Schlegel

The intelligence of that creature known as a crowd is the square root of the number of people in it. --Terry Pratchett

The mob rushes in where individuals fear to tread. --B.F. Skinner



## the talk

### Teaching functional programming to n00bs in mobs

### Context: building teams of functional programmers that productively uses junior developers

This talk is one of four on building teams of functional programmers. These talks build on each other, so each talk contains seeds from the others.

* Why be functional?
* Becoming functional: Functional first development
* Surrender to the mob
* >> Teaching functional programming to n00bs in mobs

### Why be functional?

[ slide:

"[W]e have to keep it crisp, disentangled, and simple if we refuse to be crushed by the complexities of our own making." Edsger Djikstra

What is complexity?

* We can't reason about our software.
* We can't test our software.
* We can't prove our software.
* Ergo, we can't trust it.

]

[ slide:

"I conclude that there are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult." C. A. R. Hoare, 1980

What is simplicity?

* We can reason about it.
* We can test it.
* We can prove it.
* Ergo, we can trust it.

]

[ slide:

"OO makes code understandable by encapsulating moving parts. FP makes code understandable by minimizing moving parts." --Michael Feathers

The simplicity test for languages:

* Does it help us to create code we can reason about?
* Does it help us to create code we can test?
* Does it help us to create code we can prove?

]

[ slide:

"The purpose of software engineering is to control complexity, not to create it." --Dr Pamela Zave

Unsupported claims about functional programming and the simplicity test:

* Pure functions: simpler
* Immutable state: simpler
* Side effects: Not necessarily simpler, just isolated

]

In object oriented code, state is encapsulated and thus hidden. It's hard for the team to see the impact of increased complexity.

In functional code, increased complexity is exposed as increasingly complicated function interfaces. It's hard to miss the impact of increased complexity.

[ slide:

"The tools we use have a profound (and devious!) influence on our thinking habits, and, therefore, on our thinking abilities." --Edsger Dijkstra

"[P]rogramming language design revolves around program design. A language’s design reflects the opinions of its creators about the proper design of programs." --Reginald Braithwaite

"A language that doesn't affect the way you think about programming is not worth knowing." --Alan Perlis

]

Functional programming is simple. Anyone who says differently, I'll wager, is an object oriented programmer.

I'm often surprised by the kind of people (good engineers, good managers) who claim that FP is hard, or that only the best seniors can even "get" it.

I accept it is hard, for them, and it was hard for me too, but I came at it with 30 years of imperative programming experience.

Even worse, I learned FP without really knowing how or why to learn it, which is a common condition in my opinion. But when it comes down to it, we're encumbered by how we've trained our brains to work, not by the subject matter.

I'm convinced a new developer learns functional programming more easily than OO programming. And I think we're proving it:

* "We made a shopping cart! OMG!"
* "When we started I thought we weren't going to get anywhere. We got a lot farther than I expected. I think we were all surprised every time something works."
* "I did a coding workshop earlier this week, and after this session I think it made everything a lot less daunting."
* "I'm really really excited about Elixir now!!"
* "I picked up five or six patterns by saying, 'How do you do this?' and somebody telling me how to do it. I very much appreciate being able to pick up on the patterns right in the moment in the problem I'm experiencing right now."
* "I feel confident that I can learn to program. It's not completely far away, out of my reach. It's something I've wanted to learn for a long time."
* "I understand functional programming much better now."
* "I'm a newby and I always think 'I don't understand much, I don't know much.' But I kept up with this. And it's more comforting to me, that I want to keep going on this."
* "It'd be really nice to know what level we're at. After doing this weekend, how far along are we to being able to do real programs that do things?"
* "I feel very energized. I feel like I want to go home and do programming."

### Becoming functional: Functional-first development

The simplicity test for languages is dependent on either the discipline of the the developer or the constraints of the language, but when it comes down to it, this is the same test we want to apply to any code.

[ slide:

* First, code whatever you can without side effects.
* Then, code your side effects.

]

[ slide:

* First, code whatever you can without side effects.
  * Core logic in the core language.
  * Referentially transparent
  * Composable
* Then, code your side effects.
  * Libraries for side effects.
  * Stateless, or use agent/services for state

"In the end, any program must manipulate state. A program that has no side effects whatsoever is a kind of black box. All you can tell is that the box gets hotter." --Simon Peyton-Jones

]

[ slide:

Simplicity test for functional first programming:

* Does it help us to create code we can reason about? Yes.
* Does it help us to create code we can test? Yes.
* Does it help us to create code we can prove? Probably.

]

[ slide:

Functional first programming gets n00b code into production sooner

* Learning a language is easy, learning an ecosystem is hard
* Much less complexity, way easier to reason about the code
* Easy testing with no mocking
* Almost all side effects use libraries, which probably need no unit tests

Less is more.

]

For n00bs, it consolidates work into two sections: the logic, based on the plain language, and side effects that require libraries. This is why we're teaching FP to n00bs, functional language or not, using functional first programming.

Side-effect free code is easy and fast to test - referential integrity for the win.

Side-effect code is almost all based on libraries and other services - nothing to unit test.

Testing and functional first programming - we don't need to test libraries for side effects.

[ slide:

Functional first refactoring:

* Refactor functions out of side effects.
* Unit test functions.
* Consolidate leftover side effects.

]

[ slide:

Functional first development gets our teams half way there

* Functional first development works with any language.
* Devs are doing functional programming, or at least major patterns, in whatever language they're using.

]

[ slide:

What's the other half?

Functional first development in a non-functional language requires knowledge, discipline, and convention.
Best is to have a language that enforces these habits - a pure functional language

]

### Mob programming

[ slide:

"The mob rushes in where individuals fear to tread." --B.F. Skinner

Mob Programming

* 5 to 9 developers and domain experts
* One large screen
* One keyboard

]

[ slide:

Our mobbing guidelines

0. Kindness, consideration, and respect are way better than having anyone in charge.
0. “Yes and” goes further than “no but”.

0. We speak at the lowest level of abstraction anyone in the mob needs in the moment.
0. Declarative language and experience sharing goes further than imperative language.
0. Thinking out loud helps everyone in the mob follow what you’re doing.

0. Drivers type code the mob proposes.
0. We learn differently when we’re the driver, so it’s important that everyone drives.
0. Rotations can happen as often as every five minutes.

0. Learning is contributing.

0. Turn up the good.

]

* “Yes and” goes further than “no” and “but”.

This comes from improv comedy training - how improv teams build off each other

* Kindness, consideration, and respect are way better than having anyone in charge.

This comes from classical anarchy - non-coercion and the value of having people work on what's important to them

* Declarative language and experience sharing goes further than imperative language.

This comes from working with declarative (functional and logical) programming languages versus imperative and object oriented languages. It also comes from working with kids, especially special needs kids. More. Prefrontal cortex.

* Thinking out loud helps everyone in the mob follow what you’re doing.

This also comes from working with special needs kids, especially from RDI. Experience-sharing, apprenticeship, self-talk, and the value of having something to say.

* We speak at the highest level of abstraction the mob is able to digest in the moment.

As a mob changes, so does the way we talk about the work of the mob. In a mob with new developers, even if there are also seniors, we will often speak in terms of what to type. As the mob becomes more experienced, our discussion becomes more and more abstract, and often the driver takes more responsibility for translating what the mob suggests into code.

* Drivers type code that the mob proposes.
* We learn differently when we’re the driver, so it’s important that everyone drives.
* Rotations can happen as often as every five minutes.

This also comes from working with special needs kids, and kids with ADHD attention-deficit/hyperactivity disorder. A lot of us learn kinetically. I can still tell you phone numbers I knew as a child, but only if I pretend to dial it. A lot of our programming is stored in fingers, not in our brain.

* <~  Learning is contributing.  ~>

This comes straight from imposter syndrome. So many people - almost everyone - are afraid to disrupt the momentum by asking questions. But without these interruptions, the mob is literally useless, a bunch of people watching someone code without understanding. The emphasis on learning is crucial.

[ slide:

The 10x developer

The 10x developer delivers an order of magnitude more value than the average developer.

]

Note, ten times the value, not ten times the code.

This is what I want, and I'm willing to start with brand new developers and try to help them become a 10x developer.

[ slide:

Avg dev: 10 decisions, average value of 1. 1<sup>10</sup> = 1.0

10x dev: 10 decisions, average value of 1.25. 1.25<sup>10</sup> = 9.31

]

To understand mob programming a little better, let's look at the extreme opposite - the (possibly mythical?) developer who, working solo, does as much as ten other programmers. He, or she, does it by making series of particularly good decisions that build on one another.

[ slide:

Examples of good decisions:

* Write less code.
* Write code the team can reason about.
* Use the right languages and abstractions.
* Depend on as little third party code as possible.
* Write code that scales linearly.
* Write code that does only what it's specified to do.
* Don't ship technical debt.
* Understand the best abstractions and architecture for your project before you start.
* Demonstrate, if possible prove, correctness.
* Write code that is secure.

]



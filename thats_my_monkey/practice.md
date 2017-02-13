# That's my monkey

## A functional, reactive, domain driven design, and common sense approach to architecture.

There's a Polish proverb that says, "This is not my circus, not my monkeys". I love this saying, how brilliantly if helps us figure out where and why we're spending our energy. I picture chaos monkeys running amok while the circus tent falls in on itself. It's hard to not get involved, but then I say "not my monkeys..." and I can let go. Phew.

And then I realize, if those aren't my monkeys, where are my monkeys? What kind of havok are they wreaking?

## What is a senior?

This article is something of a manifesto, so I decided to save time by starting in the middle.

Alan Perlis says anyone can learn to sculpt, but some people are natural. Henri Cartier-Bresson says it's going to take a lot of work before we be "not too bad" at something. If these are true, than how do we know who is advanced in our field?

I don't think it is measured in years. Or in hours, or the number of languages, or lines of code, or numbers of projects. I don't think counting helps us find the seniors.

I think "value delivered" is what tells us who are the seniors, and like that value to be delivered as simple, demonstrably correct code.

## What is a 10x developer?

We can go beyond senior and aim for the illusive (sometimes called imaginary) 10x developer. How can we tell who is a 10x developer? By what standard can we claim someone is a 10 developer?

The term was more or less created in 1968 in research done by Sackman, Erikson, and Grant, and it was restated in 1975 by Fred Brooks in the Mythical Man Month. Today we often misquote it as describing someone who is "ten times as productive as the average programmer", but the Sackman study (and many since) have demonstrated an order of magnitude difference between the most and the least productive programmers, depending on what you're measuring.

Just like with seniors, I think what to measure is the interesting question. Objective metrics per developer are difficult to measure and normalize across projects. Even value is hard to measure and normalize across projects.

On the other hand, relative value is easier to notice, when the developers are working on the same project, when we're comparing them to each other. We were going to compare them anyway, so we should pay attention to the value delivered verses the cost of producing the code. We can just look at labor time, unless you have an order of magnitude difference between what you pay developers.

## What is value?

Programming is a practical, rather than aesthetic art. We're creative for sure, but what we tend to produce are tools that other people use to build richer lives. We aren't the sculptors. We are Michelangelo's blacksmith.

The degree to which our tools meet the needs of our users is how we measure value. The contribution we as developers make toward that value depends on where we are in the software and business lifecycle, and what kind of judgement we brought along the way.

## The 10x developer

To become a 10x developer, we need to create 10 times as much value. Value comes from judgement. How much judgement does it take to deliver 10 times as much value?

Here's a thought experiment.

Let's say Developer A consistently makes decisions that deliver 25% more (that is, 1.25 times more) value to our project than the average developer per unit of effort.

Developer B is that average developer, delivering an average amount of value 1.0 times average. You know, average.

Developer C is one of our least skilled developers, and makes decisions delivering 25% less value (that is, 0.75 times as much value) per unit of effort.

I accept as a given that the decisions to which each developer is applying their judgement are decisions that compound. That is, each decision impacts all subsequent decisions.

If this is all so, and we have a project that requires ten compounding decisions that affect value comparably, that means that Developer A delivers nearly 10 times (1.25 ^ 10 = 9.31x) as much value as the *average* developer. Developer B delivers an average amount of value. And poor developer C should never have been asked to make those decisions, because the value they deliver ends up at less than 1/10th that of the average developer (0.75 ^ 10 = 0.056x). That's two orders of magnitude on a relatively complex software project when a developer has the power to impact each stage of the project.

## Creating 10x developers

10x developers are by themselves not necessarily worth the effort, especially if we need to go hunt them down and drag them back by their egos. It's far better to create our own 10x developers, and with them, 10x teams.

Here are some of the efforts I make that contribute to creating 10x developers:

* We start work together before the developer knows their first language, when they attend introductory workshops I teach on functional programming in Elixir or data science in F#. I usually teach these workshops in both the United States and Europe in collaboration with groups like Women Who Code, Girl Develop It, Girls Who Code, and other groups that advocate for women in technology. If you want to know why I work with women, ask a question at the end if I left time.

* Next I run internships, ranging from a standard master-apprentice arrangement, to creating teams of four or five interns who are responsible to learn Elixir and Elm, and work from sprint zero with an internal customer to identify and build a group project plus an individual project for each. Last class, I had one intern who delivered three individual projects. I do want to point out, I'm not recruiting from the universities. My interns range from a young woman who loved playing with her boyfriend's Arduino to a career electrician who wanted to change fields.

* All my teams are organized around a master-apprentice approach, with a senior and a junior. The senior is responsible for the junior, and the junior makes the senior better.

* We often do mob programming with as many as 6 to 8 people involved. It's a hugely collaborative activity, and as long as one member of the mob brings excellent judgement we can raise the judgement and skill level of the entire group in each mobbing session.

* The lead developer is responsible for all of the code produced by the teams on a given product or project, including architecture, design, and security. The lead developer is expected to do weekly code reviews with all her teams together so they have an opportunity to learn from the resulting discussion.

These efforts are the outcome of some of the goals I've made for myself over the past few years:

* I wanted to learn to build teams of functional programmers that productively include juniors.
* I wanted to learn to teach functional programming concepts, especially to juniors and new developers.
* I wanted to learn how to migrate teams of imperative programmers, and their code, to functional programming.
* Now, I'm trying to figure out how to take someone from an intern to a senior, based on value delivered, within four years.

## Deliver value quickly (or, can we survive our success?)

I've had a job that spoiled me in approaching these goals, but now I work in a machine learning startup. Startups have certain patterns they like to follow. In spite of that (or because of that?) such a high percentage of startups fail that I find it convenient to simply round it up to "all startups fail".

And pretty much all startups do fail, over and over again, until they either run out of runway or hit their mark. If we're going to fail often, then we want to fail as cheaply as possible. So we want to ship what we think is valuable to our users as quickly and frequently as possible, and either validate it or bin it.

The tools we've historically used for this have been:

* Rapid development environments
* Scripting languages like Ruby, Python, and Javascript
* Monolithic frameworks
* Popular libraries
* Pizza, energy drinks, and brogrammers

The code actually produced with these tools is most charitably described as "expedient", but it does allow us to validate our ideas quickly. And if they are rubbish, we can wipe the slate and try again.

But how do we handle success?

## What is anti-value?

One way to handle success is to not handicap ourselves before we even get there. It's almost as if the decisions we make in one stage directly create the problems we experience in the next. That's not a good product. That's a jobs program.

Here are some of the decisions that hobble us:

* Monolithic code is rigid, tightly couple one front end to one back end, tend toward complexity, and are often fragile in our actual applications.
* Untested and inadequately tested code is harder to work with, much harder to maintain, and tends to get shipped with more bugs.
* Agile methodologies focus on prioritizing features through an iterative (and often explorative) process. An unintended byproduct of that process is technical debt. Resolving the technical debt shipped with one feature has a much lower priority than working on the next hot feature.

## Value and anti-value

If we proceed with the typical route, we can deliver and validate value quickly, and succeed with our product. Then we get lots of users. Then our systems fall down while we scramble to fix and rewrite (often in a more functional programming language) while our customers complain.

If we manage anti-value as well as we manage value, we can deliver and validate value quickly, and success with our product. Then we get lots of users, and our system absorbs them without falling down. We don't need to refactor or rewrite, but based on our improved architecture, we can innovate new products by mashing up things that work in our existing products.

## Simple, demonstrably correct code

I found my monkeys. Their names are "Simple" and "Demonstrably correct". Maybe you've heard about them. I know my team has. I talk about them ALL THE TIME.

## What is complexity?

Before we look at simplicity, let's flip the coin over.

* Complexity is code that we didn't make small enough in scope and size. Sandi Metz has a rule for developers that their Ruby methods can't be longer than five lines. My interns and juniors have the same rule for their Elixir functions.

* Interdependency adds complexity.

* Complexity and reliability are inversely proportional. Dan Geer said "The central enemy of reliability is complexity." Tony Hoare said "The price of reliability is the pursuit of the utmost simplicity."

* Complexity is ugly. Dan Gelertner said "Beauty is the ultimate defense against complexity." Even Buckminster Fuller said "[W]hen I have finished, if the solution is not beautiful, I know it is wrong."

* Finally, code is complexity. All code. Brooks says it's either essential complexity or accidental complexity, but I think it's all just complexity. If we could deliver the same value for less effort without writing code, we would probably do that.

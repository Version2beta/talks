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

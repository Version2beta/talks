# Notes on a talk "Domain Driven Design in a Functional Context"

## DDD nomenclature

* domain - a collection of related models, events, and services representing related real world entities, activities, and processes. [Umbrella application]
* ubiquitous language - naming models, events, services, and aggregates based on the way people think about things in the actual domain
* bounded context - portions of a domain that can be simply and effectively described with a single model [Module]
* model - information within a bounded context, organized in a way that parallels the way people within a domain think about their information, using the ubiquitous language [Struct, Projection or Reduction]
* aggregate root - a model, or portion of a model, that is transformed over time in response to events [Struct]
* aggregate - a collection of events that transform the current state of an aggregate root within a model over time [Event store]
* event - a representation of something happening to a real world entity that is modeled as an aggregate within our bounded context [Event store]
* service - a function that transforms a model in response to an event [function, microservice]


# Functional Programming from Ruby to Elixir

Description: 

We've heard the arguments for functional programming, and maybe we're even convinced, but that doesn't change the fact that we have a body of code in Ruby and people paying us handsomely to work on it. Even if you want to move to functional programming, it's hard to take the leap from experienced Ruby developer to functional programming n00b. This talk addresses these concerns with code. We'll look at how to use the lowest hanging fruit from functional programming in our daily work with Ruby. As a bonus, we'll also look at how to do the same thing in Elixir, and see how familiar Elixir feels to a Ruby developer.

Bio:

Rob Martin is an architect, functional programmer, trainer, and VP Engineering for Big Squid, a machine learning and predictive analytics company in Salt Lake City, Utah. His professional work includes a focus on building teams of functional programmers, transitioning teams to functional programming, teaching and working with juniors and interns, mob programming, and simple, demonstrably correct code. He can be found online at Version2beta.com, or version2beta on Twitter, GitHub, and almost everywhere else.

## Ruby live coding

```
. ~/.bash_profile
chruby 2.4.1
bundle gem ruby_cart
cd ruby_cart
```

Fixup ruby_cart.gemspec:

```
  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"
```

Install dependencies:

`bundle`

First test?

```
-> rake spec

RubyCart
  has a version number
  does something useful (FAILED - 1)
```

Let's write a test.

```
  it "knows what's in a cart" do
    expect(RubyCart.contents(cartTestEvents)).to eq(cartShouldContain)
  end
```

Test it?

```
-> rake spec

Failures:

  1) RubyCart knows what's in a cart
     Failure/Error: expect(RubyCart.contents(cartTestEvents)).to eq(cartShouldContain)

     NameError:
       undefined local variable or method `cartTestEvents'
```

Let's add cartTestEvents.

```
require "date"
...
  def cartTestEvents
    [ { action: :add,
        item: :organic_twinkies,
        timestamp: DateTime.iso8601("2017-04-20T13:12:00Z") },
      { action: :add,
        item: :elephant_food,
        timestamp: DateTime.iso8601("2017-04-20T13:15:00Z") },
      { action: :add,
        item: :toenail_polish,
        timestamp: DateTime.iso8601("2017-04-20T13:16:00Z") },
      { action: :add,
        item: :cummerbund,
        timestamp: DateTime.iso8601("2017-04-20T13:19:00Z") },
      { action: :remove,
        item: :toenail_polish,
        timestamp: DateTime.iso8601("2017-04-20T13:25:00Z") },
      { action: :add,
        item: :hula_hoop,
        timestamp: DateTime.iso8601("2017-04-20T13:26:00Z") },
      { action: :add,
        item: :hula_hoop,
        timestamp: DateTime.iso8601("2017-04-20T13:26:02Z") },
      { action: :add,
        item: :hydrofluoric_acid,
        timestamp: DateTime.iso8601("2017-04-20T13:29:00Z") },
      { action: :remove,
        item: :hula_hoop,
        timestamp: DateTime.iso8601("2017-04-20T13:31:00Z") }
    ]
  end
```

Test this?

```
-> rake spec

Failures:

  1) RubyCart knows what's in a cart
     Failure/Error: expect(RubyCart::contents(cartTestEvents)).to eq(cartShouldContain)

     NoMethodError:
       undefined method `contents' for RubyCart:Module
```

Let's implement RubyCart::contents.

```
   def self.contents(events)
     (events.reduce([]) { |acc, event| contentReducer(acc, event) }).sort
   end
```

Test this...

```
-> rake spec

Failures:

  1) RubyCart knows what's in a cart
     Failure/Error: (events.reduce([]) { |acc, event| contentReducer(acc, event) }).sort

     NoMethodError:
       undefined method `contentReducer' for RubyCart:Module
```

Let's implement contentReducer.

```
   def self.contentReducer(acc, event)
     case event[:action]
       when :add
         acc << event[:item]
       when :remove
         acc.delete_at(acc.index(event[:item]) || acc.length)
         acc
       else
         acc
     end
   end
```

And test this...

```
-> rake spec

Failures:

  1) RubyCart knows what's in a cart
     Failure/Error: expect(RubyCart::contents(cartTestEvents)).to eq(cartShouldContain)

     NameError:
       undefined local variable or method `cartShouldContain'
```

And finally, implement cartShouldContain.

```
   def cartShouldContain
     [
       :organic_twinkies,
       :elephant_food,
       :cummerbund,
       :hula_hoop,
       :hydrofluoric_acid
     ].sort
   end
```

## Elixir live coding

```
mix new cart
cd cart
mix test
vim -O test/cart_test.exs lib/cart.ex
```

test/cart_test.exs:

First, a simple test from our example.

```
  test "cart contains all the right stuff" do
    assert Cart.contents(cartTestEvents()) == cartShouldContain()
  end
```

What should the cart contain?

```
  def cartShouldContain do
    [
      :organic_twinkies,
      :elephant_food,
      :cummerbund,
      :hula_hoop,
      :hydrofluoric_acid
    ] |> Enum.sort
  end
```

Finally, lets create a list of events:

```
  def cartTestEvents do
    [ { :add,
        :organic_twinkies,
        DateTime.from_iso8601("2017-04-20T13:12:00Z") },
      { :add,
        :elephant_food,
        DateTime.from_iso8601("2017-04-20T13:15:00Z") },
      { :add,
        :toenail_polish,
        DateTime.from_iso8601("2017-04-20T13:16:00Z") },
      { :add,
        :cummerbund,
        DateTime.from_iso8601("2017-04-20T13:19:00Z") },
      { :remove,
        :toenail_polish,
        DateTime.from_iso8601("2017-04-20T13:25:00Z") },
      { :add,
        :hula_hoop,
        DateTime.from_iso8601("2017-04-20T13:26:00Z") },
      { :add,
        :hula_hoop,
        DateTime.from_iso8601("2017-04-20T13:26:02Z") },
      { :add,
        :hydrofluoric_acid,
        DateTime.from_iso8601("2017-04-20T13:29:00Z") },
      { :remove,
        :hula_hoop,
        DateTime.from_iso8601("2017-04-20T13:31:00Z") }
    ]
  end
```

Test it?

```
-> mix test
Compiling 1 file (.ex)

1) test cart contains all the right stuff (CartTest)
     test/cart_test.exs:46
     ** (UndefinedFunctionError) function Cart.contents/1 is undefined or private
     stacktrace:
```

lib/cart.ex:

Let's define Cart.contents/1.

```
  def contents(events) do
    events |>
    Enum.reduce([], &contentReducer/2) |>
    Enum.sort
  end
```

and test it?

```
-> mix test
Compiling 1 file (.ex)

== Compilation error on file lib/cart.ex ==
** (CompileError) lib/cart.ex:9: undefined function contentReducer/2
    (stdlib) lists.erl:1338: :lists.foreach/2
    (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6
```

We can use pattern matching to implement the contentReducer.

```
  def contentReducer({:add, what, _when}, acc) do
    [ what | acc ]
  end

  def contentReducer({:remove, what, _when}, acc) do
    acc |> List.delete(what)
  end
```

and test it?

```
-> mix test
Compiling 1 file (.ex)
.

Finished in 0.03 seconds
1 test, 0 failures
```

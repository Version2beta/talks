require "spec_helper"
require "date"

RSpec.describe RubyCart do
  it "has a version number" do
    expect(RubyCart::VERSION).not_to be nil
  end

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

   def cartShouldContain
     [
       :organic_twinkies,
       :elephant_food,
       :cummerbund,
       :hula_hoop,
       :hydrofluoric_acid
     ].sort
   end

  it "knows what's in a cart" do
    expect(RubyCart::contents(cartTestEvents)).to eq(cartShouldContain)
  end
end

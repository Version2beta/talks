require "ruby_cart/version"

module RubyCart

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

   def self.contents(events)
     (events.reduce([]) { |acc, event| contentReducer(acc, event) }).sort
   end
end

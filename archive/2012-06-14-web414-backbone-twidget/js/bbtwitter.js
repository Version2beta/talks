// bbtwitter.js
// written by Rob Martin @version2beta and Arlen Walker @arlen
// for demonstration of Backbone.js at the June 2012 @web414 meetup

// Models

bbtwitter.Tweet = Backbone.Model.extend({
});

// Collections

bbtwitter.Tweets = Backbone.Collection.extend({
	model: bbtwitter.Tweet,
	url: function () {
    return 'http://search.twitter.com/search.json?q=' + this.query + '&page=' + this.page + '&callback=?'
  },
  parse: function(resp, xhr) {
    return resp.results;
  },
  page: 1,
  query: 'web414bb'
});

// Views

bbtwitter.Twidget = Backbone.View.extend({
  el: '.twidget',
  initialize: function () {
    this.tweets = new bbtwitter.Tweets();
    this.isLoading = false;
  },
  render: function () {
    var that = this;
    this.isLoading = true;
    this.tweets.fetch({
      success: function (tweets) {
        console.log(tweets);
        $(that.el).append(that.templatizer({models: tweets.models}));
        that.isLoading = false;
      }
    });
  },
  next: function() {
    this.tweets.page = this.tweets.page + 1;
    this.render();
  },
  events: {
    scroll: function() {
      if (!this.isLoading && this.el.scrollTop + this.el.clientHeight + 100 > this.el.scrollHeight) {
        this.next();
      }
    }
  },
  templatizer: _.template('<ul>' +
    '<% _.each(models, function(m){ %>' +
      '<li>' +
        '<img src="<%= m.get("profile_image_url_https") %>" alt="Twitter avatar for <%= m.get("from_user") %>" />' +
        '<span class="from"><%= m.get("from_user_name") %> (@<%= m.get("from_user") %>)</span> ' +
        '<span class="when"><%= m.get("created_at") %></span>' +
        '<span class="tweet"><%= m.get("text") %></span> ' +
      '</li>' +
    '<% }); %>' +
    '</ul>')
});

// And rock-n-roll

twidget = new bbtwitter.Twidget();
twidget.render();


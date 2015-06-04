HTMLWidgets.widget({

  name: 'formattable_widget',

  type: 'output',

  initialize: function(el, width, height) {

    return {  }

  },

  renderValue: function(el, x, instance) {
    el.innerHTML = x.html // to test js markdown conversion , markdown.toHTML( x.md )].join(' ')
  },

  resize: function(el, width, height, instance) {

  }

});

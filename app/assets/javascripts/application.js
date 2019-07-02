// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require underscore
//= require select2
//= require_tree .

function runSelect2 (klass) {
  $('#' + klass.replace('[]', '_')).select2({
    ajax: {
      url: '/search/autocomplete',
      data: function(params) {
        return {
          klass: klass.replace('[]', ''),
          term: params.term
        };
      },
      dataType: 'json',
      delay: 500,
      processResults: function(data, params) {
        return {
          results: _.map(data, function(el) {
            return {
              id: el.id,
              name: el.name
            };
          })
        };
      },
      cache: true
    },
    escapeMarkup: function(markup) {
      return markup;
    },
    minimumInputLength: 2,
    templateResult: function(item) {
      return item.name;
    },
    templateSelection: function(item) {
      return item.name;
    }
  });
}

document.addEventListener('turbolinks:before-cache', function() {
  $('.select2-hidden-accessible').select2('destroy');
});

$(document).on('turbolinks:load', function() {
  $(".navbar-burger").click(function() {
    $(".navbar-burger").toggleClass("is-active");
    $(".navbar-menu").toggleClass("is-active");
  });
});


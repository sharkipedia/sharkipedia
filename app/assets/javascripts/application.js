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

/*jshint browser:true */
/* eslint-env browser */
/* eslint no-use-before-define:0 */
/*global Uint8Array, Uint16Array, ArrayBuffer */
/*global XLSX */

function checkController(name) {
  return $('body').hasClass(name);
}

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

function isNumberKey(evt){
  var charCode = (evt.which) ? evt.which : event.keyCode
  if (charCode > 31 && (charCode < 48 || charCode > 57))
    return false;
  return true;
}

document.addEventListener('turbolinks:before-cache', function() {
  $('.select2-hidden-accessible').select2('destroy');
  $('#gridctr canvas-datagrid').remove()
});

document.addEventListener('turbolinks:load', function() {
  $(".navbar-burger").click(function() {
    $(".navbar-burger").toggleClass("is-active");
    $(".navbar-menu").toggleClass("is-active");
  });
});


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
//= require filterrific/filterrific
//= require vanilla_nested
//= require_tree .

function checkController(name) {
  return $("body").hasClass(name);
}

function runSelect2(klass) {
  $("#" + klass.replace("[]", "_")).select2({
    selectOnClose: true,
    ajax: {
      url: "/search/autocomplete",
      data: function (params) {
        return {
          klass: klass.replace("[]", ""),
          term: params.term
        };
      },
      dataType: "json",
      delay: 500,
      processResults: function (data, params) {
        return {
          results: _.map(data, function (el) {
            return {
              id: el.id,
              name: el.name,
              description: el.description
            };
          })
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) {
      return markup;
    },
    minimumInputLength: 2,
    templateResult: function (e) {
      if (e.name === undefined) {
        return "<em>loading</em>";
      } else {
        let description = e.description === null ? "" : " - " + e.description;
        return $("<span>" + e.name + description + "</span>");
      }
    },
    templateSelection: function (item) {
      return item.name;
    }
  });
}

function isNumberKey(evt) {
  var charCode = evt.which ? evt.which : event.keyCode;
  if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
  return true;
}

document.addEventListener("turbolinks:before-cache", function () {
  $(".select2-hidden-accessible").select2("destroy");
  $("#gridctr canvas-datagrid").remove();
});

document.addEventListener("turbolinks:load", function () {
  $(".navbar-burger").click(function () {
    $(".navbar-burger").toggleClass("is-active");
    $(".navbar-menu").toggleClass("is-active");
  });
});

// Override filterrific's init to no-op on pages without a #filterrific_filter
// form. The upstream version (5.2.7) dereferences the form unconditionally
// and throws "Cannot read properties of null (reading 'querySelectorAll')".
// filterrific.js has already registered the *original* init against
// turbolinks:load and DOMContentLoaded, so we must detach those before
// reassigning — otherwise the old reference keeps firing.
if (typeof Filterrific !== "undefined") {
  document.removeEventListener("turbolinks:load", Filterrific.init);
  document.removeEventListener("DOMContentLoaded", Filterrific.init);

  Filterrific.init = function () {
    var form = document.querySelector("#filterrific_filter");
    if (!form) return;
    form.querySelectorAll("input, textarea, select").forEach(function (input) {
      input.addEventListener("change", Filterrific.submitFilterForm);
    });
    Filterrific.observe_field(
      ".filterrific-periodically-observed",
      0.5,
      Filterrific.submitFilterForm
    );
  };

  document.addEventListener("turbolinks:load", Filterrific.init);
}

jQuery(document).on('turbolinks:load', function() {
  [
    'oceans', 'species[]'
  ].forEach(function(element) {
    runSelect2(element);
  });
});

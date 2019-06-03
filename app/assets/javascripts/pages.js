jQuery(document).on('turbolinks:load', function() {
  [
    'family[]',
    'species[]',
    'traits[]'
  ].forEach(function(element) {
    runSelect2(element);
  });
});

let select2Elements = [ 'family[]', 'species[]', 'traits[]' ];

jQuery(document).on('turbolinks:load', function() {
  select2Elements.forEach(function(element) {
    runSelect2(element);
  });
});

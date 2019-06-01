jQuery(document).on('turbolinks:load', function() {
  function runSelect2 (klass) {
    $('#' + klass).select2({
      ajax: {
        url: '/search/autocomplete',
        data: function(params) {
          return {
            klass: klass,
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

  [
    'family',
    'species',
    'traits'
  ].forEach(function(element) {
    runSelect2(element);
  });
});

$(document).on('turbolinks:load', function() {
  $('#trait_search').select2();

  $('#trait_search').on('select2:select', function (e) {
    var data = e.params.data;
    Turbolinks.visit('/traits/' + data.id);
  });
});

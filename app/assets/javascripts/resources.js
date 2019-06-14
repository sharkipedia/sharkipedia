$(document).on('turbolinks:load', function() {
  runSelect2('resources');

  $('#resources').on('select2:select', function (e) {
    var data = e.params.data;
    Turbolinks.visit('/resources/' + data.id);
  });
});

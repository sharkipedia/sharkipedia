$(document).on('turbolinks:load', function() {
  if (!checkController('references')) {
    return;
  }

  runSelect2('references');

  $('#references').on('select2:select', function (e) {
    var data = e.params.data;
    Turbolinks.visit('/references/' + data.id);
  });
});

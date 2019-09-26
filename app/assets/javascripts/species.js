$(document).on('turbolinks:load', function() {
  if (!checkController('species')) {
    return;
  }

  [
    'species'
  ].forEach(function(element) {
    runSelect2(element);
  });

  $('#species').on('select2:select', function (e) {
    var data = e.params.data;
    Turbolinks.visit('/species/' + data.id);
  });
});

$(document).on('turbolinks:load', function() {
  if (!checkController('observations')) {
    return;
  }

  if (checkController('new') || checkController('edit')) {
    // species autocomplete
    runSelect2('observation_species_id');
    $('#observation_species_id').on('select2:select', function (e) {
      var data = e.params.data;
      Rails.ajax({
        url: "/species/" + data.id + '.js',
        type: "get"
      })
    });

    // resources autocomplete
    runSelect2('observation_resource_id');
    $('#observation_resource_id').on('select2:select', function (e) {
      var data = e.params.data;
      Rails.ajax({
        url: "/resources/" + data.id + '.js',
        type: "get"
      })
    });

  }
});

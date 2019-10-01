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
    runSelect2('observation_resource_ids');
    $('#observation_resource_ids').on('select2:select', function (e) {
      var data = e.params.data;
      Rails.ajax({
        url: "/resources/" + data.id + '.js',
        type: "get"
      })
    });

    $(document).on('click', 'form .remove_fields', function(event) {
      $(this).prev('input[type=hidden]').val('1');
      $(this).closest('fieldset').hide();
      return event.preventDefault();
    });

    $(document).on('click', 'form .add_fields', function(event) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).before($(this).data('fields').replace(regexp, time));
      return event.preventDefault();
    });
  }
});

$(document).on('turbolinks:load', function() {
  if (!checkController('trends')) {
    return;
  }

  if (checkController('new') || checkController('edit')) {
    // species autocomplete
    runSelect2('trend_species_id');
    $('#trend_species_id').on('select2:select', function (e) {
      var data = e.params.data;
      Rails.ajax({
        url: "/species/" + data.id + '.js',
        type: "get"
      })
    });

    // references autocomplete
    runSelect2('trend_reference_id');
    $('#trend_reference_id').on('select2:select', function (e) {
      var data = e.params.data;
      Rails.ajax({
        url: "/references/" + data.id + '.js',
        type: "get"
      })
    });

    // unit / standard autocomplete
    let select2Elements = [
      'trend_standard_id', 'trend_sampling_method_id',
      'trend_data_type_id', 'trend_ocean_id', 'trend_location_id'
    ];
    select2Elements.forEach(function(element) {
      $('#' + element).select2({ selectOnClose: true });
    });

    function previewFile() {
      var preview = document.querySelector('#img_prev');
      var file    = document.querySelector('#trend_figure').files[0];
      var reader  = new FileReader();

      reader.addEventListener("load", function () {
        preview.src = reader.result;
      }, false);

      if (file) {
        reader.readAsDataURL(file);
      }
    }

    $('#trend_figure').on('change', function(e) {
      previewFile();

      let image = document.getElementById('img_prev');
      image.classList.remove("is-hidden");
    });

  } else if (checkController('show')) {
    $('.tabs ul li').on('click', function() {
      const number = $(this).data('option');
      $('.tabs ul li').removeClass('is-active');
      $(this).addClass('is-active');
      $('.tab-container .tab-item').removeClass('is-active');
      $('div[data-item="' + number + '"]').addClass('is-active');
    });
  }
});

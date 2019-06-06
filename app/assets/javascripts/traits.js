$(document).on('turbolinks:load', function() {
  $('#trait_search').select2();

  $('#trait_search').on('select2:select', function (e) {
    var data = e.params.data;
    Turbolinks.visit('/traits/' + data.id);
  });

  $('.tabs ul li').on('click', function() {
    var number = $(this).data('option');
    $('.tabs ul li').removeClass('is-active');
    $(this).addClass('is-active');
    $('.tab-container .tab-item').removeClass('is-active');
    $('div[data-item="' + number + '"]').addClass('is-active');
  });
});

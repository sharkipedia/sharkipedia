jQuery(document).on('turbolinks:load', function() {
  if (!$('body').hasClass('data_export')) {
    return;
  }

  [
    'oceans', 'species[]'
  ].forEach(function(element) {
    runSelect2(element);
  });

  if (!$('.export_data').data('csvdata')) {
    return;
  };

  var data = $('.export_data').data('csvdata');
  var wb = XLSX.read(data, {type:"binary"});
  var js = XLSX.utils.sheet_to_json(wb.Sheets.Sheet1, {header:1, raw:true});

  var grid = canvasDatagrid({
    parentNode: document.getElementById('gridctr'),
    editable: false,
    data: js
  });
  grid.style.height = '100%';
  grid.style.width = '100%';

  var date = new Date().toISOString().slice(0,10);
  var fname = 'shark-export-' + date + '.csv';
  var a = document.getElementById("data-export-link");
  a.onclick = function() {
    XLSX.writeFile(wb, fname)
    return false;
  }
});

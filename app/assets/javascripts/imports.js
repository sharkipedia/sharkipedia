// document.addEventListener("turbolinks:load", function() {
//   var url = "http://oss.sheetjs.com/test_files/formula_stress_test.xlsx";

//   var req = new XMLHttpRequest();
//   req.open("GET", url, true);
//   req.responseType = "arraybuffer";

//   req.onload = function(e) {
//     var data = new Uint8Array(req.response);
//     var workbook = XLSX.read(data, {type:"array"});

//     /* DO SOMETHING WITH workbook HERE */
//   }

//   req.send();
// });

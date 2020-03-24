import XLSX from 'xlsx';
import 'canvas-datagrid';
import './style.scss'

let gridctr = document.getElementById('gridctr');
if (gridctr !== null) {
  let url = gridctr.dataset.url;

  var req = new XMLHttpRequest();
  req.open("GET", url, true);
  req.responseType = "arraybuffer";

  req.onload = function() {
    let responseData = new Uint8Array(req.response);
    let workbook = XLSX.read(responseData, {type:"array"});

    let ws = workbook.Sheets[workbook.SheetNames[0]];
    let data = XLSX.utils.sheet_to_json(ws, {header:1});

    let grid = canvasDatagrid({
      editable: false,
    });

    grid.data = data;

    gridctr.appendChild(grid);
  }

  req.send();
}

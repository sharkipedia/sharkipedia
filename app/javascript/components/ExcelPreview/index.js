import React from "react"
import PropTypes from "prop-types"
import XLSX from 'xlsx';
import './style.scss'
import CanvasDatagrid from '../CanvasDatagrid'

class ExcelPreview extends React.Component {
  constructor(props) {
    super(props)
    this.state = { sheetData: [] }
  }

  componentDidMount() {
    this.loadSheet().then(data => {
      this.setState({ sheetData: data });
    });
  }

  loadSheet = function() {
    return new Promise(resolve => {
      fetch(this.props.url)
        .then(function(res) {
          if(!res.ok) throw new Error("fetch failed");
          return res.arrayBuffer();
        }).then(function(ab) {
          let sheetData = new Uint8Array(ab);
          let workbook = XLSX.read(sheetData, {type:"array"});
          let ws = workbook.Sheets[workbook.SheetNames[0]];
          resolve(XLSX.utils.sheet_to_json(ws, {header:1}));
        })
        .catch((error) => {
          console.error(error)
          resolve([]);
        });
    });
  }

  render () {
    return (
      <div id="gridctr">
        <CanvasDatagrid data={this.state.sheetData} editable={false} />
      </div>
    );
  }
}

ExcelPreview.propTypes = {
  url: PropTypes.string
};
export default ExcelPreview

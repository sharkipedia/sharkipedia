import React from "react"
import ReactDOM from "react-dom"
import PropTypes from "prop-types"
import 'canvas-datagrid';

class CanvasDatagrid extends React.Component {
  constructor(props) {
    super(props);
  }

  updateAttributes(nextProps) {
    Object.keys(this.props).forEach(key => {
      if (!nextProps || this.props[key] !== nextProps[key]) {
        if (this.grid.attributes[key] !== undefined) {
          this.grid.attributes[key] = nextProps ? nextProps[key] : this.props[key];
        } else {
          this.grid[key] = nextProps ? nextProps[key] : this.props[key];
        }
      }
    });
  }

  componentDidUpdate() {
    this.updateAttributes();
  }

  componentWillUnmount() {
    this.grid.dispose();
  }

  componentDidMount() {
    this.grid = ReactDOM.findDOMNode(this);
    this.grid.style.height = '100%';
    this.grid.style.width = '100%';
    this.updateAttributes();
  }

  render() {
    return React.createElement('canvas-datagrid', { } );
  }
}

CanvasDatagrid.propTypes = {
  data: PropTypes.array
};
export default CanvasDatagrid

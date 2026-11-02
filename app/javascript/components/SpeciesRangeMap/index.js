import React from "react"
import PropTypes from "prop-types"
import 'ol/ol.css';
import './style.scss'
import Map from 'ol/Map';
import View from 'ol/View';
import LayerGroup from 'ol/layer/Group';
import TileLayer from 'ol/layer/Tile';
import TileWMS from 'ol/source/TileWMS';
import SourceOSM from 'ol/source/OSM';

const IUCN_EOO_WMS_URL = 'https://geo.holmes-iv.com/geoserver/iucn_eoo/wms'
// const IUCN_EOO_WMS_URL = 'https://geo.holmes-iv.com/geoserver/IUCN_EOO/wms'

class SpeciesRangeMap extends React.Component {
  constructor(props) {
    super(props);
    this.mapContainerRef = React.createRef();
    this.state = { map: {} };
  }

  componentDidMount() {
    const cqlFilter = `"BINOMIAL" = '${this.props.binomial}'`;
    const wmsFilteredImageLayer = new TileLayer({
      title: 'dataset',
      opacity: 0.6,
      source: new TileWMS({
        url: IUCN_EOO_WMS_URL,
        params: {
          // LAYERS: 'IUCN_EOO:iucn_eeo_01_s',
          LAYERS: 'iucn_eoo:iucn_eoo_01_s',
          STYLES: 'polygon_black',
          CQL_FILTER: cqlFilter,
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const map = new Map({
      target: this.mapContainerRef.current,
      layers: [
        new LayerGroup({
          title: 'Base map',
          layers: [
            new TileLayer({
              title: 'OSM',
              type: 'base',
              visible: true,
              source: new SourceOSM()
            })
          ]
        }),
        wmsFilteredImageLayer,
      ],
      view: new View({
        // center: trendLocation,
        center: [0, 0],
        zoom: 0
      })
    });

    this.setState({
      map: map,
    });
  }

  render() {
    return(
      <div ref={this.mapContainerRef} className="speciesRangeMap"></div>
    )
  }
}

SpeciesRangeMap.propTypes = {
  binomial: PropTypes.string,
};
export default SpeciesRangeMap

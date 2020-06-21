import React from "react"
import PropTypes from "prop-types"
import 'ol/ol.css';
import 'ol-layerswitcher/src/ol-layerswitcher.css';
import './style.scss'
import Map from 'ol/Map';
import View from 'ol/View';
import LayerGroup from 'ol/layer/Group';
import VectorLayer from 'ol/layer/Vector';
import TileLayer from 'ol/layer/Tile';
import TileWMS from 'ol/source/TileWMS';
import Feature from 'ol/Feature';
import SourceOSM from 'ol/source/OSM';
import VectorSource from 'ol/source/Vector';
import LayerSwitcher from 'ol-layerswitcher';
import Point from 'ol/geom/Point';
import {Circle as CircleStyle, Fill, Stroke, Style} from 'ol/style';
import {fromLonLat} from 'ol/proj';

// http://www.marineregions.org/webservices.php
const LONGHURST_WMS_URL = "https://geo.holmes-iv.com/geoserver/longhurst/wms";

const PPOW_MEOW_WMS_URL = 'https://geo.holmes-iv.com/geoserver/ppow_meow_simplified/wms'

// FAO Statistical Areas for Fishery Purposes
const FAO_WMS_URL = 'https://geo.holmes-iv.com/geoserver/fao_area/wms'

class MarineRegionsMap extends React.Component {
  constructor(props) {
    super(props);
    this.mapContainerRef = React.createRef();
    this.state = { map: {} };
  }

  componentDidMount() {
    // LONGHURST REGIONS
    // the "selected" layer
    const longhurstCqlFilter = `INTERSECTS(the_geom, POINT(${this.props.longitude} ${this.props.latitude}))`;
    const longhurstWMSFilteredImageLayer = new TileLayer({
      title: 'dataset',
      opacity: 0.6,
      source: new TileWMS({
        url: LONGHURST_WMS_URL,
        params: {
          LAYERS: 'longhurst:Longhurst_world_v4_2010',
          STYLES: 'polygon_black',
          CQL_FILTER: longhurstCqlFilter,
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const longhurstWMSAllImageLayer = new TileLayer({
      title: 'all',
      opacity: 0.1,
      source: new TileWMS({
        url: LONGHURST_WMS_URL,
        params: {
          STYLES: 'black_line',
          LAYERS: 'longhurst:Longhurst_world_v4_2010'
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const longhurstGroup = new LayerGroup({
      title: "Longhurst Provinces",
      layers: [
        longhurstWMSAllImageLayer,
        longhurstWMSFilteredImageLayer
      ]
    });

    const ppow_meow_tiled = new TileLayer({
      title: 'all',
      opacity: 0.1,
      source: new TileWMS({
        url: PPOW_MEOW_WMS_URL,
        params: {
          'LAYERS': 'ppow_meow_simplified:ppow_meow_simplified',
          'TILED': true,
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    })

    const regionCqlFilter = `OBJECTID in (${this.props.marine_ecoregions_world.map(e => `'${e}'`).join(', ')})`

    const filteredPPOWMEOWLayer = new TileLayer({
      title: 'dataset',
      opacity: 0.6,
      source: new TileWMS({
        url: PPOW_MEOW_WMS_URL,
        params: {
          'LAYERS': 'ppow_meow_simplified:ppow_meow_simplified',
          'TILED': true,
          'CQL_FILTER': regionCqlFilter,
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    })

    const ppowmeowGroup = new LayerGroup({
      title: 'Marine Ecoregions of the World',
      layers: [
        ppow_meow_tiled,
        filteredPPOWMEOWLayer
      ]
    });

    // FAO REGIONS
    const faoWMSLayer = new TileLayer({
      title: 'all',
      opacity: 0.1,
      source: new TileWMS({
        url: FAO_WMS_URL,
        params: {
          LAYERS: 'FAO_AREAS',
          CQL_FILTER: `F_LEVEL = 'MAJOR'`
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const f_code_cqlFilter = `F_CODE in (${this.props.fao_areas.map(e => `'${e}'`).join(', ')})`

    const filteredFaoLayer = new TileLayer({
      title: 'dataset',
      opacity: 0.4,
      source: new TileWMS({
        url: FAO_WMS_URL,
        params: {
          LAYERS: 'FAO_AREAS',
          CQL_FILTER: f_code_cqlFilter,
          STYLES: 'fao_area:fao_style_active',
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const faoGroup = new LayerGroup({
      title: 'FAO areas',
      layers: [
        faoWMSLayer,
        filteredFaoLayer
      ]
    });

    // https://openlayers.org/en/latest/doc/faq.html#why-is-the-order-of-a-coordinate-lon-lat-and-not-lat-lon-
    const trendCoordinates = [this.props.longitude, this.props.latitude]
    const trendLocation = fromLonLat(trendCoordinates);

    const measurementMarker = new VectorLayer({
      source: new VectorSource({
        features: [
          new Feature({
            type: 'geoMarker',
            geometry: new Point(trendLocation)
          })
        ]}),
      style: new Style({
        image: new CircleStyle({
          radius: 7,
          fill: new Fill({color: 'black'}),
          stroke: new Stroke({
            color: 'white', width: 2
          })
        })
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
        new LayerGroup({
          title: 'Marine Regions',
          layers: [
            faoGroup,
            longhurstGroup,
            ppowmeowGroup
          ]
        }),
        measurementMarker
      ],
      view: new View({
        center: trendLocation,
        zoom: 6
      })
    });

    const layerSwitcher = new LayerSwitcher();
    map.addControl(layerSwitcher);

    this.setState({
      map: map,
    });
  }

  render() {
    return(
      <div ref={this.mapContainerRef} className="longhurtsMap"></div>
    )
  }
}

MarineRegionsMap.propTypes = {
  latitude: PropTypes.string,
  longitude: PropTypes.string,
  marine_ecoregions_world: PropTypes.array,
  fao_areas: PropTypes.array,
};
export default MarineRegionsMap

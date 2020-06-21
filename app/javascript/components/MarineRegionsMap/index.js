import React from "react"
import PropTypes from "prop-types"
import 'ol/ol.css';
import 'ol-layerswitcher/src/ol-layerswitcher.css';
import './style.scss'
import Map from 'ol/Map';
import View from 'ol/View';
import LayerGroup from 'ol/layer/Group';
import ImageLayer from 'ol/layer/Image';
import VectorLayer from 'ol/layer/Vector';
import TileLayer from 'ol/layer/Tile';
import TileWMS from 'ol/source/TileWMS';
import Feature from 'ol/Feature';
import ImageWMS from 'ol/source/ImageWMS';
// import SourceImageArcGISRest from 'ol/source/ImageArcGISRest';
import TileArcGISRest from 'ol/source/TileArcGISRest';
import SourceOSM from 'ol/source/OSM';
import VectorSource from 'ol/source/Vector';
import LayerSwitcher from 'ol-layerswitcher';
import Point from 'ol/geom/Point';
import {Circle as CircleStyle, Fill, Stroke, Style} from 'ol/style';
import {fromLonLat} from 'ol/proj';
import {WFS, GeoJSON, EsriJSON} from 'ol/format';
import {all} from 'ol/loadingstrategy';
import {or, equalTo} from 'ol/format/filter';

// http://www.marineregions.org/webservices.php
const LONGHURST_WMS_URL = "https://geo.vliz.be/geoserver/MarineRegions/wms";

const PPOW_MEOW_WMS_URL = 'https://geo.holmes-iv.com/geoserver/ppow_meow_simplified/wms'

// FAO Statistical Areas for Fishery Purposes
const FAO_WFS_URL = 'https://geo.holmes-iv.com/geoserver/ows?service=wfs&version=2.0.0&request=GetCapabilities'
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
    const longhurstWMSFilteredImageLayer = new ImageLayer({
      source: new ImageWMS({
        url: LONGHURST_WMS_URL,
        params: {
          LAYERS: 'longhurst',
          STYLES: 'polygon_black', // 'gazetteer_red',
          FILTER: `<Filter><Intersects><PropertyName>the_geom</PropertyName><Point><coordinates>${this.props.longitude},${this.props.latitude}</coordinates></Point></Intersects></Filter>`
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const longhurstWMSAllImageLayer = new ImageLayer({
      source: new ImageWMS({
        url: LONGHURST_WMS_URL,
        params: { LAYERS: 'MarineRegions:longhurst' },
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

    const cqlFilter = `OBJECTID in (${this.props.marine_ecoregions_world.map(e => `'${e}'`).join(', ')})`

    const filteredPPOWMEOWLayer = new TileLayer({
      title: 'dataset',
      opacity: 0.6,
      source: new TileWMS({
        url: PPOW_MEOW_WMS_URL,
        params: {
          'LAYERS': 'ppow_meow_simplified:ppow_meow_simplified',
          'TILED': true,
          'CQL_FILTER': cqlFilter,
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
    const faoWMSLayer = new ImageLayer({
      opacity: 0.6,
      source: new ImageWMS({
        url: FAO_WMS_URL,
        params: {
          LAYERS: 'FAO_AREAS',
          FILTER: `<Filter><PropertyIsEqualTo><PropertyName>F_LEVEL</PropertyName><Literal>MAJOR</Literal></PropertyIsEqualTo></Filter>`
        },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const f_code_filter = function(fao_areas) {
      if (fao_areas.length > 1) {
        return or(
          ...fao_areas.map(f_code => equalTo('F_CODE', f_code))
        );
      } else {
        return equalTo('F_CODE', fao_areas[0]);
      }
    }(this.props.fao_areas);

    const filteredFaoSource = new VectorSource({
      loader: function(_extent, _resolution, _projection) {
        const featureRequest = new WFS().writeGetFeature({
          srsName: 'EPSG:3857',
          featurePrefix: 'area',
          featureTypes: ['FAO_AREAS'],
          outputFormat: 'application/json',
          filter: f_code_filter
        });

        fetch(FAO_WFS_URL, {
          method: 'POST',
          body: new XMLSerializer().serializeToString(featureRequest)
        }).then(response => response.json()
        ).then(json => {
          const features = new GeoJSON().readFeatures(json);
          filteredFaoSource.addFeatures(features);
        });
      }
    });

    const filteredFaoLayer = new VectorLayer({
      source: filteredFaoSource,
      opacity: 0.3,
      style: new Style({
        fill: new Fill({
          color: 'rgba(0, 0, 255, 1.0)',
        }),
        stroke: new Stroke({
          color: 'rgba(0, 0, 79, 1)',
          width: 1.5
        })
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

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
// https://data.unep-wcmc.org/
const PPOW_MEOW_URL = "https://gis.unep-wcmc.org/arcgis/rest/services/marine/WCMC_036_MEOW_PPOW_2007_2012/MapServer"
// http://www.fao.org/geonetwork/srv/en/main.home#fisheries - FAO Statistical Areas for Fishery Purposes
// note: they don't have SSL
const FAO_WFS_URL = 'http://www.fao.org/figis/geoserver/area/ows?service=WFS&request=GetFeature&version=1.0.0&typeName=area:FAO_AREAS'
const FAO_WMS_URL = 'http://www.fao.org/figis/geoserver/area/ows?service=WMS'

const esrijsonFormat = new EsriJSON();

const ppoe_meowStyles = {
  'MEOW': new Style({
    fill: new Fill({
      color: 'rgba(71, 71, 71, 0.57)'
    }),
    stroke: new Stroke({
      color: 'rgba(255, 36, 36, 1)',
      width: 2.5
    })
  }),
  'PPOW': new Style({
    fill: new Fill({
      color: 'rgba(19, 117, 202, 0.54)'
    }),
    stroke: new Stroke({
      color: 'rgba(0, 0, 0, 1)',
      width: 2.5
    })
  })
};

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

    // MARINE ECOREGIONS OF THE WORLD
    const ppoe_meow_tiled = new TileLayer({
      opacity: 0.6,
      source: new TileArcGISRest({
        ratio: 1,
        params: {},
        url: PPOW_MEOW_URL,
        projection: 'EPSG:4326'
      })
    })

    const url = `${PPOW_MEOW_URL}/0/query?where=FID+IN+(${this.props.marine_ecoregions_world.join('%2C+')})&outFields=FID%2CTYPE%2CPROVINC&returnGeometry=true&returnTrueCurves=false&returnIdsOnly=false&returnCountOnly=false&returnZ=false&returnM=false&returnDistinctValues=false&f=pjson`
    const filteredPPOEMEOWSource = new VectorSource({
      loader: function(_extent, _resolution, projection) {
        fetch(url)
          .then(response => response.json())
          .then(info => {
            const features = esrijsonFormat.readFeatures(info, {
              featureProjection: projection
            });

            if (features.length > 0) {
              filteredPPOEMEOWSource.addFeatures(features);
            }
          });
      },
      strategy: all
    });

    const filteredPPOEMEOWLayer = new VectorLayer({
      source: filteredPPOEMEOWSource,
      opacity: 0.6,
      style: (feature) => {
        const prov_type = feature.get('TYPE');
        return ppoe_meowStyles[prov_type];
      }
    });

    const ppoemeowGroup = new LayerGroup({
      title: 'Marine Ecoregions of the World',
      layers: [
        ppoe_meow_tiled,
        filteredPPOEMEOWLayer
      ]
    });

    // FAO REGIONS
    const faoWMSLayer = new ImageLayer({
      opacity: 0.6,
      source: new ImageWMS({
        url: FAO_WMS_URL,
        params: { LAYERS: 'FAO_AREAS' },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    const filteredFaoSource = new VectorSource({
      loader: function(_extent, _resolution, _projection) {
        const featureRequest = new WFS().writeGetFeature({
          srsName: 'EPSG:3857',
          featurePrefix: 'area',
          featureTypes: ['FAO_AREAS'],
          outputFormat: 'application/json',
          filter: or(
            equalTo('F_CODE', '34'),
            equalTo('F_CODE', '37')
          )
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
            longhurstGroup,
            ppoemeowGroup,
            faoGroup
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

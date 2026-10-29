import React, { useEffect, useRef } from "react"
import PropTypes from "prop-types"
import "ol/ol.css"
import "ol-layerswitcher/dist/ol-layerswitcher.css"
import "./style.scss"
import Map from "ol/Map"
import View from "ol/View"
import LayerGroup from "ol/layer/Group"
import VectorLayer from "ol/layer/Vector"
import TileLayer from "ol/layer/Tile"
import Feature from "ol/Feature"
import SourceOSM from "ol/source/OSM"
import VectorSource from "ol/source/Vector"
import GeoJSON from "ol/format/GeoJSON"
import LayerSwitcher from "ol-layerswitcher"
import Point from "ol/geom/Point"
import { Circle as CircleStyle, Fill, Stroke, Style } from "ol/style"
import { fromLonLat } from "ol/proj"

// Region polygons are served as GeoJSON by RegionsController
// (/regions/:layer.geojson, optionally filtered with ?codes=a,b).
export const regionUrl = (baseUrl, layer, codes) => {
  const url = `${baseUrl}/${layer}.geojson`
  return codes ? `${url}?codes=${codes.map(encodeURIComponent).join(",")}` : url
}

const presentCodes = (codes) =>
  (codes || []).filter((code) => code !== null && code !== undefined && code !== "").map(String)

// A vector source that fetches one or more GeoJSON urls. OpenLayers only
// calls the loader once the layer is first rendered, so the hidden "all"
// layers cost nothing until they are switched on.
export const regionSource = (urls) => {
  const format = new GeoJSON()
  const source = new VectorSource({
    loader: (extent, _resolution, projection, success, failure) => {
      Promise.all(
        urls.map((url) =>
          fetch(url).then((response) => {
            if (!response.ok) throw new Error(`${url}: ${response.status}`)
            return response.json()
          })
        )
      )
        .then((collections) => {
          const features = collections.flatMap((collection) =>
            format.readFeatures(collection, { featureProjection: projection })
          )
          source.addFeatures(features)
          success(features)
        })
        .catch(() => {
          source.removeLoadedExtent(extent)
          failure()
        })
    },
  })
  return source
}

const regionStyle = (stroke, fill) =>
  new Style({
    stroke: new Stroke({ color: stroke, width: 1 }),
    fill: new Fill({ color: fill }),
  })

const ALL_STYLE = regionStyle("#000", "rgba(0, 0, 0, 0.05)")

// Each group keeps the old switcher layout: a hidden "all" layer with faint
// outlines of every polygon, and a "dataset" layer with the trend's regions.
const regionGroup = (title, allUrls, datasetUrls, datasetStyle) =>
  new LayerGroup({
    title,
    layers: [
      new VectorLayer({ title: "all", visible: false, opacity: 0.4, style: ALL_STYLE, source: regionSource(allUrls) }),
      new VectorLayer({ title: "dataset", opacity: 0.6, style: datasetStyle, source: regionSource(datasetUrls) }),
    ],
  })

const filteredUrls = (baseUrl, layer, codes) => {
  const present = presentCodes(codes)
  return present.length > 0 ? [regionUrl(baseUrl, layer, present)] : []
}

export const buildRegionGroups = ({ baseUrl, fao_areas, longhurst, meow, ppow }) => [
  regionGroup(
    "FAO areas",
    [regionUrl(baseUrl, "fao")],
    filteredUrls(baseUrl, "fao", fao_areas),
    regionStyle("#1f4e9c", "rgba(31, 78, 156, 0.35)")
  ),
  regionGroup(
    "Longhurst Provinces",
    [regionUrl(baseUrl, "longhurst")],
    filteredUrls(baseUrl, "longhurst", [longhurst]),
    regionStyle("#000", "rgba(0, 0, 0, 0.3)")
  ),
  // MEOW (coastal) and PPOW (pelagic) provinces share one group, as before.
  regionGroup(
    "Marine Ecoregions of the World",
    [regionUrl(baseUrl, "meow"), regionUrl(baseUrl, "ppow")],
    [...filteredUrls(baseUrl, "meow", meow), ...filteredUrls(baseUrl, "ppow", ppow)],
    regionStyle("#0b6e4f", "rgba(11, 110, 79, 0.35)")
  ),
]

const MarineRegionsMap = ({
  latitude,
  longitude,
  meow = [],
  ppow = [],
  fao_areas = [],
  longhurst = null,
  regionsBaseUrl = "/regions",
}) => {
  const mapContainerRef = useRef(null)

  useEffect(() => {
    // https://openlayers.org/en/latest/doc/faq.html#why-is-the-order-of-a-coordinate-lon-lat-and-not-lat-lon-
    const trendLocation = fromLonLat([longitude, latitude])

    const measurementMarker = new VectorLayer({
      source: new VectorSource({
        features: [new Feature({ type: "geoMarker", geometry: new Point(trendLocation) })],
      }),
      style: new Style({
        image: new CircleStyle({
          radius: 7,
          fill: new Fill({ color: "black" }),
          stroke: new Stroke({ color: "white", width: 2 }),
        }),
      }),
    })

    const map = new Map({
      target: mapContainerRef.current,
      layers: [
        new LayerGroup({
          title: "Base map",
          layers: [new TileLayer({ title: "OSM", type: "base", visible: true, source: new SourceOSM() })],
        }),
        new LayerGroup({
          title: "Marine Regions",
          layers: buildRegionGroups({ baseUrl: regionsBaseUrl, fao_areas, longhurst, meow, ppow }),
        }),
        measurementMarker,
      ],
      view: new View({ center: trendLocation, zoom: 6 }),
    })
    map.addControl(new LayerSwitcher())

    return () => map.setTarget(undefined)
    // Props come from the server-rendered page and never change; build the
    // map once on mount.
  }, [])

  return <div ref={mapContainerRef} className="longhurtsMap" data-testid="marine-regions-map"></div>
}

MarineRegionsMap.propTypes = {
  latitude: PropTypes.number,
  longitude: PropTypes.number,
  meow: PropTypes.array,
  ppow: PropTypes.array,
  fao_areas: PropTypes.array,
  longhurst: PropTypes.string,
  regionsBaseUrl: PropTypes.string,
}

export default MarineRegionsMap

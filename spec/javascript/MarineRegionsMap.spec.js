import React from "react"
import { render, screen } from "@testing-library/react"
import "@testing-library/jest-dom"
import { get as getProjection } from "ol/proj"
import MarineRegionsMap, {
  buildRegionGroups,
  regionSource,
  regionUrl,
} from "../../app/javascript/components/MarineRegionsMap"

const square = {
  type: "MultiPolygon",
  coordinates: [[[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]]]],
}
const collection = (codes) => ({
  type: "FeatureCollection",
  features: codes.map((code) => ({ type: "Feature", properties: { code }, geometry: square })),
})

const childLayers = (group) =>
  Object.fromEntries(group.getLayers().getArray().map((layer) => [layer.get("title"), layer]))

afterEach(() => {
  delete global.fetch
})

test("regionUrl builds the endpoint url with optional codes", () => {
  expect(regionUrl("/regions", "fao")).toBe("/regions/fao.geojson")
  expect(regionUrl("/regions", "fao", ["21", "31"])).toBe("/regions/fao.geojson?codes=21,31")
})

test("buildRegionGroups keeps the switcher layout and visibility defaults", () => {
  const groups = buildRegionGroups({
    baseUrl: "/regions",
    fao_areas: ["21"],
    longhurst: "NWCS",
    meow: [6],
    ppow: [],
  })

  expect(groups.map((group) => group.get("title"))).toEqual([
    "FAO areas",
    "Longhurst Provinces",
    "Marine Ecoregions of the World",
  ])
  groups.forEach((group) => {
    const { all, dataset } = childLayers(group)
    expect(all.getVisible()).toBe(false)
    expect(dataset.getVisible()).toBe(true)
  })
})

test("regionSource fetches every url and adds the features", async () => {
  global.fetch = jest.fn((url) =>
    Promise.resolve({
      ok: true,
      json: () => Promise.resolve(collection(url.includes("meow") ? ["6", "12"] : ["28"])),
    })
  )
  const source = regionSource(["/regions/meow.geojson?codes=6,12", "/regions/ppow.geojson?codes=28"])

  await new Promise((resolve) => {
    source.once("featuresloadend", resolve)
    source.loadFeatures([-1, -1, 1, 1], 1, getProjection("EPSG:3857"))
  })

  expect(global.fetch).toHaveBeenCalledTimes(2)
  expect(source.getFeatures().map((f) => f.get("code")).sort()).toEqual(["12", "28", "6"])
})

test("dataset layers without codes never fetch", async () => {
  global.fetch = jest.fn()
  const [fao] = buildRegionGroups({ baseUrl: "/regions", fao_areas: [], longhurst: null, meow: [], ppow: [] })
  const source = childLayers(fao).dataset.getSource()

  await new Promise((resolve) => {
    source.once("featuresloadend", resolve)
    source.loadFeatures([-1, -1, 1, 1], 1, getProjection("EPSG:3857"))
  })

  expect(global.fetch).not.toHaveBeenCalled()
  expect(source.getFeatures()).toHaveLength(0)
})

test("renders the map container and cleans up on unmount", () => {
  // jsdom lacks ResizeObserver, which ol/Map uses to track its size.
  global.ResizeObserver = class {
    observe() {}
    unobserve() {}
    disconnect() {}
  }
  const { unmount } = render(<MarineRegionsMap latitude={31} longitude={-81} fao_areas={["21"]} longhurst="NWCS" />)
  expect(screen.getByTestId("marine-regions-map")).toBeInTheDocument()
  expect(screen.getByTestId("marine-regions-map").querySelector(".ol-viewport")).not.toBeNull()
  unmount()
  delete global.ResizeObserver
})

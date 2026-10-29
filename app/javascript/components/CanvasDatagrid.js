import React, { useEffect, useRef } from "react"
import PropTypes from "prop-types"
import "canvas-datagrid"

// Thin wrapper around the <canvas-datagrid> web component. Each prop is
// copied onto the element: as a grid attribute when canvas-datagrid knows
// it (e.g. `editable`), otherwise as a plain property (e.g. `data`).
const CanvasDatagrid = (props) => {
  const gridRef = useRef(null)

  useEffect(() => {
    const grid = gridRef.current
    grid.style.height = "100%"
    grid.style.width = "100%"
    return () => grid.dispose()
  }, [])

  useEffect(() => {
    const grid = gridRef.current
    Object.keys(props).forEach((key) => {
      if (grid.attributes[key] !== undefined) {
        grid.attributes[key] = props[key]
      } else {
        grid[key] = props[key]
      }
    })
  })

  return React.createElement("canvas-datagrid", { ref: gridRef })
}

CanvasDatagrid.propTypes = {
  data: PropTypes.array
}

export default CanvasDatagrid

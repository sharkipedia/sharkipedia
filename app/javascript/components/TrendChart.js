import React from "react"
import PropTypes from "prop-types"
import { Line } from "react-chartjs-2"
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  TimeScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
} from "chart.js"
import "chartjs-adapter-moment"

// Chart.js 4 is tree-shakable; register the components we use.
ChartJS.register(
  CategoryScale,
  LinearScale,
  TimeScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
)

const TrendChart = (props) => {
  // In order to produce the correct year in the Date object we pass '7' for
  // the month (August), so timezone conversions don't drift into a neighbour
  // year.
  const years = props.observations.map((pair) => new Date(pair[0], 7))

  const values = props.observations.map((pair) => (pair[1] === "" ? null : pair[1]))

  const colours = values.map((value) => (value < 0 ? "red" : "yellow"))
  const pointRadius = values.map((value) => (value < 0 ? 6 : 3))
  const pointStyles = values.map((value) => (value < 0 ? "rectRot" : "circle"))
  const pointBorders = values.map((value) => (value < 0 ? "black" : "#f09154"))

  const data = {
    labels: years,
    datasets: [{
      fill: false,
      data: values,
      borderColor: "#fe8b36",
      backgroundColor: "#fe8b36",
      tension: 0,
      pointRadius: pointRadius,
      pointHoverRadius: 8,
      pointBorderColor: pointBorders,
      pointBackgroundColor: colours,
      pointStyle: pointStyles
    }]
  }

  const options = {
    animation: { duration: 0 },
    responsive: true,
    plugins: {
      legend: { display: false },
      tooltip: {
        callbacks: {
          title: (tooltipItems) => new Date(tooltipItems[0].parsed.x).getFullYear()
        }
      }
    },
    scales: {
      x: {
        type: "time",
        display: true,
        time: { unit: "year" }
      },
      y: {
        beginAtZero: true,
        display: true,
        title: {
          display: Boolean(props.unit),
          text: props.unit || ""
        }
      }
    }
  }

  return (
    <div className="trend-chart" data-testid="trend-chart">
      <Line data={data} options={options} />
    </div>
  )
}

TrendChart.propTypes = {
  observations: PropTypes.array,
  unit: PropTypes.string
}

export default TrendChart

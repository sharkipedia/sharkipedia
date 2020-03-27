import React from "react"
import PropTypes from "prop-types"
import { Line } from 'react-chartjs-2';

class TrendChart extends React.Component {
  render () {
    const years = this.props.observations.map(pair => new Date(pair[0]));
    const values = this.props.observations.map(pair => pair[1]);
    const colours = values.map((value) => value < 0 ? 'red' : 'yellow');
    const pointRadius = values.map((value) => value < 0 ? '6' : '3');
    const pointStyles = values.map((value) => value < 0 ? 'rectRot' : 'circle');
    const pointBorders = values.map((value) => value < 0 ? 'black' : '#f09154');

    const data = {
      labels: years,
      datasets: [{
        fill: false,
        data: values,
        borderColor: '#fe8b36',
        backgroundColor: '#fe8b36',
        lineTension: 0,
        pointRadius: pointRadius,
        pointHoverRadius: 8,
        pointBorderColor: pointBorders,
        pointBackgroundColor: colours,
        pointStyle: pointStyles,
      }]
    };

    const legend = {
      display: false
    }

    const options = {
      fill: false,
      animation: {
        duration: 0,
      },
      responsive: true,
      tooltips: {
        callbacks: {
          title: (tooltipItem) => {
            return new Date(tooltipItem[0].label).getFullYear() + 1;
          }
        }
      },
      scales: {
        xAxes: [{
          type: 'time',
          display: true,
          scaleLabel: {
            display: true,
          },
          distribution: 'series',
          time: {
            unit: 'year'
          }
        }],
        yAxes: [{
          ticks: {
            beginAtZero: true,
          },
          display: true,
          scaleLabel: {
            display: true,
          }
        }]
      }
    }

    return (
      <div className="trend-chart">
        <Line data={data} options={options} legend={legend} />
      </div>
    );
  }
}

TrendChart.propTypes = {
  observations: PropTypes.array
};
export default TrendChart

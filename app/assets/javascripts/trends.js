$(document).on('turbolinks:load', function() {

  function renderChart() {
    var trendData = document.querySelectorAll('.trend-data input')

    var years = [];
    var values = [];
    for (i = 0; i < trendData.length; i++) {
      if (i % 2 === 0) {
        years.push(new Date(trendData[i].value));
      } else {
        values.push(trendData[i].value);
      }
    }

    var ctx = document.getElementById('myChart').getContext('2d');

    const data = {
      labels: years,
      datasets: [{
        fill: false,
        data: values,
        borderColor: '#fe8b36',
        backgroundColor: '#fe8b36',
        lineTension: 0,
      }]
    }
    const options = {
      type: 'line',
      data: data,
      options: {
        fill: false,
        responsive: true,
        tooltips: {
          enabled: false,
        },
        legend: {
          display: false
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
    }
    const chart = new Chart(ctx, options);
  }

  renderChart();

  var valueInputs = document.querySelectorAll('.trend-data input.trend-value');
  for (i = 0; i < valueInputs.length; i++) {
    valueInputs[i].addEventListener('change', renderChart);
  }

});

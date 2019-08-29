$(document).on('turbolinks:load', function() {

  function renderChart() {
    var trendData = document.querySelectorAll('#trend-data input')

    var years = [];
    var values = [];
    for (i = 0; i < trendData.length; i++) {
      if (i % 2 === 0) {
        years.push(new Date(trendData[i].value));
      } else {
        let val = trendData[i].value;
        values.push(val === "" ? null : val);
      }
    }

    var ctx = document.getElementById('myChart').getContext('2d');

    // uncomment this to interpolate between missing data points
    // Chart.defaults.line.spanGaps = true;

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

  function calcNumYears() {
    let start = document.getElementById('trend_start_year').value;
    let end = document.getElementById('trend_end_year').value;

    if (start.match(/^\d{4}$/) && end.match(/^\d{4}$/)) {
      let noYears = end - start + 1;
      document.getElementById('trend_no_years').value = noYears;
      adjustYearValueInputs(start, end, noYears);

      let help = document.getElementById('trend-help-msg');
      if (help) {
        help.remove();
      }

      let chart = document.getElementById('myChart');
      chart.classList.remove("is-hidden");
    }
  }

  // creates or removes year <> value inputs
  function adjustYearValueInputs(start, end, noYears) {
    var trendData = document.getElementById('trend-data');
    trendData.innerHTML = "";

    for (let i = 0; i < noYears; i++) {
      trendData.insertAdjacentHTML('beforeend', yearValueInput(i, parseInt(start) + i));
    }

    var valueInputs = document.querySelectorAll('input.trend-value');
    for (i = 0; i < valueInputs.length; i++) {
      valueInputs[i].addEventListener('change', renderChart);
    }

    let target = document.querySelector('#trend_trend_observations_attributes_0_value');
      target.addEventListener('paste', (event) => {
        let paste = (event.clipboardData || window.clipboardData).getData('text');

        var values = paste.split(/\s|;|,/);
        console.log(values);

        $(values).each(function(index) {
          var inputBox = $("#trend_trend_observations_attributes_" + index + "_value");
          inputBox.val(values[index])
        });

        event.preventDefault();

        renderChart();
      });
  }

  function yearValueInput(index, year) {
    return `
  <div class="field is-horizontal">
    <div class="field-body">
        <div class="field">
          <div class="control">
            <input value="${year}" class="input" readonly="readonly" disabled="disabled" type="text" name="trend[trend_observations_attributes][${index}][year]" id="trend_trend_observations_attributes_${index}_year"><br>
          </div>
        </div>

        <div class="field">
          <div class="control">
            <input type="number" pattern="^[0–9]$" class="input trend-value" name="trend[trend_observations_attributes][${index}][value]" id="trend_trend_observations_attributes_${index}_value"><br>
          </div>
        </div>
    </div>
  </div>
    `
  }

  document.getElementById('trend_end_year')
    .addEventListener('change', calcNumYears);
  document.getElementById('trend_start_year')
    .addEventListener('change', calcNumYears);
});

$('document').ready(function(){
  var ctx = document.getElementById("convertsChart");
  var scatterChart = new Chart(ctx, {
    type: 'line',
    showTooltips: true,
    data: {
      datasets: [{
        label: 'Exchange amount',
        data: rates,
        backgroundColor: 'rgba(69, 173, 242, 0.7)',
        borderColor: 'rgba(69, 81, 242, 1)',
        borderWidth: 4
      }]
    },
    options: {
      scales: {
        xAxes: [{
          display: true,
          ticks: {
            autoSkip: true,
            maxTicksLimit: 10
          },
          type: 'time',
          time: {
            unit: 'week'
          }
        }]
      }
    }
  });
});

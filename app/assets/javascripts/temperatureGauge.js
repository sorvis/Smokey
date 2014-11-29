$(function () {

    $('#temperatureGauge').highcharts({

chart: {
type: 'gauge',
plotBackgroundColor: null,
plotBackgroundImage: null,
plotBorderWidth: 0,
plotShadow: false
},

title: {
text: 'Temperature'
},

pane: {
startAngle: -150,
endAngle: 150,
background: [{
backgroundColor: {
linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
stops: [
  [0, '#FFF'],
[1, '#333']
  ]
                 },
borderWidth: 0,
             outerRadius: '109%'
}, {
backgroundColor: {
linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                stops: [
                  [0, '#333'],
                [1, '#FFF']
                  ]
                 },
borderWidth: 1,
             outerRadius: '107%'
}, {
  // default background
}, {
backgroundColor: '#DDD',
                   borderWidth: 0,
                   outerRadius: '105%',
                   innerRadius: '103%'
}]
},

  // the value axis
yAxis: {
min: 0,
     max: 240,

     minorTickInterval: 'auto',
     minorTickWidth: 1,
     minorTickLength: 10,
     minorTickPosition: 'inside',
     minorTickColor: '#666',

     tickPixelInterval: 30,
     tickWidth: 2,
     tickPosition: 'inside',
     tickLength: 10,
     tickColor: '#666',
     labels: {
step: 2,
      rotation: 'auto'
     },
title: {
text: 'Fahrenheit'
       },
plotBands: [{
from: 0,
      to: 120,
      color: '#DDDF0D' // green
           }, {
from: 120,
      to: 180,
      color: '#55BF3B' // yellow
           }, {
from: 180,
      to: 240,
      color: '#DF5353' // red
           }]
       },

series: [{
name: 'Speed',
      data: [80],
      tooltip: {
valueSuffix: ' km/h'
      }
        }]

},
  // Add some life
  function (chart) {
    if (!chart.renderer.forExport) {
      setInterval(function () {
          var point = chart.series[0].points[0];

          $.ajax({
              type: "GET",
              url: "<%= summary_latest_path %>" ,
                  dataType: "JSON",
                      success: function(data) {
                        newVal = data.fahrenheit;
                        point.update(Number(newVal));
                        chart.setTitle({text: "Temperature -- " + data.created_at});
                            }
                            });
          }, 3000);
    }
  });
});



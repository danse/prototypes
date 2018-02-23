function convert (d) {
  return {
    value: parseFloat(d.value),
    date: Date.parse(d.date)
  };
};
var data = [{
  value: 1,
  count: 1,
  date: 2
},{
  value: 2,
  count: 1,
  date: 2
},{
  value: 3,
  count: 1,
  date: 2
}];

function visie (data) {
  var chart = tornado()
  var converted = data.map(convert).filter(function(x) {
    return !isNaN(parseFloat(x.value));
  });
  converted.sort(function(a, b) {
    return b.date - a.date;
  });
  var aggregated = aggregate(converted);
  var interval = 100000 / data.length;
  aggregated.forEach(function(data, frame) {
    setTimeout(function() {
      d3
        .select('.chart')
        .data([data])
        .call(chart);
    }, frame * interval);
  });
}

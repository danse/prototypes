'use strict';

function tornado(config) {

    function getValue(x) { return x.value; }
    function getCount(x) { return x.count; }
    function getDate(x) { return x.date; }
    function formatTimestamp(x) { return (new Date(x)).toDateString(); }

    var compact = false,
    resize = true,
    duration = 200,
    margin = {
        top: 100,
        right: 200,
        bottom: 100,
        left: 200
    },
    totalWidth = 960,
    totalHeight = 500,
    width = totalWidth - margin.left - margin.right,
    height = totalHeight - margin.top - margin.bottom,
    scale = {
        x: d3.scale.linear(),
        y: d3.scale.linear(),
        radius: d3.scale.linear(),
        opacity: d3.scale.linear()
    },
    radius = {
        min: 2,
        max: 40
    },
    axis = {
        x: d3.svg.axis().scale(scale.x).orient('top'),
        y: d3.svg.axis().scale(scale.y).orient('left')
            .tickFormat(formatTimestamp)
    };

    var chart = function(selection) {

        selection.each(function(data) {
            if (compact) {
                height = 0;
                totalHeight = margin.top + margin.bottom;
            }
            if (resize) {
                scale.x
                    .domain([d3.min(data, getValue), d3.max(data, getValue)])
                    .range([0, width]);
            }
            scale.y
                .domain([d3.min(data, getDate), d3.max(data, getDate)])
                .range([0, height]);
            scale.radius
                .domain([1, data.length])
                .range([radius.min, radius.max]);
            scale.opacity
                .domain([1, data.length])
                .range([1, 0]);

            // select the root element if it exist
            var svg = d3.select(this).selectAll('svg').data([true]);
            // otherwise create it
            var gEnter = svg.enter().append('svg').append('g');
            
            svg
                .attr('width', totalWidth)
                .attr('height', totalHeight);

            var g = svg.select('g')
                .attr('transform',
                      'translate('+margin.left+','+margin.top+')');

            var dataGroup = g
                .selectAll('g.datum')
                .data(data, getDate);

            var groupEnter = dataGroup
                .enter()
                .append('g')
                .attr('class', 'datum');
            groupEnter
                .append('circle');
            groupEnter
                .append('title');
            
            dataGroup
            /* make sure that the smaller circles are on front. this
             * is useful just for the compact view */
                .sort(function(a, b) {
                    return d3.descending(a.count, b.count);
                })
                .transition()
                .duration(duration)
                .delay(duration)
                .attr('transform', function(d, i) {
                    return 'translate('+
                        scale.x(getValue(d))+','+
                        scale.y(getDate(d))+')';
                });
            dataGroup
                .select('circle')
                .transition()
                .duration(2*duration)
                .attr('r', function(d, i) {
                    return scale.radius(getCount(d));
                })
                .attr('class', function(d, i) {
                    return (getValue(d) > 0) ? 'positive' : 'negative';
                })
                .style('fill-opacity', function(d) {
                    return compact ? 1 : scale.opacity(getCount(d));
                });
            dataGroup
                .select('title')
                .text(function(d, i) {
                    return 'value: '+d.value+'\n'+
                        'represents '+d.count+' points\n'+
                        'date: '+(new Date(d.date)).toDateString();
                });

            // after data has been appended
            gEnter.append('g').attr('class', 'x axis');
            if (!compact) {
                gEnter.append('g').attr('class', 'y axis');
            }

            g.select('.x.axis').call(axis.x);
            g.select('.y.axis').call(axis.y);
        });
    };
    chart.compact = function(arg) {
        if (typeof arg == 'undefined') {
            return compact;
        } else {
            compact = arg;
            return chart;
        }
    };
    chart.resize = function(arg) {
        if (typeof arg == 'undefined') {
            return resize;
        } else {
            resize = arg;
            return chart;
        }
    };
    return chart;
}

// aggregate data, expects them to be sorted
function aggregate(data) {
    function copy(x){ return JSON.parse(JSON.stringify(x)); }
    var iterations = [];
    function sum(i, j) {
        var sum = i.sum + j.value;
        var count = i.count + 1;
        return {
            value: sum / count,
            sum: sum,
            count: count,
            date: j.date
        };
    };
    function process(iteration, prev, current) {
        iterations.push(copy(iteration));
        if (current < iteration.length) {
            iteration[current] = sum(iteration[prev], iteration[current]);
            process(iteration, prev+1, current+1);
        }
    };
    data.forEach(function(d) { d.count = 1; });
    data[0].sum = data[0].value;
    process(data, 0, 1);
    return iterations;
}

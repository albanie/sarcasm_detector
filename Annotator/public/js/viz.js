var custom_bubble_chart = (function(d3, CustomTooltip) {
  "use strict";
 
  var width = 700,
      height = 300,
      tooltip = CustomTooltip("gates_tooltip", 240),
      layout_gravity = -0.01,
      damper = 0.1,
      nodes = [],
      vis, force, circles, radius_scale;
 
  var center = {x: width / 2, y: height / 2};
 
  var category_centers = {
      "positive": {x: width / 3, y: height / 2},
      "sarcastic": {x: width / 2, y: height / 2},
      "negative": {x: 2 * width / 3, y: height / 2}
    };
 
  var fill_color = d3.scale.ordinal()
                  .domain(["positive", "sarcastic", "negative"])
                  .range(["#01939a", "#8f04aa", "#ff9900"]);
 
  function custom_chart(data) {
    var max_amount = d3.max(data, function(d) { return parseInt(5, 10); } );
    radius_scale = d3.scale.pow().exponent(0.5).domain([0, max_amount]).range([2, 85]);
 
    //create node objects from original data
    //that will serve as the data behind each
    //bubble in the vis, then add each node
    //to nodes to be used later
    data.forEach(function(d){
      var node = {
        id: d.id,
        name: d.tweet_content,
        category: d.category,
        radius: Math.random() * 10, //radius_scale(parseInt(d.tweet_content.length, 10)),
        value: 5,    
        x: Math.random() * 900,
        y: Math.random() * 800
      };
      nodes.push(node);
    });
 
    nodes.sort(function(a, b) {return b.id- a.id; });
 
    vis = d3.select("#vis").append("svg")
                .attr("width", width)
                .attr("height", height)
                .attr("id", "svg_vis");
 
    circles = vis.selectAll("circle")
                 .data(nodes, function(d) { return d.id ;});
 
    circles.enter().append("circle")
      .attr("r", 0)
      .attr("fill", function(d) { return fill_color(d.category) ;})
      .attr("stroke-width", 2)
      .attr("stroke", function(d) {return d3.rgb(fill_color(d.category)).darker();})
      .attr("id", function(d) { return  "bubble_" + d.id; })
      .on("mouseover", function(d, i) {show_details(d, i, this);} )
      .on("mouseout", function(d, i) {hide_details(d, i, this);} );
 
    circles.transition().duration(2000).attr("r", function(d) { return d.radius; });
 
  }
 
  function charge(d) {
    return -Math.pow(d.radius, 2.0) / 8;
  }
 
  function start() {
    force = d3.layout.force()
            .nodes(nodes)
            .size([width, height]);
  }
 
  function display_group_all() {
    force.gravity(layout_gravity)
         .charge(charge)
         .friction(0.9)
         .on("tick", function(e) {
            circles.each(move_towards_center(e.alpha))
                   .attr("cx", function(d) {return d.x;})
                   .attr("cy", function(d) {return d.y;});
         });
    force.start();
    hide_categories();
  }
 
  function move_towards_center(alpha) {
    return function(d) {
      d.x = d.x + (center.x - d.x) * (damper + 0.02) * alpha;
      d.y = d.y + (center.y - d.y) * (damper + 0.02) * alpha;
    };
  }
 
  function display_by_category() {
    force.gravity(layout_gravity)
         .charge(charge)
         .friction(0.9)
        .on("tick", function(e) {
          circles.each(move_towards_category(e.alpha))
                 .attr("cx", function(d) {return d.x;})
                 .attr("cy", function(d) {return d.y;});
        });
    force.start();
    display_categories();
  }
 
  function move_towards_category(alpha) {
    return function(d) {
      var target = category_centers[d.category];
      d.x = d.x + (target.x - d.x) * (damper + 0.02) * alpha * 1.1;
      d.y = d.y + (target.y - d.y) * (damper + 0.02) * alpha * 1.1;
    };
  }
 
 
  function display_categories() {
      var categories_x = {"positive": 160, "sarcastic": width / 2, "negative": width - 160};
      var categories_data = d3.keys(categories_x);
      var categories = vis.selectAll(".categories")
                 .data(categories_data);
 
      categories.enter().append("text")
                   .attr("class", "categories")
                   .attr("x", function(d) { return categories_x[d]; }  )
                   .attr("y", 40)
                   .attr("text-anchor", "middle")
                   .text(function(d) { return d;});
 
  }
 
  function hide_categories() {
      var categories = vis.selectAll(".categories").remove();
  }
 
 
  function show_details(data, i, element) {
    d3.select(element).attr("stroke", "black");
    var content = "<span class=\"name\">Tweet:</span><span class=\"value\"> " + data.name + "</span><br/>";
    content +="<span class=\"name\">Category:</span><span class=\"value\"> " + data.category + "</span>";
    tooltip.showTooltip(content, d3.event);
  }
 
  function hide_details(data, i, element) {
    d3.select(element).attr("stroke", function(d) { return d3.rgb(fill_color(d.category)).darker();} );
    tooltip.hideTooltip();
  }
 
  var my_mod = {};
  my_mod.init = function (_data) {
    custom_chart(_data);
    start();
  };
 
  my_mod.display_all = display_group_all;
  my_mod.display_category = display_by_category;
  my_mod.toggle_view = function(view_type) {
    if (view_type == 'category') {
      display_by_category();
    } else {
      display_group_all();
      }
    };
 
  return my_mod;
})(d3, CustomTooltip);
console.log();
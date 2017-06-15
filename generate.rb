#!/usr/bin/env ruby
require 'csv'

require 'json'
require 'erb'

csv = CSV.read('idol.csv')

nodedata = csv.each_with_index.
  select { |l,idx| idx > 0 && l[0] }.
  map { |l, idx|
    {
      id: idx.to_i,
      label: l[0],
      group: l[1],
    }
  }

edges = []
csv.each_with_index do |l, _y|
  l.each_with_index do |c, _x|
    x = _x - 1
    y = _y
    if c =~ /◯/ && x < y
      edges << [x,y]
    end
  end
end

edgedata = edges.map do |x,y|
  {
    from: x,
    to: y,
  }
end

options = {
  nodes: {
    shape: 'circle'
  },
  groups: {
    火: {
      color: '#fee',
      border: 'red',
    },
    水: {
      color: '#eef',
      border: 'blue',
    },
    風: {
      color: '#efe',
      border: 'green',
    },
    土: {
      color: '#d7A992',
      border: '#734229',
    },
    闇: {
      color: '#ddd',
      border: 'black',
    },
    光: {
      color: '#ff3',
      border: '#cbcc00',
    },
  },
}

File.write "docs/graph.html", ERB.new(DATA.read).result(binding)

__END__
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>グラブルxシンデレラガールズコラボ掛け合いネットワーク</title>
  <script src="//cdnjs.cloudflare.com/ajax/libs/vis/4.20.0/vis.min.js"></script>
  <link href="//cdnjs.cloudflare.com/ajax/libs/vis/4.20.0/vis.min.css" rel="stylesheet" type="text/css" />
  <style type="text/css">
    h1 { font-size: 1em; }
    @font-face {
      font-family: 'Noto Sans JP';
      font-style: normal;
      font-weight: 400;
        src: local("Noto Sans CJK JP"),
        url(//fonts.gstatic.com/ea/notosansjp/v5/NotoSansJP-Regular.woff2) format('woff2'),
        url(//fonts.gstatic.com/ea/notosansjp/v5/NotoSansJP-Regular.woff) format('woff'),
        url(//fonts.gstatic.com/ea/notosansjp/v5/NotoSansJP-Regular.otf) format('opentype');
    }
  </style>
</head>
<body>
<h1>グラブルxシンデレラガールズコラボ掛け合いネットワーク</h1>
<div id="mygraph"></div>
<script type="text/javascript">
  var container = document.getElementById('mygraph');
  var nodes = new vis.DataSet(
<%= nodedata.to_json %>
  );

  var edges = new vis.DataSet(
<%= edgedata.to_json %>
  );

  var data = { nodes: nodes, edges: edges };
  var options = <%= options.to_json %>;

  var network = new vis.Network(container, data, options);
</script>
</body>

</html>

Snap = require 'snapsvg'

s = Snap 800, 600

smallCircle = s
  .circle 100, 150, 70

discs = s
  .group smallCircle, s.circle 200, 150, 70
  .attr
    fill: 'R(150, 150, 100)#fff-#000'

patternStripes = s
  .path 'M10-5-10,15M15,0,0,15M0-5-20,15'
  .attr
    fill: 'none'
    stroke: '#bada55'
    strokeWidth: 5
  .pattern 0, 0, 10, 10

bigCircle = s
  .circle 150, 150, 100
  .attr
    fill: patternStripes
    stroke: '#000'
    strokeWidth: 5
    mask: discs

discs.selectAll('circle').animate {r: 50}, 1000

patternStripes.select('path').animate {stroke: '#f00'}, 1000

bigCircle.drag()

s.text 200, 100, 'Snap.svg'

Snap   = require 'snapsvg'
Graph  = require '../../graph/graph'
config = require './data'

class SVGGraph

  constructor: (@paper, @config) ->
    @start = @finish = undefined
    @graph = new Graph config

  ###
  Handles vertex dragging movement events.
  ###
  onDragMove: (dx, dy, x, y) ->
    @moveTo x, y
    @el.attr cx: x, cy: y
    for edge in @edges
      edge.el
        .attr if @ is edge.v1 then {x1: x, y1: y} else {x2: x, y2: y}
        .attr strokeWidth: 2

  ###
  Handles vertex dragging stop.
  ###
  onDragEnd: ->
    @findShortestPath @start, @finish

  ###
  Initializes graph display.
  ###
  init: ->
    for edge in @graph.edges
      [x1, y1] = [edge.v1.position[0], edge.v1.position[1]]
      [x2, y2] = [edge.v2.position[0], edge.v2.position[1]]
      edge.el  = @paper.line x1, y1, x2, y2
        .addClass 'edge'
        .attr strokeWidth: 2

    for id, vertex of @graph.vertices
      vertex.el = @paper.circle vertex.position[0], vertex.position[1], 15
        .addClass 'vertex'
        .attr strokeWidth: 2
        .drag @onDragMove, null, @onDragEnd, vertex, null, @

    @

  findShortestPath: (@start, @finish) ->
    @resetHighlight()
    path = @graph.findShortestPath @graph.vertices[start], @graph.vertices[finish]
    @highlightPath path

  resetHighlight: ->
    for index, vertex of @graph.vertices
      vertex.el?.removeClass 'highlight'
      for edge in vertex.edges
        edge.el?.removeClass 'highlight'

  highlightPath: (path) ->
    for edge in path
      edge.v1.el?.addClass 'highlight'
      edge.v2.el?.addClass 'highlight'
      edge.el?.addClass 'highlight'

paper = Snap 800, 600
graph = new SVGGraph paper, config
graph.init().findShortestPath 'A', 'Z'

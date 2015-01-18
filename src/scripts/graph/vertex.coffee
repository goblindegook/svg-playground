_    = require 'underscore'
Edge = require './edge'

###
Graph vertex.
###
module.exports = class Vertex

  ###
  Vertex constructor.
  @param {String} id       Vertex id.
  @param {Array}  position Vertex position coordinates.
  ###
  constructor: (@id, @position) ->
    @edges    = []        # Connecting edges.

  ###
  Determines the Euclidian distance between two vertices.
  @param  {Vertex} vertex Vertex to measure distance from.
  @return {Number}        Distance to vertex.
  ###
  distanceToVertex: (vertex) ->
    quadrance = 0
    for coordinate, i in vertex.position
      quadrance = quadrance + (@position[i] - coordinate) ** 2
    Math.sqrt quadrance

  ###
  Connects with another vertex.
  @param  {Vertex} vertex Vertex to connect to.
  @return {Edge}          Connecting edge.
  ###
  connectToVertex: (vertex) ->
    edge = new Edge @, vertex, @distanceToVertex vertex
    @edges.push edge
    vertex.edges.push edge
    edge

  ###
  Find the first edge that connects this vertex to the provided neighbor.
  @param  {Vertex} neighbor Neighboring vertex.
  @return {Edge}            First edge that connects to provided vertex.
  ###
  edgeToNeighborVertex: (neighbor) ->
    _.find @edges, (edge) -> neighbor in [edge.v1, edge.v2]

  ###
  Move vertex to a new position.
  @param {Number} position... Multiple coordinates.
  ###
  moveTo: (position...) ->
    @position = _.map position, (coordinate) -> parseFloat coordinate
    edge.updateDistance() for index, edge of @edges

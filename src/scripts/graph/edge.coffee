###
Graph edge.
###
module.exports = class Edge

  ###
  Edge constructor.
  @param {Vertex} v1       First vertex.
  @param {Vertex} v2       Second vertex.
  @param {Number} distance Distance between vertices.
  ###
  constructor: (@v1, @v2, @distance) ->

  ###
  Recalculate distance between vertices.
  ###
  updateDistance: ->
    @distance = @v1.distanceToVertex @v2

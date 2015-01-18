Edge   = require './edge'
Vertex = require './vertex'

###
Graph object.
###
module.exports = class Graph

  ###
  Graph constructor.
  ###
  constructor: ->
    @vertices = {}

  ###
  Returns the first vertex with id.
  @param  {String} id Vertex identifier.
  @return {Vertex}    Vertex with id.
  ###
  getVertex: (id) -> @vertices[id]

  ###
  Adds a vertex if nothing exists at its position, otherwise reuses it.
  @param  {String} id       Vertex id.
  @param  {Array}  position Vertex position.
  @return {Vertex}          Added vertex, or existing one.
  ###
  addVertex: (id, position) ->
    @vertices[id] = new Vertex id, position

  ###
  Implements Dijkstra's algorithm with a priority queue to find the shortest
  route between two vertices in the graph.

  @param  {Vertex} origin      Starting node identifier.
  @param  {Vertex} destination Destination node identifier.
  @return {Array}              Edges describing the shortest path between vertices.
  ###
  findShortestPath: (origin, destination) ->
    queue    = []
    path     = []

    for index, vertex of @vertices
      vertex.distance = if vertex is origin then 0 else Infinity
      vertex.previous = null
      queue.push vertex

    # Sort unvisited nodes by distance:
    queue.sort (a, b) -> a.distance - b.distance

    while queue.length
      nearest = queue.shift()

      if destination is nearest
        # Reached destination vertex
        while nearest.previous
          edge    = nearest.edgeToNeighborVertex nearest.previous
          nearest = nearest.previous 
          path.unshift edge
        break

      continue if not nearest or nearest.distance is Infinity

      for edge in nearest.edges
        priority = edge.distance + nearest.distance
        neighbor = if edge.v1 is nearest then edge.v2 else edge.v1

        if priority < neighbor.distance
          # Found a shorter path:
          neighbor.distance = priority
          neighbor.previous = nearest
          queue.push neighbor
          queue.sort (a, b) -> a.distance - b.distance

    path

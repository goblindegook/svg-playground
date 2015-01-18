Edge   = require './edge'
Vertex = require './vertex'

###
Graph object.
###
module.exports = class Graph

  ###
  Graph constructor.
  ###
  constructor: (config) ->
    @vertices = {}
    @edges    = []

    for id, position of config.vertices
      @addVertex id, position

    for id, neighbors of config.edges
      for neighbor in neighbors
        @edges.push @vertices[id].connectToVertex @vertices[neighbor]

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
    previous = {} # Previous vertex.
    distance = {} # Distance to start.

    for id, vertex of @vertices
      distance[id] = if vertex is origin then 0 else Infinity
      previous[id] = null
      queue.push vertex

    # Sort unvisited nodes by distance:
    queue.sort (a, b) -> distance[a.id] - distance[b.id]

    while queue.length
      nearest = queue.shift()

      if destination is nearest
        # Reached destination vertex
        while previous[nearest.id]
          path.unshift nearest.edgeToNeighborVertex previous[nearest.id]
          nearest = previous[nearest.id]
        break

      continue if not nearest or distance[nearest.id] is Infinity

      for edge in nearest.edges
        priority = edge.distance + distance[nearest.id]
        neighbor = if edge.v1 is nearest then edge.v2 else edge.v1

        if priority < distance[neighbor.id]
          # Found a shorter path:
          distance[neighbor.id] = priority
          previous[neighbor.id] = nearest
          queue.push neighbor
          queue.sort (a, b) -> distance[a.id] - distance[b.id]

    path

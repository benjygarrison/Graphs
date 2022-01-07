//
//  main.swift
//  Graphs
//
//  Created by Ben Garrison on 1/7/22.
//

import Foundation

/*
 MARK: Graphs
 Used for mapping: social networks, connecting gamers, actual maps, etc.
 A binary tree is a very simple graph structure. More complex graphs have the following structure:
 
 A graph (G) is an ordered pair of a set of vertices (V) and a set of edges (E). G = (V,E)
             V1 (edge) V2
              O ------ O
            / |       / \
        V3 /  | V4   /   \
          O   O     /     \
          \    \   /       \
           \    \ /         \
         V6 O -- O --------> O V5
                 V7
 
 Edges can be "directed" (O-->O) or "undirected"/bidirectional (O---O)
 A Weighted Graph hads weight between along the edges: the relative cost to traverse the distance between vertices
 
 MARK: Three common ways to represent graphs as data -> Edge Lists, Adjacency Matrices, Adjacency Lists
 MARK: Two common algos -> Breadth First Search, Depth First Search
 */

/*
 MARK: Edge List:
 Take each edge and represent its endpoints in a 2 value array. Using example above:
 Note! Direction of edge matters!! Measure OUTBOUND edges.
 
 Edge List = (V) [1, 2], [1, 3], [1, 4], [2, 5], [2, 7], [3, 6], [4, 7], [5, 2], [6, 7], [7, 5], [7, 6]
 
 Advantage: It's simple, order doesn't matter
 Disadvantage: Linear, search runtime is O(n)
*/


/*
 MARK: Adjacency Matrix:
 Take each edge and repesent it as a 1 in a 2 x 2 matrix positions (i, j) = (0, 1). Using example above:
 Note! Direction Matters!!

 (V)
 _|1_2_3_4_5_6_7_
 1|0 1 1 1 0 0 0
 2|1 0 0 0 1 0 1
 3|1 0 0 0 0 1 0
 4|1 0 0 0 0 0 1
 5|0 1 0 0 0 0 0 <- (Note direction is outbound from 7 to 5)
 6|0 0 1 0 0 0 1
 7|0 0 1 0 0 1 1
 Enclose each row in brackets and remove zeros -> get the array values in the adjacency list below! Each row == array.
 
 Advantage: Fast, lookup runtime = O(1)
 Disadvantage: Not space efficient
 */

/*
 MARK: Adjacency List
 Best of both worlds. Take each vertice and put its neighbors in a list in an array
 Note! Direction of edge matters!! Using example above:
 
 (V) 1 -> [2, 3, 4]
     2 -> [5, 7]
     3 -> [1, 6]
     4 -> [1, 7]
     5 -> [2]     <- (note one-way direction from vertice 7)
     6 -> [3, 7]
     7 -> [4, 6, 5]
 
 Advantage: Fast lookup, easy to find neighbors
 
 */

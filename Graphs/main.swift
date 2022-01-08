//
//  main.swift
//  Graphs
//
//  Created by Ben Garrison on 1/7/22.
//

import Foundation

/*
 MARK: Graphs
 Used for mapping: social networks, connecting gamers to nearby servers, music recommendations, actual maps, etc.
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

//MARK: Queue for BFS
struct Queue<T> {
    private var array: [T]
    
    init() {
        array = []
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func add(_ element: T) {
        array.append(element)
    }
    
    mutating func remove() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    func peek() -> T? {
        return array.first
    }
}

//MARK: Stack for DFS
struct Stack<T> {
    fileprivate var array = [T]()
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    var top: T? {
        return array.last
    }
}

//MARK: Build Graph class

class Graph {
    var V = 0                       // number of vertices
    var adj = [[Int]]()             // adjacency list
    
    init(_ V: Int) {
        self.V = V
        for _ in 0..<V {
            adj.append([Int]())     // create empty array of adjacency lists
        }
    }
    
    func addEdge(v: Int, w: Int) {
        adj[v].append(w)            // add edges
    }


/*
 MARK: Breadth First Search
 Start from middle and expand outward to nearest neighbors. Once all same-level nodes have been traverse, next level is searched. Ex: how social media connects to first level contacs, second level, etc.
 
 Uses a queue for search (FIFO). Origin node is popped into and out of queue to establish starting point (special case). All immediately connected nodes are then added to queue and marked as visited. Pop out first value currently in queue and find its neighbors. Go down queue and pop out any nodes that have no unsearched connections. Repeat.
 */

    func BFS(s: Int) -> [Int] {
        var result = [Int]()
    
        // mark all vertices as not visited
        var visited = adj.map {_ in false}
        
        // create BFS queue
        var queue = Queue<Int>()
        
        // mark first vertex as visit and enqueue
        visited[s] = true
//        print("Starting at \(s)")
        queue.add(s)
        result.append(s)
        
        while queue.count > 0 {
            let current = queue.remove()!
//            print("De-Queueing \(current)")
            
            // get all adjacent vertices of the current vertex
            //if adjacent has not been visited, mark visited and enqueue
            
            for n in adj[current] {
                if visited[n] == false {
                    visited[n] = true
 //                   print("Queuing at \(n)")
                    queue.add(n)
                    result.append(n)
                }
            }
        }
        return result
    }
    
/*
MARK: Depth First Search
Ignore current depth, and just tunnel downward along single path until end is reached. Ex: Path finding, cycle detection
*/

    // DFS traversal from a given source s
        func DFS(s: Int) -> [Int] {
            
            var result = [Int]()
            
            // Mark all vertices as not visited
            var visited = adj.map { _ in false }
            
            // Create DFS Stack
            var stack = Stack<Int>()
            
            // Mark first vertex as visited and enqueue
    //        print("Starting at \(s)")
            visited[s] = true
            stack.push(s)
            
            while stack.count > 0 {
                let current = stack.pop()!
    //            print("Popping \(current)")
                result.append(current)
                
                // Iterate over all neighbours adding to queue and popping deep as we go
                for n in adj[current] {
                    if visited[n] == false {
                        visited[n] = true
    //                    print("Pushing - \(n)")
                        stack.push(n)
                    }
                }
            }
            
            return result
        }
}

//MARK: Create graph from lesson (non-directional)

let g = Graph(8)
g.addEdge(v: 0, w: 1)
g.addEdge(v: 1, w: 4)
g.addEdge(v: 4, w: 6)
g.addEdge(v: 6, w: 0)
g.addEdge(v: 1, w: 5)
g.addEdge(v: 5, w: 3)
g.addEdge(v: 3, w: 0)
g.addEdge(v: 5, w: 2)
g.addEdge(v: 2, w: 7)

//MARK: My graph from above

let myG = Graph(9)
myG.addEdge(v: 1, w: 2)
myG.addEdge(v: 2, w: 5)
myG.addEdge(v: 1, w: 3)
myG.addEdge(v: 3, w: 6)
myG.addEdge(v: 6, w: 7)
myG.addEdge(v: 1, w: 4)
myG.addEdge(v: 4, w: 7)
myG.addEdge(v: 2, w: 7)
myG.addEdge(v: 7, w: 5)

print("Breadth First Search: \(myG.BFS(s: 1))")
print("")
print("Depth First Search: \(myG.DFS(s: 1))")

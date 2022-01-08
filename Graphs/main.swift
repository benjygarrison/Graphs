//
//  main.swift
//  Graphs
//
//  Created by Ben Garrison on 1/7/22.
//

import Foundation

/*
 MARK: Graphs
 
 MARK: What to know -> Which is best? Depends. Breadth first is better near the top (social networks, nearby peers in games, etc.). Depth first is better for finding things that are far away, such as a single value on a different level (game simulations, such as AI in chess game, looking for a move).
 
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
     5 -> [2]     <- (note one-way direction from vertex 7)
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
 Start from middle and expand outward to nearest neighbors. Once all same-level vertices have been traversed, next level is searched. Ex: how social media connects to first level contacts, second level, etc.
 
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
 Uses stacks for traversing (LIFO). Push origin vertex onto stack, then pop it off (special case). Next, add surrounding vertices. Last one added gets popped off, and then its neighbor is found and popped off... and repeat.
 
 MARK: In code, literally just swap queue for stack
 
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

//note: must equal the number of EDGES, not vertices or directions
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

//MARK: My graph from above (one-way directional from 7 -> 5)

let myG = Graph(9)
myG.addEdge(v: 1, w: 2)
myG.addEdge(v: 1, w: 3)
myG.addEdge(v: 1, w: 4)
myG.addEdge(v: 2, w: 1)
myG.addEdge(v: 2, w: 5)
myG.addEdge(v: 3, w: 1)
myG.addEdge(v: 3, w: 6)
myG.addEdge(v: 4, w: 1)
myG.addEdge(v: 4, w: 7)
myG.addEdge(v: 5, w: 2)
myG.addEdge(v: 6, w: 3)
myG.addEdge(v: 6, w: 7)
myG.addEdge(v: 7, w: 2)
myG.addEdge(v: 7, w: 4)
myG.addEdge(v: 7, w: 5)

print("Breadth First Search: \(myG.BFS(s: 1))")
print("")
print("Depth First Search: \(myG.DFS(s: 1))")
print("")


//MARK: Common question. Come back to this!!
/*
 You are given in undirected graph consisting of N vertices, numbered from 1 to N, and M edges.
 
 The graph is described by two arrays, A and B, both of length M. A pair A[K] and B[K] for K from 0 to M-1, describe the edge between vertex A[K] and vertex B[K].
 
 Your task is to check whether the given graph contains a path from vertex 1 to vertex N going through all the vertices, one-by-one, in increasing order of the numbers. All connections on the path should be direct.
 
 Write a function, that given an integer N and two arrays A and B of M integers each, returns true if there exists a path from vertex 1 to N going through all vertices, one-by-one, in increasing order, or false other wise.
 
 Example 1:
          ┌─────┐
   ┌──────│  3  │──────┐
   │      └─────┘      │
   │         │         │
┌─────┐      │      ┌─────┐
│  2  │      │      │  4  │
└─────       │      └─────┘
   │      ┌─────┐      │
   └──────│  1  │──────┘
          └─────┘
 
 Given N = 4
       A = [1, 2, 4, 4, 3]
       B = [2, 3, 1, 3, 1]
       Function should return true.
 
 There is a path (1 > 2 > 3 > 4) using edges (1, 2), (2, 3), (4, 3).
 
 Example 2:
          ┌─────┐
   ┌──────│  4  │──────┐
   │      └─────┘      │
   │         │         │
┌─────┐      │      ┌─────┐
│  2  │      │      │  3  │
└─────       │      └─────┘
   │      ┌─────┐      │
   └──────│  1  │──────┘
          └─────┘
 
 Given N = 4
       A = [1, 2, 1, 3]
       B = [2, 4, 3, 4]
       Function should return false.
 
 There is no path (1 > 2 > 3 > 4) as there is no direct connection from vertex 2 to vertex 3.
 
 Example 3:
 ┌─────┐
 │  1  │
 └─────┘
                             
┌─────┐    ┌─────┐    ┌─────┐   ┌─────┐    ┌─────┐
│  2  │────┤  3  │────│  4  │───│  5  │────│  6  │
└─────┘    └─────┘    └─────┘   └─────┘    └─────┘
 
 Given N = 6
       A = [2, 4, 5, 3]
       B = [3, 5, 6, 4]
       Function should return false.
  
 Example 4:
 ┌─────┐    ┌─────┐    ┌─────┐
 │  1  │────┤  2  │────│  3  │
 └─────┘    └─────┘    └─────┘
 Given N = 3
       A = [1, 3]
       B = [2, 2]
       Function should return true.
 
 Example 5:
 ┌─────┐    ┌─────┐    ┌─────┐
 │  2  │────┤  3  │────│  4  │
 └─────┘    └─────┘    └─────┘
 
 Given N = 3
       A = [2, 3]
       B = [3, 4]
       Function should return false.
 */

struct Edge: Equatable {
    let from: Int
    let to: Int
    
    init(_ from: Int, _ to: Int) {
        self.from = from
        self.to = to
    }
}

func solution(_ A: [Int], _ B: [Int]) -> Bool {
    guard A.count > 0 && B.count > 0 else { return false }
    
    // make edges
    var edges: [Edge] = []
    for n in 0..<A.count {
        edges.append(Edge(A[n], B[n]))
    }

    // walk cases
    if A.count == 1 {
        return edges.contains(Edge(1, 2)) || edges.contains(Edge(2, 1))
    } else if A.count == 2 {
        return (edges.contains(Edge(1, 2)) || edges.contains(Edge(2, 1))) &&
               (edges.contains(Edge(2, 3)) || edges.contains(Edge(3, 2)))
    }
    
    for i in 1..<A.count - 1 {
        if edges.contains(Edge(i, i+1)) || edges.contains(Edge(i+1, i)) { continue }
        else { return false }
    }

    return true
}

// Tips
// 1. Work out on paper
// 2. Work on simple case manually.
// 3. Read problem carefully.
//var edges: [Edge] = []
//edges.insert(Edge(1, 2))
//edges.insert(Edge(3, 2))
//
// walk in order
//edges.contains(Edge(1, 2)) || given.contains(Edge(2, 1))
//edges.contains(Edge(2, 3)) || given.contains(Edge(3, 2))


/*
 Example 1:
          ┌─────┐
   ┌──────│  3  │──────┐
   │      └─────┘      │
   │         │         │
┌─────┐      │      ┌─────┐
│  2  │      │      │  4  │
└─────       │      └─────┘
   │      ┌─────┐      │
   └──────│  1  │──────┘
          └─────┘
 
 Given N = 4
       A = [1, 2, 4, 4, 3]
       B = [2, 3, 1, 3, 1]
       Function should return true.
 */
print(solution([1, 2, 4, 4, 3], [2, 3, 1, 3, 1])) // true
/*
 Example 2:
          ┌─────┐
   ┌──────│  4  │──────┐
   │      └─────┘      │
   │         │         │
┌─────┐      │      ┌─────┐
│  2  │      │      │  3  │
└─────       │      └─────┘
   │      ┌─────┐      │
   └──────│  1  │──────┘
          └─────┘
 
 Given N = 4
       A = [1, 2, 1, 3]
       B = [2, 4, 3, 4]
       Function should return false.
 */
print(solution([1, 2, 1, 3], [2, 4, 3, 4])) // false
/*
 Example 3:
 ┌─────┐
 │  1  │
 └─────┘
                             
┌─────┐    ┌─────┐    ┌─────┐   ┌─────┐    ┌─────┐
│  2  │────┤  3  │────│  4  │───│  5  │────│  6  │
└─────┘    └─────┘    └─────┘   └─────┘    └─────┘
 
 Given N = 6
       A = [2, 4, 5, 3]
       B = [3, 5, 6, 4]
       Function should return false.
 */
print(solution([2, 4, 5, 3], [3, 5, 6, 4])) // false
/*
 Example 4:
 ┌─────┐    ┌─────┐    ┌─────┐
 │  1  │────┤  2  │────│  3  │
 └─────┘    └─────┘    └─────┘
 Given N = 3
       A = [1, 3]
       B = [2, 2]
       Function should return true.
 */
print(solution([1, 3], [2, 2])) // true
/*
 
 Example 5:
 ┌─────┐    ┌─────┐    ┌─────┐
 │  2  │────┤  3  │────│  4  │
 └─────┘    └─────┘    └─────┘
 
 Given N = 3
       A = [2, 3]
       B = [3, 4]
       Function should return false.
 */

print(solution([2, 3], [3, 4])) // false

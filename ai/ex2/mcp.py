#!/usr/bin/env python
#coding: utf-8

# Solve the missionary-cannibal-problem by using depth-first search.

# The state is represented as a 3-dim vector [m,c,b], describing the number of 
# objects ([m]issionaries, [c]annibals, [b]oat) on side A of the river. The 
# state of the other side is always given as [3,3,1]-[m,c,b]. Starting state is
# [3,3,1], goal state is [0,0,0].

class Node:

    def __init__(self, state, parent=None):
        self.state = state
        self.parent = parent

    def expand(self):
        '''
        returns a list of all nodes that can be reached from this node
        '''
        states = getAllowedStates(self.state)
        return [Node(s, parent=self) for s in states]

    def __eq__(self, other):
        return all([s1 == s2 for s1, s2 in zip(self.state, other.state)]) 

    def printMe(self):
        '''
        prints the trace from the initial node to this one
        '''
        if self.parent is not None:
            self.parent.printMe()
        print(self.state)

def getAllowedStates(state):
    '''
    get the states that are
      a) reachable (can be reached in one boat crossing)
      b) allowed (don't lead to a massacre)
    '''
    m = state[0]
    c = state[1]
    b = state[2]

    # these are the states that can be reached by valid actions
    # i.e. 1 or 2 people cross the river from the boat side to the other one
    newStates = [[m + (1-b)*2 - b*2, c, 1-b],
                 [m + (1-b) - b, c, 1-b],
                 [m + (1-b) - b, c + (1-b) - b, 1-b],
                 [m, c + (1-b) - b, 1-b],
                 [m, c + (1-b)*2 - b*2, 1-b]]

    return [s for s in newStates if doesNotLeadToMassacre(s)]

def doesNotLeadToMassacre(state):
    '''
    a state does not lead to a massacre if the missionaries are not
    outnumbered by the cannibals on either side
    (we also check if the numbers add up, but checkValidState would have been
    a boring function name)
    '''
    m = state[0]
    c = state[1]

    return (m == 0 or m == 3 or m == c) \
        and m>=0 and m<=3 and c>=0 and c<= 3

def dfsearch(initial_state, goal_state):
    '''
    apply depth-first search to reach the goal_state fro mthe initial_state
    '''
    
    # initialize stuff
    goal = Node(goal_state)
    nodes = [Node(initial_state)]
    visited = []

    reachedGoal = False
    while len(nodes)>0:
        # get next unexpanded node
        node = nodes.pop()

        if node == goal:
            # we found a way to the goal
            reachedGoal = True
            break

        # mark node as visited - no cycles!
        visited.append(node)
        
        # expand node, add nodes to stack
        newNodes = [n for n in node.expand() if not n in visited]
        nodes += newNodes 

    if not reachedGoal:
        print("Sorry, no solution found.")
    else:
        print("Yay! Solution:")
        node.printMe()


if __name__ == "__main__":
    dfsearch([3,3,1], [0,0,0])


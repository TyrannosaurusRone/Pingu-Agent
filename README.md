# Pingu-Agent
### This project was developed in collaboration with Urvi Parekh.

An autonomous agent able to navigate the optimal path of a square lattice graph maze of any size.

This program uses the Q-learning algorithm to autonomously learn the optimal path through a maze. As per the requirements of Q-learning, the maze is modelled as a Markov Decision Process, with each state representing 'Pingu's' (our name for the agent) position in a maze of 'igloos'.

Pingu-Agent.m initialises a 5x5 matrix numbered 1-25, this represents the maze, with 1 being the start state and 25 being the goal state. A 25x25 matrix is then initialised to represent the state space of the maze, with the rows representing the state Pingu is in at t and the columns representing the state Pingu can move to at t+1, indicated by a 1. This code will work with a maze and transition function of any given size, only the initialisation sizes and the R matrix provided by csv with the rewards need to be changed. An example of this is shown in Pingu-Agent_expanded.m.

Pingu-Agent.m reads in data from the R-matrix in the R.csv file. This file must be in the matlab path to be read in, it is a 25x25 state space matrix with negative rewards set for certain states in the maze. 

The parameters which can be altered beyond the maze size are learning rate (alpha), discount factor (gamma), policy (explore or exploit, epsilon) and the number of episodes. An empty Q-matrix for rewards learned is initiated and with each episode of Q-learning the rewards are updated, the policy gradually shifts from explore to exploit and the agent Pingu learns the maze.


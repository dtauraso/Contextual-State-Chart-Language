# Contexual-State-Chart-Language
This is an extracurricular research project.  I’m researching the question “Is there a way to code programs in a way that is cognitively more straightforward to humans than what we currently have?”

The idea to solve this question is to use some research from General AI mentioned below.

Note: This is a supplemental language.  It is not meant to replace programming languages.  You will still use your primary langauge: Python, JS, Java, etc.
## Inspiration

  DFA’s from taking CS 460 with Professor Watts
  
  **On Intelligence** by Jeff Hawkins
  
  first white paper
  
  
  https://numenta.com/assets/pdf/whitepapers/hierarchical-temporal-memory-cortical-learning-algorithm-0.2.1-en.pdf

  The main ideas I gathered from these
		a state modeling neurons can be represented in an arbitrary number of contexts
		context sensitive sequences
		context sensitive hierarchy of sequences



## Why

  I knew that the languages I used: Lisp, Haskell, C++, C, Python were Turing Complete, but felt there was something missing.  They all have ways they want you to think, OOP, FP, Declarative Programming, Structured Programming, etc.  They are fine to use and have advantages, but I wanted more out of them.  They didn’t provide a generally straightforward way to make hierarchical context sensitive sequences of instructions for different situations the way we do easily.  I wanted a way to do that with consistency consistent across all languages, and looked around for something that worked.  There are statecharts, but it’s still not straightforward to make hierarchical context sensitive sequences.  There are languages, like XState(only for JavaScript), SCSML, XASM(only for C), State Machine Compiler, but they are tied to a specific language, don’t have a hierarchy, etc.  Essentially, they don’t make it straightforward to make what I’m looking for.

## What

  What I made is a state machine program that uses preorder traversal to walk through a tree of graphs of nodes.  The visitor pattern is used here.  The visitor function uses preorder on a tree.  Each node in tree represents the start point of a graph.  Next, visitor uses BFS on the graph.  Each node in the graph represents the start point of a tree.   

  Each node represents a neuron from the above description.  Each node has links to various locations: all parents, children that start the submachine, nodes to run after the current node is finished, and each node runs a function.  The function can be any code you want with the language you are using.  I made one for JavaScript and one for Python.  Current developments are on a language version of the program for Swift.


## Why didn’t I use a grammar directly to describe the language rules?

  They would force me to describe the sequences I want using character matching only.  A way to avoid this by using functions to decide when to check for a certain count of characters to force correspondences, or to check for a character match.  This can be done by a general purpose programming language.  To recognize L = {a^nb^nc^n | n>= 1} we need 3 states. 1 state saves the first count of n.  The other 2 states make sure b’s and c’s appear in the right order with the same counts as the a’s were.

## Goals
	industry level development
	designing code in a less mechanical way and more organically
	prevent bugs and catch them faster
	single overall map of application
	coding with cognitive ease

## Beginning development
From summer 2017 through fall 18
examples of JavaScript and Python
https://github.com/dtauraso/calculator-js
https://github.com/dtauraso/calculator-py

On the last Monday Wednesday class of Fall 18, I hosted a CS club workshop about state machines.  The slides are below.

https://www.slideshare.net/DavidTauraso1/hierarchical-context-sensitive-state-machines-124560006



## What I learned
people want an easy way to use it

## Current development
From winter 18 to now

Updated state machine slides using Swift version of language
https://www.slideshare.net/DavidTauraso1/contextual-state-chart-language-swift-132831797

Here is the parsing graph
https://github.com/dtauraso/Contexual-State-Chart-Language/blob/master/Contexual-State-Chart-Language/Contexual-State-Chart-Language/parsing_graph.pdf

## About the language
	Structure of the nodes
	Name
	This is a sequence of strings. Each indent means a different contextual dimension the state represents. The strings can say anything except for “Next”, “Children”, “Function”.  You can say them if the quotes are part of the string literal.

	Next states
		Treat them like if else if else cases
		The “/“ indicates the contextual dimension of the string in the name

	Start Children
	States in the below level
	Treat them like if else if else cases in the below level
	Can find them by looking for the “-” starting the last string of the name
	Children
		State in the below level
		They are not evaluated by the visitor function
	Can find them because they have no “-” starting the last string of the name

	Parents
		Metadata for my state machine algorithm to work

	Function
		1 function for each (first name, second name) pair	
		The function doesn’t necessarily have to do a character match
	syntax
	references to other states(usually used so several parents can link to the same child)

	use “&”
		examples
		-& a state name / a context name
	
	general state structure section
	name_0
		name_1
			Children
				first_sub_state_name_0
					-sub_state_name_1
				second_sub_state_name_0
					sub_state_name_1
				
	name_0 and name_1 are names of the state
	the indents indicate context and dimension(fix in slides)
	
	the “-“ at the last name tells you if it’s going to be run as a next state with it’s siblings
	you can use “-“ and “&” like above
	
	name_2
		name_3
			Next
				another state / another state’s context
				another state_1 / another state’s context_1
			Function
				aFunction
	This example doesn’t have children
	The states inside the “Next” word are neighbor states in the graph
	The name inside “Function” is the function run by (name_2, name_3)

	this example has children

	name_2
		name_3
			Children
				first_sub_state_name_1
					-sub_state_name_2
				second_sub_state_name_1
					sub_state_name_2
			Next
				another state / another state’s context
				another state_1 / another state’s context_1
			Function
				aFunction

		there is another option
	States can be variables
		name one
			Data
				data_from_primary_programming_langugage_syntax
	
	using children, one can build classes

	end states
	They are states that have no neighbors
	The function they run is implicitly returnTrue
	name_2
		name_3
			Children
				first_sub_state_name_1
					-sub_state_name_2
				second_sub_state_name_1
					sub_state_name_2
			Next
				another state / another state’s context
				another state_1 / another state’s context_1
			Function
				aFunction
	end state
		this is another dimension for an end state
	another state
		Next
			name_2 / name_3
## program status
	It works.
## program test from the updated slides
Input:
https://github.com/dtauraso/Contexual-State-Chart-Language/blob/master/Contexual-State-Chart-Language/parsing_test_from_slides.txt

Output from
https://github.com/dtauraso/Contexual-State-Chart-Language/blob/master/Contexual-State-Chart-Language/test_from_slides_passed.txt

## How the parser works and why
    Depth first traversal is used to save the name parts of each state.
    Breath first traversal is used to save the remaining attributes of each state.
   
    The goal for the parser is to be straghtforward to change in the future, and as a result, certain decisions were made.
    One decision was to use the contextual state chart representation to be the control flow model.
    The other decision was to use iteration.  Both traversals are done iteratively.
    Recursion was not used, because the focus was on the many unique situations the small groups of lines in the file presented.
    An iterative approach seemed to fit best at the time.

## Let’s say you are finished with CSCL(Contextual State Chart Language).  How would you use it?

	put the CSCL code in a file ending in “.txt”
	make the functions and classes in your regular language. 
	use the connecting instructions provided below to link your language to the CSCL code.
	

  For ios apps:
  
  	Current idea:
		Each class would have a table of member function names mapping to their references.
		You would then call the visitor function from your class and send the table along.
		May require another function between the class function and visitor.
	
 For terminal programs:
 
		Still in developement.


## Future Research

Working with others to encourage community contributions to this project

Recording states used to show a full usage history for design, debugging, etc

Learn how others use it to improve design

Look at other programming techniques to find ways to improve it

Storing code in Function using brackets

Backtracking

Parallel states

Folding for levels you don’t want to see

Maybe even an api for locks, so this can simulate an operating system directly





# Contexual-State-Chart-Language
This is an extracurricular research project.  I’m researching the question “Is there a way to code programs in a way that is cognitively more straightforward to humans than what we currently have?”

The idea to solve this question is to use some research from General AI mentioned below.

Note: This is a supplemental language.  It is not meant to replace programming languages.  You will still use your primary langauge: Python, JS, Java, etc.
## Inspiration

  DFA’s from taking CS 460 with Dr. Watts
  
  **On Intelligence** by Jeff Hawkins
  

  The below images show how the HTM* network models contex sensitive sequences:
 
  https://www.frontiersin.org/files/Articles/174222/fncir-10-00023-HTML/image_m/fncir-10-00023-g002.jpg *
  https://www.frontiersin.org/files/Articles/174222/fncir-10-00023-HTML/image_m/fncir-10-00023-g003.jpg *
	
  The page these came from is at the bottom of the readme.

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
	Here is a visual description of an example of the language and how it is represented in the program.
	https://github.com/dtauraso/Contexual-State-Chart-Language/blob/master/Contexual-State-Chart-Language/Contexual-State-Chart-Language/Contextual%20State%20Chart%20Language%20internal%20representation.pdf
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


## Other sources:

* These are about Numenta, a company Jeff Hawkins cofounded.
  https://www.frontiersin.org/articles/10.3389/fncir.2016.00023/full
	
  Illustrations from  https://www.frontiersin.org/articles/10.3389/fncir.2016.00023/full.

  https://numenta.com/assets/pdf/whitepapers/hierarchical-temporal-memory-cortical-learning-algorithm-0.2.1-en.pdf


//
//  Visit.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/18/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
func returnTrue(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return true
}
func returnFalse(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return false
}
class ChildParent {

    var child: [String]
    
    var parent: ChildParent?
    
    init(child: [String], parent: ChildParent?)
    {
        self.child = child
        self.parent = parent
    }
    func getChild() -> [String]
    {
        return self.child
    }
    func getParent() -> ChildParent?
    {
        if self.parent == nil
        {
            return nil
        }
        return self.parent!
    }
    func setChild(new_child: [String])
    {
        self.child = new_child
    }
    func setParent(new_parent: ChildParent?)
    {
        self.parent = new_parent
    }
    func equal(object1: ChildParent?, object2: ChildParent?) -> Bool
    {
        return object1?.child == object2?.child &&
                object1?.parent == object2?.parent
    }
}
extension ChildParent: Equatable {
    static func == (lhs: ChildParent, rhs: ChildParent) -> Bool {
        return lhs.child == rhs.child &&
               lhs.parent == rhs.parent
        }
    }

class NextStatePackage {

    var bottom_of_shortened_stack: ChildParent
    
    var next_states: [[String]]
    var indents: Int
    init(bottom_of_shortened_stack: ChildParent, next_states: [[String]], indents: Int)
    {
        self.bottom_of_shortened_stack = bottom_of_shortened_stack
        self.next_states = next_states
        self.indents = indents
    }
    func getBottomOfShortenedStack() -> ChildParent
    {
        return self.bottom_of_shortened_stack
    }
    func setBottomOfShortenedStack(bottom_of_shortened_stack: ChildParent)
    {
        self.bottom_of_shortened_stack = bottom_of_shortened_stack
    }
    func setNextStates(next_states: [[String]])
    {
        self.next_states = next_states
    }
}

class Visit {

    var next_states:        [[String]]
    
    var current_state_name: [String]
    
    var end_state_name:     [String]
    
    var bottom:             ChildParent
    
    var bottom_tracker:     ChildParent
    
    var dummy_node:         ContextState
    
    var name_state_table:  [[String]: ContextState]
    
    
    var ii:                 Int
    var indents:            Int
    
    init(next_states:           [[String]],
         current_state_name:    [String],
         bottom:                ChildParent,
         dummy_node:            ContextState,
         name_state_table:     [[String]: ContextState])
    {
    
        self.next_states        =   next_states
        self.current_state_name =   current_state_name
        self.bottom             =   bottom
        self.bottom_tracker     =   bottom
        self.dummy_node         =   dummy_node
        self.name_state_table  =   name_state_table
        self.ii                 =   Int()
        self.indents            =   Int()
        self.end_state_name     =   [String]()

    }
    func getNextStates(bottom:              ChildParent,
                       next_states:         [[String]],
                       indents:             Int,
                       name_state_table:   [[String]: ContextState]) -> NextStatePackage
    {
        //print("in stack shrink")
        // the stack is a reversed linked list
        // goes up the stack and finds the next set of next states
        // will erase the progress of any bottom up branches connected to the node popped
        // only pop if the current path is the only path
        // if there is more than 1 path, reset where the bottom tracker is
        var indents2: Int = indents
        let return_package: NextStatePackage = NextStatePackage.init(bottom_of_shortened_stack: bottom,
                                                                     next_states:               next_states,
                                                                     indents:                   indents2)
        var state: [String] = return_package.getBottomOfShortenedStack().getChild()
        while(!(return_package.getBottomOfShortenedStack().getParent() == nil) &&
                return_package.next_states.count == 0)
        {
            // maybe .decrementIndents?
            indents2 -= 1
            return_package.setBottomOfShortenedStack(bottom_of_shortened_stack: return_package.getBottomOfShortenedStack().getParent()!)
            state = return_package.getBottomOfShortenedStack().getChild()
            if(state[0] == "root" )
            {
                return_package.setNextStates(next_states: [])
                //print("end of stack shrink")

                return return_package
            }
            
            //let state_location: ContextState = name_state_table[state]!
            return_package.setNextStates(next_states: (name_state_table[state]!.getNexts()))
            //printStack2(bottom_tracker: return_package.getBottomOfShortenedStack())
        }
        //print("end of stack shrink")

        return return_package
        
    }
    func isParent(maybe_parent: Int) -> Bool
    {
    
        return maybe_parent > 0
    }
    func isBottomAtTheParentOfCurrentState(parents: [[String]],
                                           bottom_state: [String]) -> Bool
    {
        // assume that each state can have multiple parents, but only 1 of those parents is in use from the child's perspective
        for parent in parents
        {
            //let ith_parent_point: ContextState = self.name_state_table[parent]!
            
            //let bottom_state_point: ContextState = self.name_state_table[bottom_state]!
            
            if(self.name_state_table[parent]! == self.name_state_table[bottom_state]!)
            {
                return true
            }
        }
        return false
    }
    func hasParent(name_state_table: [[String]: ContextState], state_name: [String]) -> Bool
    {
        return (name_state_table[state_name]?.getParents().count)! > 0
    }
    func printStack2(bottom_tracker: ChildParent?)
    {
        print("stack\n")
        var bottom_tracker2 = self.bottom_tracker
        
        // still might not work
        // tracker's parent != nil
        
        while(!(bottom_tracker2.getParent() == nil))
        {
            print(bottom_tracker2.getChild())
            //print("|")
            bottom_tracker2 = bottom_tracker2.getParent()!
        }
        // last item
        print(bottom_tracker2.getChild())

        print("\n")
        
    }
    func returnTrue(current_state_name: [String]) -> Bool
    {
        return true
    }

    func prettyFormat(node: ContextState,
                      indents: String,
                      start_child: Bool,
                      matrix: [Point: ContextState],
                      point_table: [[String]: Point]) -> String
    {
        var formated_string = String()
        //formated_string.append(indents + "entered\n")
        formated_string.append(indents)

        let indents_for_name = indents
        for name_part in node.getName()
        {
            if(name_part == node.getName()[node.getName().count - 1])
            {
                if(start_child)
                {
                    //formated_string.append(contentsOf: indents_for_name)
                    formated_string.append(contentsOf: "-")
                }
            }
            formated_string.append(contentsOf: name_part)
            formated_string.append(contentsOf: "\n")
            var indents_x = indents_for_name
            if(name_part != node.getName()[node.getName().count - 1])
            {
                indents_x += " "
                formated_string.append(contentsOf: indents_x)

            }
            //else
            
        }
        //print("|" + indents_for_name + "|")
       
        if(node.getStartChildren().count + node.getChildren().count > 0)
        {
            //indents_for_name += "  "
            //print("before children")
            //print("|" + indents_for_name + "|")

            formated_string.append(contentsOf: indents_for_name + "  ")
            formated_string.append("Children\n")
            //print(formated_string)
            //indents_for_name += "    "

            //formated_string.append(contentsOf: indents)
            //formated_string.append("    ")
            //var indents_for_name = indents + "    " + "    "
            for start_child in node.getStartChildren()
            {
                if(point_table[start_child] == nil)
                {
                    print(start_child, "does not exist")
                    exit(0)
                }
                let point = point_table[start_child]!
                
                let child_node = matrix[point]!
                //print("|" + indents_for_name + "|")

                formated_string.append(prettyFormat(node: child_node,
                                                    indents: indents_for_name + "      ",
                                                    start_child: true,
                                                    matrix: matrix,
                                                    point_table: point_table))


            }
            for name in node.getChildren()
            {
                //print(name)
                //print(name_state_table.keys)
                let point = point_table[name]!
                
                let child_node = matrix[point]!
                //print(child_node.getStartChildren().count > 0)
                formated_string.append(prettyFormat(node: child_node,
                                                    indents: indents_for_name + "      ",
                                                    start_child: false,
                                                    matrix: matrix,
                                                    point_table: point_table))
            }
        }
        if(node.getNexts().count > 0)
        {
            //indents_for_name += "     "
            formated_string.append(contentsOf: indents_for_name + "  ")
            formated_string.append("Next\n")
                        //let x = indents_for_name + "  "

            //indents_for_name += "  "
            formated_string.append(contentsOf: indents_for_name + "    ")
            for next_state_link in node.getNexts()
            {
                for context in next_state_link
                {
                    formated_string.append(contentsOf: context)
                    if(context != next_state_link[next_state_link.count - 1])
                    {
                        formated_string.append(contentsOf: " / ")

                    }


                }
                if(next_state_link != node.getNexts()[node.getNexts().count - 1])
                {
                    formated_string.append(contentsOf: "\n")
                    formated_string.append(contentsOf: indents_for_name + "    ")

                }
            }
            //formated_string.append(contentsOf: "\n")


            
        }
        formated_string.append(contentsOf: "\n")

        //indents_for_name += "  "
        formated_string.append(contentsOf: indents_for_name + "  ")
        formated_string.append("Function\n")

        //indents_for_name += "     "
        formated_string.append(contentsOf: indents_for_name + "    ")
        //formated_string.append(contentsOf: "\n")
        //formated_string.append(contentsOf: indents_for_name)
        formated_string.append(contentsOf: node.function_name)
        formated_string.append(contentsOf: "\n")

        if(node.getParents().count > 0)
        {
            formated_string.append(contentsOf: indents_for_name + "  ")
            formated_string.append("Parents\n")
            //indents_for_name += "     "

            for parent in node.getParents()
            {
                formated_string.append(contentsOf: indents_for_name + "    ")
                for i in (0..<parent.count)
                {
                    formated_string.append(contentsOf: parent[i])
                    if(i < parent.count - 1)
                    {
                        formated_string.append(", ")

                    }

                }
                formated_string.append(contentsOf: "\n")

            }
            //formated_string.append(contentsOf: "\n")
        }
        //formated_string.append(indents + "exit\n")

        return formated_string
        //if()

    }

    func visitStates(start_state: ContextState/*, end_state: ContextState*/, parser: inout Parser, function_name_to_function: [String: ([String], inout Parser, ChildParent) -> Bool])
    {
        // the user will have to make a map from state to function
        // set current state to start_state
        // keep going untill an end state is reached (error), or end_state is reached (success)
        
        print("entered visit function")
        self.current_state_name = start_state.getName()
        //self.end_state_name = end_state.getName()
        // https://useyourloaf.com/blog/swift-hashable/
        // when the end state is checked in the loop guard, end state machine
        //let end_states_nexts = [self.end_state_name]//end_state.getNexts()
        //print(end_state.getNexts())
        //exit(1)
        self.bottom_tracker = self.bottom
        self.name_state_table[self.dummy_node.name] = ContextState.init(name: [], function: returnTrue(current_state_name: parser: stack:))
        //var end_of_input: Bool = false
        while(self.next_states != [])//(self.next_states != end_states_nexts)
        {
            
            // get the index and the input
            // if index == input.count
                // exit machine
            
            //print("at", self.ii)
            /*
            if(ii == 380)
            {
                print("too many states run\n")
                
                let matrix = name_state_table[["sparse_matrix"]]!.getData().data["[Point: ContextState]"] as! [Point: ContextState]
                let points = matrix.keys
                var index = points.startIndex
                for i in (0..<points.count)
                {
                    matrix[index].value.Print(indent_level: 0)
                    index = points.index(index, offsetBy: 1)
                    print()
                    print()
                }

                exit(1)
            }*/
            var state_changed: Bool = false
            var j: Int = Int()
            //print("current state")
            //print(self.next_states[0])
            //print()
            //print(self.next_states)
            // map each self.current_state_name to a bool result
            // save all true results
            // run the hasParent... on the set of true results
            while(j < self.next_states.count)
            {
                /*

                if(i == length)
                {
                    print("end of input")
                    break
                }
                */
                // how to let it run multiple true states?
                self.current_state_name = self.next_states[j]
                //print("trying state")
                //print(self.current_state_name)
                // there should always be an entry in the table that is getting indexed
                //let point: ContextState = self.name_state_table[self.current_state_name]!
                //print(self.current_state_name)
                let maybe_parent: Int = (self.name_state_table[self.current_state_name]?.getStartChildren().count)!
                //print("running", levels[point]?.function_name)
                let function_call_name : String = (self.name_state_table[self.current_state_name]?.getFunctionName())!
                //print(function_call_name)
                let function : ([String], inout Parser, ChildParent) -> Bool = function_name_to_function[function_call_name]!
                //print(function)
                let did_function_pass: Bool = function(self.current_state_name, &parser, self.bottom_tracker)
                
                if(did_function_pass)
                {
                    self.name_state_table[self.current_state_name]?.advanceIterationNumber()
                    if(hasParent(name_state_table: self.name_state_table, state_name: self.current_state_name))
                    {
                        let bottom_state: [String] = self.bottom_tracker.getChild()
                        let parents: [[String]] = (self.name_state_table[self.current_state_name]?.getParents())!
                        if(isBottomAtTheParentOfCurrentState(parents:       parents,
                                                             bottom_state:  bottom_state))
                        {
                            let new_parent: ChildParent = ChildParent.init(child: self.current_state_name,
                                                                           parent: self.bottom_tracker)
                            self.bottom_tracker = new_parent
                            self.indents += 1
                        }
                    }
                    if(isParent(maybe_parent: maybe_parent))
                    {
                        self.bottom_tracker.setChild(new_child: self.current_state_name)
                        let start_children: [[String]] = (self.name_state_table[self.current_state_name]?.getStartChildren())!
                        self.next_states = []
                        for start_child in start_children
                        {
                            self.next_states.append(start_child)
                        }
                    }
                    else
                    {
                        let nexts:[[String]] = (self.name_state_table[self.current_state_name]?.getNexts())!
                        self.next_states = []
                        for next_state in nexts
                        {
                            self.next_states.append(next_state)
                        }
                        self.bottom_tracker.setChild(new_child: self.current_state_name)
                    }
                    state_changed = true
                    break
                }
                
                j += 1
            }
            //print("state changed?", state_changed)
           // print("stack")
            //print("winning state1 ", self.current_state_name)
            //print("next states")
            //print(self.next_states)
            //printStack2(bottom_tracker: self.bottom_tracker)
            if(self.next_states.count == 0)
            {
            
            
                //print("time to shorten stack\n")
                let tracker_continuing_next_states_indents: NextStatePackage = getNextStates(bottom: self.bottom_tracker,
                                                                                             next_states: self.next_states,
                                                                                             indents: self.indents,
                                                                                             name_state_table: self.name_state_table)
                self.next_states = tracker_continuing_next_states_indents.next_states
                self.indents = tracker_continuing_next_states_indents.indents
                self.bottom = tracker_continuing_next_states_indents.bottom_of_shortened_stack
                self.bottom_tracker = self.bottom
                //print(self.next_states)
                //print("shortened stack")
                //printStack2(bottom_tracker: self.bottom_tracker)
                //print(self.next_states)
            }
            if(!state_changed && self.next_states.count > 0)
            {
                print("error at ")
                for next_state in self.next_states
                {
                    print(next_state, parser.getState(state_name: next_state).getFunctionName())
                }
                //print(self.next_states)
                break
                /*
                    //printf(getIndents(indents), next_states, "on");
                    level_id_state_id* point = ht_search2(state_x_y_table, current_state_name);

                    //printf(getIndents(indents), '('+  '\'' + current_state_name + '\'' + ',' , case_ + ',', "f=" +
                    //       levels[point->level_id].state_list[point->state_id]->function_name + ',', str(indents) + ')');
                    break;

                    //print(next_states, 'have failed so your state machine is incomplete')
                    //exit()

                */
            }
            // when machine's stack is folded and done this echos the last state run from before the folding
            let point2: ContextState = self.name_state_table[self.current_state_name]!

            //print("winning state", self.current_state_name, "f=", point2.function_name)
            //print("next states", self.next_states)
            //printStack2(bottom_tracker: self.bottom_tracker)
            //print()


            //print("end condition")
            //print(end_states_nexts)
            
            self.ii += 1
        }
        print("state machine is done\n")
        print("total states run", self.ii)
    
        //let matrix = name_state_table[["sparse_matrix"]]!.getData().data["[Point: ContextState]"] as! [Point: ContextState]
        //let point_table = name_state_table[["point_table"]]!.getData().data["[[String]: Point]"] as! [[String]: Point]
        //print(matrix.count)
        //let start_node = matrix[Point.init(l: 0, s: 0)]!
        /*
        let points = matrix.keys
        var index = points.startIndex
        for i in (0..<points.count)
        {
            matrix[index].value.Print(indent_level: 0)
            index = points.index(index, offsetBy: 1)
            print()
            print()
        }*/
                      //  let matrix = name_state_table[["sparse_matrix"]]!.getData().data["[Point: ContextState]"] as! [Point: ContextState]
        /*
        let format_string = prettyFormat(node: start_node,
                                         indents: "",
                                         start_child: false,
                                         matrix: matrix,
                                         point_table: point_table)
        
        print(format_string)
        */
        for i in parser.unresolved_list
        {
                print(i.key)
                for j in i.value
                {
                    j.Print()
                    let parent = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: j)
                    print(parent.getName())
                    print()
                    print()

                }

        }
    }
}

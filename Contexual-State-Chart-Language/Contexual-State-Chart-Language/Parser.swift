//
//  Parser.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/23/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

// this is separated from the functions that actually do the parsing because the functions will eventually be moved to separate files and the number of functions will likely increase
class Parser {
    
    var unresolved_list: [[String]: [Point]] = [[String]: [Point]]()
    var name_state_table: [[String]: ContextState] = [[String]: ContextState]()
    func getState(state_name: [String]) -> ContextState
    {
        return retrieveState(current_state_name: state_name, name_state_table: &name_state_table)
    }
    func getVariable(state_name: [String]) -> Data
    {
        return retrieveState(current_state_name: state_name, name_state_table: &name_state_table).getData()
    }
    func saveState(state: ContextState)
    {
        self.name_state_table[state.getName()] = state

    }
    func getContextStateFromStringListToContextStateEntry(key: [String]) -> ContextState
    {
        let entry = self.name_state_table[key]
        if(entry != nil)
        {
            return entry!
        }
        return ContextState.init(name: [], function: returnTrue)
    }
    
    
    
    

    func testing(current_state_name: [String], parser: inout Parser) -> Bool
    {
        //let test: String = parser.name_state_table[current_state_name]!.getData().getString()
        return true
    }

   
}
// functions for parsing
func outOfBounds(i: Int, size: Int) -> Bool
{
    return i <= -1 || i >= size
}
/*
 func runParser()
{
    let name_state_table = [[String]: ContextState]()

    let visitor_class: Visit = Visit.init(next_states: [["states", "state"]],
                                              current_state_name:    ["states", "state"],
                                              bottom:                ChildParent.init(child: ["root", "0"],
                                                                                      parent: nil),
                                              dummy_node:            ContextState.init(name:["root", "0"],
                                                                                       nexts: [],
                                                                                       start_children: [],
                                                                                       function: returnTrue(current_state_name:parser:stack:),
                                                                                       function_name: "returnTrue",
                                                                                       data: Data.init(new_data: [:]),
                                                                                       parents: []),
                                              name_state_table:     name_state_table)
var parser: Parser = Parser.init()

}*/
func setState(current_state: ContextState, name_state_table: inout [[String]: ContextState])
{
    name_state_table[current_state.getName()] = current_state

}

func retrieveState(current_state_name: [String], name_state_table: inout [[String]: ContextState]) -> ContextState
{
    if(name_state_table[current_state_name] != nil)
    {
        return name_state_table[current_state_name]!

    }
    print("no state by ", current_state_name, "is in name_state_table")
    return ContextState.init(name: ["state does not exist"], function: returnTrue(current_state_name: parser:stack:))
}
func setData(current_state_name: [String], name_state_table: inout [[String]: ContextState], data: Int)
{
    if(name_state_table[current_state_name] != nil)
    {
        
        name_state_table[current_state_name]?.getData().setInt(value: data)
    }
}


// functions for the parser
func advance(index: inout String.Index, input: String, character: Character)
{
    while(!outOfBounds(i: index.encodedOffset, size: input.count) &&  input[index] == character)
    {
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
    }
}
func handleBlankLines(index: inout String.Index, input: String)
{
    // handle extra blank lines and tabs on the blank lines
    while(!outOfBounds(i: index.encodedOffset, size: input.count))
    {
        // check the \n*\t* pattern
        advance(index: &index, input: input, character: "\n")
    
        if(!outOfBounds(i: index.encodedOffset, size: input.count) && input[index] == " ")
        {
                advance(index: &index, input: input, character: " ")

        }
        else if(!outOfBounds(i: index.encodedOffset, size: input.count) && input[index] == "\t")
        {
                advance(index: &index, input: input, character: "\t")

        }

        // backtrack to the start of the last \t* before a letter
        if( !outOfBounds(i: index.encodedOffset, size: input.count) &&
            input[index] != "\t" &&
            input[index] != "\n")
        {
            index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset - 1) )

            while(!outOfBounds(i: index.encodedOffset, size: input.count) &&  input[index] == "\t")
            {
                index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset - 1) )
            }
            index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
            break
        }
    }
}

func advanceInit(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    var i: Int = parser.getVariable(state_name: ["i"]).getInt()
    let input: String = parser.getVariable(state_name: ["input"]).getString()
    var index = input.index(input.startIndex, offsetBy: 0)

    var word: String = String()
    if(outOfBounds(i: index.encodedOffset, size: input.count))
    {
        return false
    }
    while(!outOfBounds(i: index.encodedOffset, size: input.count) &&  input[index] != "\n")
    {
        word.append(input[index])
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
    }


    index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
    handleBlankLines(index: &index, input: input)

    
    var indent_count: Int = Int()
    while(!outOfBounds(i: index.encodedOffset, size: input.count) && input[index] == "\t")
    {
        
        indent_count += 1
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
        
    }
    i = index.encodedOffset
    parser.getVariable(state_name: ["i"]).setInt(value: i)
    parser.getVariable(state_name: ["current_word"]).setString(value: word)

    parser.getVariable(state_name: ["next_indent"]).setInt(value: indent_count)

    return true
}
func collectName(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state_name_progress = parser.getVariable(state_name: ["current_word"]).getString()

    parser.getVariable(state_name: ["name", "state_name"]).appendString(value: state_name_progress)


    return true
}
func advanceLoop(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    // the way the index advances is tricky
    var i: Int = parser.getVariable(state_name: ["i"]).getInt()
    let input: String = parser.getVariable(state_name: ["input"]).getString()
    var next_indent = parser.getVariable(state_name: ["next_indent"]).getInt()
    var prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    var current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var prev_word = parser.getVariable(state_name: ["prev_word"]).getString()
    var index = input.index(input.startIndex, offsetBy: String.IndexDistance(i))
    parser.getVariable(state_name: ["prev_prev_indent"]).setInt(value: prev_indent)
    // input[index] is not supposed to = '\n'
    if(outOfBounds(i: i, size: input.count))
    {
        return false
    }

    var word: String = String()
    if(index.encodedOffset + 1 >= input.count)
    {
        print("done")
        exit(0)
    }

    while(!outOfBounds(i: index.encodedOffset, size: input.count) && input[index] != "\n")
    {
        
        word.append(input[index])
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
    }
    


    // end of file so save the function name
    if(index.encodedOffset + 1 >= input.count)
    {
        parser.getVariable(state_name: ["i"]).setInt(value: -1)

        parser.getVariable(state_name: ["current_word"]).setString(value: word)

        // set TLO to true
        parser.getVariable(state_name: ["tlo"]).setBool(value: true)

        return true
    }
    index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))

    handleBlankLines(index: &index, input: input)

    var indent_count: Int = Int()
    while(!outOfBounds(i: i, size: input.count) && input[index] == "\t")
    {
        
        indent_count += 1
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
        
    }

    parser.getVariable(state_name: ["child"]).setBool(value: false)
    parser.getVariable(state_name: ["sibling"]).setBool(value: false)
    parser.getVariable(state_name: ["new_parent"]).setBool(value: false)

    if(prev_indent < next_indent)
    {
        parser.getVariable(state_name: ["child"]).setBool(value: true)

    }
    else if(prev_indent == next_indent)
    {
        parser.getVariable(state_name: ["sibling"]).setBool(value: true)
    }
    else if(prev_indent > next_indent)
    {
        parser.getVariable(state_name: ["new_parent"]).setBool(value: true)
    }
    swap(&next_indent, &prev_indent)
    swap(&current_word, &prev_word)
    current_word = word

    next_indent = indent_count

    i = index.encodedOffset

    parser.getVariable(state_name: ["i"]).setInt(value: i)

    parser.getVariable(state_name: ["prev_word"]).setString(value: prev_word)


    parser.getVariable(state_name: ["current_word"]).setString(value: current_word)
    
    parser.getVariable(state_name: ["prev_indent"]).setInt(value: prev_indent)

    parser.getVariable(state_name: ["next_indent"]).setInt(value: next_indent)

   // let x = parser.getVariable(state_name: ["max_stack_index"]).getInt()

    //let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    
    return true
}
func endOfInput(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    // advance loop from "advance past \"Data\"" pushed j past the point of the input

    //let input = parser.getVariable(state_name: ["input"]).getString()

    let j = parser.getVariable(state_name: ["i"]).getInt()

    // when index goes beyond the end of the string
    return j == -1
}
func tlo(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return parser.getVariable(state_name: ["tlo"]).getBool()
}
func isDeadState(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    let next_indent = parser.getVariable(state_name: ["next_indent"]).getInt()
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()

    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    //let prev_word = parser.getVariable(state_name: ["prev_word"]).getString()

    if(current_word == "")
    {
        print("end of input")
        parser.getVariable(state_name: ["tlo"]).setBool(value: true)
        return true

    }
    return next_indent == prev_indent
}
func isLink(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    let current_word = parser.getVariable(state_name: ["current_word"]).getString()

    if(current_word.count >= 2)
    {
        let child_index = current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(0))

        let start_child_index = current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(1))
        if(current_word[child_index] == "&")
        {
            return true
        }
        else if(current_word[start_child_index] == "&")
        {
            return true
        }

    }
    return false
}
func dash(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var j = parser.getVariable(state_name: ["j"]).getInt()
    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    // in case there are extra spaces
    j = skipSpaces(input: current_word, i: j)
    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
    if(char == "-")
    {
        parser.getVariable(state_name: ["j"]).setInt(value: j + 1)
        parser.getVariable(state_name: ["is_start_child"]).setBool(value: true)
        return true
    }
    return false
}
func ampersand(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var j = parser.getVariable(state_name: ["j"]).getInt()
    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    // in case there are extra spaces
    j = skipSpaces(input: current_word, i: j)
    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]

    if(char == "&")
    {
        j = skipSpaces(input: current_word, i: j)
        parser.getVariable(state_name: ["j"]).setInt(value: j)

        return true
    }
    return false
}
func detectLink(link: String) -> Bool
{
    if(link.count > 1)
    {
        let child_index = link.index(link.startIndex, offsetBy: String.IndexDistance(0))

        let start_child_index = link.index(link.startIndex, offsetBy: String.IndexDistance(1))
        if(link[child_index] == "&")
        {
            return true
        }
        else if(link[start_child_index] == "&")
        {
            return true
        }
    }
    
    return false
}
func detectStartChild(link: String, parser: inout Parser) -> Bool
{
    //let start_child_index = link.startIndex
    if(link.count > 0)
    {
        return parser.getVariable(state_name: ["is_start_child"]).getBool() == true

    }
    return false
}
func addToUnresolvedLinks(  current_state_name: [String],
                            parser: inout Parser,
                            stack: ChildParent,
                            parent: inout ContextState,
                            link: [String],
                            parent_level: Int,
                            parent_state: Int) -> Bool
{
    let point = parser.getVariable(state_name: ["point_table"]).getPointFromStringListToPointEntry(key: link)
    if(point != Point.init(l: -1, s: -1))
    {
        let state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: point)
        let parents = state.getParents()
        state.setParents(parents: parents + [parent.name])


        parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: [])

        return true
    }
    else
    {

        if(parser.unresolved_list[link] != nil)
        {
            if((parser.unresolved_list[link]?.count)! > 0)
            {
                parser.unresolved_list[link]?.append(Point.init(l: parent_level, s: parent_state))


                parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: [])

                return true
            }
            
        }
        else// if((parser.unresolved_list[link]?.count)! == 0)
        {

            parser.unresolved_list[link] = [Point.init(l: parent_level, s: parent_state)]


            parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: [])

            return true
        }
        
    }
    return false
}
func saveChildLink(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    var link = parser.getVariable(state_name: ["names", "next state links"]).getStringList()

    // increment the state id anyways cause there is expected to be a place for the link being collected
    if(detectLink(link: link[0]))
    {
        if(!detectStartChild(link: link[0], parser: &parser))
        {

            link[0] = String(link[0].dropFirst())
            while(link[0][ link[0].startIndex ] == " ")
            {
                link[0] = String(link[0].dropFirst())

            }

            let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()

            let parent_level = parser.getVariable(state_name: ["level_number", String(max_stack_index - 1)]).getInt()


            let parent_state = parser.getVariable(state_name: ["state_number", String(max_stack_index - 1)]).getInt()
            
            var parent = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: Point.init(l: parent_level, s: parent_state))
            
            // when saving the state, just append the child -> parent links that haven't been accounted for here(get rid of the extra parent to child unaccounted for links code)
            parent.appendChild(child: link)
            
            
            

            return addToUnresolvedLinks(   current_state_name: current_state_name,
                                    parser: &parser,
                                    stack: stack,
                                    parent: &parent,
                                    link: link,
                                    parent_level: parent_level,
                                    parent_state: parent_state)
        }
        
    }

    
    

    return false
}
func saveStartChildLink(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    var link = parser.getVariable(state_name: ["names", "next state links"]).getStringList()
    if(detectLink(link: link[0]))
    {
        if(detectStartChild(link: link[0], parser: &parser))
        {
            // get rid of "&"
            link[0] = String(link[0].dropFirst())

            while(link[0][ link[0].startIndex ] == " ")
            {
                link[0] = String(link[0].dropFirst())

            }

            let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()

            let parent_level = parser.getVariable(state_name: ["level_number", String(max_stack_index - 1)]).getInt()


            let parent_state = parser.getVariable(state_name: ["state_number", String(max_stack_index - 1)]).getInt()

            var parent = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: Point.init(l: parent_level, s: parent_state))
            parent.appendStartChild(start_child: link)

            addToUnresolvedLinks(   current_state_name: current_state_name,
                                    parser: &parser,
                                    stack: stack,
                                    parent: &parent,
                                    link: link,
                                    parent_level: parent_level,
                                    parent_state: parent_state)
            
        }
        
    }
    
    return false
}

func isData(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Data"

}
func printData(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    print(parser.getVariable(state_name: ["current_word"]).getString())
    parser.getVariable(state_name: ["x"]).setInt(value: 0)
    parser.getVariable(state_name: ["structure"]).setString(value: "")
    parser.getVariable(state_name: ["dict init key type"]).setString(value: "")
    parser.getVariable(state_name: ["dict init value type"]).setString(value: "")

    return true
}
func isChildren(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Children"

}
func isNext(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Next"

}
func notIsCurrentWordFunction(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return !(parser.getVariable(state_name: ["current_word"]).getString() == "Function")

}
func isCurrentWordFunction(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Function"

}
func saveState(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    // if at any other state, have to set it's parent to the last state saved and the last state saved's first children
    // if there is more than 1 child, do the above for the first child only
    
    var collected_state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    let last_item = collected_state_name.count - 1

    let start_index = collected_state_name[last_item].startIndex
    var collected_state_name2 = [String]()
    for i in collected_state_name
    {
        collected_state_name2.append(i)
    }
    if(collected_state_name[last_item][start_index] == "-")
    {
        collected_state_name2[last_item] = String(collected_state_name2[last_item].dropFirst())
    }

    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    let level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()

    let state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()
    // level_id and state_id are the top of the stack
    // the stack should have the current level, current indent level for state, ith state

    let new_state = ContextState.init(name: collected_state_name2, function: returnTrue(current_state_name: parser:stack:))

    if(current_state_name == ["save dead state"] || current_state_name == ["save dead state", "2"])
    {
        new_state.setFunctionName(function_name: "returnTrue")
    }
    // point_table "[[String]: Point]"
    parser.getVariable(state_name: ["point_table"]).setStringListToPointEntry(key: collected_state_name2,
                                                                              value: Point.init(l: level, s: state))

    
    // sparse_matrix "[Point: ContextState]"
    parser.getVariable(state_name: ["sparse_matrix"]).setPointToContextState(key: Point.init(l: level, s: state),
                                                                             value: new_state)
    
    
    if(level == 0 && state == 0)
    {
            // if at first state(0, 0), have to set it's parent and root's start children
        let point: Point = Point.init(l: 0, s: 0)

        let state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: point)

        state.setParents(parents: [["root"]])



    }
    // for when same level is reentered later in the tree
    else// if (state >= 0)
    {
        
        
        let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
        let prev_level_state_number = parser.getVariable(state_name: ["state_number", String(max_stack_index - 1)]).getInt()
        
        let prev_level_level_number = parser.getVariable(state_name: ["level_number", String(max_stack_index - 1)]).getInt()

        let point: Point = Point.init(l: prev_level_level_number, s: prev_level_state_number)
        
        let parent_state: ContextState = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: point)
        let start_index = collected_state_name[last_item].startIndex
        if(collected_state_name[last_item][start_index] == "-")
        {
            collected_state_name[last_item] = String(collected_state_name[last_item].dropFirst())
            parent_state.appendStartChild(start_child: collected_state_name)
            
            
        }
        else
        {
            
            parent_state.appendChild(child: collected_state_name)

            

        }

        let location_of_child = Point.init(l: level, s: state)
        let child_state: ContextState = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: location_of_child)

        child_state.setParents(parents: [parent_state.getName()])

        if(parser.unresolved_list[collected_state_name2] != nil)
        {
            for parent_point in parser.unresolved_list[collected_state_name2]!
            {
                var secondary_parent_state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: parent_point)

                child_state.parents.append(secondary_parent_state.getName())
            }
                
        }
        parser.unresolved_list.removeValue(forKey: collected_state_name2)


    }
    
    
    
    // print saved state
    let point = parser.getVariable(state_name: ["point_table"]).getPointFromStringListToPointEntry(key: collected_state_name)


    let context_state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: point)
    
    context_state.Print(indent_level: level)

    return true
    
}
func saveNewState(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    saveState(current_state_name: current_state_name, parser: &parser, stack: stack)

    let state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    let x = state_name.dropLast()
    var new_state_name = [String]()
    for i in x
    {
        new_state_name.append(i)
    }
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: new_state_name)
    let matrix = parser.getVariable(state_name: ["sparse_matrix"]).data["[Point: ContextState]"] as! [Point: ContextState]

    return true
}
func advanceLevel(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    // take the current level and state values from the tracker and use them to calculate secondary name for stack variables, location of stack veriables in the levels matrix
    // does depth first traversal using the level id's
    // does breath first traversal using the state id's
    var max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    
    let current_level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()

    let current_state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()

    /*
     // level_indent_stack
            // 0, 1, 2
            // level_number
                // 0, 1, 2
            // indent_number
                // 0, 1, 2
    */

    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    
    
    
    let state: ContextState = parser.getContextStateFromStringListToContextStateEntry(key: ["state_number", String(max_stack_index + 1)])

    // push
    if(state == ContextState.init(name: [], function: returnTrue))
    {
        max_stack_index += 1

        parser.name_state_table[["level_number", String(max_stack_index)]] = ContextState.init(name: ["level_number", String(max_stack_index)],
                                                                                             nexts: [],
                                                                                             start_children: [],
                                                                                             function: returnTrue(current_state_name:parser:stack:),
                                                                                             function_name: "returnTrue",
                                                                                             data: Data.init(new_data: ["Int": current_level + 1]),
                                                                                             parents: [])

        parser.name_state_table[["state_number", String(max_stack_index)]] = ContextState.init(name: ["state_number", String(max_stack_index)],
                                                                                             nexts: [],
                                                                                             start_children: [],
                                                                                             function: returnTrue(current_state_name:parser:stack:),
                                                                                             function_name: "returnTrue",
                                                                                             data: Data.init(new_data: ["Int": 0]),
                                                                                             parents: [])

        parser.name_state_table[["indent_number", String(max_stack_index)]] = ContextState.init(name: ["indent_number", String(max_stack_index)],
                                                                                              nexts: [],
                                                                                              start_children: [],
                                                                                              function: returnTrue(current_state_name:parser:stack:),
                                                                                              function_name: "returnTrue",
                                                                                              data: Data.init(new_data: ["Int": prev_indent]),
                                                                                              parents: [])
        
        // grow stack
        parser.getVariable(state_name: ["max_stack_index"]).setInt(value: max_stack_index)

    }
    // copy over
    else
    {

        parser.getVariable(state_name: ["max_stack_index"]).setInt(value: max_stack_index + 1)
        let last_value = parser.getVariable(state_name: ["state_number", String(max_stack_index + 1)]).getInt()
        
        // increment state_number[max_stack_index + 1]
        parser.getVariable(state_name: ["state_number", String(max_stack_index + 1)]).setInt(value: last_value + 1)

        max_stack_index += 1
        

    }
    
    
    return true
}

func saveNextStateLink(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    
    return true
}
func initJ(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    parser.getVariable(state_name: ["j"]).setInt(value: 0)
    parser.getVariable(state_name: ["names", "next state links"]).setStringList(value: [String]())
    return true
}
func initI(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    parser.getVariable(state_name: ["state name string", "next states"]).setString(value: String())
    return true
}

func skipSpaces(input: String, i: Int) -> Int
{
    var k = input.index(input.startIndex, offsetBy: String.IndexDistance(i))


    while(!outOfBounds(i: k.encodedOffset, size: input.count) && input[k] == " ")
    {
        k = input.index(input.startIndex, offsetBy: String.IndexDistance(k.encodedOffset + 1))
    }
    return k.encodedOffset
}
func collectSpaces(input: String, i: Int) -> String
{
    var k = input.index(input.startIndex, offsetBy: String.IndexDistance(i))
    var spaces = String()
    while(!outOfBounds(i: k.encodedOffset, size: input.count) && input[k] == " ")
    {
        spaces.append(" ")
        k = input.index(input.startIndex, offsetBy: String.IndexDistance(k.encodedOffset + 1))
    }
    return spaces
}
func charNotBackSlashNotWhiteSpace(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()

    if(!outOfBounds(i: j, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]

        if(char != "\\" && char != " ")
        {
            var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()
            state_name.append(char)
            parser.getVariable(state_name: ["state name string", "next states"]).setString(value: state_name)
            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)
            return true
        }
    }
    
    return false
    
}
func backSlash(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()

    if(!outOfBounds(i: j, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
        if(char == "\\")
        {
            var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()

            state_name.append(char)
            parser.getVariable(state_name: ["state name string", "next states"]).setString(value: state_name)
            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

            return true
        }
    }
    
    return false
}
func whiteSpace0(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()

    if(!outOfBounds(i: j, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
        if(char == " ")
        {

            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

            return true
        }
    }
    
    return false
    
}
func collectLastSpace(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()

    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
    if(char != "\\" && char != " " && char != "/")
    {
        var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()
        state_name.append(" ")

        parser.getVariable(state_name: ["state name string", "next states"]).setString(value: state_name)

        return true
    }
    return false
    
}
func forwardSlash0(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var j = parser.getVariable(state_name: ["j"]).getInt()
    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    // in case there are extra spaces
    j = skipSpaces(input: current_word, i: j)
    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
    if(char == "/")
    {

        return true
    }
    return false
    
}
func inputHasBeenReadIn0(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()


    return outOfBounds(i: j, size: current_word.count)
}

func forwardSlash(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    
    if(!outOfBounds(i: j, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
        if(char == "/")
        {

            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

            return true
        }
    }
   
    return false
}

func whiteSpace1(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()

    if(outOfBounds(i: j, size: current_word.count))
    {
        return false
    }
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
    if(char == " ")
    {
        var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()

        parser.getVariable(state_name: ["names", "next state links"]).appendString(value: state_name)

        parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

        return true
    }
    return false
}
func inputHasBeenReadIn2(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    if(outOfBounds(i: j, size: current_word.count))
    {
        let next_state_links = parser.getVariable(state_name: ["names", "next state links"]).getStringList()
        let state_sub_name_i = parser.getVariable(state_name: ["state name string", "next states"]).getString()
        parser.getVariable(state_name: ["names", "next state links"]).appendString(value: state_sub_name_i)
        return true


    }
    return false
}
func addLinkToState(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let link = parser.getVariable(state_name: ["names", "next state links"]).getStringList()

    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    let current_level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()


    let current_state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()


    let state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: Point.init(l: current_level,
                                                                                                                         s: current_state))
    
    state.appendNextChild(next_child: link)

    return true
}

func isLetter(char: Character) -> Bool
{
    return char >= "a" && char <= "z" || char >= "A" && char <= "Z"
}
func isLetterUnderscoreNumber(char: Character) -> Bool
{

    return isLetter(char: char)         ||
            char == "_"                 ||
            char >= "0" && char <= "9"
}
func initK(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    parser.getVariable(state_name: ["k"]).setInt(value: 0)
    parser.getVariable(state_name: ["function name"]).setString(value: String())

    return true
}
func isFirstCharS(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()

    if(outOfBounds(i: 0, size: current_word.count))
    {
        return false
    }
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(0))]

    if(char == "S")
    {
        parser.getVariable(state_name: ["k"]).setInt(value: 1)
        return true

    }
    
    

    return false
}
func letter(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()

    let k = parser.getVariable(state_name: ["k"]).getInt()

    if(!outOfBounds(i: k, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]

        if(isLetter(char: char))
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func letterUnderscoreNumber(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()

    if(!outOfBounds(i: k, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]

        if(isLetterUnderscoreNumber(char: char))
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func leftParens(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()

    if(!outOfBounds(i: k, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        
        if(char == "(")
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func colon(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()

    if(!outOfBounds(i: k, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]

        if(char == ":")
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func rightParens(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()

    if(!outOfBounds(i: k, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]

        if(char == ")")
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func collectLetter(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    // this function is run after runs so there should be at least one space after the word "runs" in the input
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var k = parser.getVariable(state_name: ["k"]).getInt()
    if(outOfBounds(i: k, size: current_word.count))
    {
        return false
    }
    k = skipSpaces(input: current_word, i: k)
    if(outOfBounds(i: k, size: current_word.count))
    {
        return false
    }
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]

    if(isLetter(char: char))
    {
        var state_name = parser.getVariable(state_name: ["function name"]).getString()

        state_name.append(char)
        
        parser.getVariable(state_name: ["function name"]).setString(value: state_name)
        parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
        return true
    }
    return false
}
func collectLetterUnderscoreNumber(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    if(!outOfBounds(i: k, size: current_word.count))
    {

        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        if(isLetterUnderscoreNumber(char: char))
        {
            var state_name = parser.getVariable(state_name: ["function name"]).getString()

            state_name.append(char)
            
            parser.getVariable(state_name: ["function name"]).setString(value: state_name)
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true
        }
    }
    
    return false
}
func inputEmpty(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    if(outOfBounds(i: k, size: current_word.count))
    {

        return true


    }
    return false
}
func runs(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var k = parser.getVariable(state_name: ["k"]).getInt()
    k = skipSpaces(input: current_word, i: k)
    if(!outOfBounds(i: k + 3, size: current_word.count))
    {
        let char1 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        let char2 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k + 1))]
        let char3 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k + 2))]
        let char4 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k + 3))]

        if(char1 == "r" &&
           char2 == "u" &&
           char3 == "n" &&
           char4 == "s")
        {
            var state_name = parser.getVariable(state_name: ["function name"]).getString()


            parser.getVariable(state_name: ["function name"]).setString(value: state_name)
            parser.getVariable(state_name: ["k"]).setInt(value: k + 4)
            return true
        }
    }
    return false

}
func saveFunctionName(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    // save current word as function name

    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    let current_word = parser.getVariable(state_name: ["function name"]).getString()
    let current_level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()


    let current_state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()


    let state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: Point.init(l: current_level,
                                                                                                                         s: current_state))
    state.setFunctionName(function_name: current_word)
    
    return true
}
func isCurrentWordASiblingOfPrevWord(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    return parser.getVariable(state_name: ["sibling"]).getBool()

}

func isCurrentWordADifferentParentOfPrevWord(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    return parser.getVariable(state_name: ["new_parent"]).getBool()
}

func windBackStateNameFromEnd(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let prev_prev_indent = parser.getVariable(state_name: ["prev_prev_indent"]).getInt()
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let current_indent = parser.getVariable(state_name: ["next_indent"]).getInt()
    var last_state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    
    // very not intuitive, because the incrementing numbers and strings are set up in a certain way
    // the second +1 is so the value is positive cause saveNewState deletes the last item off(throwing off this equation cause
    // we are assuming no state name parts are deleted off after the dead state is saved)
    let names_to_delete_from_the_end = prev_prev_indent - prev_indent  + 1

    var cleaned_state_name = [String]()

    for i in (0..<(last_state_name.count - names_to_delete_from_the_end))
    {
        cleaned_state_name.append(last_state_name[i])
    }
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: cleaned_state_name)

    return true
}
func isAStateName(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    return !(parser.getVariable(state_name: ["current_word"]).getString() == "Children" ||
             parser.getVariable(state_name: ["current_word"]).getString() == "Next"     ||
             parser.getVariable(state_name: ["current_word"]).getString() == "Function")
}
func isCurrentIndentSameAsIndentForLevel(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    // already incremented to the state name, so the next indent is pointing to the Children word(the next indent is past the current word of consideration)
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    let current_level_indent_number = parser.getVariable(state_name: ["indent_number", String(max_stack_index)]).getInt()

    return prev_indent == current_level_indent_number
}
func deleteCurrentStateName(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: [])
    return true
}
func isCurrentIndentGreaterThanAsIndentForLevel(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    // already incremented to the state name, so the next indent is pointing to the Children word(the next indent is past the current word of consideration)
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    var state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()

    let current_level_indent_number = parser.getVariable(state_name: ["indent_number", String(max_stack_index)]).getInt()

    return prev_indent > current_level_indent_number
}
func isTheDataStateOuter(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let prev_prev_indent = parser.getVariable(state_name: ["prev_prev_indent"]).getInt()

    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    var state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()

    let current_level_indent_number = parser.getVariable(state_name: ["indent_number", String(max_stack_index)]).getInt()

    return (prev_prev_indent - prev_indent) > 2
}
func windBackDataStateName(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    let prev_prev_indent = parser.getVariable(state_name: ["prev_prev_indent"]).getInt()

    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let current_indent = parser.getVariable(state_name: ["next_indent"]).getInt()
    var last_state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    
    // very not intuitive, because the incrementing numbers and strings are set up in a certain way
    let names_to_delete_from_the_end = (prev_prev_indent - 2) - prev_indent

    var cleaned_state_name = [String]()

    for i in (0..<(last_state_name.count - names_to_delete_from_the_end))
    {
        cleaned_state_name.append(last_state_name[i])
    }
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: cleaned_state_name)
    //print(parser.getVariable(state_name: ["name", "state_name"]).getStringList())
    return true

}
func deleteTheLastContext(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    var state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()


    let x = state_name.dropLast()
    var new_state_name = [String]()
    for i in x
    {
        new_state_name.append(i)
    }
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: new_state_name)

    return true
}

func incrementTheStateId(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    let current_level_state_number = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()


    parser.getVariable(state_name: ["state_number", String(max_stack_index)]).setInt(value: current_level_state_number + 1)

    return true
}
func decreaseMaxStackIndex(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    parser.getVariable(state_name: ["max_stack_index"]).setInt(value: max_stack_index - 1)
    let current_index = parser.getVariable(state_name: ["indent_number", String(max_stack_index - 1)]).getInt()

    return true
    
}


func doubleQuote(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]

    if(char == "\"")
    {
        parser.getVariable(state_name: ["x"]).setInt(value: x + 1)

        return true

    }
    return false

}
func collectAndAdvance(parser: inout Parser, x: Int, container_name: [String], char: Character)
{
    let current_number = parser.getVariable(state_name: container_name).getString()

    parser.getVariable(state_name: ["x"]).setInt(value: x + 1)



    parser.getVariable(state_name: container_name).setString(value: current_number + String(char))
}
func notDoubleQuoteNotBackSlash(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    
    if(!(char == "\"" || char == "\\"))
    {
        print(stack.getChild(),stack.getParent()?.getChild(), stack.getParent()?.getChild() == ["make structure"])
        if(stack.getParent()?.getChild() == ["make structure"])
        {
            collectAndAdvance(parser: &parser, x: x, container_name: ["structure"], char: char)
            return true

        }
        if(stack.getChild() == ["key"])
        {
            print("here")
            exit(0)
        }

    }
    return false

}
func backSlash2(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
 let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(char == "\\")
    {
        if(stack.getParent()?.getChild() == ["make structure"])
        {
            collectAndAdvance(parser: &parser, x: x, container_name: ["structure"], char: char)
            return true

        }
    }
    return false
}
func any(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(char >= " " && char <= "~")
    {
        if(stack.getParent()?.getChild() == ["make structure"])
        {
            collectAndAdvance(parser: &parser, x: x, container_name: ["structure"], char: char)
            return true

        }

    }
    return false
}
func negative(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()

    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(char == "-")
    {
        return check(parser: &parser, x: x, char: char, stack: stack)
    }
    return false
}
func dot(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(char == ".")
    {
        return check(parser: &parser, x: x, char: char, stack: stack)
    }
    return false
}
func digit(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]

    if(char >= "0" && char <= "9")
    {
        return check(parser: &parser, x: x, char: char, stack: stack)
    }
    return false
}
func isTrue(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]

    if(x + 3 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "t"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "r"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "u"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "e")
        {
            

            if(stack.child == ["make structure"])
            {

                let state = getLastStateSaved(parser: &parser)
                state.getData().setBool(value: true)

                return true
            }
        }
    }
    return false
    
}
func isFalse(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 4 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "f"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "a"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "l"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "s"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 4))] == "e")
        {

             if(stack.child == ["make structure"])
            {

                let state = getLastStateSaved(parser: &parser)
                state.getData().setBool(value: false)

                return true
            }
        }

    }
    return false
    
}
func isNil(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 2 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "n"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "i"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "l")
        {
             if(stack.child == ["make structure"])
            {

                let state = getLastStateSaved(parser: &parser)
                state.getData().setNil()

                return true
            }
        }
        
    }
    return false
    
}
func isBool(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 3 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "B"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "o"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "o"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "l")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 4)
            parser.getVariable(state_name: ["dict init key type"]).setString(value: "Bool")
            return true
        }
    }
    return false
    
}
func isInt(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 2 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "I"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "n"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "t")
        {
            // move x past Int
            parser.getVariable(state_name: ["x"]).setInt(value: x + 3)
            parser.getVariable(state_name: ["dict init key type"]).setString(value: "Int")

            return true
        }
    }
    return false
    
}
func isFloat(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 4 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "F"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "l"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "o"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "a"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 4))] == "t")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 5)
            parser.getVariable(state_name: ["dict init key type"]).setString(value: "Float")
            return true
        }

    }
    return false
    
}
func isString(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 5 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "S"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "t"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "r"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "i"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 4))] == "n"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 5))] == "g")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 6)
            parser.getVariable(state_name: ["dict init key type"]).setString(value: "String")
            return true
        }

    }
    return false
    
}
func parens(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]

    if(x + 1 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "("     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == ")")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 2)
            return true
        }

    }
    return false
}
func leftSquareBraket(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "[" )
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 1)
            return true
        }

    }
    return false
}
func rightSquareBraket(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]

    if(x < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "]")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 1)
            return true
        }

    }
    return false
}
func collect(parser: inout Parser, x: Int, container_name: [String], char: Character)
{
    let current_number = parser.getVariable(state_name: container_name).getString()

    parser.getVariable(state_name: ["x"]).setInt(value: skipSpaces(input: current_number, i: x))


    parser.getVariable(state_name: ["x"]).setInt(value: parser.getVariable(state_name: ["x"]).getInt() + 1)
    parser.getVariable(state_name: container_name).setString(value: current_number + String(char))

}
func getLastStateSaved(parser: inout Parser) -> ContextState
{
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    let current_level_state_number = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()
    let current_level_level_number = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()
    let state = parser.getVariable(state_name: ["sparse_matrix"])
                      .getContextStateFromPointToContextState(key: Point(l: current_level_level_number,
                                                                         s: current_level_state_number))
    return state
}
func isKOutOfBounds(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()

    if(x >= input.count)
    {
        //print(stack.child)
        if(current_state_name == ["int"])
        {
            // if parent is
            if(stack.getParent()!.child == ["make structure"])
            {
                //print("convert to int")

                //print(parser.getVariable(state_name: ["structure"]).getString())
                let string = parser.getVariable(state_name: ["structure"]).getString()
                // get the state
                let state = getLastStateSaved(parser: &parser)
                state.getData().setInt(value: Int(string)!)
                //state.Print(indent_level: 0)
                //exit(0)
                // state.setInt(Int(parser.getVariable(state_name: ["structure"]).getString()))
                return true
            }
            
        }
        else if(current_state_name == ["float"])
        {
            if(stack.getParent()!.child == ["make structure"])
            {
                //print(parser.getVariable(state_name: ["structure"]).getString())
                let string = parser.getVariable(state_name: ["structure"]).getString()
                // get the state
                let state = getLastStateSaved(parser: &parser)
                state.getData().setFloat(value: Float(string)!)
                //state.Print(indent_level: 0)
                //exit(0)
                return true
            }
        }
        else if(current_state_name == ["string"])
        {
             if(stack.getParent()!.child == ["make structure"])
            {
                //print(parser.getVariable(state_name: ["structure"]).getString())
                let string = parser.getVariable(state_name: ["structure"]).getString()
                //print(string)
                // get the state
                let state = getLastStateSaved(parser: &parser)
                state.getData().setString(value: string)
                //state.Print(indent_level: 0)
                //exit(0)
                return true
            }
        }
    }
    return false
}

func saveInitFalse(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setBool(value: false)
    //state.Print(indent_level: 0)

    return true
}
func saveInit0(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setInt(value: 0)
    //state.Print(indent_level: 0)
    return true

}
func saveInitFloat0(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setFloat(value: 0.0)
    //state.Print(indent_level: 0)
    return true

}
func saveInitString(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setString(value: "")
    //state.Print(indent_level: 0)
    return true

}
func saveInitArrayFalse(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setBoolList(value: [Bool]())
    //state.Print(indent_level: 0)
    return true

}
func saveInitArray0(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setIntList(value: [Int]())
    //state.Print(indent_level: 0)
    return true

}
func saveInitArrayFloat0(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setFloatList(value: [Float]())
    //state.Print(indent_level: 0)
    return true

}
func saveInitArrayString(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    let state = getLastStateSaved(parser: &parser)
    state.getData().setStringList(value: [String]())
    //state.Print(indent_level: 0)
    return true

}

func colon3(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var k = parser.getVariable(state_name: ["x"]).getInt()
    k = skipSpaces(input: current_word, i: k)
    if(!outOfBounds(i: k, size: current_word.count))
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        //print(char)
        if(char == ":")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func boolSaveValueType(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    var x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    x = skipSpaces(input: input, i: x)

    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 3 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "B"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "o"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "o"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "l")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 4)
            parser.getVariable(state_name: ["dict init value type"]).setString(value: "Bool")
            return true
        }
    }
    return false
    

}
func intSaveValueType(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    var x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    x = skipSpaces(input: input, i: x)

    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]

    if(x + 2 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "I"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "n"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "t")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 3)
            parser.getVariable(state_name: ["dict init value type"]).setString(value: "Int")
            return true
        }
    }
    return false

}
func floatSaveValueType(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    var x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    x = skipSpaces(input: input, i: x)

    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
    if(x + 4 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "F"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "l"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "o"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "a"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 4))] == "t")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 5)
            parser.getVariable(state_name: ["dict init value type"]).setString(value: "Float")
            return true//check(parser: &parser, x: x, char: char, stack: stack)
        }
    }
    return false

}
func stringSaveValueType(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    var x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    x = skipSpaces(input: input, i: x)

    let i = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    let char = input[i]
     if(x + 5 < input.count)
    {
        if(  input[input.index(input.startIndex, offsetBy: String.IndexDistance(x))]  == "S"     &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 1))] == "t"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 2))] == "r"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 3))] == "i"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 4))] == "n"  &&
                input[input.index(input.startIndex, offsetBy: String.IndexDistance(x + 5))] == "g")
        {
            parser.getVariable(state_name: ["x"]).setInt(value: x + 6)
            parser.getVariable(state_name: ["dict init value type"]).setString(value: "String")
            return true//check(parser: &parser, x: x, char: char, stack: stack)
        }
    }
    return false

}
func saveInitDictEntry(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    return true
}
func saveInitDict(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{
    /*
    for each type in "dict init key type", "dict init value type"
        save the correct dict init into the last state
    */
    //print("Save dict")
    //print(parser.getVariable(state_name: ["dict init key type"]).getString(), parser.getVariable(state_name: ["dict init value type"]).getString())
    let key = parser.getVariable(state_name: ["dict init key type"]).getString()
    let value = parser.getVariable(state_name: ["dict init value type"]).getString()
    let state = getLastStateSaved(parser: &parser)

    if(key == "Bool")
    {
        if(value == "Bool")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Bool: Bool]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Int")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Bool: Int]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Float")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Bool: Float]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "String")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Bool: String]())
            //state.Print(indent_level: 0)
            return true
        }
        
    }
    if(key == "Int")
    {
        if(value == "Bool")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Int: Bool]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Int")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Int: Int]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Float")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Int: Float]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "String")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Int: String]())
            //state.Print(indent_level: 0)
            return true
        }
        
    }
    if(key == "Float")
    {
        if(value == "Bool")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Float: Bool]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Int")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Float: Int]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Float")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Float: Float]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "String")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [Float: String]())
            //state.Print(indent_level: 0)
            return true
        }
        
    }
    if(key == "String")
    {
        if(value == "Bool")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [String: Bool]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Int")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [String: Int]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "Float")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [String: Float]())
            //state.Print(indent_level: 0)
            return true
        }
        if(value == "String")
        {
            state.getData().setDict(key_0: key, key_1: value, value: [String: String]())
            //state.Print(indent_level: 0)
            return true
        }
        
    }
    /*
    Bool Bool
    Bool Int
    Bool Float
    Bool String
    Int Bool
    Int Int
    Int Float
    Int String
    Float Bool
    Float Int
    Float Float
    Float String
    String Bool
    String Int
    String Float
    String String
    */
    return false

}

func noInitStateChar(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
{

    var x = parser.getVariable(state_name: ["x"]).getInt()
    let input = parser.getVariable(state_name: ["current_word"]).getString()
    let index = input.index(input.startIndex, offsetBy: String.IndexDistance(x))
    return  !(input[index] == "B" ||
            input[index] == "I" ||
            input[index] ==  "F" ||
            input[index] ==  "S")
    
}
func check(parser: inout Parser, x: Int, char: Character, stack: ChildParent) -> Bool
{
    // first time, "make structure" is on the stack, second time to nth time, It is not
    //print(stack.getParent()?.child)
    if(stack.child == ["make structure"])
    {
        //print(stack.child)
        //exit(0)
        collect(parser: &parser, x: x, container_name: ["structure"], char: char)
        return true
    }
    else if(stack.getParent()?.child == ["make structure"])
    {
        //print(stack.child)
        //exit(0)
        collect(parser: &parser, x: x, container_name: ["structure"], char: char)
        return true

    }
    else if(stack.child == ["key"])
    {
        collect(parser: &parser, x: x, container_name: ["value", "key"], char: char)
        return true

    }
    else if(stack.child == ["value", "1"])
    {
        collect(parser: &parser, x: x, container_name: ["value", "value"], char: char)
        return true


    }
    else if(stack.child == ["value"])
    {
        collect(parser: &parser, x: x, container_name: ["value", "element"], char: char)
        return true


    }
    return false

}



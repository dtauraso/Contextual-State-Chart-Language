//
//  parsing_test_from_slides_functions.swift
//  Contexual-State-Chart-Language
//
//  Created by David on 3/12/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

// have a class that says
// current_state_name: [String], parser: inout Parser, stack: ChildParent
class StateMetadata
{
    var current_state_name: [String]
    var parser: Parser
    var stack: ChildParent
    init(current_state_name: [String], parser: inout Parser, stack: ChildParent)
    {
        self.current_state_name = current_state_name
        self.parser = parser
        self.stack = stack
    }
}

func returnTrue(state_data: StateMetadata) -> Bool
{
    return true
}
func returnFalse(state_data: StateMetadata) -> Bool
{
    return false
}
func leftParens(state_data: StateMetadata) -> Bool
{

    let input = state_data.parser.getVariable2(state_name: ["input"]).getStringList()
    let i = state_data.parser.getVariable2(state_name: ["i"]).getInt()
    print(i)
    if(i >= input.count)
    {
        return false
    }
    if(input[i] == "(")
    {
        state_data.parser.getVariable2(state_name: ["i"]).setInt(value: i + 1)
        return true

    }
    return false
}

func rightParens(state_data: StateMetadata) -> Bool
{

    let input = state_data.parser.getVariable2(state_name: ["input"]).getStringList()
    let i = state_data.parser.getVariable2(state_name: ["i"]).getInt()
    if(i >= input.count)
    {
        return false
    }
    if(input[i] == ")")
    {
        state_data.parser.getVariable2(state_name: ["i"]).setInt(value: i + 1)
        return true

    }
    return false
}
func isDigit(state_data: StateMetadata) -> Bool
{

    let input = state_data.parser.getVariable2(state_name: ["input"]).getStringList()
    let i = state_data.parser.getVariable2(state_name: ["i"]).getInt()
    if(i >= input.count)
    {
        return false
    }
    if(input[i] >= "0" && input[i] <= "9")
    {
        state_data.parser.getVariable2(state_name: ["i"]).setInt(value: i + 1)
        return true

    }
    return false
}

func isLetter(state_data: StateMetadata) -> Bool
{

    let input = state_data.parser.getVariable2(state_name: ["input"]).getStringList()
    let i = state_data.parser.getVariable2(state_name: ["i"]).getInt()
    if(i >= input.count)
    {
        return false
    }
    if(input[i] >= "a" && input[i] <= "z" || input[i] >= "A" && input[i] <= "Z" )
    {
        state_data.parser.getVariable2(state_name: ["i"]).setInt(value: i + 1)
        return true

    }
    return false
}


func noLettersAndNoDigits(state_data: StateMetadata) -> Bool
{

    let input = state_data.parser.getVariable2(state_name: ["input"]).getStringList()
    let i = state_data.parser.getVariable2(state_name: ["i"]).getInt()
    if(i >= input.count)
    {
        return false
    }
    if(
        !(
        (input[i] >= "0" && input[i] <= "9") ||
        (input[i] >= "a" && input[i] <= "z" || input[i] >= "A" && input[i] <= "Z")
        )
        )
    {
        return true

    }
    return false
}


// entire subgrapth control flow is contained inside the viewcontroller class

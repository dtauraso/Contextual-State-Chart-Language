//
//  main.swift
//  Contexual-State-Chart-Language
//
//  Created by David on 2/16/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation
// ([String], inout Parser, ChildParent) -> Bool
let function_name_to_function: [String: ([String], inout Parser, ChildParent) -> Bool] = [
    "returnTrue"                    : returnTrue,
    "returnFalse"                   : returnFalse,
    "advanceInit"                   : advanceInit,
    "collectName"                   : collectName,
    "advanceLoop"                   : advanceLoop,
    "endOfInput"                    : endOfInput,
    "isData"                        : isData,
    "printData"                     : printData,
    "tlo"                           : tlo,
    "isDeadState"                   : isDeadState,
    "isLink"                        : isLink,
    "dash"                          : dash,
    "ampersand"                     : ampersand,
    "saveChildLink"                 : saveChildLink,
    "saveStartChildLink"            : saveStartChildLink,
    "isChildren"                    : isChildren,
    "isNext"                        : isNext,
    "notIsCurrentWordFunction"      : notIsCurrentWordFunction,
    "isCurrentWordFunction"         : isCurrentWordFunction,
    "saveState"                     : saveState,
    "saveNewState"                  : saveNewState,
    "advanceLevel"                  : advanceLevel,
    "saveNextStateLink"             : saveNextStateLink,
    "initJ"                         : initJ,
    "initI"                         : initI,
    "charNotBackSlashNotWhiteSpace" : charNotBackSlashNotWhiteSpace,
    "backSlash"                     : backSlash,
    "whiteSpace0"                   : whiteSpace0,
    "collectLastSpace"              : collectLastSpace,
    "forwardSlash0"                 : forwardSlash0,
    "inputHasBeenReadIn0"           : inputHasBeenReadIn0,
    "forwardSlash"                  : forwardSlash,
    "whiteSpace1"                   : whiteSpace1,
    "inputHasBeenReadIn2"           : inputHasBeenReadIn2,
    "addLinkToState"                : addLinkToState,
    "isCurrentWordASiblingOfPrevWord" : isCurrentWordASiblingOfPrevWord,
    "initK"                         : initK,
    "isFirstCharS"                  : isFirstCharS,
    "letter"                        : letter,
    "letterUnderscoreNumber"        : letterUnderscoreNumber,
    "leftParens"                    : leftParens,
    "colon"                         : colon,
    "rightParens"                   : rightParens,
    "collectLetter"                 : collectLetter,
    "collectLetterUnderscoreNumber" : collectLetterUnderscoreNumber,
    "inputEmpty"                    : inputEmpty,
    "runs"                          : runs,
    "saveFunctionName"              : saveFunctionName,
    "isCurrentWordADifferentParentOfPrevWord" : isCurrentWordADifferentParentOfPrevWord,
    "isTheDataStateOuter"           : isTheDataStateOuter,
    "windBackDataStateName"         : windBackDataStateName,
    "windBackStateNameFromEnd"      : windBackStateNameFromEnd,
    "isAStateName"                  : isAStateName,
    "isCurrentIndentSameAsIndentForLevel" : isCurrentIndentSameAsIndentForLevel,
    "deleteCurrentStateName"        : deleteCurrentStateName,
    "isCurrentIndentGreaterThanAsIndentForLevel" : isCurrentIndentGreaterThanAsIndentForLevel,
    "deleteTheLastContext"          : deleteTheLastContext,
    "incrementTheStateId"           : incrementTheStateId,
    "decreaseMaxStackIndex"         : decreaseMaxStackIndex,

    "doubleQuote"                   : doubleQuote,
    "notDoubleQuoteNotBackSlash"    : notDoubleQuoteNotBackSlash,
    "backSlash2"                    : backSlash2,
    "any"                           : any,
    "negative"                      : negative,
    "dot"                           : dot,
    "digit"                         : digit,
    "isTrue"                        : isTrue,
    "isFalse"                       : isFalse,
    "isNil"                         : isNil,
    "isBool"                        : isBool,
    "isInt"                         : isInt,
    "isFloat"                       : isFloat,
    "isString"                      : isString,
    "parens"                        : parens,
    "leftSquareBraket"              : leftSquareBraket,
    "rightSquareBraket"             : rightSquareBraket,
    "isKOutOfBounds"                : isKOutOfBounds,
    "saveInitFalse"                 : saveInitFalse,
    "saveInit0"                     : saveInit0,
    "saveInitFloat0"                : saveInitFloat0,
    "saveInitString"                : saveInitString,
    "saveInitArrayFalse"            : saveInitArrayFalse,
    "saveInitArray0"                : saveInitArray0,
    "saveInitArrayFloat0"           : saveInitArrayFloat0,
    "saveInitArrayString"           : saveInitArrayString,

    "colon3"                        : colon3,
    "comma"                         : comma,
    "boolSaveValueType"             : boolSaveValueType,
    "intSaveValueType"              : intSaveValueType,
    "floatSaveValueType"            : floatSaveValueType,
    "stringSaveValueType"           : stringSaveValueType,
    "saveInitDict"                  : saveInitDict,
    "noInitStateChar"               : noInitStateChar,
    
    "endOfValueButNotOutOfBounds"   : endOfValueButNotOutOfBounds,
    "addDictEntry"                  : addDictEntry,
    "printState"                    : printState

]
func deleteSecondToNNewLines(input: String) -> String
{
    var new_input = String()
    let input_list = input.components(separatedBy: "\n")
    //print(input_list)
    var new_input_list = [String]()
    for input_line in input_list
    {
        var add = false
        for char in input_line
        {
            // all non whitespace characters
            if(char >= "!" && char <= "~")
            {
                add = true
                break
            }
        }
        if(add)
        {
            new_input_list.append(input_line)
        }
    }
    new_input = new_input_list.joined(separator: "\n")
    
    return new_input
}
func makeDataObject(value: [String: String]) -> Data
{
    let data_item : Data = Data.init(new_data: [:])
    //print(value)

    if(value["nothing"] != nil)
    {
        if(value["nothing"] == "null")
        {
            data_item.data = [:]
        }
    }
    else if (value["Int"] != nil)
    {
        data_item.data = ["Int": Int()]
        if(value["Int"] == "nil")
        {
            data_item.data["Int"] = 0
        }
        else
        {
            data_item.data["Int"] = Int(value["Int"]!)

        }
        
    }
    else if(value["String"] != nil)
    {
        data_item.data = ["String" : String()]

        data_item.data["String"] = value["String"]
    }
    else if(value["[Point: ContextState]"] != nil)
    {
        data_item.data = ["[Point: ContextState]": [Point: ContextState]()]
    }
    else if(value["[[String]: Point]"] != nil)
    {
        data_item.data = ["[[String]: Point]" : [[String]: Point]()]
    }
    else if(value["[String]"] != nil)
    {
        data_item.data = ["[String]" : [String]()]
    }
    else if(value["Any"] != nil)
    {
        data_item.data = ["Any" : String()]
    }
    return data_item
}
func readFile(path: String) -> String
{
    let file_manager = FileManager.default
    let file_path = file_manager.currentDirectoryPath + "/" + path
    var contents = NSString()
    do
    {
        // Get the contents
        contents = try NSString(contentsOfFile: file_path, encoding: String.Encoding.utf8.rawValue)
        //print(contents)
    }
    catch let error as NSError
    {
        print("Ooops! Something went wrong: \(error)")
        exit(0)
    }
    return String(contents)

}


func run2()
{
    //
    
    // the executable is 5 levels down in the project(the derived data folder is not in the repo)
    // get parsing graph from backup
    let five_levels_down = "../../../../../"

    var name_state_table = [[String]: ContextState]()
    let data: String = readFile(path: five_levels_down + "parsing_tree.json")
    
    var my_struct: [x] = [x]()
    do
    {
        my_struct = try JSONDecoder().decode([x].self, from: data.data(using: .utf8)!)
    }
    catch
    {
    print(error)
    }
    for item in my_struct
    {
    //print(item.name, item.data)
    //print()
    /*
    name:                  [String],
    nexts:                 [[String]],
    start_children:        [[String]],
    children
    function_name:         String,
    data:                  Data,
    parents:
    */
    name_state_table[item.name] = ContextState.init()
    name_state_table[item.name]?.name = item.name
    name_state_table[item.name]?.nexts = item.nexts
    name_state_table[item.name]?.start_children = item.start_children
    name_state_table[item.name]?.children = item.children
    name_state_table[item.name]?.function_name = item.function_name
    name_state_table[item.name]?.data = makeDataObject(value: item.data)
    name_state_table[item.name]?.parents = item.parents
    //name_state_table[item.name]?.Print(indent_level: 0)
    //print()
    }
    // "data_and_dead_state_parsing_only_input.txt"
    name_state_table[["input"]]?.getData().setString(value: deleteSecondToNNewLines(input: readFile(path: five_levels_down + "data_and_dead_state_parsing_only_input.txt")) )
    //print((name_state_table[["input"]]?.getData().getString())!)
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
    // need to get the states into name_state_table
    //parser.runParser()
    // read in the json file
    // make the ContextState objects and store them into parser


    var parsing_object = Parser.init()
    parsing_object.name_state_table = name_state_table
    visitor_class.visitStates(start_state: name_state_table[["states", "state"]]!, parser: &parsing_object, function_name_to_function: function_name_to_function)
    //var json_data = data.data(using: .utf8)!
    //print(json_data)
    //let jsonDecoder = JSONDecoder()
    //let person = try? jsonDecoder.decode(ContextState.self, from: json_data)
    //dump(person)

    //visitor_class.visitStates(start_state: name_state_table[["states", "state"]]!, parser: &parser)


    //print(new_context.callFunction(a: 1, b: 2))
    //hierarchial_state_machine = inita()
    //previous_state = "start"
    // find all level values

    //var x = od()
    //x.test()
    //x.setdefault(key: "histogram", value: Value(value: od()))
    //x.dict["x"] = od(["a", "b", "c"])
    // try this: https://stackoverflow.com/questions/35232922/how-do-you-find-a-maximum-value-in-a-swift-dictionary
    //level_number_max_state_name_string_count = findMaxLevelWordCount(list: hierarchial_state_machine.map({ [$0.value["level"] as! Int , $0.key.characters.count] }))


                    // go through tree and find the max state name size for each level
    // for all levels in the tree
        // array[level]["states"].append(state_name)
        // array[level]["difference"] = difference
    // when about the print the state name find the difference between it and the max size
    // for all in
        // dict[level] = {state_name : difference}
    // add the difference to the printout in the form of spaces
    // dict[level][previous_state]

    /*
    sync rules
        assume each task and its history from last sync is visible for algorithm
        make state machine

        keep last change
        exceptions
            check mark vs no check mark(anything that undoes the previos thing)
                in this case the non destructive changes win
            edit notes
                are saved and all fragments are concatenated together with a delimiter
        // if all items have the sync status
            // return to state that was send to sync
    */

}

run2()

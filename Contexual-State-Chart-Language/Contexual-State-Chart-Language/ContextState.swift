//
//  ContextState.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/17/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
// https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375
struct x{
    let name:           [String]
    
    let start_children: [[String]]
    let children:       [[String]]
    let parents:        [[String]]
    let nexts:          [[String]]
    let function_name:  String
    let data:           [String: String]
    
    init(name:                  [String],
         nexts:                 [[String]],
         start_children:        [[String]],
         children:              [[String]],

         function_name:         String,
         data:                  [String: String],
         parents:               [[String]])
    {
        self.name           =   name
        self.nexts          =   nexts
        self.start_children =   start_children
        self.children       =   children
        self.function_name  =   function_name
        self.data           =   data
        self.parents        =   parents

    }
    init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
    let name: [String] = try container.decode([String].self, forKey: .name) // extracting the data
    let start_children: [[String]] = try container.decode([[String]].self, forKey: .start_children) // extracting the data
    let children: [[String]] = try container.decode([[String]].self, forKey: .children) // extracting the data
    let parents: [[String]] = try container.decode([[String]].self, forKey: .parents) // extracting the data
    let nexts: [[String]] = try container.decode([[String]].self, forKey: .nexts) // extracting the data
    let function_name: String = try container.decode(String.self, forKey: .function_name) // extracting the data
    let data: [String: String] = try container.decode([String: String].self, forKey: .data) // extracting the data

    //self.init(fullName: fullName, id: id, twitter: twitter) // initializing our struct
    self.init(name:                  name,
         nexts:                 nexts,
         start_children:        start_children,
         children:              children,

         function_name:         function_name,
         data:                  data,
         parents:               parents)
  }
    
}
extension x: Decodable {
  enum MyStructKeys: String, CodingKey { // declaring our keys
    case name =           "name"
    case start_children = "start_children"
    case children =       "children"
    case parents =        "parents"
    case nexts =          "nexts"
    case function_name =  "function_name"
    case data =           "data"
  }
}

class Data {
    
    var data:           [String: Any]
    var is_dict:        Bool
    var is_array:       Bool
    func Print()
    {
        //print(data)
        if(getBool2() != "no bool value")
        {
            print("Bool", self.data["Bool"]!)
        }
        else if(getInt() != -123)
        {
            print("Int", self.data["Int"]!)
        }
        else if(getFloat() != -87654321.876543)
        {
            print("Float", self.data["Float"]!)
        }
        else if(getString() != "no String type is here")
        {
            if(self.data["String"]! as? String == "")
            {
                print("String", "\"\"")
            }
            else
            {
                print("String", self.data["String"]!)
            }
        }
        else if(getStringList() != ["no [String] type is here"])
        {
            print("[String]", self.data["[String]"]!)
        }
        else if(Point.init(l: -1, s: -1) != Point.init(l: -1, s: -1))
        {
            print("Point", self.data["Point"]!)
        }
        else if(self.data["[Bool]"] != nil)
        {
            print("[Bool]", self.data["[Bool]"]!)
        }
        else if(self.data["[String]"] != nil)
        {
            print("[String]", self.data["[String]"]!)
        }
        else if(self.data["[Int]"] != nil)
        {
            print("[Int]", self.data["[Int]"]!)
        }
        else if(self.data["[Float]"] != nil)
        {
            print("[Float]", self.data["[Float]"]!)
        }
        // printing all dicts
        else if(self.data.keys.count > 0)
        {
            let x: String = self.data.keys[self.data.keys.startIndex]
            print(x, self.data[x]!)

        }
       //["[String]"]
//self.data["[Bool]"]// = value
//["[Int]"]// = value
//["[Float]"]
        /*
        else if(is_dict)
        {
            print("Dictionary", self.data["Dictionary"]!)
        }
        else if(is_array)
        {
            print("Array", self.data["Array"]!)
        }*/
        else
        {
            print("[:]")
        }
        
    }
    func returnTrue(current_state_name: [String]) -> Bool
    {
        return true
    }
    init(new_data: [String: Any])
    {
        self.data = new_data
        self.is_dict = false
        self.is_array = false
    }
    init(new_data: [String: Any], container_type: String)
    {
        self.data = new_data
        self.is_array = false
        self.is_dict = false

        if(container_type == "Array")
        {
            self.is_array = true
        }
        else if(container_type == "Dictionary")
        {
            self.is_dict = true
        }
    }
    func getBool2() -> String
    {
        let bool = self.data["Bool"] as? Bool
        if(bool != nil)
        {
            return String(bool!)
        }

        return "no bool value"

    }
    func getBool() -> Bool
    {
        let bool = self.data["Bool"] as? Bool
        if(bool != nil)
        {
            return bool!
        }

        return false

    }

    func getInt() -> Int
    {
        let int = self.data["Int"] as? Int
        if(int != nil)
        {
            return int!
        }

        return -123
        
    }
    func getFloat() -> Float
    {
        let float = self.data["Float"] as? Float
        if(float != nil)
        {
            return float!
        }
        return -87654321.876543
    }
    // there should only be 1 value in [String: Any] per state
    func getString() -> String
    {
        let string = self.data["String"] as? String
        if(string != nil)
        {
            return string!
        }

        return "no String type is here"
    }
    func getStringList() -> [String]
    {
        let string_list = self.data["[String]"] as? [String]
        if(string_list != nil)
        {
            return string_list!
        }

        return ["no [String] type is here"]
    }
    func getPoint() -> Point
    {
        let point = self.data["Point"] as? Point
        if(point != nil)
        {
            return point!
        }

        return Point.init(l: -1, s: -1)

    }
    func getPointFromStringListToPointEntry(key: [String]) -> Point
    {
        var entry = self.data["[[String]: Point]"] as? [[String]: Point]
        if(entry != nil)
        {
            if(entry![key] != nil)
            {
                return entry![key]!

            }
        }
        return Point.init(l: -1, s: -1)
    }
    func getContextStateFromPointToContextState(key: Point) -> ContextState
    {
        var entry = self.data["[Point: ContextState]"] as? [Point: ContextState]
        if(entry != nil)
        {
            if(entry![key] != nil)
            {
                return entry![key]!

            }
        }
        return ContextState.init(name: ["nil"], function: returnTrue(current_state_name: parser: stack:))
    }
    func setBool(value: Bool)
    {
        self.data["Bool"] = value
    }
    func setInt(value: Int)
    {
        self.data["Int"] = value
    }
    func setFloat(value: Float)
    {
        self.data["Float"] = value
    }
    func setString(value: String)
    {
        self.data["String"] = value
    }
    func setStringList(value: [String])
    {
        self.data["[String]"] = value
    }
    func setBoolList(value: [Bool])
    {
        self.data["[Bool]"] = value
    }
    func setIntList(value: [Int])
    {
        self.data["[Int]"] = value
    }
    func setFloatList(value: [Float])
    {
        self.data["[Float]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [Bool: Bool])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [Bool: Int])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [Bool: Float])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [Bool: String])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [Int: Bool])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [Int: Int])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [Int: Float])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [Int: String])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [Float: Bool])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [Float: Int])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [Float: Float])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [Float: String])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [String: Bool])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [String: Int])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setDict(key_0: String, key_1: String, value: [String: Float])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
     func setDict(key_0: String, key_1: String, value: [String: String])
    {
        self.data["[" + key_0 + ": " + key_1 + "]"] = value
    }
    func setNil()
    {
        self.data["Nil"] = nil
    }
    func appendString(value: String)
    {
        var string_list = self.data["[String]"] as! [String]
        //print(value)
        string_list.append(value)
        //print(string_list)
        self.data["[String]"] = string_list
    }
    func setPoint(value: Point)
    {
        self.data["Point"] = value
    }

    func setStringListToPointEntry(key: [String], value: Point)
    {
        var dict = (self.data["[[String]: Point]"] as! [[String]: Point])
        dict[key] = value
        self.data["[[String]: Point]"] = dict
    }
    func setPointToContextState(key: Point, value: ContextState)
    {
        var dict = (self.data["[Point: ContextState]"] as! [Point: ContextState])
        dict[key] = value
        self.data["[Point: ContextState]"] = dict

    }
}


class ContextState {

    var name:           [String]
    
    var start_children: [[String]]
    var children:       [[String]]
    var parents:        [[String]]
    
    
    var nexts:          [[String]]
    //name_state_table:
    var function:       ([String], inout Parser, ChildParent) -> Bool
    
    var function_name:  String
    
    // this should only have 1 entry as each state also can stand in as a single variable(digit, string, array, custom class)
    var data:           Data
    
    var iteration_number: Int
    /*required init(from decoder: Decoder) throws {
        //let container = try decoder.container(keyedBy: CodingKey.self)
          //  self.alcohol_content = try container.decode(String.self, forKey: .alcohol_content)
            //try super.init(from: decoder)
        let name:                  [String]
         let nexts:                 [[String]]
         let start_children:        [[String]]
         let function_name:         String
         let data:                  [String: Any]
         let parents:               [[String]]
        }
    */
    init()
    {
        self.name           =   [String]()
        self.nexts          =   [[String]]()
        self.start_children =   [[String]]()
        self.children       =   [[String]]()
        self.function       =   returnTrue(current_state_name:parser:stack:)
        self.function_name  =   String()
        self.data           =   Data.init(new_data:[:])
        self.parents        =   [[String]]()
        self.iteration_number = Int()
    }
    init(name:                  [String],
         nexts:                 [[String]],
         start_children:        [[String]],
         function: @escaping    ([String], inout Parser, ChildParent) -> Bool,
         function_name:         String,
         data:                  Data,
         parents:               [[String]])
    {
        self.name           =   name
        self.nexts          =   nexts
        self.start_children =   start_children
        self.children       =   []
        self.function       =   function
        self.function_name  =   function_name
        self.data           =   data
        self.parents        =   parents
        self.iteration_number = Int()

    }
    init(name:                  [String],
         nexts:                 [[String]],
         start_children:        [[String]],
         children:              [[String]],
         function: @escaping    ([String], inout Parser, ChildParent) -> Bool,
         function_name:         String,
         data:                  Data,
         parents:               [[String]])
    {
        self.name           =   name
        self.nexts          =   nexts
        self.start_children =   start_children
        self.children       =   children
        self.function       =   function
        self.function_name  =   function_name
        self.data           =   data
        self.parents        =   parents
        self.iteration_number = Int()

    }
    init(name:                  [String],
         nexts:                 [[String]],
         start_children:        [[String]],
         children:              [[String]],
         function_name:         String,
         data:                  Data,
         parents:               [[String]])
    {
        self.name           =   name
        self.nexts          =   nexts
        self.start_children =   start_children
        self.children       =   children
        self.function       =   returnTrue
        self.function_name  =   function_name
        self.data           =   data
        self.parents        =   parents
        self.iteration_number = Int()

    }
    init(name: [String], function: @escaping ([String], inout Parser, ChildParent) -> Bool)
    {
        self.name = name
        self.nexts          =   []
        self.start_children =   []
        self.children       =   []
        self.function       =   function
        self.function_name  =   ""
        self.data           =   Data.init(new_data: [:])
        self.parents        =   []
        self.iteration_number = Int()
    }
    func appendStartChild(start_child: [String])
    {
        self.start_children.append(start_child)
    }
    func appendChild(child: [String])
    {
        self.children.append(child)
    }
    func setParents(parents: [[String]])
    {
        self.parents = parents
    }
    func appendNextChild(next_child: [String])
    {
        self.nexts.append(next_child)
    }
    func setFunctionName(function_name: String)
    {
        self.function_name = function_name
    }
    func makeIndentString(indent_level: Int) -> String
    {
        var indent_string: String = String()
        var indent = indent_level
        while(indent > 0)
        {
            indent_string.append(" ")
            indent -= 1
        }
        return indent_string
    }
    func Print(indent_level: Int)
    {
        let indent_string = makeIndentString(indent_level: indent_level)
        
        print(indent_string, "name:")
        print(indent_string, self.name)
        print(indent_string, "nexts:")
        print(indent_string, self.nexts)
        print(indent_string, "start children:")
        print(indent_string, self.start_children)
        print(indent_string, "children:")
        print(indent_string, self.children)
        
        print(indent_string, "parents:")
        print(indent_string, self.parents)

        print(indent_string, "function name:")
        print(indent_string, self.function_name)
        print(indent_string, "data:")
        print(indent_string)
        self.data.Print()

        print(indent_string, "iteration number:")
        print(indent_string, self.iteration_number)
    }
    func getIterationNumber() -> Int
    {
        return self.iteration_number
    }
    func getName() -> [String]
    {
        return self.name
    }
    func getStartChildren() -> [[String]]
    {
        return self.start_children
    }
    func getChildren() -> [[String]]
    {
        return self.children
    }
    func getParents() -> [[String]]
    {
        return self.parents
    }
    func getNexts() -> [[String]]
    {
        return self.nexts
    }
    func callFunction(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
    {
        return self.function(current_state_name, &parser, stack)
    }
    func getFunctionName() -> String
    {
        return self.function_name
    }
    func getData() -> Data
    {
        return self.data
    }
    func setData(data: Int)
    {
        self.data.setInt(value: data)
    }
    func setData(data: String)
    {
        self.data.setString(value: data)
    }
    
    func advanceIterationNumber()
    {
        self.iteration_number += 1
    }
    
}


extension ContextState: Equatable {
  static func == (lhs: ContextState, rhs: ContextState) -> Bool {
    return lhs.name == rhs.name &&
      lhs.nexts == rhs.nexts &&
      lhs.start_children == rhs.start_children &&
      lhs.children == rhs.children &&
      lhs.function_name == rhs.function_name &&
      //lhs.data == rhs.data &&
      lhs.parents == rhs.parents &&
      lhs.iteration_number == rhs.iteration_number
    
    }
}



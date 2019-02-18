//
//  point.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/18/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class Point {

    var level_id: Int
    var state_id: Int
    
    init(l: Int, s: Int)
    {
        self.level_id = l
        self.state_id = s
    }
    func Print()
    {
        print(self.level_id)
        print(self.state_id)
    }
    func getLevelId() -> Int
    {
        return self.level_id
    }
    func getStateId() -> Int
    {
        return self.state_id
    }
    
}
extension Point: Equatable {
  static func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.level_id == rhs.level_id &&
      lhs.state_id == rhs.state_id
    
    }
}

extension Point: Hashable {
  var hashValue: Int {
    return level_id.hashValue ^ state_id.hashValue
  }
}


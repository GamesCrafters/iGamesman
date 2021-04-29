//
//  Move.swift
//  iGamesman
//
//  Created by Sina Dalir on 4/9/21.
//

import Foundation


struct MovesResponse: Codable {
    var response: Moves
    var status: String
 
}

struct Moves: Codable {
    var moves: [Move]
    var position: String
    var positionValue: String
    var remoteness: Int
 
}

struct Move: Codable  {
    
    var deltaRemoteness: Int
    var move: String
    var moveValue: String
    var position: String
    var positionValue: String
    var remoteness: Int
}




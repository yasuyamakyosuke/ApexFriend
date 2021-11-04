//
//  Message.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/11/04.
//

import Foundation
import Firebase

struct Message {
    let id:String!
    let selectMode:String!
    let selectNumber:String!
    let selectPlatform:String!
    let selectFirstChara:String!
    let selectSecondChara:String!
    let time:String?
    let title:String!
    let userID:String!
    let vc:String?
    let createdAt:Timestamp!
}


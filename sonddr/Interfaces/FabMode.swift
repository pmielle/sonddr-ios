//
//  FabMode.swift
//  sonddr
//
//  Created by Paul Mielle on 09/12/2022.
//

import SwiftUI

enum FabMode: Equatable {
    case Add(goal: Goal? = nil)
    case Rate
}

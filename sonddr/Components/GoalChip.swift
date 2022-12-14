//
//  GoalChip.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

struct GoalChip: View {
    
    // attributes
    // ------------------------------------------
    let goal: Goal

    
    // body
    // ------------------------------------------
    var body: some View {
        Label(self.goal.name, systemImage: self.goal.icon)
            .myLabel(color: self.goal.color)
            .foregroundColor(.white)
    }
}

struct GoalChip_Previews: PreviewProvider {
    static var previews: some View {
        GoalChip(goal: dummyGoal())
    }
}

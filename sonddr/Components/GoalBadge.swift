//
//  GoalBadge.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct GoalBadge: View {
    let goal: Goal
    
    var body: some View {
        Circle()
            .fill(self.goal.color)
            .frame(height: goalChipHeight)
            .overlay {
                Image(systemName: self.goal.icon)
            }
    }
}

struct GoalBadge_Previews: PreviewProvider {
    static var previews: some View {
        GoalBadge(goal: dummyGoal())
    }
}

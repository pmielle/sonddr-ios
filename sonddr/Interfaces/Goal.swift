//
//  Goal.swift
//  sonddr
//
//  Created by Paul Mielle on 13/11/2022.
//

import SwiftUI

struct Goal: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let icon: String  // SF symbol
    let color: Color
    let darkerColor: Color
}

func dummyGoal() -> Goal {
    Goal(
        id: randomId(),
        name: "Dummy Goal",
        icon: "bolt.fill",
        color: .orange,
        darkerColor: .red
    )
}

let noPoverty = Goal(id: randomId(), name: "No poverty", icon: "house.fill", color: Color("PinkGoalColor"), darkerColor: Color("DarkerPinkGoalColor"))
let healthAndWellBeing = Goal(id: randomId(), name: "Health and well being", icon: "cross.fill", color: Color("RedGoalColor"), darkerColor: Color("DarkerRedGoalColor"))
let reducedInequalities = Goal(id: randomId(), name: "Reduced inequalities", icon: "figure.2.arms.open", color: Color("OrangeGoalColor"), darkerColor: Color("DarkerOrangeGoalColor"))
let sustainability = Goal(id: randomId(), name: "Sustainability", icon: "infinity", color: Color("YellowGoalColor"), darkerColor: Color("DarkerYellowGoalColor"))
let preservedEcosystems = Goal(id: randomId(), name: "Preserved ecosystems", icon: "leaf.fill", color: Color("GreenGoalColor"), darkerColor: Color("DarkerGreenGoalColor"))
let peaceAndJustice = Goal(id: randomId(), name: "Peace and justice", icon: "bird.fill", color: Color("CyanGoalColor"), darkerColor: Color("DarkerCyanGoalColor"))
let decentWork = Goal(id: randomId(), name: "Decent work", icon: "briefcase.fill", color: Color("BlueGoalColor"), darkerColor: Color("DarkerBlueGoalColor"))
let qualityEducation = Goal(id: randomId(), name: "Quality education", icon: "graduationcap.fill", color: Color("PurpleGoalColor"), darkerColor: Color("DarkerPurpleGoalColor"))

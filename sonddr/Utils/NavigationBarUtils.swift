//
//  NavigationBarUtils.swift
//  sonddr
//
//  Created by Paul Mielle on 03/12/2022.
//

import SwiftUI

func setNavigationBarColor(color: Color) {
    let coloredNavAppearance = UINavigationBarAppearance()
    coloredNavAppearance.configureWithOpaqueBackground()
    coloredNavAppearance.backgroundColor = UIColor(color)
    coloredNavAppearance.shadowColor = .clear
    UINavigationBar.appearance().standardAppearance = coloredNavAppearance
    UINavigationBar.appearance().compactAppearance = coloredNavAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    UINavigationBar.appearance().compactScrollEdgeAppearance = coloredNavAppearance
}

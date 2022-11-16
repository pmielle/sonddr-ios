//
//  MyBackground.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct MyBackground: View {
    var body: some View {
        myBackgroundColor
            .ignoresSafeArea()
    }
}

struct MyBackground_Previews: PreviewProvider {
    static var previews: some View {
        MyBackground()
    }
}

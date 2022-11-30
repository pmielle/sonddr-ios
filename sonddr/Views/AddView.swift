//
//  AddView.swift
//  sonddr
//
//  Created by Paul Mielle on 30/11/2022.
//

import SwiftUI

struct AddView: View {

    // attributes
    // ------------------------------------------
    @Binding var isPresented: Bool
    let preselectedGoal: Goal?
    
    
    // body
    // ------------------------------------------
    var body: some View {
        NavigationStack {
            ZStack() { MyBackground()
                
                Text("preselected goal: \(preselectedGoal?.name ?? "nil")")
                
            }
            .toolbar {
                self.toolbar()
            }
            .navigationTitle("Share an idea")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    // subviews
    // ------------------------------------------
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "xmark")
                .onTapGesture {
                    self.isPresented = false
                }
        }
    }
    
    
    // methods
    // ------------------------------------------
    // ...
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(isPresented: .constant(true), preselectedGoal: nil)
    }
}

//
//  DatabaseService.swift
//  sonddr
//
//  Created by Paul Mielle on 27/11/2022.
//

import SwiftUI

class DatabaseService: ObservableObject {
    
    // attributes
    // ------------------------------------------
    let testMode: Bool
    var loggedInUserToken: String? = nil
    @Published var goals: [Goal]? = nil
    
    
    // constructor
    // ------------------------------------------
    init(testMode: Bool = false) {
        self.testMode = testMode
    }
    
    
    // methods
    // ------------------------------------------
    func getUser() -> User {
        return dummyUser()
    }
    
    func cacheGoals() {
        self.goals = self.getGoals()
    }
    
    func getGoals() ->[Goal] {
        return [dummyGoal(), dummyGoal()]
    }
    
    func getIdeas() -> [Idea] {
        return [dummyIdea(), dummyIdea()]
    }
}

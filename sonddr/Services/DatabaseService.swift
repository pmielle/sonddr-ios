//
//  DatabaseService.swift
//  sonddr
//
//  Created by Paul Mielle on 27/11/2022.
//

import SwiftUI

@MainActor
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
        if (testMode) {
            self.goals = [dummyGoal(), dummyGoal()]
        }
    }
    
    
    // methods
    // ------------------------------------------
    func postIdea(idea: Idea) async throws {
        await sleep(seconds: 0.1)
        return
    }
    
    func getUser() async throws -> User {
        await sleep(seconds: 0.1)
        return dummyUser()
    }
    
    func cacheGoals() async throws {
        await sleep(seconds: 0.1)
        self.goals = try await self.getGoals()
    }
    
    func getGoals() async throws ->[Goal] {
        await sleep(seconds: 0.1)
        return [dummyGoal(), dummyGoal()]
    }
    
    func getIdeas() async throws -> [Idea] {
        await sleep(seconds: 0.1)
        return [dummyIdea(), dummyIdea()]
    }
    
    func getNotifications(user: User) async throws -> [MyNotification] {
        await sleep(seconds: 0.1)
        return [dummyNotification(), dummyNotification()]
    }
    
    func getDiscussions(user: User) async throws -> [Discussion] {
        await sleep(seconds: 0.1)
        return [dummyDiscussion(), dummyDiscussion()]
    }
}

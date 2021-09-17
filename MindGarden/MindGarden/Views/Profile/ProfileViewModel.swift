//
//  ProfileViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 8/31/21.
//

import Swift
import Combine
import Firebase
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var signUpDate: String = ""
    @Published var totalMins: Int = 0
    @Published var totalSessions: Int = 0
    @Published var name: String = ""
    var userModel: UserViewModel
    var gardenModel: GardenViewModel

    init(userModel: UserViewModel, gardenModel: GardenViewModel) {
        self.userModel = userModel
        self.gardenModel = gardenModel
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        self.signUpDate = userModel.joinDate
        self.name = userModel.name
        self.totalMins = gardenModel.allTimeMinutes
        self.totalSessions = gardenModel.allTimeSessions
    }

    func signOut() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
    }
}

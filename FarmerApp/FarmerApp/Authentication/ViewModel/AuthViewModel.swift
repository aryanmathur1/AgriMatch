//
//  AuthViewModel.swift
//  FarmerApp
//
//  Created by vibhun naredla on 3/22/25.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit
import SwiftUI
import FirebaseAuth

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }

    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user

            let userData: [String: Any] = [
                "id": result.user.uid,
                "fullname": fullname,
                "email": email,
                
            ]

            try await Firestore.firestore().collection("users").document(result.user.uid).setData(userData)
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil // need to reset data from old user to new user
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }

    func deleteAccount() {
        print("Delete account")
    }

    func resetPreferences() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // Delete all accepted plants
        let acceptedRef = db.collection("users").document(uid).collection("acceptedPlants")
        acceptedRef.getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                for document in documents {
                    acceptedRef.document(document.documentID).delete()
                }
            }
        }
        
        // Delete all rejected plants
        let rejectedRef = db.collection("users").document(uid).collection("rejectedPlants")
        rejectedRef.getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                for document in documents {
                    rejectedRef.document(document.documentID).delete()
                }
            }
        }
    }
    
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()

            if let data = snapshot.data() {
                let user = User(
                    id: data["id"] as? String ?? "",
                    fullname: data["fullname"] as? String ?? "",
                    email: data["email"] as? String ?? ""
                )
                self.currentUser = user
                print("DEBUG: Successfully fetched user: \(user)")
            } else {
                print("DEBUG: No user document found")
            }
        } catch {
            print("DEBUG: Failed to fetch user with error \(error.localizedDescription)")
        }
    }
    
    func savePlant(plant: PlantCard, to collection: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uid)
            .collection(collection)
            .addDocument(data: [
                "plantName": plant.plantName,
                "imageURL": plant.imageURL,
                "timestamp": Timestamp()
            ]) { error in
                if let error = error {
                    print("DEBUG: Failed to save plant: \(error.localizedDescription)")
                } else {
                    print("DEBUG: Successfully saved plant to \(collection)")
                }
            }
    }


    
}

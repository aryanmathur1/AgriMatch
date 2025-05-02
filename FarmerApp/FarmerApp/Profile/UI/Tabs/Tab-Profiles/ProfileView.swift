//
//  ProfileView.swift
//  Shopping
//
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                if let user = viewModel.currentUser {
                    // User Info Section
                    Section {
                        HStack(spacing: 16) {
                            Text(user.initials)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 64, height: 64)
                                .background(Color("AgriGreen"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Account Actions
                    Section("Account") {
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRow(
                                imageName: "arrow.left.circle.fill",
                                title: "Sign Out",
                                tintColor: .red
                            )
                        }
                        
                        Button {
                            viewModel.deleteAccount()
                        } label: {
                            SettingsRow(
                                imageName: "xmark.circle.fill",
                                title: "Delete Account",
                                tintColor: .red
                            )
                        }
                        Button {
                            viewModel.resetPreferences()
                            } label: {
                                SettingsRow(
                                    imageName: "arrow.counterclockwise.circle.fill",
                                    title: "Reset Preferences",
                                    tintColor: .orange
                                )
                            }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("AgriCream").opacity(0.15))
            .navigationTitle("Profile")
        }
    }
}


#Preview {
    ProfileView()
}

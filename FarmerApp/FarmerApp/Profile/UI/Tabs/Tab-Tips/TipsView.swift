//
//  TipsView.swift
//  FarmerApp
//
//  Created by vibhun naredla on 4/27/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TipsView: View {
    private var tipOfTheDay: Tip = dailyTip
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Tip of the Day")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(tipOfTheDay.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(tipOfTheDay.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("AgriCream").opacity(0.3))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding()
            }
            .frame(alignment: .top)
            //.navigationTitle("Tips")
            //.background(Color("AgriCream").opacity(0.1))
        }
    }
}

#Preview {
    TipsView()
}

struct TitleView: View {
    
    //MARK: - Properties
    let title: String
    
    //MARK: - Initializes
    
    //MARK: - Contents
    var body: some View {
        VStack(spacing: 20.0) {
            Text("\(title) ")
                .font(.montExtraBold(size: 40.0))
            +
            Text("screen")
                .font(.montExtraBold(size: 40.0))
                .foregroundStyle(.blue)
            
            Text("FOLLOW")
                .font(.montExtraBold(size: 40.0))
                .foregroundStyle(.purple)
                .underline(true, color: .purple)
            +
            Text(" ME")
                .font(.montExtraBold(size: 40.0))
        }
    }
}


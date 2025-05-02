//
//  SettingsRow.swift
//  FarmerApp
//
//  Created by vibhun naredla on 3/22/25.
//

import SwiftUI

struct SettingsRow: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(tintColor)
                    .frame(width: 36, height: 36)
                
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color("AgriCream"))
        }
        .padding(.vertical, 6)
    }
}

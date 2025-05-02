//
//  GetHeightModifier.swift
//  Shopping
//
//

import SwiftUI

struct GetHeightModifier: ViewModifier {
    
    @Binding var height: CGFloat
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry -> Color in
                DispatchQueue.main.async {
                    self.height = geometry.size.height
                }
                
                return Color.clear
            }
        )
    }
}

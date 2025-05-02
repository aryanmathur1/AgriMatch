//
//  HideTabView.swift
//  Shopping
//
//

import SwiftUI

struct HideTabView: UIViewRepresentable {
    
    //MARK: - Properties
    var result: () -> ()
    
    //MARK: - Make UI
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        
        DispatchQueue.main.async {
            if let tabBarController = view.tabController {
                tabBarController.tabBar.isHidden = true
                result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

//
//  Types.swift
//  Shopping
//
//

import SwiftUI

var screenWidth: CGFloat {
    UIApplication.shared.screenWidth
}

var screenHeight: CGFloat {
    UIApplication.shared.screenHeight
}

var currentScene: UIScreen {
    UIApplication.shared.current
}

var keyWindow: UIWindow {
    UIApplication.shared.keyWindow
}

var topPadding: CGFloat {
    UIApplication.shared.topPadding
}

var bottomPadding: CGFloat {
    UIApplication.shared.bottomPadding
}

//Dưới cùng của Tab Bar
var spaceBottom: CGFloat {
    let v1 = screenWidth * (15/315)
    let v2 = screenWidth * (200/1000)
    return v1 + v2
}

func delay(dr: TimeInterval, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + dr, execute: completion)
}

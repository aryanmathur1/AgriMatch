//
//  Font+Ext.swift
//  Shopping
//
//

import SwiftUI

extension Font {
    
    static func montBold(size: CGFloat) -> Font {
        .custom(FontName.montBold, size: size)
    }
    
    static func montExtraBold(size: CGFloat) -> Font {
        .custom(FontName.montExtraBold, size: size)
    }
    
    static func montLight(size: CGFloat) -> Font {
        .custom(FontName.montLight, size: size)
    }
    
    static func montMedium(size: CGFloat) -> Font {
        .custom(FontName.montMedium, size: size)
    }
    
    static func montMediumItalic(size: CGFloat) -> Font {
        .custom(FontName.montMediumItalic, size: size)
    }
    
    static func montRegular(size: CGFloat) -> Font {
        .custom(FontName.montRegular, size: size)
    }
    
    static func montSemiBold(size: CGFloat) -> Font {
        .custom(FontName.montSemiBold, size: size)
    }
}

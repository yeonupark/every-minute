//
//  Color.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/07.
//

import Foundation
import SwiftUI

enum ColorSet {
    
    enum Brand {
        static let green = Color("Green")
        static let error = Color("Error")
        static let inactive = Color("Inactive")
        static let gray = Color("Gray")
        static let white = Color("White")
        static let black = Color("Black")
    }
    
    enum Text {
        static let primary = Color("PrimaryTX")
        static let secondary = Color("SecondaryTX")
    }
    
    enum Background {
        static let primary = Color("PrimaryBG")
        static let secondary = Color("White")
    }
    
    enum View {
        static let separator = Color("Separator")
        static let alpha = Color("Black").opacity(0.5)
    }
}

struct FontSet {
    let font: UIFont
    let lineHeight: CGFloat
}

enum Typography {
    static let title1 = FontSet(font: UIFont.boldSystemFont(ofSize: 22), lineHeight: 30)
}


struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}

extension View {
    func fontWithLineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: font, lineHeight: lineHeight))
    }
}

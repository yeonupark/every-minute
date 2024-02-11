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
        static let orange = Color("Orange")
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
    static let title1 = FontSet(font: UIFont.systemFont(ofSize: 22, weight: .bold), lineHeight: 30)
    static let title2 = FontSet(font: UIFont.systemFont(ofSize: 14, weight: .bold), lineHeight: 20)
    static let bodyBold = FontSet(font: UIFont.systemFont(ofSize: 13, weight: .bold), lineHeight: 18)
    static let bodyRegular = FontSet(font: UIFont.systemFont(ofSize: 13, weight: .regular), lineHeight: 18)
    static let caption = FontSet(font: UIFont.systemFont(ofSize: 12, weight: .regular), lineHeight: 18)
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

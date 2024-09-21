//
//  open_close_animation.swift
//  SDU App
//
//  Created by Nurkhat on 16.09.2024.
//

import Foundation
import SwiftUI

// Простой эффект анимации "водопад"
struct WaterfallTransition: ViewModifier {
    let isExpanded: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isExpanded ? 1 : 0) // Плавная смена прозрачности
            .offset(y: isExpanded ? 0 : -10) // Сдвиг вверх/вниз
    }
}

extension AnyTransition {
    static var waterfallTransition: AnyTransition {
        AnyTransition.modifier(
            active: WaterfallTransition(isExpanded: false),
            identity: WaterfallTransition(isExpanded: true)
        )
    }
}

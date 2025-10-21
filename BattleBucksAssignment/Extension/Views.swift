//
//  Views.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 21/10/25.
//

import Foundation
import SwiftUI

// MARK: - Shimmer Extension
extension View {
    func shimmer(isAnimating: Bool = true) -> some View {
        self.modifier(ShimmerModifier(isAnimating: isAnimating))
    }
}

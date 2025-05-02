//
//  SectionRectangle.swift
//  TasksDiary
//
//  Created by Макс Понизов on 29.03.2025.
//

import SwiftUI

///Custom modifier for task description views
struct SectionRectangle: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke()
                    .fill(color)
            }
            .padding(.horizontal)
    }
}

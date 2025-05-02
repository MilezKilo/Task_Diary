//
//  Greetings.swift
//  TasksDiary
//
//  Created by Макс Понизов on 12.03.2025.
//

import SwiftUI

struct Greetings: View {
    
    //MARK: - PROPERTIES
    //This property will turn off to false after 3.5 seconds
    @Binding var showScreen: Bool
    
    //plane image animation properties
    @State private var planeOffset: CGFloat = -100
    @State private var animationStages: Int = 0
    
    //MARK: - BODY
    var body: some View {
        VStack {
            plane_section
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.default) {
                    self.showScreen = false
                }
            }
        }
    }
}

//MARK: - VIEW EXTENSION
extension Greetings {
    private var plane_section: some View {
        ZStack {
            Text("Welcome!")
                .font(.custom("BubbleSans-Regular", size: 24))
                .transition(.opacity)
                .opacity(animationStages >= 3 ? 100 : 0)
            
            Image("plane")
                .resizable()
                .frame(width: 75, height: 100)
                .offset(x: animationStages >= 1 ? 100 : -100)
                .opacity(animationStages >= 2 ? 0 : 100)
                .task {
                    withAnimation(.easeIn(duration: 1)) {
                        self.animationStages += 1
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
                        withAnimation(.default) { self.animationStages += 1 }
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                        withAnimation(.easeIn(duration: 10)) { self.animationStages += 1 }
                    }
                }
        }
    }
}


//MARK: - PREVIEW
struct Greetings_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            Greetings(showScreen: .constant(true))
                .preferredColorScheme(.light)
            
            Greetings(showScreen: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}

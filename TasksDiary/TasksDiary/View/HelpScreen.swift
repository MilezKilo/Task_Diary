//
//  HelpScreen.swift
//  TasksDiary
//
//  Created by Макс Понизов on 29.03.2025.
//

import SwiftUI

struct HelpScreen: View {
    
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            header
                .padding([.horizontal, .bottom])
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .light ? Color.blue : Color.blue.opacity(0.75))
                        .ignoresSafeArea()
                }
                .padding(.bottom)
            
            helpSection
                .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}


//MARK: - VIEW EXTENSION
extension HelpScreen {
    private var header: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
                Spacer()
            }
            
            HStack {
                Text("Help")
                    .font(.title)
                    .bold()
                Spacer()
            }
        }
    }
    private var helpSection: some View {
        VStack(spacing: 30) {
            HStack {
                Image(systemName: "hand.rays.fill")
                    .font(.system(size: 45))
                Text("A single tap opens detailed information about the task.")
                Spacer()
            }
            
            HStack {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 50))
                Text("A long tap will delete current task from database.")
                Spacer()
            }
        }
    }
}

//MARK: - PREVIEW
struct HelpScreen_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            HelpScreen()
                .preferredColorScheme(.light)
            HelpScreen()
                .preferredColorScheme(.dark)
        }
    }
}

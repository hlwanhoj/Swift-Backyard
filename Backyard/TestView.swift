//
//  TestView.swift
//  Backyard
//
//  Created by Ho Lun Wan on 13/6/2025.
//

import SwiftUI

struct TestView: View {
    private let textToMatch = "Some books are to be tasted, others to be swallowed, and some few to be chewed and digested."
    @State private var textInput: String = ""
    var body: some View {
        List {
            TextField("Text Input", text: $textInput)
            Label("Text to Match: \(textToMatch)", systemImage: "textformat")
                
            Text(textToMatch)
        }
    }
}

#Preview {
    NavigationStack {
        TestView()
    }
}

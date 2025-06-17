//
//  CustomLayout01View.swift
//  Backyard
//
//  Created by Ho Lun Wan on 12/6/2025.
//

import SwiftUI
import UIKit

struct CustomLayout01View: View {
    var body: some View {
        VStack {
            Text("A layout which items will snap to the left edge of the collection view, and the snapped item will be expanded to reveal its content.")
                .themeFont(.body)
                .padding(13)
            CL01ViewControllerRepresentable()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle("Custom Layout 1")
    }
}

struct CL01ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CL01ViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        CL01ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

#Preview {
    NavigationStack {
        CustomLayout01View()
    }
}

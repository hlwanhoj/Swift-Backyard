//
//  AlertToastModifier.swift
//  Backyard
//
//  Created by Ho Lun Wan on 12/6/2025.
//

import SwiftUI

struct AlertToastModifier<V>: ViewModifier where V : View {
    @Binding var isShowing: Bool
    let alert: () -> V
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack(alignment: .center) {
                    if isShowing {
                        alert()
                            .transition(.asymmetric(
                                insertion: .scale,
                                removal: .opacity))
                            .onAppear {
                                disappearAfterDelay()
                            }
                    }
                }
                .animation(Animation.spring(duration: 0.25, bounce: 0.333), value: isShowing)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
            // In case the view is dismissing by animation but it is set to be shown again, trigger the disappearance once more
            .onChange(of: isShowing) { oldValue, newValue in
                if oldValue != newValue && newValue {
                    disappearAfterDelay()
                }
            }
    }
    
    private func disappearAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowing = false
        }
    }
}

extension View {
    func alertToast<V>(isShowing: Binding<Bool>, @ViewBuilder alert: @escaping () -> V) -> some View where V : View {
        modifier(AlertToastModifier(isShowing: isShowing, alert: alert))
    }
}

//
//  SystemMaterialView.swift
//  Backyard
//
//  Created by Ho Lun Wan on 18/6/2025.
//

import SwiftUI

private struct MaterialInfo: Identifiable {
    let name: String
    let material: Material
    
    var id: String { name }
}

struct SystemMaterialView: View {
    @State private var isSettingsPresented = false
    @State private var backgroundViewKind: SystemMaterialBackgroundView.Kind = .blackAndWhite
    
    private let materials: [MaterialInfo] = [
        MaterialInfo(name: "Ultra Thin", material: .ultraThin),
        MaterialInfo(name: "Thin", material: .thin),
        MaterialInfo(name: "Regular", material: .regular),
        MaterialInfo(name: "Thick", material: .thick),
        MaterialInfo(name: "Ultra Thick", material: .ultraThick),
    ]
    
    var body: some View {
        ZStack {
            SystemMaterialBackgroundView(kind: $backgroundViewKind)
            VStack(spacing: 36) {
                ForEach(materials) { material in
                    VStack {
                        Text(material.name)
                            .themeFont(.footnote)
                            .foregroundStyle(.ultraThinMaterial)
                            .shadow(color: .white, radius: 0, x: 1, y: 1)
                        HStack {
                            ForEach(0..<2) { i in
                                Label("Flag", systemImage: "flag.fill")
                                    .themeFont(.body)
                                    .padding()
                                    .background(material.material)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Material")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isSettingsPresented.toggle()
                }) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $isSettingsPresented) {
            List {
                HStack {
                    Picker("Background", selection: $backgroundViewKind) {
                        Text("Black and White")
                            .tag(SystemMaterialBackgroundView.Kind.blackAndWhite)
                        Text("Random Colors")
                            .tag(SystemMaterialBackgroundView.Kind.randomColors)
                    }
                    .pickerStyle(.menu)
                }
            }
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .presentationDetents([.fraction(0.25)])
            .presentationDragIndicator(.visible)
            .presentationBackground(.thinMaterial)
        }
    }
}

private struct SystemMaterialBackgroundView: View {
    enum Kind: Int {
        case blackAndWhite
        case randomColors
    }
    
    @Binding var kind: Kind
    
    var body: some View {
        switch kind {
        case .blackAndWhite:
            HStack(spacing: 0) {
                Color.black
                Color(hue: 0, saturation: 0, brightness: 1, opacity: 1)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        case .randomColors:
            AnimatingRandomColorsView()
        }
    }
}

private struct AnimatingRandomColorsView: View {
    @State private var currentColor: Color = .random // Initial random color
    
    // Timer to trigger color changes
    // Using an optional Timer so we can invalidate it easily
    @State private var timer: Timer?

    // Configuration for the animation
    let animationDuration: Double = 1.0 // How long each color transition takes
    let changeInterval: Double = 1.5   // How often the color changes

    var body: some View {
        currentColor
            .animation(.easeInOut(duration: animationDuration), value: currentColor)
            .ignoresSafeArea() // Make the background fill the entire screen
            .onAppear {
                startColorAnimation()
            }
            .onDisappear {
                stopColorAnimation()
            }
    }

    // MARK: - Timer Management
    private func startColorAnimation() {
        // Invalidate any existing timer to prevent multiple timers running
        stopColorAnimation()
        
        let timer = Timer.scheduledTimer(withTimeInterval: changeInterval, repeats: true) { _ in
            withAnimation { // Use withAnimation for immediate animation trigger
                self.currentColor = .random
            }
        }
        self.timer = timer
        // Add the timer to the current run loop to ensure it fires
        RunLoop.current.add(timer, forMode: .common)
    }

    private func stopColorAnimation() {
        timer?.invalidate() // Stop the timer
        timer = nil          // Release the timer
    }
}

#Preview {
    NavigationStack {
        SystemMaterialView()
    }
}

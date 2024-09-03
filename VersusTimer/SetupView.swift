import SwiftUI

struct SetupView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var topViewModel: CountdownViewModel
    @ObservedObject var bottomViewModel: CountdownViewModel

    @State private var topTimerDuration: Double = 5
    @State private var bottomTimerDuration: Double = 5
    @State private var startColor: Color = .green
    @State private var endColor: Color = .red
    @State private var isAutoTurnoverOn: Bool = false
    @State private var autoTurnoverDelay: Double = 3

    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Top Timer Settings")) {
                    Stepper(value: $topTimerDuration, in: 1...600) {
                        Text("Top Timer Duration: \(Int(topTimerDuration)) seconds")
                    }
                }
                
                Section(header: Text("Bottom Timer Settings")) {
                    Stepper(value: $bottomTimerDuration, in: 1...600) {
                        Text("Bottom Timer Duration: \(Int(bottomTimerDuration)) seconds")
                    }
                }

                Section(header: Text("Color Settings")) {
                    VStack(alignment: .leading) {
                        Text("Start Color")
                        HStack {
                            ForEach(colors, id: \.self) { color in
                                color
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(startColor == color ? Color.black : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        startColor = color
                                    }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("End Color")
                        HStack {
                            ForEach(colors, id: \.self) { color in
                                color
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(endColor == color ? Color.black : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        endColor = color
                                    }
                            }
                        }
                    }
                }
                
                Section(header: Text("Auto Turnover")) {
                    Toggle(isOn: $isAutoTurnoverOn) {
                        Text("Enable Auto Turnover")
                    }
                    
                    Stepper(value: $autoTurnoverDelay, in: 0...10) {
                        Text("Turnover Delay: \(Int(autoTurnoverDelay)) seconds")
                    }
                }
            }
            .navigationTitle("Setup")
            .navigationBarItems(trailing: Button("Done") {
                applySettings()
                dismiss()
            })
            .onAppear {
                topTimerDuration = topViewModel.totalTime
                bottomTimerDuration = bottomViewModel.totalTime
                startColor = topViewModel.startColor
                endColor = topViewModel.endColor
                isAutoTurnoverOn = topViewModel.isAutoTurnoverOn
                autoTurnoverDelay = topViewModel.autoTurnoverDelay
            }
        }
    }
    
    private func applySettings() {
        topViewModel.setTime(topTimerDuration)
        bottomViewModel.setTime(bottomTimerDuration)
        topViewModel.setColors(startColor: startColor, endColor: endColor)
        bottomViewModel.setColors(startColor: startColor, endColor: endColor)
        topViewModel.setAutoTurnover(isOn: isAutoTurnoverOn, delay: autoTurnoverDelay)
        bottomViewModel.setAutoTurnover(isOn: isAutoTurnoverOn, delay: autoTurnoverDelay)
    }
}

#Preview {
    SetupView(topViewModel: CountdownViewModel(), bottomViewModel: CountdownViewModel())
}

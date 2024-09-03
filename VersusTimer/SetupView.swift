import SwiftUI

struct SetupView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var topViewModel: CountdownViewModel
    @ObservedObject var bottomViewModel: CountdownViewModel

    @State private var topTimerDuration: Double = 5
    @State private var bottomTimerDuration: Double = 5

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
            }
            .navigationTitle("Setup")
            .navigationBarItems(trailing: Button("Done") {
                applySettings()
                dismiss()
            })
            .onAppear {
                topTimerDuration = topViewModel.totalTime
                bottomTimerDuration = bottomViewModel.totalTime
            }
        }
    }
    
    private func applySettings() {
        topViewModel.setTime(topTimerDuration)
        bottomViewModel.setTime(bottomTimerDuration)
    }
}

#Preview {
    SetupView(topViewModel: CountdownViewModel(), bottomViewModel: CountdownViewModel())
}

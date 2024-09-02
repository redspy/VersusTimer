import SwiftUI

class CountdownViewModel: ObservableObject {
    @Published var timeInput: String = ""
    @Published var remainingTime: Double = 0.0
    @Published var isRunning: Bool = false
    @Published var showRedBackground: Bool = false
    @Published var blinkBackground: Bool = false
    @Published var totalTime: Double = 0.0

    private var timer: Timer? = nil

    func startCountdown(time: Double) {
        self.totalTime = time
        self.remainingTime = time
        self.isRunning = true
        self.showRedBackground = false
        self.blinkBackground = false
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if self.remainingTime > 0.01 {
                self.remainingTime -= 0.01
                
                if self.remainingTime <= 3.0 && self.remainingTime > 2.99 {
                    self.startBlinking()
                }
                
                if self.remainingTime <= 2.0 && self.remainingTime > 1.99 {
                    self.startBlinking()
                }
                
                if self.remainingTime <= 1.0 && self.remainingTime > 0.99 {
                    self.startBlinking()
                }
                
            } else {
                self.remainingTime = 0.00
                self.stopCountdown()
                self.showRedBackground = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showRedBackground = false
                }
            }
        }
    }

    func stopCountdown() {
        self.timer?.invalidate()
        self.timer = nil
        self.isRunning = false
        self.remainingTime = 0.00
    }
    
    private func startBlinking() {
        withAnimation(.easeInOut(duration: 0.2).repeatCount(2, autoreverses: true)) {
            self.blinkBackground = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.blinkBackground = false
        }
    }
}

struct CountdownView: View {
    @StateObject private var viewModel = CountdownViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Countdown Timer")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter time in seconds", text: $viewModel.timeInput)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center) // 가운데 정렬 설정
                .disabled(viewModel.isRunning)
            
            Text(String(format: "%.2f", viewModel.remainingTime))
                .font(.system(size: 50, weight: .bold, design: .monospaced))
                .padding()
            
            Button(action: {
                if let time = Double(viewModel.timeInput) {
                    viewModel.startCountdown(time: time)
                }
            }) {
                Text(viewModel.isRunning ? "Running..." : "Start")
                    .font(.title)
                    .padding()
                    .background(viewModel.isRunning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isRunning)
        }
        .padding()
        .background(progressBackground().edgesIgnoringSafeArea(.all))
    }
    
    func progressBackground() -> some View {
        let progress = viewModel.isRunning || viewModel.showRedBackground ? viewModel.remainingTime / viewModel.totalTime : 1.0
        
        return GeometryReader { geometry in
            VStack(spacing: 0) {
                Color.red
                    .frame(height: geometry.size.height * (1.0 - progress))
                
                if viewModel.blinkBackground {
                    Color.white
                        .frame(height: geometry.size.height * progress)
                        .transition(.opacity)
                } else {
                    Color.green
                        .frame(height: geometry.size.height * progress)
                }
            }
        }
    }
}

#Preview {
    CountdownView()
}

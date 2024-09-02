import SwiftUI

struct CountdownView: View {
    @State private var timeInput: String = ""
    @State private var remainingTime: Double = 0.0
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil
    @State private var totalTime: Double = 0.0
    @State private var showRedBackground: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Countdown Timer")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter time in seconds", text: $timeInput)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isRunning)
            
            Text(String(format: "%.2f", remainingTime))
                .font(.system(size: 50, weight: .bold, design: .monospaced))
                .padding()
            
            Button(action: {
                if let time = Double(self.timeInput) {
                    self.startCountdown(time: time)
                }
            }) {
                Text(isRunning ? "Running..." : "Start")
                    .font(.title)
                    .padding()
                    .background(isRunning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isRunning)
        }
        .padding()
        .background(progressBackground().edgesIgnoringSafeArea(.all))
    }
    
    func progressBackground() -> some View {
        let progress = isRunning || showRedBackground ? remainingTime / totalTime : 1.0
        
        return GeometryReader { geometry in
            VStack(spacing: 0) {
                Color.red
                    .frame(height: geometry.size.height * (1.0 - progress))
                Color.green
                    .frame(height: geometry.size.height * progress)
            }
        }
    }
    
    func startCountdown(time: Double) {
        self.totalTime = time
        self.remainingTime = time
        self.isRunning = true
        self.showRedBackground = false
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if self.remainingTime > 0.01 {
                self.remainingTime -= 0.01
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
}

#Preview {
    CountdownView()
}

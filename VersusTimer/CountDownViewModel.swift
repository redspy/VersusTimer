import SwiftUI

class CountdownViewModel: ObservableObject {
    @Published var remainingTime: Double = 5.0  // 초기값 5초
    @Published var isRunning: Bool = false
    @Published var showRedBackground: Bool = false
    @Published var blinkBackground: Bool = false
    @Published var totalTime: Double = 5.0  // 초기값 5초
    @Published var startColor: Color = .green  // 시작 색상 초기값
    @Published var endColor: Color = .red  // 종료 색상 초기값

    private var timer: Timer? = nil

    func startCountdown() {
        self.remainingTime = totalTime
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
                    self.resetToInitialTime()
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
    
    func setTime(_ time: Double) {
        self.totalTime = time
        self.remainingTime = time
    }
    
    func setColors(startColor: Color, endColor: Color) {
        self.startColor = startColor
        self.endColor = endColor
    }
    
    private func resetToInitialTime() {
        self.remainingTime = self.totalTime
        self.showRedBackground = false
    }
}

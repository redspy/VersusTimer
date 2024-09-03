import SwiftUI

class CountdownViewModel: ObservableObject {
    @Published var remainingTime: Double = 5.0  // 초기값 5초
    @Published var isRunning: Bool = false
    @Published var showRedBackground: Bool = false
    @Published var blinkBackground: Bool = false
    @Published var totalTime: Double {
        didSet { UserDefaults.standard.set(totalTime, forKey: "totalTime") }
    }
    @Published var startColor: Color
    @Published var endColor: Color
    @Published var isAutoTurnoverOn: Bool
    @Published var autoTurnoverDelay: Double

    private var timer: Timer? = nil
    var onComplete: (() -> Void)?

    init() {
        self.totalTime = UserDefaults.standard.double(forKey: "totalTime")
        self.startColor = UserDefaults.standard.color(forKey: "startColor") ?? .green
        self.endColor = UserDefaults.standard.color(forKey: "endColor") ?? .red
        self.isAutoTurnoverOn = UserDefaults.standard.bool(forKey: "isAutoTurnoverOn")
        self.autoTurnoverDelay = UserDefaults.standard.double(forKey: "autoTurnoverDelay")
        
        if totalTime == 0 {
            totalTime = 5.0
        }
        
        if autoTurnoverDelay == 0 {
            autoTurnoverDelay = 3.0
        }
    }

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
                    self.onComplete?()
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
        UserDefaults.standard.setColor(startColor, forKey: "startColor")
        UserDefaults.standard.setColor(endColor, forKey: "endColor")
    }
    
    func setAutoTurnover(isOn: Bool, delay: Double) {
        self.isAutoTurnoverOn = isOn
        self.autoTurnoverDelay = delay
        UserDefaults.standard.set(isOn, forKey: "isAutoTurnoverOn")
        UserDefaults.standard.set(delay, forKey: "autoTurnoverDelay")
    }
    
    private func resetToInitialTime() {
        self.remainingTime = self.totalTime
        self.showRedBackground = false
    }
}

extension UserDefaults {
    func color(forKey key: String) -> Color? {
        if let colorData = data(forKey: key) {
            do {
                if let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    return Color(uiColor)
                }
            } catch {
                print("Failed to unarchive color data for key: \(key)")
            }
        }
        return nil
    }

    func setColor(_ color: Color, forKey key: String) {
        let uiColor = UIColor(color)
        do {
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
            set(colorData, forKey: key)
        } catch {
            print("Failed to archive color for key: \(key)")
        }
    }
}

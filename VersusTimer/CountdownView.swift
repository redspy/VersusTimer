//
//  CountdownView.swift
//  VersusTimer
//
//  Created by Minsu Han on 9/2/24.
//

import SwiftUI

struct CountdownView: View {
    @State private var timeInput: String = ""
    @State private var remainingTime: Double = 0.0
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil
    
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
    }
    
    func startCountdown(time: Double) {
        self.remainingTime = time
        self.isRunning = true
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if self.remainingTime > 0 {
                self.remainingTime -= 0.01
            } else {
                self.stopCountdown()
            }
        }
    }
    
    func stopCountdown() {
        self.timer?.invalidate()
        self.timer = nil
        self.isRunning = false
    }
}

#Preview {
    CountdownView()
}

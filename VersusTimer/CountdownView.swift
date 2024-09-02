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
    @State private var backgroundColor: Color = .green
    
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
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
    }
    
    func startCountdown(time: Double) {
        self.remainingTime = time
        self.isRunning = true
        self.backgroundColor = .green  // 타이머 시작 시 배경색을 Green으로 설정
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if self.remainingTime > 0.01 {
                self.remainingTime -= 0.01
            } else {
                self.remainingTime = 0.00  // 타이머가 0.00 이하로 내려가지 않도록 설정
                self.stopCountdown()
            }
        }
    }
    
    func stopCountdown() {
        self.timer?.invalidate()
        self.timer = nil
        self.isRunning = false
        self.backgroundColor = .red  // 타이머 종료 시 배경색을 Red로 설정
    }
}

#Preview {
    CountdownView()
}

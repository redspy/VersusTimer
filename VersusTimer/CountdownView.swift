import SwiftUI

struct CountdownView: View {
    @StateObject private var topViewModel = CountdownViewModel()
    @StateObject private var bottomViewModel = CountdownViewModel()
    @State private var isSetupPresented = false

    var body: some View {
        VStack(spacing: 0) {
            CountdownContent(viewModel: topViewModel)
                .rotationEffect(.degrees(180)) // 상단 타이머 180도 회전
            
            Button(action: {
                isSetupPresented.toggle()
            }) {
                Text("Setup")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .sheet(isPresented: $isSetupPresented) {
                SetupView(topViewModel: topViewModel, bottomViewModel: bottomViewModel)
            }

            CountdownContent(viewModel: bottomViewModel)
        }
    }
}

struct CountdownContent: View {
    @ObservedObject var viewModel: CountdownViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Countdown Timer")
                .font(.largeTitle)
                .padding()
            
            // 남은 시간을 소숫점 두 자리까지 표시
            Text(String(format: "%.2f", viewModel.remainingTime))
                .font(.system(size: 50, weight: .bold, design: .monospaced))
                .padding()
            
            Button(action: {
                viewModel.startCountdown()
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
    
    private func progressBackground() -> some View {
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

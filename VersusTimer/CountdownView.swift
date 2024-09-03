import SwiftUI

struct CountdownView: View {
    @StateObject private var topViewModel = CountdownViewModel()
    @StateObject private var bottomViewModel = CountdownViewModel()
    @State private var isSetupPresented = false

    var body: some View {
        VStack(spacing: 0) {
            CountdownContent(viewModel: topViewModel)
                .rotationEffect(.degrees(180)) // 상단 타이머 180도 회전
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    setupAutoTurnover()
                }
            
            Button(action: {
                isSetupPresented.toggle()
            }) {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 20) // 세로 크기를 20으로 설정
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $isSetupPresented) {
                SetupView(topViewModel: topViewModel, bottomViewModel: bottomViewModel)
            }

            CountdownContent(viewModel: bottomViewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func setupAutoTurnover() {
        topViewModel.onComplete = {
            if self.topViewModel.isAutoTurnoverOn {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.topViewModel.autoTurnoverDelay) {
                    self.bottomViewModel.startCountdown()
                }
            }
        }
        
        bottomViewModel.onComplete = {
            if self.bottomViewModel.isAutoTurnoverOn {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.bottomViewModel.autoTurnoverDelay) {
                    self.topViewModel.startCountdown()
                }
            }
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
            }
            .disabled(viewModel.isRunning)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(progressBackground().edgesIgnoringSafeArea(.all))
    }
    
    private func progressBackground() -> some View {
        let progress = viewModel.isRunning || viewModel.showRedBackground ? viewModel.remainingTime / viewModel.totalTime : 1.0
        
        return GeometryReader { geometry in
            VStack(spacing: 0) {
                viewModel.endColor
                    .frame(height: geometry.size.height * (1.0 - progress))
                
                if viewModel.blinkBackground {
                    Color.white
                        .frame(height: geometry.size.height * progress)
                        .transition(.opacity)
                } else {
                    viewModel.startColor
                        .frame(height: geometry.size.height * progress)
                }
            }
        }
    }
}

#Preview {
    CountdownView()
}

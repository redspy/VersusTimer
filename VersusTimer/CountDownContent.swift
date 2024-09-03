import SwiftUI

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
    CountdownContent(viewModel: CountdownViewModel(totalTimeKey: "testTimerDuration"))
}

import SwiftUI

struct CountdownView: View {
    @StateObject private var topViewModel = CountdownViewModel(totalTimeKey: "topTimerDuration")
    @StateObject private var bottomViewModel = CountdownViewModel(totalTimeKey: "bottomTimerDuration")
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

#Preview {
    CountdownView()
}

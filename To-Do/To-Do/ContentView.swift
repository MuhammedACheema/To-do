import SwiftUI

struct ContentView: View {
    private var timer = PomodoroTimer(workInSeconds: 10, breakInSeconds: 5)
    
    @State private var displayWarning = false
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack{
            //circle
            CircularTimer(fraction:timer.fractionPassed, primaryText: timer.secondsLeftString, secondaryText: timer.mode.rawValue)
            
            HStack{
                //skip
                if timer.state == .idle && timer.mode == .pause{
                    CircleButton(icon: "forward.fill"){
                        timer.skip()
                    }
                }
                //start button
                if timer.state == .idle{
                    CircleButton(icon: "play.fill"){
                        timer.start()
                    }
                }
                
                //resume
                if timer.state == .paused{
                    CircleButton(icon: "play.fill"){
                        timer.resume()
                    }
                }
                
                //paused
                if timer.state == .running{
                    CircleButton(icon: "pause.fill"){
                        timer.pause()
                    }
                }
                //reset timer
                if timer.state == .running || timer.state == .paused{
                    CircleButton(icon: "stop.fill"){
                        timer.reset()
                    }
                }
            }
            //notif disabled warning
            if displayWarning{
                NotificationDisabled()
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(
                gradient: Gradient(colors:
                                    [Color("Light"),Color("Dark")]),
                center: .center,
                startRadius: 5,
                endRadius: 500
            )
        )
        .onChange(of: scenePhase){
            if scenePhase == .active{
                Notification.checkAuthorization{
                    authorized in
                    displayWarning = !authorized
                }
            }
        }
        
    }
}
#Preview {
    ContentView()
}

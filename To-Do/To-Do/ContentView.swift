import SwiftUI

struct ContentView: View {
    private var timer = PomodoroTimer(workInSeconds: 10, breakInSeconds: 5)
    
    @State private var displayWarning = false
    @Environment(\.scenePhase) var scenePhase
    @State private var todoItems: [String] = [] // List of to-do items
    @State private var newTodo: String = "" // New to-do input field
    
    var body: some View {
        VStack {
            // To-Do List Section
            if !todoItems.isEmpty {
                VStack {
                    // Centered To-Do List title
                    Text("To-Do List")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                    
                    // List of To-Do items
                    List {
                        ForEach(todoItems, id: \.self) { item in
                            Text(item)
                        }
                        .onDelete(perform: deleteTodo)
                    }
                    .animation(.easeInOut, value: todoItems.count) // Animation for smooth updates
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            }
            
            // Input field and add button
            HStack {
                TextField("New Task", text: $newTodo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !newTodo.isEmpty {
                        todoItems.append(newTodo)
                        newTodo = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            }
            .padding()
            
            // Pomodoro Timer
            CircularTimer(fraction: timer.fractionPassed, primaryText: timer.secondsLeftString, secondaryText: timer.mode.rawValue)
            
            HStack {
                // Timer control buttons
                if timer.state == .idle && timer.mode == .pause {
                    CircleButton(icon: "forward.fill") {
                        timer.skip()
                    }
                }
                if timer.state == .idle {
                    CircleButton(icon: "play.fill") {
                        timer.start()
                    }
                }
                if timer.state == .paused {
                    CircleButton(icon: "play.fill") {
                        timer.resume()
                    }
                }
                if timer.state == .running {
                    CircleButton(icon: "pause.fill") {
                        timer.pause()
                    }
                }
                if timer.state == .running || timer.state == .paused {
                    CircleButton(icon: "stop.fill") {
                        timer.reset()
                    }
                }
            }
            
            // Notification Disabled Warning
            if displayWarning {
                NotificationDisabled()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(
                gradient: Gradient(colors: [Color("Light"), Color("Dark")]),
                center: .center,
                startRadius: 5,
                endRadius: 500
            )
        )
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                Notification.checkAuthorization { authorized in
                    displayWarning = !authorized
                }
            }
        }
    }
    
    // Function to delete items
    private func deleteTodo(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}

//
//  TimerView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

enum TimerStatus {
    case started
    case paused
    case stopped
    case alarming
}

enum TimerType {
    case workTimer
    case breakTimer
    
    var name : String {
        switch self {
            case .workTimer: return "Work"
            case .breakTimer: return "Break"
        }
    }
    
    var isWork : Bool {
        switch self {
            case .workTimer: return true
            case .breakTimer: return false
        }
    }
}

func formatTimePart(timePart: Int) -> String {
    if timePart < 10 {
        return "0\(timePart)"
    } else {
        return "\(timePart)"
    }
}

func formatTime(hour: Int, minute: Int, second: Int) -> String {
    return "\(formatTimePart(timePart: hour)):\(formatTimePart(timePart: minute)):\(formatTimePart(timePart: second))"
}

struct TimerView: View {
    @State private var selectedTimer: TimerType = .workTimer
    @State private var timerHour: Int = 0
    @State private var timerMinute: Int = 0
    @State private var timerSecond: Int = 0
    @State private var timerDurationInSeconds: Int = 0
    @State private var timerStatus: TimerStatus = .stopped
    @State private var startDate: Date = Date()
    @State private var currentlyElapsedTime: Int = 0
    @State private var previouslyElapsedTime: Int = 0
    @State private var currentHour: Int = 0
    @State private var currentMinute: Int = 0
    @State private var currentSecond: Int = 0
    @State var timer = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()

    
    private let timerTypes: [TimerType] = [
        .workTimer,
        .breakTimer
    ]
    
    var body: some View {
        NavigationView(title: "Timer") {
            VStack(spacing: 20){
                Picker("Select a course", selection: $selectedTimer) {
                    ForEach(timerTypes, id: \.self) { timerType in
                        Text(timerType.name)
                    }
                }.pickerStyle(.segmented).disabled(timerStatus != .stopped)
                HStack{
                    Picker("Hours", selection: $timerHour) {
                        ForEach(0...24, id: \.self) { hour in
                            Text("\(hour) hours")
                        }
                    }.pickerStyle(.wheel).disabled(timerStatus != .stopped)
                    
                    Picker("Minutes", selection: $timerMinute) {
                        ForEach(0...59, id: \.self) { minute in
                            Text("\(minute) min")
                        }
                    }.pickerStyle(.wheel).disabled(timerStatus != .stopped)
                    
                    Picker("Seconds", selection: $timerSecond) {
                        ForEach(0...59, id: \.self) { second in
                            Text("\(second) sec")
                        }
                    }.pickerStyle(.wheel).disabled(timerStatus != .stopped)
                    
                }
                HStack{
                    Image(systemName: "timer")
                        .imageScale(.large)
                    Text(
                        timerStatus != .stopped ?
                        formatTime(hour: currentHour, minute: currentMinute, second: currentSecond)
                        :
                        formatTime(hour: timerHour, minute: timerMinute, second: timerSecond)
                        
                    ).font(.title)
                }.foregroundColor(timerStatus != .stopped ? .black : .gray)
                
                if timerStatus != .alarming {
                    HStack{
                        TextButton(title: timerStatus != .started ? (timerStatus == .stopped ? "Start" : "Resume") : "Pause", foregroundColor: .white, backgroundColor: timerStatus != .started ? .green : .orange) {
                            switch timerStatus {
                            case .started:
                                timerStatus = .paused
                                previouslyElapsedTime = currentlyElapsedTime
                                timer.upstream.connect().cancel()
                            case .paused:
                                timerStatus = .started
                                startDate = Date()
                                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            case .stopped:
                                if timerHour > 0 || timerMinute > 0 || timerSecond > 0 {
                                    timerStatus = .started
                                    startDate = Date()
                                    previouslyElapsedTime = 0
                                    currentlyElapsedTime = 0
                                    currentHour = timerHour
                                    currentMinute = timerMinute
                                    currentSecond = timerSecond
                                    timerDurationInSeconds = timerHour * 3600 + timerMinute * 60 + timerSecond
                                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                }
                            case .alarming: break
                            }
                            
                        }
                        TextButton(title: "Stop", foregroundColor: .white, backgroundColor: .red) {
                            timerStatus = .stopped
                        }
                    }
                } else {
                    TextButton(title: "Shut off", foregroundColor: .white, backgroundColor: .pink) {
                        SoundPlayer.shared.stopSound()
                        timerStatus = .stopped
                    }
                }
                Spacer()
            }
            .padding(20)
            
            
            
        }.onReceive(timer) { firedDate in
            if currentHour == 0 && currentMinute == 0 && currentSecond == 0 {
                timerStatus = .alarming
                timer.upstream.connect().cancel()
                SoundPlayer.shared.playSound(forResource: "alarm_clock", withExtension: "mp3")
            } else {
                currentlyElapsedTime = previouslyElapsedTime + Int(firedDate.timeIntervalSince(startDate))
                let timeLeft = timerDurationInSeconds - currentlyElapsedTime
                currentHour = max(timeLeft / 3600, 0)
                currentMinute = max((timeLeft % 3600) / 60, 0)
                currentSecond = max(timeLeft % 60, 0)
            }
        }
    }
}

#Preview {
    TimerView()
}

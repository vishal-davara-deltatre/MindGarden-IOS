//
//  PlayViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 2/7/22.
//

import SwiftUI
import OneSignal

extension MeditationViewModel {
    //MARK: - timer
    func startCountdown() {
        bellPlayer.prepareToPlay()

        if selectedMeditation?.reward == -1 {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                self.secondsRemaining += 1
                if secondsRemaining >= 60 {
                    switch selectedMeditation?.id {
                    case 58: if secondsRemaining.truncatingRemainder(dividingBy: 60) == 0.0 { bellPlayer.play()}
                    case 59:  if secondsRemaining.truncatingRemainder(dividingBy: 120) == 0.0 { bellPlayer.play()}
                    case 60:  if secondsRemaining.truncatingRemainder(dividingBy: 300) == 0.0 { bellPlayer.play()}
                    case 61: if secondsRemaining.truncatingRemainder(dividingBy: 600) == 0.0 { bellPlayer.play()}
                    case 62:  if secondsRemaining.truncatingRemainder(dividingBy: 900) == 0.0 { bellPlayer.play()}
                    case 63:  if secondsRemaining.truncatingRemainder(dividingBy: 1200) == 0.0 { bellPlayer.play()}
                    case 64: if secondsRemaining.truncatingRemainder(dividingBy: 1500) == 0.0 { bellPlayer.play()}
                    case 65: if secondsRemaining.truncatingRemainder(dividingBy: 1800) == 0.0 { bellPlayer.play()}
                    case 66: if secondsRemaining.truncatingRemainder(dividingBy: 3600) == 0.0 { bellPlayer.play()}
                    default: break
                    }
                }

                withAnimation {
                    if secondsRemaining >= 300 { //15 = 0
                        lastSeconds = true
                        playImage = selectedPlant?.coverImage ?? Img.redTulips3
                    } else if secondsRemaining - 0.2 >= 200 { //30 - 15
                        playImage = selectedPlant?.two ?? Img.redTulips2
                    } else if secondsRemaining - 0.2 >= 100 { //45-30
                        playImage = selectedPlant?.one ?? Img.redTulips1
                    } else { //60 - 45
                        playImage = Img.seed
                    }
                }
            }
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                self.secondsRemaining -= 1
                withAnimation {
                    if secondsRemaining - 0.2 <= totalTime * 0.25 { //15 = 0
                        lastSeconds = true
                        playImage = selectedPlant?.coverImage ?? Img.redTulips3
                    } else if secondsRemaining - 0.2 <= totalTime * 0.5 { //30 - 15
                        playImage = selectedPlant?.two ?? Img.redTulips2
                    } else if secondsRemaining - 0.2 <= totalTime * 0.75 { //45-30
                        playImage = selectedPlant?.one ?? Img.redTulips1
                    } else { //60 - 45
                        playImage = Img.seed
                    }

                    if secondsRemaining <= 0 {
                        if let med = self.selectedMeditation {
                            if med.id != 27 && med.id != 39 && med.id != 54 {
                                bellPlayer.play()
                            }
                        }

                        stop()
                        switch selectedMeditation?.id {
                        case 7:  OneSignal.sendTag("day1", value: "true")
                        case 8:  OneSignal.sendTag("day2", value: "true")
                        case 9:  OneSignal.sendTag("day3", value: "true")
                        case 10: OneSignal.sendTag("day4", value: "true")
                        case 11:
                            UserDefaults.standard.setValue(true, forKey: "day5")
                            OneSignal.sendTag("day5", value: "true")
                        case 12:
                            UserDefaults.standard.setValue(true, forKey: "day6")
                            OneSignal.sendTag("day6", value: "true")
                        case 13:
                            UserDefaults.standard.setValue(true, forKey: "day7")
                            OneSignal.sendTag("day7", value: "true")
                        default: break
                        }
                        if UserDefaults.standard.bool(forKey: "day5") &&  UserDefaults.standard.bool(forKey: "day6") &&  UserDefaults.standard.bool(forKey: "day7") {
                            UserDefaults.standard.setValue(true, forKey: "beginnerCourse")
                            UserDefaults.standard.setValue(true, forKey: "unlockStrawberry")
                            getFeaturedMeditation()
                        }
                        if self.selectedMeditation?.id == 21 {
                            UserDefaults.standard.setValue(true, forKey: "intermediateCourse")
                            getFeaturedMeditation()
                        }
                        viewRouter?.currentPage = .finished
                        return
                    }
                }
            }
        }
        timer.fire()
    }

    func setup(_ viewRouter: ViewRouter) {
       self.viewRouter = viewRouter
     }

    func stop() {
        timer.invalidate()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.secondsCounted += 1 }
        timer.fire()
    }


    func secondsToMinutesSeconds (totalSeconds: Float) -> String {
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        return String(format:"%02d:%02d", minutes, seconds)
    }
}
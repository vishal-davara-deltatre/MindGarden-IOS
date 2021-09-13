//
//  ContentView.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import SwiftUI
import Combine
import Lottie

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @State private var showPopUp = false
    @State private var addMood = false
    @State private var openPrompts = false
    @State private var addGratitude = false
    @State private var isOnboarding = false
    var bonusModel: BonusViewModel

    init(bonusModel: BonusViewModel) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.bonusModel = bonusModel
//        meditationModel.isOpenEnded = false
//        meditationModel.secondsRemaining = 150
        //check for auth here
    }

    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack {
                        if #available(iOS 14.0, *) {
                            switch viewRouter.currentPage {
                            case .onboarding:
                                OnboardingScene()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .experience:
                                ExperienceScene()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .meditate:
                                Home(bonusModel: bonusModel)
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                                    .onAppear {
                                        self.isOnboarding = false
                                        self.showPopUp = false
                                    }
                            case .garden:
                                Garden()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .shop:
                                Store(showPlantSelect: .constant(false))
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .profile:
                                ProfileScene()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .categories:
                                CategoriesScene()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .middle:
                                MiddleSelect()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .play:
                                Play()
                                    .frame(height: geometry.size.height + 80)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .finished:
                                Finished()
                                    .frame(height: geometry.size.height + 80)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .authentication:
                                    Authentication(isSignUp: true, viewModel: AuthenticationViewModel(userModel: userModel, viewRouter: viewRouter))
                                        .frame(height: geometry.size.height)
                                        .navigationViewStyle(StackNavigationViewStyle())
                            case .notification:
                                NotificationScene()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }.edgesIgnoringSafeArea(.all)
                    if viewRouter.currentPage != .play && viewRouter.currentPage != .authentication
                        && viewRouter.currentPage != .notification && viewRouter.currentPage != .onboarding
                        && viewRouter.currentPage != .experience && viewRouter.currentPage != .finished {
                        if showPopUp || addMood || addGratitude || isOnboarding {
                            Button {
                                if !isOnboarding {
                                    withAnimation {
                                        showPopUp = false
                                        addMood = false
                                        addGratitude = false
                                    }
                                }
                            } label: {
                                Color.black
                                    .opacity(0.3)
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(height: showPopUp || addMood || addGratitude || isOnboarding ? geometry.size.height: 0)
                            }.animation(.easeInOut(duration: 0.1))
                        }
                        ZStack {
                            PlusMenu(showPopUp: $showPopUp, addMood: $addMood, addGratitude: $addGratitude, isOnboarding: isOnboarding, width: geometry.size.width)
                                .offset(y: showPopUp ?  geometry.size.height/2 - (K.hasNotch() ? 125 : K.isPad() ? 235 : 130) : geometry.size.height/2 + 60)
                                .opacity(showPopUp ? 1 : 0)
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "signedUp" || UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "mood" ||  UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "gratitude"  {
                                LottieView(fileName: "side-arrow")
                                    .frame(width: 75, height: 25)
                                    .padding(.horizontal)
                                    .offset(x: -20, y: UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "signedUp" ? -20 : UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "gratitude" ? 70 : 10)
                            }

                            HStack {
                                TabBarIcon(viewRouter: viewRouter, assignedPage: .garden, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Garden", img: Img.plantIcon)
                                TabBarIcon(viewRouter: viewRouter, assignedPage: .meditate, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Meditate", img: Img.meditateIcon)
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(21)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: geometry.size.width/7, maxHeight: geometry.size.width/7)
                                        .shadow(color: showPopUp ? .black.opacity(0) : .black.opacity(0.25), radius: 4, x: 4, y: 4)
                                        .zIndex(1)
                                    Image(systemName: "plus")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.title.weight(.semibold))
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: geometry.size.width/5.5-6 , maxHeight: geometry.size.width/5.5-6)
                                        .zIndex(2)
                                        .rotationEffect(showPopUp ? .degrees(45) : .degrees(0))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        showPopUp.toggle()
                                    }
                                }
                                .offset(y: -geometry.size.height/14/2)
                                TabBarIcon(viewRouter: viewRouter, assignedPage: .shop, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Shop", img: Img.shopIcon)
                                TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Profile", img: Img.profileIcon)
                            }.frame(width: geometry.size.width, height: 80)
                            .background(Clr.darkgreen.shadow(radius: 2))
                            .offset(y: geometry.size.height/2 - (K.hasNotch() ? 0 : 15))
                        }
                        MoodCheck(shown: $addMood, showPopUp: $showPopUp)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
                            .background(Clr.darkWhite)
                            .cornerRadius(12)
                            .offset(y: addMood ? geometry.size.height/(K.hasNotch() ? 2.5 : 2.75) : geometry.size.height)
                        Gratitude(shown: $addGratitude, showPopUp: $showPopUp, openPrompts: $openPrompts)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5 * (openPrompts ? 2.25 : 1))
                            .background(Clr.darkWhite)
                            .cornerRadius(12)
                            .offset(y: addGratitude ? geometry.size.height/(K.hasNotch() ? 3.25 * (openPrompts ? 2 : 1)  : K.isPad()  ?  2.5 * (openPrompts ? 2 : 1) : 4.5 * (openPrompts ? 4.5 : 1) )  : geometry.size.height)
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            ContentView(bonusModel: BonusViewModel(userModel: UserViewModel()))
        }
    }
}

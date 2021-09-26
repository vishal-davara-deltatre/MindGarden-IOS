//
//  ProfileScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/6/21.
//

import SwiftUI
import MessageUI

enum settings {
    case settings
    case journey
}

struct ProfileScene: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @ObservedObject var profileModel: ProfileViewModel
    @State private var selection: settings = .journey
    @State private var showNotification = false
    @State private var isSignedIn = true
    @State private var tappedSignedIn = false
    @State private var showMailView = false
    @State private var mailNeedsSetup = false

    var body: some View {
        VStack {
            NavigationView {
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .bottom, spacing: 0) {
                                SelectionButton(selection: $selection, type: .settings)
                                    .frame(width: abs(g.size.width/2.5 - 2.5))
                                VStack {
                                    Rectangle().fill(Color.gray.opacity(0.3))
                                        .frame(width: 2, height: 35)
                                        .padding(.top, 10)
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 5)
                                }.frame(width: 5)
                                SelectionButton(selection: $selection, type: .journey)
                                    .frame(width: abs(g.size.width/2.5 - 2.5))
                            }.background(Clr.darkWhite)
                            .cornerRadius(12)
                            .neoShadow()
                            if showNotification && selection == .settings {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    showNotification = false
                                } label: {
                                    Capsule()
                                        .fill(Clr.darkWhite)
                                        .padding(.horizontal)
                                        .overlay(
                                            Text("Go Back")
                                                .font(Font.mada(.semiBold, size: 20))
                                                .foregroundColor(Clr.darkgreen)
                                        )
                                        .frame(width: width * 0.35, height: 30)
                                }
                                .buttonStyle(NeumorphicPress())
                                .padding(.top)
                            }
                            if selection == .settings {
                                if showNotification {
                                    List {
                                        Row(title: "Mindful Reminders", img: Image(systemName: "envelope.fill"), swtch: true,action: {})
                                            .frame(height: 40)
                                        Row(title: "Motivational Quotes", img: Image(systemName: "arrow.triangle.2.circlepath"), swtch: true,action: {})
                                            .frame(height: 40)
                                    }.frame(maxHeight: g.size.height * 0.60)
                                    .padding()
                                    .neoShadow()
                                    .transition(.slide)
                                    .animation(.default)
                                } else {
                                    List {
                                        Row(title: "Notifications", img: Image(systemName: "bell.fill"), action: { showNotification = true })
                                            .frame(height: 40)
                                        Row(title: "Invite Friends", img: Image(systemName: "arrowshape.turn.up.right.fill"), action: { actionSheet() })
                                                .frame(height: 40)
                                        Row(title: "Contact Us", img: Image(systemName: "envelope.fill"), action: {
                                            if MFMailComposeViewController.canSendMail() {
                                                print("jermaine")
                                                showMailView = true
                                            } else {
                                                mailNeedsSetup = true
                                            }
                                        })
                                            .frame(height: 40)
                                        Row(title: "Restore Purchases", img: Image(systemName: "arrow.triangle.2.circlepath"), action: { print("bing")})
                                            .frame(height: 40)
                                        Row(title: "Join the Community", img: Img.redditIcon, action: {print("romain")})
                                            .frame(height: 40)
                                        Row(title: "Daily Motivation", img: Img.instaIcon, action: {print("shji")})
                                            .frame(height: 40)
                                    }.frame(maxHeight: g.size.height * 0.65)
                                    .padding()
                                    .neoShadow()
                                }
                            } else {
                                // Journey
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(12)
                                        .neoShadow()
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center, spacing: 10) {
                                            Image(systemName: "calendar")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            Text("MindGarden Journey Begins")
                                                .font(Font.mada(.regular, size: 20))
                                                .foregroundColor(Clr.black1)
                                                .padding(.top, 3)
                                        }.frame(width: abs(width - 75), alignment: .leading)
                                        .frame(height: 25)
                                        Text("\(profileModel.signUpDate)")
                                            .font(Font.mada(.bold, size: 34))
                                            .foregroundColor(Clr.darkgreen)
                                    }
                                }.frame(width: abs(width - 75), height: height/6)
                                .padding()
                                .padding(.leading)
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(12)
                                        .neoShadow()
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center, spacing: 10) {
                                            Image(systemName: "clock")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            Text("Total Time Meditated")
                                                .font(Font.mada(.regular, size: 20))
                                                .foregroundColor(Clr.black1)
                                                .padding(.top, 3)
                                        }.frame(width: abs(width - 100), alignment: .leading)
                                        .frame(height: 25)
                                        HStack {
                                            Text("\(profileModel.totalMins)")
                                                .font(Font.mada(.bold, size: 40))
                                                .foregroundColor(Clr.darkgreen)
                                            Text("minutes")
                                                .font(Font.mada(.regular, size: 28))
                                                .foregroundColor(Clr.black1)
                                        }
                                    }
                                }.frame(width: abs(width - 75), height: height/6)
                                .padding()
                                .padding(.leading)
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(12)
                                        .neoShadow()
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center, spacing: 10) {
                                            Image(systemName: "star.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            Text("Total Meditation Sessions")
                                                .font(Font.mada(.regular, size: 20))
                                                .foregroundColor(Clr.black1)
                                                .padding(.top, 3)
                                        }.frame(width: abs(width - 100), alignment: .leading)
                                        .frame(height: 25)
                                        HStack {
                                            Text("\(profileModel.totalSessions)")
                                                .font(Font.mada(.bold, size: 40))
                                                .foregroundColor(Clr.darkgreen)
                                            Text("Sessions")
                                                .font(Font.mada(.semiBold, size: 28))
                                                .foregroundColor(Clr.black1)
                                        }
                                    }
                                }.frame(width: abs(width - 75), height: height/6)
                                .padding()
                                .padding(.leading)
                            }
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                profileModel.signOut()
                            } label: {
                                Capsule()
                                    .fill(Clr.redGradientBottom)
                                    .neoShadow()
                                    .overlay(Text("Sign Out").foregroundColor(.white).font(Font.mada(.bold, size: 24)))
                            }
                            .frame(width: abs(width - 100), height: 50, alignment: .center)
                            Spacer()
                        }.navigationBarTitle("Dante", displayMode: .inline)
                        .frame(width: width, height: height)
                        .background(Clr.darkWhite)
                    }
                }
            }
            Text("been").hidden()
            .onAppear {
                // Set the default to clear
                UITableView.appearance().backgroundColor = .clear
                UITableView.appearance().isScrollEnabled = false
                profileModel.update(userModel: userModel, gardenModel: gardenModel)
            }
            .sheet(isPresented: $showMailView) {
                MailView()
            }
            .alert(isPresented: $mailNeedsSetup) {
                Alert(title: Text("Your mail is not setup"), message: Text("Please try manually emailing team@mindgarden.io thank you."))
            }
        }
    }
    func actionSheet() {
           guard let urlShare = URL(string: "https://mindgarden.io") else { return }
           let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        
       }


    struct Row: View {
        var title: String
        var img: Image
        var swtch: Bool = false
        var action: () -> ()

        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                action()
            } label: {
                VStack(spacing: 20) {
                    HStack() {
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 20)
                            .offset(x: -10)
                            .foregroundColor(Clr.darkgreen)
                        Text(title)
                            .font(Font.mada(.medium, size: 20))
                            .foregroundColor(Clr.black1)
                        Spacer()
                        if title == "Notifications" {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        } else if swtch {
                            if #available(iOS 14.0, *) {
                                Toggle("", isOn: .constant(true))
                                    .toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                                    .frame(width: UIScreen.main.bounds.width * 0.1)
                            }
                        }
                    }.padding()
                }
                .listRowBackground(Clr.darkWhite)
            }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(profileModel: ProfileViewModel())
    }
}

struct SelectionButton: View {
    @Binding var selection: settings
    var type: settings

    var body: some View {
        VStack {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                selection = type
            } label: {
                HStack {
                    Text(type == .settings ? "Settings" : "Journey")
                        .font(Font.mada(.bold, size: 20))
                        .foregroundColor(selection == type ? Clr.brightGreen : Clr.black1)
                        .padding(.top, 10)
                }
            }.frame(height: 25)
            Rectangle()
                .fill(selection == type ?  Clr.brightGreen : Color.gray.opacity(0.3))
                .frame(height: 5)
        }
    }
}

//
//  SwiftUIView.swift
//  MindGarden
//
//  Created by Dante Kim on 7/2/21.
//

import SwiftUI
import Combine
import UIKit

struct Gratitude: View, KeyboardReadable {
    @Binding var shown: Bool
    @Binding var showPopUp: Bool
    @State var text: String = "Thankful for "
    @Binding var openPrompts: Bool
    @EnvironmentObject var gardenModel: GardenViewModel
    @Binding var contentKeyVisible: Bool
    
    var body: some View {
        GeometryReader { g in
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center, spacing: 10) {
                        Button {
                            Analytics.shared.log(event: .gratitude_tapped_prompts)
                            withAnimation {
                                openPrompts.toggle()
                            }
                        } label: {
                            Capsule()
                                .fill(openPrompts ? Clr.redGradientBottom : Clr.yellow)
                                .neoShadow()
                                .overlay(
                                    Group {
                                        if !openPrompts {
                                            Text("Prompts")
                                                    .foregroundColor(Clr.black1)
                                                    .font(Font.mada(.semiBold, size: 16))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                        } else {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                                .font(Font.mada(.semiBold, size: 18))
                                        }

                                    }

                                )
                                .frame(width: g.size.width/4, height: min(25, g.size.height/10))
                        }.padding(10)
                    if openPrompts {
                        VStack(alignment: .leading) {
                            Text("1. What’s something that you’re looking forward to?")
                                .font(Font.mada(.regular, size: 20))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("2. What’s a simple pleasure that you’re grateful for? (the breeze, coffee, your phone")
                                .font(Font.mada(.regular, size: 20))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("3. What’s something about your body or health that you’re grateful for?")
                                .font(Font.mada(.regular, size: 20))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("4. What mistake or failure are you grateful for?")
                                .font(Font.mada(.regular, size: 20))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)

                        }.frame(width: g.size.width * 0.85)
                    }
                    // TODO move this back to bottom

                    Text("What are you thankful for today?")
                        .font(Font.mada(.bold, size: 20))
                        .frame(width: g.size.width * 0.85)
                        .foregroundColor(Clr.black1)
                        .offset(y: -10)
                        .lineLimit(1)
//                        .minimumScaleFactor(0.5)
                        .padding(.top)
                    DoneCancel(showPrompt: $openPrompts, shown: $shown, width: g.size.width, height: min(250, g.size.height/2), mood: false, save: {
                        Analytics.shared.log(event: .gratitude_tapped_done)
                        gardenModel.save(key: K.defaults.gratitudes, saveValue: text)
                        text = "Thankful for "
                        if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "mood" {
                            UserDefaults.standard.setValue("gratitude", forKey: K.defaults.onboarding)
                            showPopUp = true
                        }
                    }, moodSelected: .angry)
                        .padding(.bottom, 5)
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .background(Clr.darkWhite)
                            .cornerRadius(12)
                            .neoShadow()
                        ScrollView(.vertical, showsIndicators: false) {
                            if #available(iOS 14.0, *) {
                                TextEditor(text: $text)
                                    .disableAutocorrection(true)
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: -10, trailing: 10))
                                    .frame(width: g.size.width * 0.85, height: min(150, g.size.height * 0.7), alignment: .topLeading)
                                    .colorMultiply(Clr.darkWhite)
                                    .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                        withAnimation {
                                            contentKeyVisible = newIsKeyboardVisible
                                        }
                                    }
                            }
                        }
                    }.frame(width: g.size.width * 0.85, height: min(175, g.size.height * 0.6), alignment: .topLeading)
                        .padding(.bottom, 20)

                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Gratitude(shown: .constant(true), showPopUp: .constant(false), openPrompts: .constant(true), contentKeyVisible: .constant(false))
            .frame(width: UIScreen.main.bounds.width, height: 800)
            .background(Clr.darkWhite)
            .cornerRadius(12)
    }
}

/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

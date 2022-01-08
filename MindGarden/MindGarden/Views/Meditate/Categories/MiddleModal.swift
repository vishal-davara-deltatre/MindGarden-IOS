//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI

struct MiddleModal: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @Binding var shown: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        VStack(spacing: 0) {
                            Spacer()
                            HStack {
                                HStack(spacing: 0) {
                                    model.selectedMeditation?.img
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: g.size.width/4.5, height: g.size.height/(K.isSmall() ? 4 : 5))
                                        .padding(.horizontal, 5)
                                    VStack(alignment: .leading) {
                                        Text(model.selectedMeditation?.title ?? "")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.semiBold, size: 28))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.05)
                                        Text(model.selectedMeditation?.description ?? "")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.regular, size: 16))
                                            .lineLimit(4)
                                            .minimumScaleFactor(0.05)
                                    }.frame(width: g.size.width/2, height: g.size.height/(K.isSmall() ? 4 : 5))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                }
                            }.padding(.horizontal, 10)
                            HStack {
                                Text("Selected Plant:")
                                userModel.selectedPlant?.head
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                Text("\(userModel.selectedPlant?.title ?? "none")")
                            }.foregroundColor(Clr.black2)
                                .font(Font.mada(.semiBold, size: 16))
                                .padding(.top)
                                .padding(.horizontal)
                                .frame(width: g.size.width - 80, alignment: .leading)
                            HStack {
                                Text("Coins Given:")
                                Img.coin
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                Text("\(model.selectedMeditation?.reward ?? 0)")
                            }.foregroundColor(Clr.black2)
                                .font(Font.mada(.semiBold, size: 16))
                                .padding(.top, 10)
                                .padding(.horizontal)
                                .frame(width: g.size.width - 80, alignment: .leading)
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                shown = false
                                viewRouter.currentPage = .play
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.brightGreen)
                                .overlay(
                                    Text("Start Session")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.5, height: 40)
                        }.buttonStyle(NeumorphicPress())
                            .padding([.horizontal, .bottom])
                        Spacer()
                    }
                    .font(Font.mada(.regular, size: 18))
                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.5, alignment: .center)
                    .minimumScaleFactor(0.05)
                    .background(Clr.darkWhite)
                    .neoShadow()
                    .cornerRadius(12)
                    .offset(y: -50)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
}

struct MiddleModalPreview: PreviewProvider {
    static var previews: some View {
        WidgetModal(shown: .constant(true))
    }
}

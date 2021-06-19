//
//  StatsBox.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct StatBox: View {
    let label: String
    let img: Image
    let value: String

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Clr.darkWhite)
                .cornerRadius(15)
                .neoShadow()
            HStack(spacing: 0){
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                VStack(alignment: .center, spacing: 0) {
                    Text(label)
                        .font(Font.mada(.regular, size: 12))
                        .minimumScaleFactor(0.05)
                        .multilineTextAlignment(.center)
                    Text(value)
                        .font(Font.mada(.bold, size: 26))
                }
                .frame(maxWidth: 75)
                .padding(5)
            }
        }  .frame(maxWidth: 150, maxHeight: 60)
        .padding(.trailing, 10)
    }
}

struct StatsBox_Previews: PreviewProvider {
    static var previews: some View {
        StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "255")
    }
}

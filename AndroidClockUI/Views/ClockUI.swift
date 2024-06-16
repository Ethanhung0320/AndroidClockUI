//
//  ClockUI.swift
//  AndroidClockUI
//
//  Created by Ethan Hung on 2024/6/16.
//

import SwiftUI

struct ClockUI: View {
    var body: some View {
        ZStack {
            Color("backGroundColor")
                .ignoresSafeArea()
            VStack {
                Basic()
                    .padding(40)
                    .background(Color.white)
            }
        }
    }
}
#Preview {
    ClockUI()
}

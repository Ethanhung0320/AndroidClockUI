//
//  Basic.swift
//  AndroidClockUI
//
//  Created by Ethan Hung on 2024/6/16.
//

import SwiftUI

struct Basic: View {
    
    @StateObject var dateModel = DateViewModel()
    var body: some View {
        ZStack {
            Text(dateModel.selectDate, style: .time)
                .font(.largeTitle)
                .fontWeight(.bold)
                .onTapGesture {
                    //將時間設定為上次選的時間
                    dateModel.setTime()
                    withAnimation(.spring()){
                        dateModel.showPicker.toggle()
                    }
                }
            if dateModel.showPicker{
                VStack(spacing: 0) {
                    HStack(spacing: 10){
                        Spacer()//12:00ampm靠右
                        HStack(spacing: 0){
                            Text("\(dateModel.hour):")
                                .font(.largeTitle)
                                .fontWeight(dateModel.changeToMin ? .light : .bold)
                            //觸碰後更改
                                .onTapGesture {
                                    //更新角度值
                                    dateModel.angle = Double(dateModel.hour * 30)
                                    dateModel.changeToMin = false
                                }
                            Text("\(dateModel.min < 10 ? "0" : "")\(dateModel.min)")
                                .font(.largeTitle)
                                .fontWeight(dateModel.changeToMin ? .bold : .light)
                                .onTapGesture {
                                    dateModel.angle = Double(dateModel.min * 6)
                                    dateModel.changeToMin = true
                                }
                        }
                        VStack(spacing: 8) {
                            Text("AM")
                                .font(.title2)
                                .fontWeight(dateModel.symbol == "AM" ? .bold : .light)
                                .onTapGesture {
                                    dateModel.symbol = "AM"
                                }
                            Text("PM")
                                .font(.title2)
                                .fontWeight(dateModel.symbol == "PM" ? .bold : .light)
                                .onTapGesture {
                                    dateModel.symbol = "PM"
                                }
                        }
                        .frame(width: 50)
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    // Circular Slider圓形滑桿
                    TimeSlider()
                    HStack{
                        Spacer()
                        Button(action: dateModel.generateTime, label: {
                            Text("儲存")
                                .fontWeight(.bold)
                        })
                    }
                    .padding()
                }
                //最大寬度
                .frame(width: getWidth() - 120)
                .background(Color("custombrown"))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.3).ignoresSafeArea().onTapGesture {
                    withAnimation(.spring()) {
                        dateModel.showPicker.toggle()
                        dateModel.changeToMin = false
                    }
                })
                .environmentObject(dateModel)
            }
        }
    }
}
//延伸view來獲取螢幕尺寸
extension View{
    
    func getWidth()->CGFloat{
        
        return UIScreen.main.bounds.width
    }
}

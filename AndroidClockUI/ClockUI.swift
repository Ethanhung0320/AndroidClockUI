//
//  ContentView.swift
//  AndroidClockUI
//
//  Created by Ethan Hung on 2024/4/8.
//

import SwiftUI

struct ClockUI: View {
    var body: some View {
        ZStack {
            Color("")
                .ignoresSafeArea()
            VStack {
                
                Basic()
                    .padding(40)
                    .background(Color.white)
            }
        }
    }
}
struct ClockUI_Previews: PreviewProvider {
    static var previews: some View{
        ClockUI()
    }
}

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
                
                // Pickerview
                
                VStack(spacing: 0) {
                    
                    HStack(spacing: 10){
                        
                        //spacer() -->12:00ampm靠右
                        
                        HStack(spacing: 0){
                            
                            Text("\(dateModel.hour):")
                                .font(.largeTitle)
                                .fontWeight(dateModel.changeToMin ? .light : /*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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

//資料
class DateViewModel: ObservableObject {
    @Published var selectDate = Date()
    @Published var showPicker = false
    
    @Published var hour: Int = 12
    @Published var min: Int = 0
    
    //時與分的切換
    @Published var changeToMin = false
    //AM 或 PM
    @Published var symbol = "AM"
    
    //角度
    @Published var angle : Double = 0
    
    //設定按鈕功能
    func generateTime(){
        
        let format = DateFormatter()
        //大寫HH表示小時
        format.dateFormat = "HH:mm"
        
        let correctHourValue = symbol == "AM" ? hour : hour + 12
        
        let date = format.date(from: "\(correctHourValue):\(min)")
        
        self.selectDate = date!
        
        withAnimation{
            showPicker.toggle()
            changeToMin = false
        }
    }
    
    func setTime(){
        
        let calender = Calendar.current
        
        //24小時制
        hour = calender.component(.hour, from: selectDate)
        symbol = hour <= 12 ? "AM" : "PM"
        hour = hour == 0 ? 12 : hour
        hour = hour <= hour ? hour : hour - 12
        
        min = calender.component(.minute, from: selectDate)
        
        angle = Double(hour * 30)
    }
    
}

struct TimeSlider: View {
    
    @EnvironmentObject var dateModel: DateViewModel
    
    var body: some View {
        GeometryReader {reader in
            
            ZStack{
                
                //Time Sliedr
                
                let widdth = reader.frame(in: .global).width / 2
                
                //knob or circle 旋鈕或圓形
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                    .offset(x: widdth - 50)
                    .rotationEffect(.init(degrees: dateModel.angle))
                    .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                    .rotationEffect(.init(degrees: -90))
                
                
                
                ForEach(1...12,id:\.self){index in
                    
                    VStack {
                        Text("\(dateModel.changeToMin ? index * 5 : index)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        //向後看內部視圖
                            .rotationEffect(.init(degrees: Double(-index) * 30))
                    }
                    .offset(y: -widdth + 50)
                    // 12個數字旋轉
                    // 12*30
                    .rotationEffect(.init(degrees: Double(index) * 30))
                }
                
                //箭頭
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
                    .overlay(
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 2, height: widdth / 2)
                        
                        ,alignment: .bottom
                    )
                    .rotationEffect(.init(degrees: dateModel.angle))
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        //最大高度
        .frame(height: 300)
    }
    
    //手勢
    
    func onChanged(value: DragGesture.Value) {
        
        //getting angle
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // circle or knob size = 40
        // so radius = 20
        let radians = atan2(vector.dy - 20 , vector.dx - 20 )
        
        var angle = radians * 180 / .pi
        
        if angle < 0 { angle = 360 + angle }
        
        dateModel.angle = Double(angle)
        
        //禁止用分鐘
        if !dateModel.changeToMin{
            //對數值進行四捨五入
            let roundValue = 30 * Int(round(dateModel.angle / 30))
            
            dateModel.angle = Double(roundValue)
        }
        else{
            //更新分鐘
            let progress = dateModel.angle / 360
            dateModel.min = Int(progress * 60)
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        
        if !dateModel.changeToMin{
            //設定小時的值
            dateModel.hour = Int(dateModel.angle / 30)
            
            //更新picker到分鐘
            withAnimation{
                
                //設定為分鐘的值
                dateModel.angle = Double(dateModel.min * 6)
                dateModel.changeToMin = true
            }
        }
    }
}


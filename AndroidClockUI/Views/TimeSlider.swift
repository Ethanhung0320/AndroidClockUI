//
//  TimeSlider.swift
//  AndroidClockUI
//
//  Created by Ethan Hung on 2024/6/16.
//
import SwiftUI

struct TimeSlider: View {
    @EnvironmentObject var dateModel: DateViewModel
    var body: some View {
        GeometryReader {reader in
            ZStack{
                let widdth = reader.frame(in: .global).width / 2
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
                            .frame(width: 2, height: widdth / 2),alignment: .bottom
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
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
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

//
//  DateViewModel.swift
//  AndroidClockUI
//
//  Created by Ethan Hung on 2024/6/16.
//

import SwiftUI

class DateViewModel: ObservableObject {
    @Published var selectDate = Date()
    @Published var showPicker = false
    @Published var hour: Int = 12
    @Published var min: Int = 0
    @Published var changeToMin = false
    @Published var symbol = "AM"
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
        hour = calender.component(.hour, from: selectDate)
        symbol = hour <= 12 ? "AM" : "PM"
        hour = hour == 0 ? 12 : hour
        hour = hour <= hour ? hour : hour - 12
        min = calender.component(.minute, from: selectDate)
        angle = Double(hour * 30)
    }
}

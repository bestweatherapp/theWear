//
//  Weather.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 25.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import Foundation

class Current : Methods
{
    var datetime: String?
    var temp : Double?
    var condition : String?
    var wind_speed : Double?
    var wind_dir : String?
    var feelslike : Double?
    var iconURL : String?
    override init (){}
}

class ForecastCity : ReadingMethods
{
    var Current : Current?
    var AllForecastDay : [ForecastDay]?
    init(Current : Current, ForecastDay : [ForecastDay]) {
        self.Current = Current
        self.AllForecastDay = ForecastDay
    }
    override init (){}
}
class ForecastHour
{
    var time : String?
    var condition : String?
    var temperature : Double?
    var pressure : Double?
    var will_it_rain : Int?// 1 ir 0
    var chance_of_rain : String?
    var will_it_snow : Int?//1 or 0
    var feelslike : Double?
    var humidity : Double?
    var icon : String?
    
    init (){}
}
class ForecastDay : Methods
{
    var date: String? = ""
    var condition : String?
    var avg_temp_c: Double?
    var temperature_max:Double?
    var temperature_min:Double?
    var temperature_avg:Double?
    var windSpeed_max:Double?
    var avghumidity: Double?
    var comment: String?
    var iconURL : String?
    var uv : Double?
    var AllHours :  [ForecastHour]?
    init(avg_temp_c : Double, date: String,temperature_avg:Double,temperature_max:Double,temperature_min:Double, windSpeed_max:Double, iconURL : String, avghumidity: Double,  comment: String, condition : String, uv : Double, forecastHours : [ForecastHour])
    {
        self.avg_temp_c = avg_temp_c
        self.condition = condition
        self.temperature_avg=temperature_avg
        self.temperature_max=temperature_max
        self.temperature_min=temperature_min
        self.windSpeed_max=windSpeed_max
        self.avghumidity=avghumidity
        self.comment=comment
        self.uv = uv
        self.iconURL = iconURL
        AllHours = forecastHours
    }
    override init(){}
}

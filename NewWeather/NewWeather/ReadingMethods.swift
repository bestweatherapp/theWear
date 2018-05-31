//
//  ReadingMethods.swift
//  NewWeather
//
//  Created by Maxim Reshetov on 31.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import Foundation

class ReadingMethods
{
    // нет вхождения !!!!!!!!!!!!!!!!!!!!!!!!!
    func GetWeatherData (city : String)-> (Bool, ForecastCity, [String], [Double])
    {
        var Result = ForecastCity()
        var allDates = [String]()
        var allTempsdays = [Double]()
        var errorHasOccured: Bool = false
        var current_ = Current()
        var defaultAllDays = [ForecastDay]()
        var ResultForecastCity = ForecastCity(Current: current_ , ForecastDay: defaultAllDays)
        let urlString2 = "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(city)&days=7"
        let url2 = URL(string: urlString2)
        let task2 = URLSession.shared.dataTask(with: url2!)
        {
            [weak self](data, response, error) in
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    as! [String : AnyObject]
                let current = json["current"] as? [String : AnyObject]
                current_.temp = current!["temp_c"] as? Double
                current_.datetime = current!["last_updated"] as? String
                if let condition = current!["condition"] as? [String : AnyObject]
                {
                    current_.condition = condition["text"] as? String
                }
                current_.feelslike = current!["feelslike_c"] as? Double
                current_.wind_dir = current!["wind_dir"] as? String
                current_.wind_speed = current!["wind_kph"] as? Double
                current_.wind_speed = round(current_.wind_speed! * 5/18)
                ResultForecastCity.Current = current_
                let forecast = json["forecast"] as? [String: AnyObject]
                let forecastday = forecast!["forecastday"] as? [AnyObject]
                var allDays = [ForecastDay]()
                for index in 0...6
                {
                    let day1 = forecastday![index] as? [String : AnyObject]
                    var allhoursForDay = [AnyObject]()
                    //поля для forecastday
                    let day = day1!["day"] as? [String : AnyObject]
                    
                    var date_ = day1!["date"] as? String //об
                    var dateparts = date_?.components(separatedBy: "-")
                    date_ = dateparts![2] + "." + dateparts![1]
                    // self?.allDatas.append(date_!)
                    allDates.append(date_!)
                    let comment_ = ""
                    let maxtemp_ = day!["maxtemp_c"] as? Double//
                    let mintemp_ = day!["mintemp_c"] as? Double
                    let avgtemp_ = day!["avgtemp_c"] as? Double
                    allTempsdays.append(avgtemp_!)
                    // self?.allTemps.append(avgtemp_!)
                    let wind_max_ = (day!["maxwind_kph"] as? Double)! * 5/18
                    let avghum_ = day!["avghumidity"] as? Double
                    var uv_ = day!["uv"] as? Double
                    
                    let text = day!["condition"] as? [String: AnyObject]
                    let condition_ = text!["text"] as? String
                    let hoursArr = day1!["hour"] as? [AnyObject]
                    var counter = 24 // days
                    for object in hoursArr!
                    {
                        if counter>0
                        {
                            var newHour = ForecastHour()
                            let time = object["time"] as? String
                            var timeArr = time!.split(separator: " ")
                            newHour.time = String(timeArr[1])
                            newHour.feelslike = object["feelslike_c"] as? Double
                            newHour.humidity =  object["humidity"] as? Double
                            newHour.pressure =  object["pressure_mb"] as? Double
                            let text = object["condition"] as? [String : AnyObject]
                            newHour.condition = text!["text"] as? String
                            newHour.icon = text!["icon"] as? String
                            
                            newHour.temperature = object["temp_c"] as? Double
                            newHour.chance_of_rain = object["chance_of_rain"] as? String
                            newHour.will_it_rain = object["will_it_rain"] as? Int
                            newHour.will_it_snow = object["will_it_snow"] as? Int
                            allhoursForDay.append(newHour)
                            counter = counter-1
                        }
                    }
                    var newDay = ForecastDay(avg_temp_c: avgtemp_!, date: date_!,temperature_avg: avgtemp_!, temperature_max: maxtemp_!, temperature_min: mintemp_!, windSpeed_max: wind_max_, avghumidity: avghum_!, comment: comment_, condition: condition_!, uv: uv_!, forecastHours: allhoursForDay as! [ForecastHour])
                    newDay.date = date_!
                    print(newDay.date)
                    allDays.append(newDay)
                    ResultForecastCity.AllForecastDay = allDays
                }
                // var Result = ForecastCity(Current: current_, ForecastDay: allDays)
            }
            catch let jsonError {
                print(jsonError)
            }
            DispatchQueue.main.async
                {
                    print ("Getting data")
            }
        }
        task2.resume()
        return (errorHasOccured, ResultForecastCity, allDates, allTempsdays)
    }
    
}



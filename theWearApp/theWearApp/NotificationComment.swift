//
//  NotificationComment.swift
//  theWearApp
//
//  Created by Валентина on 11.06.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import Foundation
import CoreLocation


func NotificationComment(location: String, session : URLSession )-> String {
    
    //var allDates = [String]()
    var comment = ""// Add new var for all comments
   // var allClothesForForecastTableView = [[String]]()
   // var allClothesForDetailedView = [[String]]()
    var allTempsdays = [String]()
    //var allTempsdaysIcons = [String]()
    var allHours = [String]()
   // var allHourlyTemps = [String]()
   // var allHourlyTempsIcons = [String]()
    let current_ = Current()
    let currentLocation : CLLocation!
    var locationManager = CLLocationManager()
    currentLocation = locationManager.location
    
    if (currentLocation != nil)
    {
        //
        let correctLocation = location.replacingOccurrences(of: " ", with: "%20")
        let urlString = (location == "Current location") ? "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(String(describing: currentLocation.coordinate.latitude)),\(String(describing: currentLocation.coordinate.longitude))&days=7" : "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(correctLocation)&days=7"
        guard let url = URL(string: urlString) else { return "" }
        
        DispatchQueue.global(qos: .background).async {
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("returned error")
                return
            }
            guard let data = data else { return }
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            guard let current = json["current"] as?  [String : AnyObject] else {return}
            current_.temp = current["temp_c"] as? Double
            current_.datetime = current["last_updated"] as? String
            guard let condition = current["condition"] as? [String : AnyObject] else {return}
            current_.condition = condition["text"] as? String
            current_.status = condition["code"] as? Int
            current_.iconURL = condition["icon"] as? String
            current_.feelslike = current["feelslike_c"] as? Double
            current_.wind_dir = current["wind_dir"] as? String
            current_.wind_speed = current["wind_kph"] as? Double
            current_.wind_speed = round(current_.wind_speed! * 5/18)
            guard let forecast = json["forecast"] as? [String: AnyObject] else {return}
            let forecastday = forecast["forecastday"] as! [AnyObject]
            var allDays = [ForecastDay]()
                guard let day1 = forecastday[0] as? [String : AnyObject] else {return}
                var allhoursForDay = [AnyObject]()
                guard let day = day1["day"] as? [String : AnyObject] else {return}
                let date_ = day1["date"] as? String
                var comment_: (String, [String]) = ("", [String]())
                guard let maxtemp_ = day["maxtemp_c"] as? Double else {return}
                guard let mintemp_ = day["mintemp_c"] as? Double else {return}
                guard let avgtemp_ = day["avgtemp_c"] as? Double else {return}
                guard var wind_max_ = day["maxwind_kph"] as? Double? else {return}
                wind_max_ = (wind_max_!) * 5/18
                guard let avghum_ = day["avghumidity"] as? Double else {return}
                guard let uv_ = day["uv"] as? Double else {return}
                guard let text = day["condition"] as? [String: AnyObject] else {return}
                guard let condition_ = text["text"] as? String else {return}
                guard let iconUrl  = text["icon"] as? String else {return}
               // allTempsdaysIcons.append("https:" + iconUrl)
                guard let astro = day1["astro"] as? [String: AnyObject] else {return}
                guard var sunrise = astro["sunrise"] as? String? else {return}
                sunrise = convertDateFormaterForSunsetAndSunrise(sunrise!)
                guard var sunset = astro["sunset"] as? String? else {return}
                sunset = convertDateFormaterForSunsetAndSunrise(sunset!)
                guard let hoursArr = day1["hour"] as? [AnyObject] else {return}
                var counter = 24 // days
                for object in hoursArr {
                    if counter>0 {
                        let newHour = ForecastHour()
                        guard let time = object["time"] as? String else {return}
                        var timeArr = time.split(separator: " ")
                        newHour.time = String(timeArr[1])
                        newHour.feelslike = object["feelslike_c"] as? Double
                        newHour.humidity = object["humidity"] as? Double
                        newHour.pressure = object["pressure_mb"] as? Double
                        guard let text = object["condition"] as? [String : AnyObject] else {return}
                        newHour.condition = text["text"] as? String
                        newHour.icon = text["icon"] as? String
                        
                        newHour.temperature = object["temp_c"] as? Double
                        newHour.chance_of_rain = object["chance_of_rain"] as? String
                        newHour.will_it_rain = object["will_it_rain"] as? Int
                        newHour.will_it_snow = object["will_it_snow"] as? Int
                        allhoursForDay.append(newHour)
                        counter -= 1
                    }
                }
                let methods = Methods()
                var realComment = ""
                let newDay = ForecastDay(avg_temp_c: avgtemp_, date: date_!, temperature_avg: avgtemp_, temperature_max: maxtemp_, temperature_min: mintemp_, windSpeed_max: wind_max_!, iconURL: iconUrl, avghumidity: avghum_, comment: realComment, condition: condition_, uv: uv_, forecastHours: allhoursForDay as! [ForecastHour], sunset : sunset!, sunrise : sunrise!)
           
                if (UserDefaults.standard.string(forKey: "Gender") != nil)
                { comment_ = methods.GetFutureComment(day: newDay, avgmorning: newDay.AllHours![9].temperature!, avgday: newDay.AllHours![15].temperature!, avgevening: newDay.AllHours![21].temperature!, gender: UserDefaults.standard.string(forKey: "Gender")!)}
                else
                { comment_ = methods.GetFutureComment(day: newDay, avgmorning: newDay.AllHours![9].temperature!, avgday: newDay.AllHours![15].temperature!, avgevening: newDay.AllHours![21].temperature!, gender: "Man")
                    UserDefaults.standard.setValue("Man", forKey: "Gender")
                }
              comment = comment_.0
        
        }
        task.resume()
        }
    }
    return comment
}

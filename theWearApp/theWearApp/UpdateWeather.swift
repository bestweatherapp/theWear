
import Foundation
import CoreLocation

let locationManager = CLLocationManager()



func UpdateWeather(location: String, completion: @escaping (_ avgPress: [Double], _ allCommentsForDV: [String], _ allClothesForForecastTV: [[String]], _ allClothesForDV: [[String]], _ allDates: [String], _ allTemps: [String], _ allTempsIcons: [String], _ allHours: [String], _ forecastCity: ForecastCity, _ allHourlyTempsIcons: [String], _ allHourlyTemps: [String], _ allDays: [ForecastDay], _ current: Current, _ hour: Int) -> ()) -> Bool {
    
    var allDates = [String]()
    var allCommentsForDetailedView = [String]() // Add new var for all comments
    var allClothesForForecastTableView = [[String]]()
    var allClothesForDetailedView = [[String]]()
    var allTempsdays = [String]()
    var allTempsdaysIcons = [String]()
    var allHours = [String]()
    var allHourlyTemps = [String]()
    var allHourlyTempsIcons = [String]()
    let current_ = Current()
    var averagePressures = [Double]()
    let currentLocation : CLLocation!
    let hour = Calendar.current.component(.hour, from: Date()) // Current Hour
    currentLocation = locationManager.location
    
    if (currentLocation != nil) {
        let correctLocation = location.replacingOccurrences(of: " ", with: "%20")
        let urlString = (location == "Current location") ? "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(String(describing: currentLocation.coordinate.latitude)),\(String(describing: currentLocation.coordinate.longitude))&days=7" : "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(correctLocation)&days=7"
        guard let url = URL(string: urlString) else { return false }
        
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
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
            for index in 0...6 {
                guard let day1 = forecastday[index] as? [String : AnyObject] else {return}
                var allhoursForDay = [AnyObject]()
                
                guard let day = day1["day"] as? [String : AnyObject] else {return}
                let date_ = day1["date"] as? String
                if index == 0 {
                    allDates.append("Today\n\(convertDateFormaterForDailyForecastForDate(date_!))")
                } else {
                    allDates.append("\(convertDateFormaterForDailyForecastForDateDescription(date_!))\n\(convertDateFormaterForDailyForecastForDate(date_!))")
                }
                var comment_: (String, [String]) = ("", [String]())
                
                guard var maxtemp_ = day["maxtemp_c"] as? Double else {return}
                guard var mintemp_ = day["mintemp_c"] as? Double else {return}
                guard var avgtemp_ = day["avgtemp_c"] as? Double else {return}
                
                guard var wind_max_ = day["maxwind_kph"] as? Double? else {return}
                wind_max_ = (wind_max_!) * 5/18
                guard let avghum_ = day["avghumidity"] as? Double else {return}
                guard let uv_ = day["uv"] as? Double else {return}
                guard let text = day["condition"] as? [String: AnyObject] else {return}
                guard let condition_ = text["text"] as? String else {return}
                guard let iconUrl  = text["icon"] as? String else {return}
                allTempsdaysIcons.append("https:" + iconUrl)
                guard let astro = day1["astro"] as? [String: AnyObject] else {return}
                guard var sunrise = astro["sunrise"] as? String? else {return}
                sunrise = convertDateFormaterForSunsetAndSunrise(sunrise!)
                guard var sunset = astro["sunset"] as? String? else {return}
                sunset = convertDateFormaterForSunsetAndSunrise(sunset!)
                guard let hoursArr = day1["hour"] as? [AnyObject] else {return}
                var counter = 24 // days
                var avg = 0.0
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
                        avg += newHour.pressure!
                        counter -= 1
                    }
                }
                averagePressures.append(avg / 24)
                let methods = Methods()
                var realComment = ""
                let newDay = ForecastDay(avg_temp_c: avgtemp_, date: date_!, temperature_avg: avgtemp_, temperature_max: maxtemp_, temperature_min: mintemp_, windSpeed_max: wind_max_!, iconURL: iconUrl, avghumidity: avghum_, comment: realComment, condition: condition_, uv: uv_, forecastHours: allhoursForDay as! [ForecastHour], sunset : sunset!, sunrise : sunrise!)
                if (UserDefaults.standard.string(forKey: "Gender") != nil)
                { comment_ = methods.GetFutureComment(day: newDay, avgmorning: newDay.AllHours![9].temperature!, avgday: newDay.AllHours![15].temperature!, avgevening: newDay.AllHours![21].temperature!, gender: UserDefaults.standard.string(forKey: "Gender")!)}
                else
                {comment_ = methods.GetFutureComment(day: newDay, avgmorning: newDay.AllHours![9].temperature!, avgday: newDay.AllHours![15].temperature!, avgevening: newDay.AllHours![21].temperature!, gender: "Man")
                    UserDefaults.standard.setValue("Man", forKey: "Gender")
                }
                if UserDefaults.standard.string(forKey: "Gender") == "Man" {
                    let iconsClothesNight = methods.ClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(0,6))
                    let iconsClothesMorning = methods.ClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(6,12))
                    let iconsClothesDay = methods.ClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(12,18))
                    let iconsClothesEvening = methods.ClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(18,23))
                    allClothesForDetailedView.append(iconsClothesNight)
                    allClothesForDetailedView.append(iconsClothesMorning)
                    allClothesForDetailedView.append(iconsClothesDay)
                    allClothesForDetailedView.append(iconsClothesEvening)
                } else {
                    let iconsClothesNight = methods.WomenClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(0,6))
                    let iconsClothesMorning = methods.WomenClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(6,12))
                    let iconsClothesDay = methods.WomenClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(12,18))
                    let iconsClothesEvening = methods.WomenClothingForPartOfTheDay(allhours: newDay.AllHours!, bounds:(18,23))
                    allClothesForDetailedView.append(iconsClothesNight)
                    allClothesForDetailedView.append(iconsClothesMorning)
                    allClothesForDetailedView.append(iconsClothesDay)
                    allClothesForDetailedView.append(iconsClothesEvening)
                }
                realComment = comment_.0
                allClothesForForecastTableView.append(comment_.1)
                allCommentsForDetailedView.append(realComment)
                if (allCommentsForDetailedView[0] == " ") {
                    allCommentsForDetailedView.remove(at: allCommentsForDetailedView.startIndex)
                    
                }
                if (UserDefaults.standard.integer(forKey: "Temperature") == 0) {
                    allTempsdays.append("\(Int(round(newDay.AllHours![12].temperature!)))°C  \(Int(round(newDay.AllHours![0].temperature!)))°C")
                } else {
                    allTempsdays.append("\(Int(round(newDay.AllHours![12].temperature! * 9/5 + 32)))°F  \(Int(round(newDay.AllHours![0].temperature! * 9/5 + 32)))°F")
                }
                
                newDay.date = date_!
                allDays.append(newDay)
            }
            if (hour) > 12 {
                for i in (hour)..<24 {
                    allHours.append("\(i):00")
                    allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                    allHourlyTempsIcons.append("https:" + allDays[0].AllHours![i].icon!)
                }
                if 24-(hour) < 12 {
                    for i in 0...12-(24-(hour)) {
                        allHours.append("\(i):00")
                        allHourlyTemps.append("\(String(describing: Int(round(allDays[1].AllHours![i].temperature!))))°C")
                        allHourlyTempsIcons.append("https:" + allDays[1].AllHours![i].icon!)
                    }
                }
            } else {
                for i in (hour)..<(hour)+12 {
                    allHours.append("\(i):00")
                    allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                    allHourlyTempsIcons.append("https:" + allDays[0].AllHours![i].icon!)
                }
            }
            if (UserDefaults.standard.integer(forKey: "Temperature") == 0) { } else {
                for i in 0..<allHourlyTemps.count {
                    let f: Int = (Int(allHourlyTemps[i].dropLast(2))! * 9/5) + 32
                    allHourlyTemps[i] = "\(Int(f))°F"
                }
                current_.temp = current_.temp! * 9/5 + 32
            }
            
             completion(averagePressures, allCommentsForDetailedView, allClothesForForecastTableView, allClothesForDetailedView, allDates, allTempsdays, allTempsdaysIcons, allHours, ForecastCity(Current: current_, ForecastDay: allDays), allHourlyTempsIcons, allHourlyTemps, allDays, current_, hour)
            myGroup.leave()            
        }
        task.resume()
        return true
    }
    return true
}

//
//  Methods.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 25.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import Foundation
class Methods
{
    func GetCurrentComment (Current : Current, day : ForecastDay) -> String {
        var comment_ = ""
        switch (Double(Current.temp!)) {
        case -1..<10:
            switch (Double(Current.wind_speed!))
            {
            case 0..<4.5:
                comment_ += "Feels slightly cooler than it seems. "
            case 4.5..<8.9:
                comment_ += " Feels cooler than it seems."
            default:
                comment_ += " Feels considerably colder than it seems."
            }
        default:
            comment_ += ""
        }
        switch (Int(Current.feelslike!)){
        case -50 ..< -30:
            comment_ += " Extremely cold. Avoid being outside unless dressed properly! "
        case -30 ..< -10:
            comment_ += " Very cold. Dress warmly! "
        case -10 ..< -5:
            comment_ +=  " Frosty weather, put on your coat, scarf and gloves. "
        case -5 ..< -3:
            comment_ +=  " Frosty weather, put on your coat. "
        case 0..<3:
            comment_ += " Mind the freezing! Stay warm, put on a coat. "
        case 3..<7:
            comment_ += " Quite cool, put on a coat. "
        case 7..<13:
            comment_ += " Comfortable weather, put on a jacket. "
        case 13..<18:
            comment_ += " Quite warm, put on a hoodie and jeans. "
        case 18..<20:
            comment_ += " Warm weather, put on a longsleeve and jeans. "
        case 20..<23:
            comment_ += " Comfortable warm weather, put on shirt. "
        case 23..<25:
            comment_ += " Comfortable warm weather, put on a t-shirt and jeans. "
        case  25..<35:
            comment_ += " Hot weather, better put on a t-shirt and shorts  "
        case 30..<50:
            comment_ += " Extremely hot! Put on the lightest clothes. "
        default:
            comment_ = " There is no comment "
        }
        switch (Current.wind_speed!)
        {
        case 7...9:
            comment_ += " Mind strong wind!"
        case 9...20:
            comment_ += " Mind very strong wind! "
        case 20...50:
            comment_ += " Extremely strong wind! "
            default: comment_ += ""
        }
        if (day.uv! > 6.5 && day.uv! < 8)
        {
            comment_ += " High UV."
        }
        if (day.uv! > 8  )
        {
            comment_ += " Very high UV!"
        }
        return comment_
    }
    
    
    func GetThunderComment (forecastday : ForecastDay)-> String
    {
        var comment = ""
        var thunderanytime = false
        var rainanytime = false
        for element in forecastday.AllHours!
        {
            if (thunderanytime == false)
            {
                if ((element.condition!.range(of: "thunder")) != nil) || ((element.condition! == "Thundery outbreaks possible, be careful"))
                {
                    thunderanytime = true
                    comment += "Don't forget your umbrella!"
                }
            }
        }
        for element in forecastday.AllHours!{
            if ((element.condition!.range(of: "rain")) != nil) || (element.condition! == "Light rain") || ((element.condition! == "Heavy rain"))
            {
                if (rainanytime == false) && (thunderanytime == false){
                    rainanytime = true
                    comment += " Don't forget your umbrella!"}
            }
        }
        return comment
    }
    
    
    func GetFutureComment (day: ForecastDay, avgmorning : Double, avgday : Double, avgevening : Double) -> String {
        var comment = ""
        // TODO: Поместить под Forecast For Label
       // comment += day.condition!
        //comment += " "
        switch Int((day.temperature_avg)!)
        {
        case -40 ..< -30 :
            comment += " Extremely cold! Avoid being outside unless dressed up properly! "
        case -30 ..< -10:
            comment += " Very cold weather. Put on all the warmes clothes and don't say outside for too much. "
        case -10 ..< -5:
            comment +=  " Cold frosty weather. Put on a winter coat, scarf and gloves. "
        case -5 ..< -3:
            comment +=  " Feels cold and freezing. Put on a coat. "
        case -3 ..< 0:
            comment += " Freezing weather. Dress warmly. "
        case 0..<3 where Int(day.avghumidity!)>70:
            comment += " Freezing and humid weather. Put on a coat, gloves and a scarf.  "
        case 0..<3 :
            comment += " Freezing and humid weather. Put on a coat. "
        case 3..<7 where Int(day.avghumidity!)>70:
            comment += " Feels cool and humid. Put on a coat and probably a scarf. "
        case 3..<7:
            comment += " Feels cool, put on a coat "
        case 7..<13:
            comment += " Comfortable cool weather. Put on a jacket. "
        case 13..<18:
            comment += " Feels warm, probably put on a hoodie and jeans. "
        case 18..<20:
            comment += " Feels warm, probably put on a longsleeve and jeans. "
        case 20..<23:
            comment += " Feels warm, probably put on a shirt and jeans "
        case 23..<25:
            comment += " Comfortable warm weather. Put on a T-shirt and jeans. "
        case  25..<35:
            if (Int((day.temperature_avg)!) > 29) && (Int(day.avghumidity!) > 70)
            {
                comment += " Very hot outside. Mind the dehydration! Put on a t-shirt and shorts. "
            }
            else { comment += " Very hot outside. Mind the sunstroke, please! "}
        case 35..<43:
            if (Int(day.avghumidity!)>30)
            {
                comment += " Enormously hot, might be unbearable. Avoid being outside for too long! Don't wear dark colors.  "
            }
            else { comment += " Extremely hot. Be careful and avoid the sunlight. Don't wear dark colors."}
        case 43..<50:
            comment += " Enormously hot. Mind the risk of a sunstroke. Avoid being outside! Put on the lighest clothes. "
        default:
            comment = "There is no comment "
        }
        var thundermorning = false
        var thunderday = false
        var thunderevening = false
        var thundernight = false
        var nightflag = false
        var morningflag = false
        var dayflag = false
        var eveningflag = false
        for element in day.AllHours!
        {
            var date = element.time?.components(separatedBy: " ")
            //   var comp =
            var time = Int(date![0].components(separatedBy: ":")[0])
            if (element.condition! == "Thundery outbreaks possible")
            {
                switch (time!)
                {
                case 0..<6:
                    if (thundernight == false){
                        
                        thundernight = true
                        break
                    }
                case 6..<12:
                    if (thundermorning == false){
                        thundermorning = true
                        break}
                case 12..<18:
                    if (thunderday == false){
                        thunderday = true
                        break}
                default:
                    if (thunderevening == false){
                        thunderevening = true
                        break
                    }
                }
                
            }
        }
        for element in day.AllHours!{
            var date = element.time?.components(separatedBy: " ")
            //   var comp =
            var time = Int(date![0].components(separatedBy: ":")[0])
            if (Int(element.chance_of_rain!)! > 70)
            {
                switch (time!)
                {
                case 0..<6:
                    if (nightflag == false){
                        
                        nightflag = true
                        break
                    }
                case 6..<12:
                    if (morningflag == false){
                        morningflag = true
                        break}
                case 12..<18:
                    if (dayflag == false){
                        dayflag = true
                        break}
                default:
                    if (eveningflag == false){
                        eveningflag = true
                        break
                    }
                }
            }
            else {comment += ""}
        }//Логика для вывода грозы
        if (thundermorning && thunderday && thunderevening)
        {
            comment += " Thunders during all day. "
        }
        else if (thundermorning && thunderday)
        {
            comment += " Thunders in the first part of the day. "
        }
        else if (thunderevening && thundernight)
        {
            comment += " Thunders in the second part of the day. "
        }
        else if (thundermorning)
        {
            comment += " Mind thunders in the morning! "
        }
        else if (thunderday)
        {
            comment += " Mind thunders in the afternoon! "
        }
        else if (thunderevening)
        {
            comment += " Mind thunders in the evening! "
        }
        else {
            if (dayflag && morningflag && eveningflag)
            {
                comment += " Rain possible during all the day. Don't forget your umbrella! "
            }
            else if (dayflag && morningflag)
            {
                comment += " Rain  possible in the first the day. Don't forget your umbrella! "
            }
            else if (eveningflag && nightflag)
            {
                comment += " Rain possible in the second the day. Don't forget your umbrella!"
            }
            else if (morningflag)
            {
                comment += " Rain possible in the morning, take an umbrella. "
            }
            else if (dayflag)
            {
                comment += " Rain possible in the afternoon, take an umbrella. "
            }
            else if (eveningflag)
            {
                comment += " Rain possible in the evening, take an umbrella. "
            }
        }
        if (avgday - avgmorning > 5 )
        {
            if (avgday < 20)
            {comment += " Significantly warmer in the afternoon "}
            else
            {comment += " Significantly hotter in the afternoon  "}
        }
        if (avgevening - avgday > 5) && (avgday > 5)
        {
            comment += " Evening will be cooler "
        }
        if (Int(day.uv!) > 8 )//проверка!!! Анадырь 3999
        {
            comment += " Mind high UV index. Don't forget about sun-protecting products "
        }
        if (day.temperature_max! - day.temperature_min! > 12)
        {
            comment += " Considerable temperature difference possible. "
        }
        if (day.windSpeed_max! > 10 && day.windSpeed_max! < 20 )
        {
            comment += " Mind string wind! "
        }
        if (day.windSpeed_max! > 20)
        {
            comment += " Mind very strong wind! "
        }
        return comment
    }
    func ContainsCyrillyc (text : String)-> (Bool)
    {
        var index : [Int]
        let characters = CharacterSet(charactersIn: "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЮЯабвгдежзийклмнопрстуфхцчшщьюя")
        if text.rangeOfCharacter(from: characters) != nil {
            
            print("yes")
            return true
        }
        return false
    }
}



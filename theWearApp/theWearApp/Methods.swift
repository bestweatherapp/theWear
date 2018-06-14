//
//  Methods.swift
//  theWearApp

//  Created by Maxim Reshetov on 25.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import Foundation
class Methods
{
    func GetCurrentComment(Current : Current, day : ForecastDay) -> String {
        var comment_ = ""
        switch (Double(Current.temp!)) {
        case -1..<10:
            switch (Double(Current.wind_speed!))
            {
            case 0..<4.5:
                comment_ += "Feels slightly cooler than it seems. "
            case 4.5..<10:
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
            comment_ = " There is no comment " }
        switch (Current.wind_speed!)
        { case 7...9:
            comment_ += " Mind strong wind! "
        case 9...20:
            comment_ += " Mind very strong wind! "
        case 20...50:
            comment_ += " Extremely strong wind! "
            default: comment_ += ""  }
        if (day.uv! > 6.5 && day.uv! < 8)
        {comment_ += " High UV. " }
        if (day.uv! > 8  )
        { comment_ += " Very high UV! " }
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
                if ((element.condition!.range(of: "thunder")) != nil) || ((element.condition! == "Thundery outbreaks possible, be careful "))
                {thunderanytime = true
                comment += "Don't forget your umbrella! "
                    return comment
                }
            }
        }
        if (RainOrThunderAnyTime(forecastday: forecastday)) {  comment += " Don't forget your umbrella! "}
     
        return comment
    }
    //FUTURE and current clothes
    func GetFutureComment(day: ForecastDay, avgmorning : Double, avgday : Double, avgevening : Double, gender: String) -> (String,[String]) {
        var comment = ""
        var images = [String]()
        var correctTemp = Int((day.temperature_avg)!)
        if UserDefaults.standard.integer(forKey: "Grimy") == 10 {
            correctTemp -= 1
        } else if UserDefaults.standard.integer(forKey: "Grimy") == 0 {
            correctTemp += 1
        } else {
            
        }
        switch correctTemp
        {
        case -70 ..< -30 :
            comment += " Extremely cold! Avoid being outside unless dressed up properly! "
            if (gender == "Man"){
            images.append("coat_winter")
            images.append("jeans")
            images.append("uggi")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")}
            else { images.append("jacket")
                images.append("slim-fit-pants")
                images.append("uggi")
                images.append("cap")
                images.append("gloves")
                images.append("scarf")}
        case -30 ..< -10:
            comment += " Very cold weather. Put on all the warmes clothes and don't say outside for too much. "
            if (gender == "Man"){
            images.append("coat_winter")
            images.append("jeans")
            images.append("uggi")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")}
            else{images.append("jacket")
                images.append("slim-fit-pants")
                images.append("uggi")
                images.append("cap")
                images.append("gloves")
                images.append("scarf")}
        case -10 ..< -5:
            comment +=  " Cold frosty weather. Put on a winter coat, scarf and gloves. "
            if (gender == "Man"){
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")}
            else{ images.append("coat-4")
                images.append("slim-fit-pants")
                images.append("uggi")
                images.append("cap")
                images.append("gloves")
                images.append("scarf")}
        case -5 ..< -3:
            comment +=  " Feels cold and freezing. Put on a coat and a cap. "
            if (gender == "Man"){
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
            images.append("cap")}
            else{ images.append("coat-4")
                images.append("slim-fit-pants")
                images.append("women-boot")
                images.append("cap")}
        case -3 ..< 0:
            comment += " Freezing weather. Dress warmly, put on a coat and probably a cap. "
            if (gender == "Man"){
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
            images.append("cap")}
            else{}
        case 0..<3 where Int(day.avghumidity!)>70:
            comment += " Freezing and humid weather. Put on a coat, gloves and a scarf.  "
            if (gender == "Man"){
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
             images.append("gloves")
            images.append("scarf")}
            else{images.append("coat-4")
                images.append("slim-fit-pants")
                images.append("women-boot")
                images.append("cap")}
        case 0..<3 :
            comment += " Freezing and humid weather. Put on a coat and jeans. "
            if (gender == "Man"){
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")}
            else{  images.append("coat-4")
                images.append("slim-fit-pants")
                images.append("women-boot")}
        case 3..<7 where Int(day.avghumidity!)>70:
            comment += " Feels cool and humid. Put on a coat and probably a scarf. "
            if (gender == "Man"){
            images.append("jacket")
            images.append("jeans")
            images.append("snickers")}
            else{  images.append("women-coat")
                images.append("slim-fit-pants")
                images.append("women-boot")}
        case 3..<7:
            comment += " Feels cool, put on a jacket and jeans. "
            if (gender == "Man"){
            images.append("jacket_")
            images.append("jeans")
            images.append("sneakers")}
            else{     images.append("women-coat")
                images.append("slim-fit-pants")
                images.append("women-boot")}
        case 7..<13:
            comment += " Comfortable cool weather. Put on a jacket and jeans. "
            if (gender == "Man"){
            images.append("jacket")
            images.append("jeans")
            images.append("sneakers")}
            else{images.append("women-coat")
                images.append("slim-fit-pants")
                images.append("women-boot")}
        case 13..<18:
            comment += " Feels warm, probably put on a hoodie and jeans. "
            if (gender == "Man"){
            images.append("hoody")
            images.append("jeans")
            images.append("sneakers")}
            else{images.append("cotton-cardigan")
                images.append("slim-fit-pants")
                images.append("oxford-hell")}
        case 18..<20:
            comment += " Feels warm, probably put on a longsleeve and jeans. "
            if (gender == "Man"){
            images.append("longsleeve")
            images.append("jeans")
            images.append("sneakers")}
            else{ images.append("longsleeve")
                images.append("skirt-3")
                images.append("sneakers")}
        case 20..<23:
            comment += " Feels warm, probably put on a shirt and jeans. "
            if (gender == "Man"){
            images.append("shirt")
            images.append("jeans")
            images.append("sneakers")}
            else{images.append("women-vest")
                images.append("skirt-3")
                images.append("ballets-flats")}
        case 23..<25:
            comment += " Comfortable warm weather. Put on a T-shirt and jeans. "
            if (gender == "Man"){
            images.append("polo")
            images.append("jeans")
            images.append("sneakers")}
            else{ images.append("women-blouse")
                images.append("skirt-3")
                images.append("flat-shoes")}
        case  25..<35:
            if (correctTemp > 29) && (Int(day.avghumidity!) > 70)
            {
                comment += " Very hot outside. Mind the dehydration! Put on a t-shirt and shorts. "
                if (gender == "Man"){
                images.append("polo")
                images.append("chino-shorts")
                images.append("sneakers")}
                else{images.append("women-blouse")
                    images.append("skirt-2")
                    images.append("flat-shoes")}
            }
            else { comment += " Very hot outside. Mind the sunstroke, please! "
                if (gender == "Man"){
                images.append("polo")
                images.append("chino-shorts")
                images.append("sneakers")}
                else{images.append("women-blouse")
                    images.append("skirt-2")
                    images.append("flat-shoes")}
            }
        case 35..<43:
            if (Int(day.avghumidity!)>30)
            {
                comment += " Enormously hot, might be unbearable. Avoid being outside for too long! Don't wear dark colors.  "
                if (gender == "Man"){
                images.append("tshirt")
                images.append("chino-shorts")}
                else{images.append("women-blouse")
                    images.append("skirt-2")
                    images.append("flip-flops")}
//                images.append("flops")
            }
            else { comment += " Extremely hot. Be careful and avoid the sunlight. Don't wear dark colors."
                if (gender == "Man"){
                images.append("tshirt")
                images.append("chino-shorts")
                images.append("flops")}
                else{images.append("women-blouse")
                    images.append("skirt-2")
                    images.append("flip-flops")}
            }
        case 43..<100:
            comment += " Enormously hot. Mind the risk of a sunstroke. Avoid being outside! Put on the lighest clothes. "
            if (gender == "Man"){
            images.append("tshirt")
            images.append("chino-shorts")
            images.append("flops")}
            else{images.append("women-blouse")
                images.append("skirt-2")
                images.append("flip-flops")}
        default:
            comment = "There is no comment "
        }
        if (RainOrThunderAnyTime(forecastday: day) == true ) {images.append("umbrella")}
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
            let time = Int(date![0].components(separatedBy: ":")[0])
            if (element.condition! == "Thundery outbreaks possible")
            {
                switch (time!)
                {
                case 0..<6:
                        thundernight = true
                        break
                   
                case 6..<12:
                        thundermorning = true
                        break
                case 12..<18:
                  
                        thunderday = true
                        break
                case 18..<24:
                   
                        thunderevening = true
                        break
                  
                default : 1
                }
            }
        }
        for element in day.AllHours!{
            var date = element.time?.components(separatedBy: " ")
            let time = Int(date![0].components(separatedBy: ":")[0])
            if (Int(element.chance_of_rain!)! > 49)||(element.will_it_rain == 1)||(element.condition!.range(of: "rain") != nil)||(element.condition! == "Light rain")||(element.condition!.range(of: "rains") != nil)||(element.condition!.range(of: "sleet") != nil)||(element.condition!.range(of: "drizzle") != nil)||(element.condition!.range(of: "shower") != nil)||(element.condition! == "Heavy rain")||(element.condition!.range(of: "showers") != nil )
            {
                switch (time!)
                {
                case 0..<6:
                        nightflag = true
                        break
                case 6..<12:
                        morningflag = true
                        break
                case 12..<18:
                        dayflag = true
                        break
                case 18..<24:
                        eveningflag = true
                        break
                default:
                    1
                }
            }
            else {comment += ""}
        }//Логика для вывода грозы
        if (thunderday&&thundermorning&&thundernight&&thunderevening)||(thundernight&&thundermorning&&thunderday)||(thundermorning&&thunderday&&thunderevening)||(thunderday&&thunderevening&&thundernight)||(thundermorning&&thunderevening&&thundernight)
        {comment += "Thunders during all day. Be careful!"}
        else if (thunderday&&thundermorning)||(thunderday&&thunderevening)||(thunderevening&&thundermorning)
        {comment += "Mind possible thunders during the day"}
        else if (thundermorning)
        {comment += " Mind thunders in the morning."}
        else if (thunderday)
        {comment += " Mind thunders."}
        else if (thunderevening)
        {comment += " Mind thunders in the evening."}
        else if (thundernight)
        {comment += " Thunders possible."}
        else {
            if (dayflag&&morningflag&&eveningflag&&nightflag)||(nightflag&&morningflag&&dayflag)||(morningflag&&dayflag&&eveningflag)||(dayflag&&eveningflag&&nightflag)||(morningflag&&eveningflag&&nightflag)
            {comment += "Rains during all the day possible. "}
            else if (dayflag&&morningflag)||(dayflag&&eveningflag)||(eveningflag&&morningflag)
            { comment += " Mind possible rain during the day. "}
            else if (morningflag)
            {comment += " Mind rain in the morning. "}
            else if (dayflag)
            {comment += " Rain possible. "}
            else if (eveningflag)
            {comment += " Mind rains in the evening. "}
            else if (nightflag)
            {comment += " Thunders possible. "}
        }
        if (avgday - avgmorning > 6 )
        {
            if (avgday < 20)
            {comment += " Significantly warmer in the afternoon. "}
            else
            {comment += " Significantly hotter in the afternoon. "}
        }
        if (avgevening - avgday > 6) && (avgday > 5)
        {
            comment += " Evening will be cooler "
        }
        if (Int(day.uv!) > 8 )//проверка!!! Анадырь 3999
        {
            comment += " Mind high UV index. Don't forget about sun-protecting products "
            images.append("glasses")
        }
        if (day.temperature_max! - day.temperature_min! > 12)
        {
            comment += " Considerable temperature difference possible. "
        }
        if (day.windSpeed_max! > 10 && day.windSpeed_max! < 20 )
        {
            comment += " Mind strong wind! "
        }
        if (day.windSpeed_max! > 20)
        {
            comment += " Mind very strong wind! "
        }
        return (comment, images)
    }
    func ContainsCyrillyc (text : String)-> (Bool)
    {
        let characters =  "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
        let eng = Array(characters)
        let chars = Array(text)
        var flag = false
       for char in chars
        {if (!eng.contains(char))
        { flag = true
            return true  }}
        return false
    }
                
    func RainOrThunderAnyTime (forecastday : ForecastDay)-> Bool
    {
        var thunderanytime = false
        var rainanytime = false
        for element in forecastday.AllHours!
        {
            if (thunderanytime == false)
            {
                if ((element.condition!.range(of: "thunder")) != nil) || ((element.condition! == "Thundery outbreaks possible, be careful "))
                { thunderanytime = true} }
            }
        for element in forecastday.AllHours!{
            if ((element.condition!.range(of: "rain") != nil)||(element.condition! == "Light rain")||(element.condition!.range(of: "rains") != nil)||(element.condition!.range(of: "sleet") != nil)||(element.condition!.range(of: "drizzle") != nil)||(element.condition!.range(of: "shower") != nil)||(element.condition! == "Heavy rain")||(element.condition!.range(of: "showers") != nil )||(Int(element.chance_of_rain!)! > 49)||(element.will_it_rain == 1))
            { if (rainanytime == false) && (thunderanytime == false){
                    rainanytime = true } }   }
        return (rainanytime||thunderanytime)
    }
    func ClothingForPartOfTheDay (allhours:[ForecastHour],bounds: (Int,Int))->([String])
    {
        var images = [String]()
        var rainFlag = false
        let low = bounds.0
        let high = bounds.1
        var sum = 0.0
        for i in low...high
        {
            if (rainFlag == false && (allhours[i].will_it_rain == 1||Int(allhours[i].chance_of_rain!)!>49||allhours[i].condition!.range(of: "rain") != nil)||(allhours[i].condition!.range(of: "rains") != nil)||(allhours[i].condition!.range(of: "sleet") != nil)||(allhours[i].condition!.range(of: "drizzle") != nil)||(allhours[i].condition!.range(of: "shower") != nil)||(allhours[i].condition! == "Heavy rain")||(allhours[i].condition!.range(of: "showers") != nil ))
            { rainFlag = true     }
            sum += allhours[i].temperature!
        }
        sum = sum / Double(high-low)
        switch (sum)
        {
        case -40 ..< -30 :
            images.append("coat_winter")
            images.append("jeans")
            images.append("uggi")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")
        case -30 ..< -10:
            images.append("coat_winter")
            images.append("jeans")
            images.append("uggi")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")
        case -10 ..< -5:
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")
        case -5 ..< -3:
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
            images.append("cap")
        case -3 ..< 0:
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
            images.append("cap")
        case 0..<3 :
            images.append("coat-3")
            images.append("jeans")
            images.append("snickers")
        case 3..<7:
            images.append("jacket")
            images.append("jeans")
            images.append("sneakers")
        case 7..<13:
            images.append("jacket")
            images.append("jeans")
            images.append("sneakers")
        case 13..<18:
            images.append("hoody")
            images.append("jeans")
            images.append("sneakers")
        case 18..<20:
            images.append("longsleeve")
            images.append("jeans")
            images.append("sneakers")
        case 20..<23:
            images.append("shirt")
            images.append("jeans")
            images.append("sneakers")
        case 23..<25:
            images.append("polo")
            images.append("jeans")
            images.append("sneakers")
        case  25..<35:
                images.append("polo")
                images.append("chino-shorts")
                images.append("sneakers")
        case 35..<43:
                images.append("tshirt")
                images.append("chino-shorts")
                images.append("flops")
        case 43..<100:
            images.append("tshirt")
            images.append("chino-shorts")
            images.append("flops")
        default: 1 }
        if (rainFlag == true){images.append("umbrella")}
        return images
    }
    func WomenClothingForPartOfTheDay (allhours:[ForecastHour],bounds: (Int,Int))->([String])
    {
        var images = [String]()
        var rainFlag = false
        let low = bounds.0
        let high = bounds.1
        var sum = 0.0
        for i in low...high
        {
            if (rainFlag == false && (allhours[i].will_it_rain == 1||Int(allhours[i].chance_of_rain!)!>49||allhours[i].condition!.range(of: "rain") != nil)||(allhours[i].condition!.range(of: "rains") != nil)||(allhours[i].condition!.range(of: "sleet") != nil)||(allhours[i].condition!.range(of: "drizzle") != nil)||(allhours[i].condition!.range(of: "shower") != nil)||(allhours[i].condition! == "Heavy rain")||(allhours[i].condition!.range(of: "showers") != nil ))
            { rainFlag = true     }
            sum += allhours[i].temperature!        }
        sum = sum / Double(high-low)
        switch (sum)
        {
        case -40 ..< -30 :
            images.append("jacket")
            images.append("slim-fit-pants")
            images.append("uggi")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")
        case -30 ..< -10:
            images.append("jacket")
            images.append("slim-fit-pants")
            images.append("uggi")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")
        case -10 ..< -5:
            images.append("coat-4")
            images.append("slim-fit-pants")
            images.append("uggi")
            images.append("cap")
            images.append("gloves")
            images.append("scarf")
        case -5 ..< -3:
            images.append("coat-4")
            images.append("slim-fit-pants")
            images.append("women-boot")
            images.append("cap")
        case -3 ..< 0:
            images.append("coat-4")
            images.append("slim-fit-pants")
            images.append("women-boot")
            images.append("cap")
        case 0..<3 :
            images.append("coat-4")
            images.append("slim-fit-pants")
            images.append("women-boot")
        case 3..<7:
            images.append("women-coat")
            images.append("slim-fit-pants")
            images.append("women-boot")
        case 7..<13:
            images.append("women-coat")
            images.append("slim-fit-pants")
            images.append("women-boot")
        case 13..<18:
            images.append("cotton-cardigan")
            images.append("slim-fit-pants")
            images.append("oxford-hell")
        case 18..<20:
            images.append("longsleeve")
            images.append("skirt-3")
            images.append("sneakers")
        case 20..<23:
            images.append("women-vest")
            images.append("skirt-3")
            images.append("ballets-flats")
        case 23..<25:
            images.append("women-blouse")
            images.append("skirt-3")
            images.append("flat-shoes")
        case 25..<35:
            images.append("women-blouse")
            images.append("skirt-2")
            images.append("flat-shoes")
        case 35..<43:
            images.append("women-blouse")
            images.append("skirt-2")
            images.append("flip-flops")
        case 43..<100:
            images.append("women-blouse")
            images.append("skirt-2")
            images.append("flip-flops")
        default: 1
        }
        if (rainFlag == true){images.append("umbrella")}
        return images
    }
}


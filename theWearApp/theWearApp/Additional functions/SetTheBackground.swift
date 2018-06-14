
import Foundation

func SetTheBackground(status: Int, sunrise: String, currentHour: Int) -> String {
    var imageName = "none"
    let time = (currentHour < Int(sunrise.dropLast(3))!) ? "night" : "day"

    // if clear
    if status == 1000 && time == "day" {
        imageName = "sunny_day"
    } else if status == 1000 && time == "night" {
        imageName = "clear_night"
    }
    // if cloudy
    if (status == 1003 || status == 1006) && time == "day" {
        imageName = "IMG_2793"
    } else if (status == 1003 || status == 1006) && time == "night" {
        imageName = "cloudy_light_night"
    }
    // if Overcast
    if status == 1009 && time == "day" {
        imageName = "IMG_2791"
    } else if status == 1009 && time == "night" {
        imageName = "cloudy_light_night"
    }
    // if foggy or misty
    if (status == 1030 || status == 1135 || status == 1147) && time == "day" {
        imageName = "foggy_day"
    } else if (status == 1030 || status == 1135 || status == 1147) && time == "night" {
        imageName = "foggy_"
    }
    // if rain 
    if (status == 1063 || status == 1072 || status == 1150 || status == 1153 || status == 1168 || status == 1171 || status == 1180 || status == 1183 || status == 1186 || status == 1189 || status == 1192 || status == 1195 || status == 1198 || status == 1201 || status == 1240 || status == 1143 || status == 1146) && time == "day" {
        imageName = "rain_light_day"
    } else if (status == 1063 || status == 1072 || status == 1150 || status == 1153 || status == 1168 || status == 1171 || status == 1180 || status == 1183 || status == 1186 || status == 1189 || status == 1192 || status == 1195 || status == 1198 || status == 1201 || status == 1240 || status == 1143 || status == 1146) && time == "night" {
        imageName = "rain_light_night"
    }
    // if snow
    if (status == 1066 || status == 1069 || status == 1114 || status == 1204 || status == 1210 || status == 1213 || status == 1216 || status == 1219 || status == 1222 || status == 1225 || status == 1258 || status == 1255 || status == 1117) && time == "day" {
        imageName = "snow_light_day"
    } else if (status == 1066 || status == 1069 || status == 1114 || status == 1204 || status == 1210 || status == 1213 || status == 1216 || status == 1219 || status == 1222 || status == 1225 || status == 1258 || status == 1255 || status == 1117) && time == "night" {
        imageName = "snow_light_night"
    }
    // if thunder
    if status == 1087 {
        imageName = "thunder_night"
    }
    // if snow with thunder || rain with thunder
    if status == 1273 || status == 1276 || status == 1279 || status == 1282 {
        imageName = "thunder_light"
    }
    // if sleet
    if status == 1273 || status == 1249 || status == 1252 || status == 1261 || status == 1264 {
        imageName = "rain_light_day"
    }
    return imageName
}

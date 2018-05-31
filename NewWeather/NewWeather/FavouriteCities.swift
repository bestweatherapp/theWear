//
//  FavouriteCities.swift
//  NewWeather
//
//  Created by Maxim Reshetov on 31.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import Foundation

var cities : [String]?

func SaveCity(cities: [String]) {
    UserDefaults.standard.set(cities, forKey: "cities")
}

func FetchCities() -> [String]? {
    if let city = UserDefaults.standard.array(forKey: "cities") as? [String] {
        return city
    } else {
        return nil
    }
}

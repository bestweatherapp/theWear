//
//  FavouriteCities.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 24.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
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

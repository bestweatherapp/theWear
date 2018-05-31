//
//  DateFormaterFunctions.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 25.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

func convertDateFormaterForDailyForecastForDate(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "MMM d"
    return dateFormatter.string(from: date!)
}

func convertDateFormaterForDailyForecastForDateDescription(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: date!)
}

func convertDateFormaterForDailyForecastForDetailedView(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter.string(from: date!)
}


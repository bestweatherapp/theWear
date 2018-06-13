
import UIKit
import CoreLocation
import UserNotifications

extension UIImageView { // Extension for downloading an image from http request
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! HourCell
        cell.hour.attributedText = NSAttributedString(string: allHours[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        cell.temperatureIcon.downloadedFrom(link: allHourlyTempsIcons[indexPath.row])
        cell.temperature.attributedText = NSAttributedString(string: allHourlyTemps[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.forecastTableView {
            return 7
        } else {
            if cities?.count == 0 {
                tableView.isHidden = true
                self.placeholderForFav.isHidden = false
                self.placeholderForFavLabel.isHidden = false
                return 0
            } else {
                tableView.isHidden = false
                placeholderForFav.isHidden = true
                placeholderForFavLabel.isHidden = true
                return (cities?.count)!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.forecastTableView {
            let cell = forecastTableView.dequeueReusableCell(withIdentifier: "tableViewcell", for: indexPath) as! DayCell
            cell.date.attributedText = NSAttributedString(string: allDates[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
            cell.temperature.attributedText = NSAttributedString(string: allTemps[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
            cell.backgroundColor = .clear
            cell.temperatureIcon.contentMode = .scaleToFill
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.temperatureIcon.downloadedFrom(link: allTempsIcons[indexPath.row])
            var views = [cell.view1, cell.view2, cell.view3, cell.view4, cell.view5, cell.view6, cell.view7]
            views.forEach {$0.image = UIImage(named: "none")}
            DispatchQueue.main.async {
                cell.clothes.isScrollEnabled = false
                for i in 0...6 {
                    if self.allClothesForForecastTableView[indexPath.row].indices.contains(i) {
                        if i >= 5 {
                            cell.clothes.isScrollEnabled = true
                        }
                        views[i].image = UIImage(named: self.allClothesForForecastTableView[indexPath.row][i])
                    }
                }
            }
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            if cities![indexPath.row].count > 30 {
                let splittedCity = cities![indexPath.row].components(separatedBy: ",")
                var additionalText = ""
                for i in 1..<splittedCity.count {
                    additionalText += splittedCity[i]
                }
                cell.textLabel?.text = "\(splittedCity[0]),\n\(additionalText)"
            } else {
                cell.textLabel?.text = cities![indexPath.row]
            }
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 2
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.forecastTableView {
          
            morningTempIcon.downloadedFrom(link: "https:" + self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![9].icon!)
            afternoonTempIcon.downloadedFrom(link: "https:" + self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![15].icon!)
            eveningTempIcon.downloadedFrom(link: "https:" + self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![21].icon!)
            nightTempIcon.downloadedFrom(link: "https:" + self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![3].icon!)
            //
            maxWinSpeedLabel.attributedText = NSAttributedString(string: "Maximum wind speed:\n\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].windSpeed_max!))) mPs", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            pressureLabel.attributedText = NSAttributedString(string: "Average pressure:\n\(Int(round(avgPressures[indexPath.row]))) Mb", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            avgHumidityLabel.attributedText = NSAttributedString(string: "Average Humidity:\n\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].avghumidity!)))%", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            sunriseLabel.attributedText = NSAttributedString(string: String(self.currentForecastCity.AllForecastDay![indexPath.row].sunrise!), attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            sunsetLabel.attributedText = NSAttributedString(string: String(self.currentForecastCity.AllForecastDay![indexPath.row].sunset!), attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            adviceInDetailedViewLabel.attributedText = NSAttributedString(string: allCommentsForDetailedView[(forecastTableView.indexPathForSelectedRow?.row)!], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            forecastForLabel.attributedText = NSAttributedString(string: "Forecast for \n\(convertDateFormaterForDailyForecastForDetailedView("\(self.currentForecastCity.AllForecastDay![indexPath.row].date!)"))", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            if (UserDefaults.standard.integer(forKey: "Temperature") == 0) {
                morningTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![9].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                afternoonTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![15].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                eveningTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![21].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                nightTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![3].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            } else {
                morningTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![9].temperature!) * 9/5 + 32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                 afternoonTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![15].temperature!)*9/5+32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                 eveningTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![21].temperature!)*9/5+32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                 nightTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![3].temperature!)*9/5+32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            }
            if (UserDefaults.standard.integer(forKey: "Temperature") == 0) {
                morningTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![9].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                afternoonTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![15].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                eveningTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![21].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                nightTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![3].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
             } else {
                morningTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![9].feelslike!)*9/5+32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                afternoonTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![15].feelslike!)*9/5+32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                eveningTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![21].feelslike!)*9/5+32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
                nightTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![3].feelslike!)*9/5+32))°F", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
             }
            afternoonUpClothes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 2][0])
            afternoonDownClothes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 2][1])
            afternoonShoes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 2][2])
            
            eveningUpClothes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 3][0])
            eveningDownClothes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 3][1])
            eveningShoes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 3][2])
            
            nightUpClothes.image = UIImage(named: allClothesForDetailedView[indexPath.row * 4][0])
            nightDownClothes.image = UIImage(named: allClothesForDetailedView[indexPath.row * 4][1])
            nightShoes.image = UIImage(named: allClothesForDetailedView[indexPath.row * 4][2])
            
            morningUpClothes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 1][0])
            morningDownClothes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 1][1])
            morningShoes.image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 1][2])
            
            var views = [forNightAdditional1, forNightAdditional2, forNightAdditional3, forMorningAdditional1, forMorningAdditional2, forMorningAdditional3, forAfternoonAdditional1, forAfternoonAdditional2, forAfternoonAdditional3, forEveningAdditional1, forEveningAdditional2, forEveningAdditional3]
            views.forEach {$0.image = UIImage(named: "none")}
            
            nightAdditionalClothes.isScrollEnabled = false
            morningAdditionalClothes.isScrollEnabled = false
            afternoonAdditionalClothes.isScrollEnabled = false
            eveningAdditionalClothes.isScrollEnabled = false
            
            for i in 3...5 {
                if allClothesForDetailedView[(indexPath.row * 4)].indices.contains(i) {
                    if i > 3 {
                        nightAdditionalClothes.isScrollEnabled = true
                    }
                    views[i - 3].image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4)][i])
                }
                if allClothesForDetailedView[(indexPath.row * 4) + 1].indices.contains(i) {
                    if i > 3 {
                        morningAdditionalClothes.isScrollEnabled = true
                    }
                    views[(i - 3) + 3].image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 1][i])
                }
                
                if allClothesForDetailedView[(indexPath.row * 4) + 2].indices.contains(i) {
                    if i > 3 {
                        afternoonAdditionalClothes.isScrollEnabled = true
                    }
                    views[(i - 3) + 6].image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 2][i])
                }
                
                if allClothesForDetailedView[(indexPath.row * 4) + 3].indices.contains(i) {
                    if i > 3 {
                        eveningAdditionalClothes.isScrollEnabled = true
                    }
                    views[(i - 3) + 9].image = UIImage(named: allClothesForDetailedView[(indexPath.row * 4) + 3][i])
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                UIView.animate(withDuration: 0.6) {
                    self.topStackView.frame.origin.x = -self.view.frame.width
                    self.middleStackView.frame.origin.x = -self.view.frame.width
                    self.bottomStackView.frame.origin.x = -self.view.frame.width
                    self.detailedView.frame.origin.x = 25
                }
            }
        } else {
            self.forecastTableView.isUserInteractionEnabled = true
            self.forecastCollectionView.isUserInteractionEnabled = true
            self.searchButton.isUserInteractionEnabled = true
            self.bottomStackView.isUserInteractionEnabled = true
            self.topStackView.isUserInteractionEnabled = true
            self.middleStackView.isUserInteractionEnabled = true
            self.currentTemperature.isUserInteractionEnabled = true
            self.currentCondition.isUserInteractionEnabled = true
            self.currentAdvice.isUserInteractionEnabled = true
            self.currentLocation.isUserInteractionEnabled = true
            self.searchButton.isEnabled = true

            var check = UpdateWeather(location: cities![(favouriteCitiesTableView.indexPathForSelectedRow?.row)!].folding(options: .diacriticInsensitive, locale: .current)) { (avgPress, allCommentsForDatailed, allClothesForFTB, allClothesForDV, allDates, allTempsDay, allTempsDayIcons, allHours, forecastCity, allHourlyTempsIcons, allHourlyTemps, allDays, current_, hour) in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.errorLabel.alpha = 0
                        self.errorLabel.isHidden = true
                        self.view.layoutIfNeeded()
                    }
                    self.avgPressures = avgPress
                    self.allCommentsForDetailedView = allCommentsForDatailed
                    self.allClothesForForecastTableView = allClothesForFTB
                    self.allClothesForDetailedView = allClothesForDV
                    self.allDates = allDates
                    self.allTemps = allTempsDay
                    self.allTempsIcons = allTempsDayIcons
                    self.allHours = allHours
                    self.currentForecastCity = forecastCity
                    self.allHourlyTempsIcons = allHourlyTempsIcons
                    self.allHourlyTemps = allHourlyTemps
                    self.backgroundImage.image = UIImage(named: SetTheBackground(status: current_.status!, sunrise: allDays[0].sunrise!, currentHour: hour))
                    self.forecastTableView.reloadData()
                    self.forecastCollectionView.reloadData()
                    self.commentForNotification = allCommentsForDatailed[0]
                    var hour = 0
                    var minute = 0
                    if (UserDefaults.standard.string(forKey: "RemindHour") != nil){
                        if UserDefaults.standard.string(forKey: "RemindHour")!.count == 5 {
                            hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                            minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(3))!
                        } else {
                            hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                            minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(2))!
                        }}
                    
                    self.currentLocation.attributedText = NSMutableAttributedString(string: cities![(self.favouriteCitiesTableView.indexPathForSelectedRow?.row)!].folding(options: .diacriticInsensitive, locale: .current), attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    if UserDefaults.standard.integer(forKey: "Temperature") == 0 {
                        self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°C", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    } else {
                        self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°F", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    }
                    self.currentCondition.attributedText = NSMutableAttributedString(string: current_.condition!, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    let methods = Methods()
                    let forecastday_ = self.currentForecastCity.AllForecastDay![0]
                    var comment = methods.GetCurrentComment(Current : current_, day : forecastday_)
                    comment += methods.GetThunderComment(forecastday: forecastday_)
                    self.currentAdvice.attributedText = NSMutableAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                }
            }
            if check == false {
                UIView.animate(withDuration: 0.5) {
                    self.errorLabel.alpha = 1
                    self.errorLabel.isHidden = false
                    self.view.layoutIfNeeded()
                }
            }
            UIView.animate(withDuration: 0.4) {
                self.slideOutMenu.frame.origin.x = -250
                self.blurEffect.alpha = 0
                let initialIndex = 0
                let indexPath = IndexPath(item: initialIndex, section: 0)
                self.forecastCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.forecastTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == forecastTableView {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == favouriteCitiesTableView {
            if editingStyle == .delete {
                cities?.remove(at: indexPath.row)
                self.favouriteCitiesTableView.reloadData()
            } else if tableView == forecastTableView { }
        }
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var allDates = [String](repeating: "", count: 7)
    var allTemps = [String](repeating: "", count: 7)
    var allTempsIcons = [String](repeating: "", count: 7)
    var allHours = [String](repeating: "", count: 12)
    var allHourlyTemps = [String](repeating: "", count: 12)
    var allHourlyTempsIcons = [String](repeating: "", count: 12)
    var currentForecastCity = ForecastCity()
    var allCommentsForDetailedView = [String]()
    var allClothesForForecastTableView = [[String](repeating: "", count: 7),[String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7)]
    var allClothesForDetailedView = [[String]]()
    var globalCheck: Int?
    var commentForNotification = ""
    var avgPressures = [Double](repeating: 0.0, count: 7)
    
    private let dissabledInternetLabelOnSplash: UILabel = {
        let text = UILabel()
        text.sizeToFit()
        text.alpha = 0
        return text
    }()
    
    private let slideOutMenu: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.shadowColor = UIColor.myGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5
        return view
    }()
    private let placeholderForFav: UIImageView = {
        let image = UIImageView(image: UIImage(named: "PlaceHolderForFavoutites"))
        image.isHidden = false
        return image
    }()
    private let placeholderForFavLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 2
        text.sizeToFit()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Here you can add some\n preferable cities and save them", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor.myGray])
        return text
    }()
    private let addCityButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        return button
    }()
    @objc func addCity() {
        let add = AddCityViewController()
        add.modalPresentationStyle = .overFullScreen
        present(add, animated: true, completion: nil)
    }
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        return button
    }()
    @objc func showSettings() {
        [forecastTableView, forecastCollectionView, topStackView, middleStackView, bottomStackView].forEach {$0.isUserInteractionEnabled = true}
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.slideOutMenu.frame.origin.x = -250
            self.blurEffect.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.blurEffect.isHidden = true
        })
        let set = SettingsViewController()
        set.modalPresentationStyle = .overCurrentContext
        present(set, animated: true, completion: nil)
    }
    private let favouriteCitiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    @objc func UpdateFavourits() {
        self.favouriteCitiesTableView.reloadData()
    }
    
    // Update current location Button
    private let updateWithCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString(string: "Current location", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:UIColor.myGray]), for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(UpdateWithCurrentLocation), for: .touchUpInside)
        return button
    }()
    @objc func UpdateWithCurrentLocation() {
        var check = UpdateWeather(location: "Current location") { (avgPress, allCommentsForDatailed, allClothesForFTB, allClothesForDV, allDates, allTempsDay, allTempsDayIcons, allHours, forecastCity, allHourlyTempsIcons, allHourlyTemps, allDays, current_, hour) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.errorLabel.alpha = 0
                    self.errorLabel.isHidden = true
                    self.view.layoutIfNeeded()
                }
                self.avgPressures = avgPress
                self.allCommentsForDetailedView = allCommentsForDatailed
                self.allClothesForForecastTableView = allClothesForFTB
                self.allClothesForDetailedView = allClothesForDV
                self.allDates = allDates
                self.allTemps = allTempsDay
                self.allTempsIcons = allTempsDayIcons
                self.allHours = allHours
                self.currentForecastCity = forecastCity
                self.allHourlyTempsIcons = allHourlyTempsIcons
                self.allHourlyTemps = allHourlyTemps
                self.backgroundImage.image = UIImage(named: SetTheBackground(status: current_.status!, sunrise: allDays[0].sunrise!, currentHour: hour))
                self.forecastCollectionView.reloadData()
                self.commentForNotification = allCommentsForDatailed[0]
                var hour = 0
                var minute = 0
                if (UserDefaults.standard.string(forKey: "RemindHour") != nil){
                    if UserDefaults.standard.string(forKey: "RemindHour")!.count == 5 {
                        hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                        minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(3))!
                    } else {
                        hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                        minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(2))!
                    }}
                
                self.currentLocation.attributedText = NSMutableAttributedString(string: "Current location", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                if UserDefaults.standard.integer(forKey: "Temperature") == 0 {
                    self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°C", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                } else {
                    self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°F", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                }
                self.currentCondition.attributedText = NSMutableAttributedString(string: current_.condition!, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                let methods = Methods()
                let forecastday_ = self.currentForecastCity.AllForecastDay![0]
                var comment = methods.GetCurrentComment(Current : current_, day : forecastday_)
                comment += methods.GetThunderComment(forecastday: forecastday_)
                self.currentAdvice.attributedText = NSMutableAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
            }
        }
        if check == false {
            UIView.animate(withDuration: 0.5) {
                self.errorLabel.alpha = 1
                self.errorLabel.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        [forecastTableView, forecastCollectionView, topStackView, middleStackView, bottomStackView].forEach {$0.isUserInteractionEnabled = true}
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            let initialIndex = 0
            let indexPath = IndexPath(item: initialIndex, section: 0)
            self.forecastCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.forecastTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.slideOutMenu.frame.origin.x = -250
            self.blurEffect.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.blurEffect.isHidden = true
        })
    }
    
    private var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // Splash
    private let splashScreen: UIView = {
        let view = UIView()
        view.isHidden = false
        view.backgroundColor = .white
        return view
    }()
    
    // Top
    private var topStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(OpenSlideOutMenu), for: .touchUpInside)
        return button
    }()
    @objc func OpenSlideOutMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.slideOutMenu.frame.origin.x = 0
            self.blurEffect.alpha = 1
            self.blurEffect.isHidden = false
            self.view.layoutIfNeeded()
        })
        [forecastTableView, forecastCollectionView, topStackView, middleStackView, bottomStackView].forEach {$0.isUserInteractionEnabled = false}
    }
    private let currentLocation: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.sizeToFit()
        text.numberOfLines = 2
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.5
        text.backgroundColor = .clear
        return text
    }()
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(OpenSearchVC), for: .touchUpInside)
        return button
    }()
    @objc private func OpenSearchVC() {
        let searchVC = SearchViewController()
        searchVC.modalPresentationStyle = .overCurrentContext
        present(searchVC, animated: true, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.blurEffect.alpha = 1
            self.blurEffect.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    @objc func CloseSVC() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.blurEffect.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.blurEffect.isHidden = true
        })
    }
    
    // Middle
    private var middleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private let currentTemperature: UILabel = {
        let text = UILabel()
        text.sizeToFit()
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.5
        text.textAlignment = .center
        text.backgroundColor = .clear
        return text
    }()
    private let currentCondition: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.5
        text.backgroundColor = .clear
        return text
    }()
    private let currentAdvice: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.5
        text.backgroundColor = .clear
        text.numberOfLines = 3
        return text
    }()
    
    // Bottom
    private var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private let forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 30
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    let forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 25
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // Detailed View
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private let detailedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.myGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5
        return view
    }()
    private let closeDetailedViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(CloseDetailedView), for: .touchUpInside)
        return button
    }()
    @objc func CloseDetailedView() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.detailedView.frame.origin.x = self.view.frame.width + 50
            self.topStackView.frame.origin.x = 25
            self.middleStackView.frame.origin.x = 25
            self.bottomStackView.frame.origin.x = 25
        }
        scrollView.scrollToTop()
    }
    
    // Temps Icon
    private let morningTempIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let afternoonTempIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let eveningTempIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let nightTempIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // Temps
    private let morningTemp: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    private let afternoonTemp: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    private let eveningTemp: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    private let nightTemp: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    
    // Temps feels like
    private let morningTempFeelsLike: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    private let afternoonTempFeelsLike: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    private let eveningTempFeelsLike: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    private let nightTempFeelsLike: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    
    // Night clothes
    private let nightUpClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let nightDownClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let nightShoes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let nightAdditionalClothes: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let forNightAdditional1: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forNightAdditional2: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forNightAdditional3: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // Morning clothes
    private let morningUpClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let morningDownClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let morningShoes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let morningAdditionalClothes: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let forMorningAdditional1: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forMorningAdditional2: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forMorningAdditional3: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // Afternoon clothes
    private let afternoonUpClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let afternoonDownClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let afternoonShoes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let afternoonAdditionalClothes: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let forAfternoonAdditional1: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forAfternoonAdditional2: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forAfternoonAdditional3: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // Evening clothes
    private let eveningUpClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let eveningDownClothes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let eveningShoes: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let eveningAdditionalClothes: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let forEveningAdditional1: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forEveningAdditional2: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let forEveningAdditional3: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    
    private let forecastForLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.numberOfLines = 2
        return text
    }()
    private let adviceInDetailedViewLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 7
        text.sizeToFit()
        return text
    }()
    
    private let topLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let feelsLikeLine1: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    private let feelsLikeLine2: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let commentLine1: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    private let commentLine2: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let clothesLine1: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    private let clothesLine2: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let detailsLine1: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    private let detailsLine2: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let nightLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Night", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 10)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return text
    }()
    private let morningLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Morning", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 10)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return text
    }()
    private let afternoonLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Afternoon", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 10)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return text
    }()
    private let eveningLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Evening", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 10)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return text
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Feels like", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    private let clothesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Clothes", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    private let DetailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Details", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    private let maxWindSpeedIcon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "windspeed"))
        return image
    }()
    
    private let pressureIcon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "gauge"))
        return image
    }()
    private let pressureLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 2
        text.textAlignment = .left
        return text
    }()
    
    private let maxWinSpeedLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 2
        text.textAlignment = .left
        return text
    }()
    
    private let avgHumidityIcon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "humidity"))
        return image
    }()
    private let avgHumidityLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 2
        text.textAlignment = .left
        return text
    }()
    private let descrLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Description", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 11)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    // Sunset and sunrise
    private let sunriseImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "sunrise"))
        return image
    }()
    private let sunsetImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "sunset"))
        return image
    }()
    private let sunriseLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    private let sunsetLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        return text
    }()
    
    let blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isHidden = true
        return blurView
    }()
    
    private let weaLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Wea", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Bold", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    private let theLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "the", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    private let rLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "r", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Bold", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != self.slideOutMenu && self.slideOutMenu.frame.origin.x == 0 {
            [forecastTableView, forecastCollectionView, topStackView, middleStackView, bottomStackView].forEach {$0.isUserInteractionEnabled = true}
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.slideOutMenu.frame.origin.x = -250
                self.blurEffect.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.blurEffect.isHidden = true
            })
        }
    }
    
    var leadConstr: CGFloat = -250
    
    var padding: CGFloat = 0
    var lineWidth: CGFloat = 0
    var paddingForSplash: CGFloat = 0
    
    private func LayOut() {
        
        [backgroundImage, topStackView, middleStackView, bottomStackView, detailedView, errorLabel, blurEffect, slideOutMenu, splashScreen].forEach {view.addSubview($0)}
        [menuButton, currentLocation, searchButton].forEach {topStackView.addArrangedSubview($0)}
        [currentTemperature, currentCondition, currentAdvice].forEach {middleStackView.addArrangedSubview($0)}
        [forecastCollectionView, forecastTableView].forEach {bottomStackView.addArrangedSubview($0)}
        [placeholderForFavLabel, favouriteCitiesTableView, updateWithCurrentLocationButton, settingsButton, addCityButton, placeholderForFav].forEach {slideOutMenu.addSubview($0)}
        [scrollView, closeDetailedViewButton, forecastForLabel].forEach {detailedView.addSubview($0)}
        [topLine, feelsLikeLine1, feelsLikeLine2, commentLine1, commentLine2, clothesLine1, clothesLine2, detailsLine1, detailsLine2, morningTempIcon, afternoonTempIcon, eveningTempIcon, nightTempIcon, morningTemp, afternoonTemp, eveningTemp, nightTemp, morningTempFeelsLike, afternoonTempFeelsLike, eveningTempFeelsLike, nightTempFeelsLike, adviceInDetailedViewLabel, feelsLikeLabel, descrLabel, clothesLabel, DetailsLabel, maxWinSpeedLabel, maxWindSpeedIcon, avgHumidityLabel, avgHumidityIcon, sunriseImage, sunsetImage, sunriseLabel, sunsetLabel, nightUpClothes, nightDownClothes, nightShoes, nightAdditionalClothes, morningUpClothes, morningDownClothes, morningShoes, morningAdditionalClothes, afternoonUpClothes, afternoonDownClothes, afternoonShoes, afternoonAdditionalClothes, eveningUpClothes, eveningDownClothes, eveningShoes, eveningAdditionalClothes, nightLabel, morningLabel, afternoonLabel, eveningLabel, pressureIcon, pressureLabel].forEach {scrollView.addSubview($0)}
        
        [forNightAdditional1, forNightAdditional2, forNightAdditional3].forEach {nightAdditionalClothes.addSubview($0)}
        [forMorningAdditional1, forMorningAdditional2, forMorningAdditional3].forEach {morningAdditionalClothes.addSubview($0)}
        [forAfternoonAdditional1, forAfternoonAdditional2, forAfternoonAdditional3].forEach {afternoonAdditionalClothes.addSubview($0)}
        [forEveningAdditional1, forEveningAdditional2, forEveningAdditional3].forEach {eveningAdditionalClothes.addSubview($0)}
        [theLabel, weaLabel, rLabel, dissabledInternetLabelOnSplash].forEach {splashScreen.addSubview($0)}
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
            padding = 22
            paddingForSplash = 0
        case 1334:
            print("iPhone 7")
            padding = 33
            lineWidth = 259
            paddingForSplash = 45
        case 1920:
            print("iPhone 7+")
            padding = 40.8
            lineWidth = 282.4
            paddingForSplash = 64.5
        case 2436:
            print("iPhone X")
            padding = 33
            paddingForSplash = 0
        default:
            return
        }
        
        // Error label
        errorLabel.anchor(top: topStackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init())
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Blur View
        blurEffect.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init())
        
        
        // TopStackView
        topStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 40))
        menuButton.anchor(top: topStackView.topAnchor, leading: topStackView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        currentLocation.anchor(top: topStackView.topAnchor, leading: nil, bottom: topStackView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 0))
        currentLocation.centerXAnchor.constraint(equalTo: topStackView.centerXAnchor).isActive = true
        searchButton.anchor(top: topStackView.topAnchor, leading: nil, bottom: nil, trailing: topStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        
        // MiddleStackView
        middleStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: bottomStackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 5, right: 25), size: .init(width: 0, height: 210))
        currentTemperature.anchor(top: middleStackView.topAnchor, leading: nil, bottom: currentCondition.topAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 5, right: 0), size: .init(width: 0, height: 70))
        currentCondition.anchor(top: nil, leading: middleStackView.leadingAnchor, bottom: currentAdvice.topAnchor, trailing: middleStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
        currentAdvice.anchor(top: nil, leading: middleStackView.leadingAnchor, bottom: middleStackView.bottomAnchor, trailing: middleStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 70))
        
        
        // BottomStackView
        bottomStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 25, right: 25), size: .init(width: 0, height: 300))
        forecastCollectionView.anchor(top: nil, leading: bottomStackView.leadingAnchor, bottom: forecastTableView.topAnchor, trailing: bottomStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: .init(width: 0, height: 75))
        forecastTableView.anchor(top: nil, leading: bottomStackView.leadingAnchor, bottom: bottomStackView.bottomAnchor, trailing: bottomStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 100))
        
        
        // SlideOutMenu
        slideOutMenu.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: self.leadConstr, bottom: 0, right: 0), size: .init(width: 250, height: 0))
        settingsButton.anchor(top: slideOutMenu.safeAreaLayoutGuide.topAnchor, leading: slideOutMenu.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 25, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        addCityButton.anchor(top: slideOutMenu.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: slideOutMenu.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 35, height: 35))
        updateWithCurrentLocationButton.anchor(top: nil, leading: slideOutMenu.leadingAnchor, bottom: favouriteCitiesTableView.topAnchor, trailing: slideOutMenu.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 15, right: 15), size: .init(width: 0, height: 15))
        favouriteCitiesTableView.anchor(top: slideOutMenu.topAnchor, leading: slideOutMenu.leadingAnchor, bottom: slideOutMenu.bottomAnchor, trailing: slideOutMenu.trailingAnchor, padding: .init(top: 150, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        placeholderForFav.anchor(top: updateWithCurrentLocationButton.bottomAnchor, leading: slideOutMenu.leadingAnchor, bottom: nil, trailing: slideOutMenu.trailingAnchor, padding: .init(top: 75, left: 85, bottom: 0, right: 85), size: .init(width: 80, height: 80))
        placeholderForFavLabel.anchor(top: placeholderForFav.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init())
        placeholderForFavLabel.centerXAnchor.constraint(equalTo: slideOutMenu.centerXAnchor).isActive = true
        
        
        // Detailed View
        detailedView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 40, left: view.frame.width + 25, bottom: 25, right: 0), size: .init(width: view.frame.width-50, height: 0))
        scrollView.anchor(top: closeDetailedViewButton.bottomAnchor, leading: detailedView.leadingAnchor, bottom: detailedView.bottomAnchor, trailing: detailedView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        // Top Part
        closeDetailedViewButton.anchor(top: detailedView.topAnchor, leading: nil, bottom: nil, trailing: detailedView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 25), size: .init(width: 25, height: 25))
        forecastForLabel.anchor(top: nil, leading: detailedView.leadingAnchor, bottom: nil, trailing: detailedView.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: 45))
        forecastForLabel.centerYAnchor.constraint(equalTo: closeDetailedViewButton.centerYAnchor).isActive = true
        
        // Top Line
        topLine.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: padding, bottom: 0, right: 0), size: .init(width: lineWidth, height: 0.5))
        
        // Names of day parts
        nightLabel.anchor(top: topLine.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: padding - 8, bottom: 0, right: 0),  size: .init(width: 50, height: 30))
        morningLabel.anchor(top: topLine.bottomAnchor, leading: nightLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: padding - 8, bottom: 0, right: 0),  size: .init(width: 50, height: 30))
        afternoonLabel.anchor(top: topLine.bottomAnchor, leading: morningLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: padding - 8, bottom: 0, right: 0), size: .init(width: 50, height: 30))
        eveningLabel.anchor(top: topLine.bottomAnchor, leading: afternoonLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: padding - 8, bottom: 0, right: 0), size: .init(width: 50, height: 30))
        
        // Temperature Icons
        nightTempIcon.anchor(top: nightLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        morningTempIcon.anchor(top: morningLabel.bottomAnchor, leading: nightTempIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        afternoonTempIcon.anchor(top: afternoonLabel.bottomAnchor, leading: morningTempIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        eveningTempIcon.anchor(top: eveningLabel.bottomAnchor, leading: afternoonTempIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        // Temperature
        morningTemp.anchor(top: morningTempIcon.bottomAnchor, leading: morningTempIcon.leadingAnchor, bottom: nil, trailing: morningTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        afternoonTemp.anchor(top: afternoonTempIcon.bottomAnchor, leading: afternoonTempIcon.leadingAnchor, bottom: nil, trailing: afternoonTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        eveningTemp.anchor(top: eveningTempIcon.bottomAnchor, leading: eveningTempIcon.leadingAnchor, bottom: nil, trailing: eveningTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        nightTemp.anchor(top: nightTempIcon.bottomAnchor, leading: nightTempIcon.leadingAnchor, bottom: nil, trailing: nightTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        // Feels Like Line
        feelsLikeLine1.anchor(top: morningTemp.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: padding, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        feelsLikeLine2.anchor(top: morningTemp.bottomAnchor, leading: feelsLikeLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 15, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        feelsLikeLabel.anchor(top: nil, leading: feelsLikeLine1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 50, height: 30))
        feelsLikeLabel.centerYAnchor.constraint(equalTo: feelsLikeLine1.centerYAnchor).isActive = true
        feelsLikeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        // FeelsLike Temperature
        morningTempFeelsLike.anchor(top: feelsLikeLabel.bottomAnchor, leading: morningTempIcon.leadingAnchor, bottom: nil, trailing: morningTempIcon.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        afternoonTempFeelsLike.anchor(top: feelsLikeLabel.bottomAnchor, leading: afternoonTempIcon.leadingAnchor, bottom: nil, trailing: afternoonTempIcon.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        eveningTempFeelsLike.anchor(top: feelsLikeLabel.bottomAnchor, leading: eveningTempIcon.leadingAnchor, bottom: nil, trailing: eveningTempIcon.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        nightTempFeelsLike.anchor(top: feelsLikeLabel.bottomAnchor, leading: nightTempIcon.leadingAnchor, bottom: nil, trailing: nightTempIcon.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        // Description Line
        commentLine1.anchor(top: morningTempFeelsLike.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: padding, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        commentLine2.anchor(top: morningTempFeelsLike.bottomAnchor, leading: feelsLikeLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 15, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        descrLabel.anchor(top: nil, leading: commentLine1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 50, height: 30))
        descrLabel.centerYAnchor.constraint(equalTo: commentLine1.centerYAnchor).isActive = true
        descrLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        // Description Label
        adviceInDetailedViewLabel.anchor(top: descrLabel.bottomAnchor, leading: detailedView.leadingAnchor, bottom: nil, trailing: detailedView.trailingAnchor, padding: .init(top: 5, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 0))
        
        // Clothes Line
        clothesLine1.anchor(top: adviceInDetailedViewLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: padding, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        clothesLine2.anchor(top: adviceInDetailedViewLabel.bottomAnchor, leading: clothesLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 15, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        clothesLabel.anchor(top: nil, leading: clothesLine1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 50, height: 30))
        clothesLabel.centerYAnchor.constraint(equalTo: clothesLine1.centerYAnchor).isActive = true
        clothesLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        // Clothes for night
        nightUpClothes.anchor(top: clothesLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        nightDownClothes.anchor(top: nightUpClothes.bottomAnchor, leading: nightUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        nightShoes.anchor(top: nightDownClothes.bottomAnchor, leading: nightUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        nightAdditionalClothes.anchor(top: nightShoes.bottomAnchor, leading: nightUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forNightAdditional1.anchor(top: nightAdditionalClothes.topAnchor, leading: nightAdditionalClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forNightAdditional2.anchor(top: nightAdditionalClothes.topAnchor, leading: forNightAdditional1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 2.5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forNightAdditional3.anchor(top: nightAdditionalClothes.topAnchor, leading: forNightAdditional2.trailingAnchor, bottom: nightAdditionalClothes.bottomAnchor, trailing: nightAdditionalClothes.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        // Clothes for morning
        morningUpClothes.anchor(top: clothesLabel.bottomAnchor, leading: nightUpClothes.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        morningDownClothes.anchor(top: morningUpClothes.bottomAnchor, leading: morningUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        morningShoes.anchor(top: morningDownClothes.bottomAnchor, leading: morningUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        morningAdditionalClothes.anchor(top: morningShoes.bottomAnchor, leading: morningUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forMorningAdditional1.anchor(top: morningAdditionalClothes.topAnchor, leading: morningAdditionalClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forMorningAdditional2.anchor(top: morningAdditionalClothes.topAnchor, leading: forMorningAdditional1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 2.5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forMorningAdditional3.anchor(top: nightAdditionalClothes.topAnchor, leading: forMorningAdditional2.trailingAnchor, bottom: morningAdditionalClothes.bottomAnchor, trailing: morningAdditionalClothes.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        // Clothes for afternoon
        afternoonUpClothes.anchor(top: clothesLabel.bottomAnchor, leading: morningUpClothes.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        afternoonDownClothes.anchor(top: afternoonUpClothes.bottomAnchor, leading: afternoonUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        afternoonShoes.anchor(top: afternoonDownClothes.bottomAnchor, leading: afternoonUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        afternoonAdditionalClothes.anchor(top: afternoonShoes.bottomAnchor, leading: afternoonUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forAfternoonAdditional1.anchor(top: afternoonAdditionalClothes.topAnchor, leading: afternoonAdditionalClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forAfternoonAdditional2.anchor(top: afternoonAdditionalClothes.topAnchor, leading: forAfternoonAdditional1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 2.5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forAfternoonAdditional3.anchor(top: afternoonAdditionalClothes.topAnchor, leading: forAfternoonAdditional2.trailingAnchor, bottom: afternoonAdditionalClothes.bottomAnchor, trailing: afternoonAdditionalClothes.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        // Clothes for evening
        eveningUpClothes.anchor(top: clothesLabel.bottomAnchor, leading: afternoonUpClothes.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: padding, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        eveningDownClothes.anchor(top: eveningUpClothes.bottomAnchor, leading: eveningUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        eveningShoes.anchor(top: eveningDownClothes.bottomAnchor, leading: eveningUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        eveningAdditionalClothes.anchor(top: eveningShoes.bottomAnchor, leading: eveningUpClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2.5, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forEveningAdditional1.anchor(top: eveningAdditionalClothes.topAnchor, leading: eveningAdditionalClothes.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forEveningAdditional2.anchor(top: eveningAdditionalClothes.topAnchor, leading: forEveningAdditional1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 2.5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        forEveningAdditional3.anchor(top: eveningAdditionalClothes.topAnchor, leading: forEveningAdditional2.trailingAnchor, bottom: eveningAdditionalClothes.bottomAnchor, trailing: eveningAdditionalClothes.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        // Details Line
        detailsLine1.anchor(top: nightAdditionalClothes.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: padding, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        detailsLine2.anchor(top: nightAdditionalClothes.bottomAnchor, leading: DetailsLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 15, bottom: 0, right: 0), size: .init(width: (lineWidth / 2) - 40, height: 0.5))
        DetailsLabel.anchor(top: nil, leading: detailsLine1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 50, height: 30))
        DetailsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        DetailsLabel.centerYAnchor.constraint(equalTo: detailsLine1.centerYAnchor).isActive = true
        
        // Maximum Wind Speed
        maxWindSpeedIcon.anchor(top: DetailsLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: ((view.frame.width - 50) / 2) - 90, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        maxWinSpeedLabel.anchor(top: nil, leading: maxWindSpeedIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 130, height: 0))
        maxWinSpeedLabel.centerYAnchor.constraint(equalTo: maxWindSpeedIcon.centerYAnchor).isActive = true
        
        // Pressure
        pressureIcon.anchor(top: maxWindSpeedIcon.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: ((view.frame.width - 50) / 2) - 90, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        pressureLabel.anchor(top: nil, leading: pressureIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 130, height: 0))
        pressureLabel.centerYAnchor.constraint(equalTo: pressureIcon.centerYAnchor).isActive = true
        
        // Average Humidity
        avgHumidityIcon.anchor(top: pressureIcon.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: ((view.frame.width - 50) / 2) - 90, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        avgHumidityLabel.anchor(top: nil, leading: avgHumidityIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 130, height: 0))
        avgHumidityLabel.centerYAnchor.constraint(equalTo: avgHumidityIcon.centerYAnchor).isActive = true
        
        // Sunrise and Sunset
        sunriseImage.anchor(top: avgHumidityIcon.bottomAnchor, leading: avgHumidityIcon.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        sunsetImage.anchor(top: avgHumidityIcon.bottomAnchor, leading: sunriseImage.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 110, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        sunriseLabel.anchor(top: sunriseImage.bottomAnchor, leading: sunriseImage.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 35, height: 30))
        sunsetLabel.anchor(top: sunsetImage.bottomAnchor, leading: sunsetImage.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 35, height: 30))
        
        // Background Image
        backgroundImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init())
        
        // Splash Screen
        weaLabel.anchor(top: view.topAnchor, leading: theLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 160, height: 0))
        theLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: paddingForSplash, bottom: 0, right: 0), size: .init(width: 100, height: 0))
        rLabel.anchor(top: view.topAnchor, leading: weaLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 25, height: 0))
        splashScreen.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        dissabledInternetLabelOnSplash.anchor(top: nil, leading: nil, bottom: splashScreen.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: padding, right: 0), size: .init())
        dissabledInternetLabelOnSplash.centerXAnchor.constraint(equalTo: splashScreen.centerXAnchor).isActive = true
    }
    
    func catchNotification(notification: Notification) -> Void {
         [forecastTableView, forecastCollectionView, topStackView, middleStackView, bottomStackView].forEach {$0.isUserInteractionEnabled = true}
        guard let name = notification.userInfo!["name"] else {return}
        var check = UpdateWeather(location: "\(name)") { (avgPress, allCommentsForDatailed, allClothesForFTB, allClothesForDV, allDates, allTempsDay, allTempsDayIcons, allHours, forecastCity, allHourlyTempsIcons, allHourlyTemps, allDays, current_, hour) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.errorLabel.alpha = 0
                    self.errorLabel.isHidden = true
                    self.view.layoutIfNeeded()
                })
                self.avgPressures = avgPress
                self.allCommentsForDetailedView = allCommentsForDatailed
                self.allClothesForForecastTableView = allClothesForFTB
                self.allClothesForDetailedView = allClothesForDV
                self.allDates = allDates
                self.allTemps = allTempsDay
                self.allTempsIcons = allTempsDayIcons
                self.allHours = allHours
                self.currentForecastCity = forecastCity
                self.allHourlyTempsIcons = allHourlyTempsIcons
                self.allHourlyTemps = allHourlyTemps
                    self.backgroundImage.image = UIImage(named: SetTheBackground(status: current_.status!, sunrise: allDays[0].sunrise!, currentHour: hour))
                    self.forecastTableView.reloadData()
                    self.forecastCollectionView.reloadData()
                    self.commentForNotification = allCommentsForDatailed[0]
                    var hour = 0
                    var minute = 0
                    if (UserDefaults.standard.string(forKey: "RemindHour") != nil){
                        if UserDefaults.standard.string(forKey: "RemindHour")!.count == 5 {
                            hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                            minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(3))!
                        } else {
                            hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                            minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(2))!
                        }}
                    
                    self.currentLocation.attributedText = NSMutableAttributedString(string: "\(name)", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    if UserDefaults.standard.integer(forKey: "Temperature") == 0 {
                        self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°C", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    } else {
                        self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°F", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    }
                    self.currentCondition.attributedText = NSMutableAttributedString(string: current_.condition!, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                    let methods = Methods()
                    let forecastday_ = self.currentForecastCity.AllForecastDay![0]
                    var comment = methods.GetCurrentComment(Current : current_, day : forecastday_)
                    comment += methods.GetThunderComment(forecastday: forecastday_)
                    self.currentAdvice.attributedText = NSMutableAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.errorLabel.alpha = 1
            self.errorLabel.isHidden = false
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.4) {
            self.blurEffect.alpha = 0
            self.view.layoutIfNeeded()
            let initialIndex = 0
            let indexPath = IndexPath(item: initialIndex, section: 0)
            self.forecastCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.forecastTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    var timer: Timer!
    
    @objc func DissabledInternetOnSplash() {
        self.dissabledInternetLabelOnSplash.attributedText = NSMutableAttributedString(string: "There is no proper internet connection. Try again!", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        UIView.animate(withDuration: 0.5) {
            self.dissabledInternetLabelOnSplash.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.isHidden = true
        label.alpha = 0
        label.attributedText = NSMutableAttributedString(string: "Something went wrong. Try again!", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Animate()
        timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(DissabledInternetOnSplash), userInfo: nil, repeats: false)
       
        var check = UpdateWeather(location: "Current location") { (avgPress, allCommentsForDatailed, allClothesForFTB, allClothesForDV, allDates, allTempsDay, allTempsDayIcons, allHours, forecastCity, allHourlyTempsIcons, allHourlyTemps, allDays, current_, hour) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.errorLabel.alpha = 0
                    self.errorLabel.isHidden = true
                    self.view.layoutIfNeeded()
                }
                self.avgPressures = avgPress
                self.allCommentsForDetailedView = allCommentsForDatailed
                self.allClothesForForecastTableView = allClothesForFTB
                self.allClothesForDetailedView = allClothesForDV
                self.allDates = allDates
                self.allTemps = allTempsDay
                self.allTempsIcons = allTempsDayIcons
                self.allHours = allHours
                self.currentForecastCity = forecastCity
                self.allHourlyTempsIcons = allHourlyTempsIcons
                self.allHourlyTemps = allHourlyTemps
                self.backgroundImage.image = UIImage(named: SetTheBackground(status: current_.status!, sunrise: allDays[0].sunrise!, currentHour: hour))
                self.forecastTableView.reloadData()
                self.forecastCollectionView.reloadData()
                self.commentForNotification = allCommentsForDatailed[0]
                self.timer.invalidate()
                self.timer = nil
                var hour = 0
                var minute = 0
                if (UserDefaults.standard.string(forKey: "RemindHour") != nil){
                    if UserDefaults.standard.string(forKey: "RemindHour")!.count == 5 {
                        hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                        minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(3))!
                    } else {
                        hour = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropLast(3))!
                        minute = Int(UserDefaults.standard.string(forKey: "RemindHour")!.dropFirst(2))!
                    }}
                
                self.currentLocation.attributedText = NSMutableAttributedString(string: "Current location", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                if UserDefaults.standard.integer(forKey: "Temperature") == 0 {
                    self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°C", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                } else {
                    self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°F", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                }
                self.currentCondition.attributedText = NSMutableAttributedString(string: current_.condition!, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                let methods = Methods()
                let forecastday_ = self.currentForecastCity.AllForecastDay![0]
                var comment = methods.GetCurrentComment(Current : current_, day : forecastday_)
                comment += methods.GetThunderComment(forecastday: forecastday_)
                self.currentAdvice.attributedText = NSMutableAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                self.Animation()
            }
        }
        if check == false {
            UIView.animate(withDuration: 0.5) {
                self.errorLabel.alpha = 1
                self.errorLabel.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        hideKeyboardWhenTappedOutside()
        view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.backgroundColor = .lightBlue
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateFavourits), name: NSNotification.Name(rawValue: "upF"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "closeSVC"), object: nil, queue: nil, using: catchNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(CloseSVC), name: NSNotification.Name(rawValue: "closeSVCA"), object: nil)
        if (UserDefaults.standard.integer(forKey: "Notifications")==0)
        {
            let center =  UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (result, error) in
                //handle result of request failure
            }
        }
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {   timer.invalidate()
            locationManager.delegate = self
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingHeading()
        }
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        favouriteCitiesTableView.delegate = self
        favouriteCitiesTableView.dataSource = self
        forecastCollectionView.dataSource = self
        forecastTableView.register(DayCell.self, forCellReuseIdentifier: "tableViewcell")
        forecastCollectionView.register(HourCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        LayOut()
    }
    
    private func Animate() {
        self.theLabel.frame.origin.x = 0
        self.weaLabel.frame.origin.x = 0
        UIView.animate(withDuration: 2, delay: 0.25, options: [.autoreverse, .repeat], animations: {
            self.weaLabel.frame.origin.x += 100
            self.theLabel.frame.origin.x -= 160
        })
    }
    
    @objc private func Animation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.splashScreen.alpha = 0
            self.weaLabel.alpha = 0
            self.theLabel.alpha = 0
            self.rLabel.alpha = 0
        }, completion: { _ in
            self.splashScreen.isHidden = true
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension UIView { // Extension for anchoring UI elements
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.HideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func HideKeyboard() {
        view.endEditing(true)
    }
}
extension UIColor {
    static var dark = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)
    static var lightBlue = UIColor(red: 124/255, green: 214/255, blue: 255/255, alpha: 1)
    static var myGray = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 100)
}
extension Notification.Name {
    static let genderChanged = Notification.Name("peru")
}
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

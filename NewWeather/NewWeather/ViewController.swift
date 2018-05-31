//
//  ViewController.swift
//  NewWeather
//
//  Created by Валентина on 30.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
// new project

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
     let locationManager = CLLocationManager()
    var allDates = [String](repeating: "", count: 7)
    var allTemps = [String](repeating: "", count: 7)
    var allTempsIcons = [String](repeating: "", count: 7)
    var allHours = [String](repeating: "", count: 12)
    var allHourlyTemps = [String](repeating: "", count: 12)
    var allHourlyTempsIcons = [String](repeating: "", count: 12)
    var currentForecastCity = ForecastCity()
    
    private let splashScreen: UIView = {
        let view = UIView()
        view.isHidden = false
        view.backgroundColor = .white
        return view
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.effect = nil
        return blur
    }()
    
    private let forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 30
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private let forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 25
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var topStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    private var middleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let currentLocation: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.backgroundColor = .clear
        return text
    }()
    private let currentTemperature: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.backgroundColor = .clear
        return text
    }()
    private let currentCondition: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.backgroundColor = .clear
        return text
    }()
    private let currentAdvice: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.numberOfLines = 3
        return text
    }()
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "defaultBackground"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let slideOutMenu: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
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
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        return button
    }()
    @objc func showSettings() {
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
    
    private let updateWithCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString(string: "Current location", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 100)]), for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(UpdateWithCurrentLocation), for: .touchUpInside)
        return button
    }()
    @objc func UpdateWithCurrentLocation() {
        //UpdateInfo(location: "Current location")
        UIView.animate(withDuration: 0.4) {
            self.slideOutMenu.frame.origin.x = -250
            self.blurEffectView.effect = nil
        }
        self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
    }
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(OpenSlideOutMenu), for: .touchUpInside)
        return button
    }()
    @objc func OpenSlideOutMenu() {
        self.blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.slideOutMenu.frame.origin.x = 0
            self.blurEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        }
    }
    
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
        self.blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        }
        present(searchVC, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.slideOutMenu && self.slideOutMenu.frame.origin.x == 0 {
            self.searchButton.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.slideOutMenu.frame.origin.x = -250
                self.blurEffectView.effect = nil
            }
            self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
        }
    }
    
    func UpdateInfo(location: String) {
        
        var allDates = [String]()
        var allTempsdays = [String]()
        var allTempsdaysIcons = [String]()
        var allHours = [String]()
        var allHourlyTemps = [String]()
        var allHourlyTempsIcons = [String]()
        let current_ = Current()
        let currentLocation : CLLocation!
        currentLocation = locationManager.location
        let correctLocation = location.replacingOccurrences(of: " ", with: "%20")
        let urlString = (location == "Current location") ? "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(String(describing: currentLocation.coordinate.latitude)),\(String(describing: currentLocation.coordinate.longitude))&days=7" : "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(correctLocation)&days=7"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
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
                // Поля для forecastday
                guard let day = day1["day"] as? [String : AnyObject] else {return}
                let date_ = day1["date"] as? String
                if index == 0 {
                    allDates.append("Today\n\(convertDateFormaterForDailyForecastForDate(date_!))")
                } else {
                    allDates.append("\(convertDateFormaterForDailyForecastForDateDescription(date_!))\n\(convertDateFormaterForDailyForecastForDate(date_!))")
                }
                let comment_ = ""
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
                allTempsdaysIcons.append("https:" + iconUrl)
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
                let newDay = ForecastDay(avg_temp_c: avgtemp_, date: date_!,temperature_avg: avgtemp_, temperature_max: maxtemp_, temperature_min: mintemp_, windSpeed_max: wind_max_!, iconURL: iconUrl, avghumidity: avghum_, comment: comment_, condition: condition_, uv: uv_, forecastHours: allhoursForDay as! [ForecastHour])
                allTempsdays.append("\(Int(round(newDay.AllHours![12].temperature!)))°  \(Int(round(newDay.AllHours![0].temperature!)))°")
                newDay.date = date_!
                allDays.append(newDay)
            }
            self.allDates = allDates
            self.allTemps = allTempsdays
            self.allTempsIcons = allTempsdaysIcons
            
            if (self.hour) > 12 {
                for i in (self.hour)..<24 {
                    allHours.append("\(i):00")
                    allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                    allHourlyTempsIcons.append("https:" + allDays[0].AllHours![i].icon!)
                }
                if 24-(self.hour) < 12 {
                    for i in 0...12-(24-(self.hour)) {
                        allHours.append("\(i):00")
                        allHourlyTemps.append("\(String(describing: Int(round(allDays[1].AllHours![i].temperature!))))°C")
                        allHourlyTempsIcons.append("https:" + allDays[1].AllHours![i].icon!)
                    }
                }
            } else {
                for i in (self.hour)...(self.hour)+12 {
                    allHours.append("\(i):00")
                    allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                    allHourlyTempsIcons.append("https:" + allDays[0].AllHours![i].icon!)
                }
            }
            self.allHours = allHours
            self.allHourlyTemps = allHourlyTemps
            self.allHourlyTempsIcons = allHourlyTempsIcons
            self.currentForecastCity = ForecastCity(Current: current_, ForecastDay: allDays)
            DispatchQueue.main.async {
                self.forecastTableView.reloadData()
                self.forecastCollectionView.reloadData()
                self.currentLocation.attributedText = NSMutableAttributedString(string: location, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°C", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                self.currentCondition.attributedText = NSMutableAttributedString(string: current_.condition!, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                let methods = Methods()
                let forecastday_ = self.currentForecastCity.AllForecastDay![0]
                var comment = methods.GetCurrentComment(Current : current_)
                comment += methods.GetThunderComment(forecastday: forecastday_)
                self.currentAdvice.attributedText = NSMutableAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                
            }
            }.resume()
    }
    
    private func LayOut() {
        topStackView.addArrangedSubview(menuButton)
        topStackView.addArrangedSubview(currentLocation)
        topStackView.addArrangedSubview(searchButton)
        
        middleStackView.addArrangedSubview(currentTemperature)
        middleStackView.addArrangedSubview(currentCondition)
        middleStackView.addArrangedSubview(currentAdvice)
        
        bottomStackView.addArrangedSubview(forecastCollectionView)
        bottomStackView.addArrangedSubview(forecastTableView)
        
        [backgroundImage, topStackView, middleStackView, bottomStackView, blurEffectView, slideOutMenu, splashScreen].forEach {view.addSubview($0)}
        [addCityButton, settingsButton, favouriteCitiesTableView, updateWithCurrentLocationButton].forEach {slideOutMenu.addSubview($0)}
        
        blurEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        blurEffectView.isHidden = true
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
        case 1334:
            slideOutMenu.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: -290, bottom: 0, right: 0), size: .init(width: 250, height: 0))
            favouriteCitiesTableView.anchor(top: slideOutMenu.topAnchor, leading: slideOutMenu.leadingAnchor, bottom: slideOutMenu.bottomAnchor, trailing: slideOutMenu.trailingAnchor, padding: .init(top: 150, left: 0, bottom: 150, right: 0), size: .init(width: 0, height: 0))
            updateWithCurrentLocationButton.anchor(top: nil, leading: slideOutMenu.leadingAnchor, bottom: favouriteCitiesTableView.topAnchor, trailing: slideOutMenu.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 15, right: 15), size: .init(width: 0, height: 15))
            settingsButton.anchor(top: slideOutMenu.safeAreaLayoutGuide.topAnchor, leading: slideOutMenu.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 25, bottom: 0, right: 0), size: .init(width: 35, height: 35))
            addCityButton.anchor(top: slideOutMenu.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: slideOutMenu.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 35, height: 35))
            topStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 40))
            middleStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: bottomStackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 5, right: 25), size: .init(width: 0, height: 210))
            bottomStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 25, right: 25), size: .init(width: 0, height: 300))
            currentTemperature.anchor(top: middleStackView.topAnchor, leading: middleStackView.leadingAnchor, bottom: currentCondition.topAnchor, trailing: middleStackView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 5, right: 0), size: .init(width: 0, height: 0))
            currentCondition.anchor(top: nil, leading: middleStackView.leadingAnchor, bottom: currentAdvice.topAnchor, trailing: middleStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
            currentAdvice.anchor(top: nil, leading: middleStackView.leadingAnchor, bottom: middleStackView.bottomAnchor, trailing: middleStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 70))
            forecastCollectionView.anchor(top: nil, leading: bottomStackView.leadingAnchor, bottom: forecastTableView.topAnchor, trailing: bottomStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: .init(width: 0, height: 75))
            forecastTableView.anchor(top: nil, leading: bottomStackView.leadingAnchor, bottom: bottomStackView.bottomAnchor, trailing: bottomStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 100))
            menuButton.anchor(top: topStackView.topAnchor, leading: topStackView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
            searchButton.anchor(top: topStackView.topAnchor, leading: nil, bottom: nil, trailing: topStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
            currentLocation.anchor(top: topStackView.topAnchor, leading: menuButton.trailingAnchor, bottom: nil, trailing: searchButton.leadingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 40))
        case 2208:
            print("iPhone 6+")
        case 2436:
            print("iPhone X")
        default:
            return
        }
    }
    
    @objc private func Animation() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        favouriteCitiesTableView.delegate = self
        favouriteCitiesTableView.dataSource = self
        forecastCollectionView.dataSource = self
        forecastTableView.register(DayCell.self, forCellReuseIdentifier: "tableViewcell")
        forecastCollectionView.register(HourCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        LayOut()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(Animation), userInfo: nil, repeats: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension UIView {
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
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.forecastTableView {
            return 7
        } else {
            return (cities?.count)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.forecastTableView {
            let cell = forecastTableView.dequeueReusableCell(withIdentifier: "tableViewcell", for: indexPath) as! DayCell
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.forecastTableView {
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities?.remove(at: indexPath.row)
            self.favouriteCitiesTableView.reloadData()
        }
    }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! HourCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}



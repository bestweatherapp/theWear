//
//  ViewController.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 23.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit
import CoreLocation

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
            views.forEach {$0.image = UIImage(named: "t")}
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
            maxWinSpeedLabel.attributedText = NSAttributedString(string: "Maximum wind speed: \(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].windSpeed_max!))) mPs", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            avgHumidityLabel.attributedText = NSAttributedString(string: "Average Humidity: \(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].avghumidity!)))%", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            sunriseLabel.attributedText = NSAttributedString(string: String(self.currentForecastCity.AllForecastDay![indexPath.row].sunrise!.dropLast(3)), attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            sunsetLabel.attributedText = NSAttributedString(string: String(self.currentForecastCity.AllForecastDay![indexPath.row].sunset!.dropLast(3)), attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            adviceInDetailedViewLabel.attributedText = NSAttributedString(string: allCommentsForDetailedView[(forecastTableView.indexPathForSelectedRow?.row)!], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            forecastForLabel.attributedText = NSAttributedString(string: "Forecast for \n\(convertDateFormaterForDailyForecastForDetailedView("\(self.currentForecastCity.AllForecastDay![indexPath.row].date!)"))", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            morningTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![9].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            afternoonTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![15].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            eveningTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![21].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            nightTemp.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![3].temperature!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            morningTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![9].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            afternoonTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![15].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            eveningTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![21].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            nightTempFeelsLike.attributedText = NSAttributedString(string: "\(Int(round(self.currentForecastCity.AllForecastDay![indexPath.row].AllHours![3].feelslike!)))°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                UIView.animate(withDuration: 0.5) {
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
            UpdateInfo(location: cities![(favouriteCitiesTableView.indexPathForSelectedRow?.row)!].folding(options: .diacriticInsensitive, locale: .current))
            UIView.animate(withDuration: 0.4) {
                    self.slideOutMenu.frame.origin.x = -250
                    self.blurEffectView.effect = nil
                    let initialIndex = 0
                    let indexPath = IndexPath(item: initialIndex, section: 0)
                    self.forecastCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    self.forecastTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
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
    let hour = Calendar.current.component(.hour, from: Date()) // Current Hour
    var allDates = [String](repeating: "", count: 7)
    var allTemps = [String](repeating: "", count: 7)
    var allTempsIcons = [String](repeating: "", count: 7)
    var allHours = [String](repeating: "", count: 12)
    var allHourlyTemps = [String](repeating: "", count: 12)
    var allHourlyTempsIcons = [String](repeating: "", count: 12)
    var currentForecastCity = ForecastCity()
    var allCommentsForDetailedView = [String]()
    var allClothesForForecastTableView = [[String](repeating: "", count: 7),[String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7), [String](repeating: "", count: 7)]
    
    
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
    private let updateWithCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString(string: "Current location", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:UIColor.myGray]), for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(UpdateWithCurrentLocation), for: .touchUpInside)
        return button
    }()
    @objc func UpdateWithCurrentLocation() {
        UpdateInfo(location: "Current location")
        [forecastTableView, forecastCollectionView, topStackView, middleStackView, bottomStackView, blurEffectView].forEach {$0.isUserInteractionEnabled = true}
        UIView.animate(withDuration: 0.4) {
            let initialIndex = 0
            let indexPath = IndexPath(item: initialIndex, section: 0)
            self.forecastCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.forecastTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.slideOutMenu.frame.origin.x = -250
            self.blurEffectView.effect = nil
            self.view.layoutIfNeeded()
        }
        self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
    }
    
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "5704"))
        return image
    }()
    private let splashScreen: UIView = {
        let view = UIView()
        view.isHidden = false
        view.backgroundColor = .white
        return view
    }()
    
    
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
        [forecastTableView, forecastCollectionView, topStackView, middleStackView, bottomStackView, blurEffectView].forEach {$0.isUserInteractionEnabled = false}
        UIView.animate(withDuration: 0.5) {
            self.slideOutMenu.frame.origin.x = 0
            self.blurEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        }
    }
    private let currentLocation: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
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
        // Animate ViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionReveal
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        }
        present(searchVC, animated: true, completion: nil)
    }
    @objc func CloseSVC() {
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = nil
            self.view.layoutIfNeeded()
        }
        self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
    }
    
    
    private var middleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private let currentTemperature: UILabel = {
        let text = UILabel()
        text.sizeToFit()
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
        tableView.layer.shadowColor = UIColor.myGray.cgColor
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: -1, height: 1)
        tableView.layer.shadowRadius = 10
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
        collectionView.layer.shadowColor = UIColor.myGray.cgColor
        collectionView.layer.shadowOpacity = 0.5
        collectionView.layer.shadowOffset = CGSize(width: -1, height: 1)
        collectionView.layer.shadowRadius = 10
        return collectionView
    }()
    
    
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
            self.detailedView.frame.origin.x = self.view.frame.width + 50
            self.topStackView.frame.origin.x = 25
            self.middleStackView.frame.origin.x = 25
            self.bottomStackView.frame.origin.x = 25
        }
    }
    
    
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
        text.numberOfLines = 6
        text.sizeToFit()
        return text
    }()
    
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Feels like", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    private let clothesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Clothes", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    private let DetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Details", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    private let maxWinSpeedLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .left
        return text
    }()
    private let avgHumidityLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .left
        return text
    }()
    private let descrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Description", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    
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
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.slideOutMenu && self.slideOutMenu.frame.origin.x == 0 {
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
            UIView.animate(withDuration: 0.5) {
                self.slideOutMenu.frame.origin.x = -250
                self.blurEffectView.effect = nil
                self.view.layoutIfNeeded()
            }
            self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
        }

    }
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.effect = nil
        return blur
    }()
    
    var leadConstr: CGFloat = -250
    
    private func LayOut() {
        
        let topLine = UIView(frame: CGRect(x: 25, y: 35, width: 275, height: 0.5))
        topLine.layer.borderWidth = 0.5
        topLine.layer.borderColor = UIColor.dark.cgColor
       
        let leftFeelsLikeLine = UIView(frame: CGRect(x: 25, y: 145, width: 110, height: 0.5))
        leftFeelsLikeLine.layer.borderWidth = 0.5
        leftFeelsLikeLine.layer.borderColor = UIColor.dark.cgColor
        let rightFeelsLikeLine = UIView(frame: CGRect(x: 190, y: 145, width: 110, height: 0.5))
        rightFeelsLikeLine.layer.borderWidth = 0.5
        rightFeelsLikeLine.layer.borderColor = UIColor.dark.cgColor
        
        let leftDescriptionLine = UIView(frame: CGRect(x: 25, y: 205, width: 105, height: 0.5))
        leftDescriptionLine.layer.borderWidth = 0.5
        leftDescriptionLine.layer.borderColor = UIColor.dark.cgColor
        let rightDescriptionLine = UIView(frame: CGRect(x: 195, y: 205, width: 105, height: 0.5))
        rightDescriptionLine.layer.borderWidth = 0.5
        rightDescriptionLine.layer.borderColor = UIColor.dark.cgColor
    
//        let leftClothesLine = UIView(frame: CGRect(x: 25, y: self.clothesLabel.frame.origin.y + 310, width: 110, height: 0.5))
//        leftClothesLine.layer.borderWidth = 0.5
//        leftClothesLine.layer.borderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
//
//        let rightClothesLine = UIView(frame: CGRect(x: 190, y: self.clothesLabel.frame.origin.y + 310, width: 110, height: 0.5))
//        rightClothesLine.layer.borderWidth = 0.5
//        rightClothesLine.layer.borderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
        
//        let leftDetailesLine = UIView(frame: CGRect(x: 25, y: 440, width: 110, height: 0.5))
//        leftDetailesLine.layer.borderWidth = 0.5
//        leftDetailesLine.layer.borderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
//        let rightDetailsLine = UIView(frame: CGRect(x: 190, y: 440, width: 110, height: 0.5))
//        rightDetailsLine.layer.borderWidth = 0.5
//        rightDetailsLine.layer.borderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
        
        [topStackView, middleStackView, bottomStackView, blurEffectView, detailedView, slideOutMenu, splashScreen].forEach {view.addSubview($0)}
        [menuButton, currentLocation, searchButton].forEach {topStackView.addArrangedSubview($0)}
        [currentTemperature, currentCondition, currentAdvice].forEach {middleStackView.addArrangedSubview($0)}
        [forecastCollectionView, forecastTableView].forEach {bottomStackView.addArrangedSubview($0)}
        [placeholderForFavLabel, favouriteCitiesTableView, updateWithCurrentLocationButton, settingsButton, addCityButton, placeholderForFav].forEach {slideOutMenu.addSubview($0)}
        [scrollView, closeDetailedViewButton, forecastForLabel].forEach {detailedView.addSubview($0)}
        [morningTempIcon, afternoonTempIcon, eveningTempIcon, nightTempIcon, morningTemp, afternoonTemp, eveningTemp, nightTemp, morningTempFeelsLike, afternoonTempFeelsLike, eveningTempFeelsLike, nightTempFeelsLike, adviceInDetailedViewLabel, topLine, leftFeelsLikeLine, rightFeelsLikeLine, leftDescriptionLine, rightDescriptionLine, feelsLikeLabel, descrLabel, clothesLabel, DetailsLabel, maxWinSpeedLabel, avgHumidityLabel, sunriseImage, sunsetImage, sunriseLabel, sunsetLabel].forEach {scrollView.addSubview($0)}
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
        case 1334:
            print("iPhone 7")
        case 2208:
            print("iPhone 7+")
        case 2436:
            print("iPhone X")
        default:
            return
        }
        
        // TopStackView
        topStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 40))
         menuButton.anchor(top: topStackView.topAnchor, leading: topStackView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        currentLocation.anchor(top: topStackView.topAnchor, leading: menuButton.trailingAnchor, bottom: topStackView.bottomAnchor, trailing: searchButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 0))
        searchButton.anchor(top: topStackView.topAnchor, leading: nil, bottom: nil, trailing: topStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        // MiddleStackView
        middleStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: bottomStackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 5, right: 25), size: .init(width: 0, height: 210))
        currentTemperature.anchor(top: middleStackView.topAnchor, leading: nil, bottom: currentCondition.topAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 5, right: 0), size: .init(width: 0, height: 70))
        currentCondition.anchor(top: nil, leading: middleStackView.leadingAnchor, bottom: currentAdvice.topAnchor, trailing: middleStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
        currentAdvice.anchor(top: nil, leading: middleStackView.leadingAnchor, bottom: middleStackView.bottomAnchor, trailing: middleStackView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 70))
        
        // BottomStackView
        bottomStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 25, right: 25), size: .init(width: 0, height: 300))
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
        
        
        
        
        
        
        
        
        
        
        
        
        blurEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        blurEffectView.isHidden = true
        
        
        
        clothesLabel.anchor(top: adviceInDetailedViewLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        clothesLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        sunriseLabel.anchor(top: sunriseImage.bottomAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 35, bottom: 20, right: 0), size: .init(width: 40, height: 30))
        sunsetLabel.anchor(top: sunsetImage.bottomAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 150, bottom: 20, right: 0), size: .init(width: 40, height: 30))
        
        sunriseImage.anchor(top: avgHumidityLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 35, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        sunsetImage.anchor(top: avgHumidityLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 150, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        DetailsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        DetailsLabel.anchor(top: clothesLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        maxWinSpeedLabel.anchor(top: DetailsLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 25, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        avgHumidityLabel.anchor(top: maxWinSpeedLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 25, bottom: 0, right: 0), size: .init(width: 0, height: 30))

        feelsLikeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        feelsLikeLabel.centerYAnchor.constraint(equalTo: leftFeelsLikeLine.centerYAnchor).isActive = true
        
        descrLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descrLabel.centerYAnchor.constraint(equalTo: leftDescriptionLine.centerYAnchor).isActive = true
        
        scrollView.anchor(top: closeDetailedViewButton.bottomAnchor, leading: detailedView.leadingAnchor, bottom: detailedView.bottomAnchor, trailing: detailedView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        adviceInDetailedViewLabel.anchor(top: morningTempFeelsLike.bottomAnchor, leading: detailedView.leadingAnchor, bottom: nil, trailing: detailedView.trailingAnchor, padding: .init(top: 30, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 0))
        
        forecastForLabel.anchor(top: nil, leading: detailedView.leadingAnchor, bottom: nil, trailing: detailedView.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: 45))
        forecastForLabel.centerYAnchor.constraint(equalTo: closeDetailedViewButton.centerYAnchor).isActive = true
        
        morningTempIcon.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 33, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        afternoonTempIcon.anchor(top: scrollView.topAnchor, leading: morningTempIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 33, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        eveningTempIcon.anchor(top: scrollView.topAnchor, leading: afternoonTempIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 33, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        nightTempIcon.anchor(top: scrollView.topAnchor, leading: eveningTempIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 33, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        morningTemp.anchor(top: morningTempIcon.bottomAnchor, leading: morningTempIcon.leadingAnchor, bottom: nil, trailing: morningTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        afternoonTemp.anchor(top: afternoonTempIcon.bottomAnchor, leading: afternoonTempIcon.leadingAnchor, bottom: nil, trailing: afternoonTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        eveningTemp.anchor(top: eveningTempIcon.bottomAnchor, leading: eveningTempIcon.leadingAnchor, bottom: nil, trailing: eveningTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        nightTemp.anchor(top: nightTempIcon.bottomAnchor, leading: nightTempIcon.leadingAnchor, bottom: nil, trailing: nightTempIcon.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        morningTempFeelsLike.anchor(top: morningTemp.bottomAnchor, leading: morningTempIcon.leadingAnchor, bottom: nil, trailing: morningTempIcon.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        afternoonTempFeelsLike.anchor(top: afternoonTemp.bottomAnchor, leading: afternoonTempIcon.leadingAnchor, bottom: nil, trailing: afternoonTempIcon.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        eveningTempFeelsLike.anchor(top: eveningTemp.bottomAnchor, leading: eveningTempIcon.leadingAnchor, bottom: nil, trailing: eveningTempIcon.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        nightTempFeelsLike.anchor(top: nightTemp.bottomAnchor, leading: nightTempIcon.leadingAnchor, bottom: nil, trailing: nightTempIcon.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
       
        closeDetailedViewButton.anchor(top: detailedView.topAnchor, leading: nil, bottom: nil, trailing: detailedView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 25), size: .init(width: 25, height: 25))
        
        detailedView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 40, left: view.frame.width + 25, bottom: 25, right: 0), size: .init(width: view.frame.width-50, height: 0))
        
        
        splashScreen.addSubview(theLabel)
        splashScreen.addSubview(weaLabel)
        splashScreen.addSubview(rLabel)
        
        weaLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 45, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        theLabel.anchor(top: view.topAnchor, leading: weaLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        rLabel.anchor(top: view.topAnchor, leading: theLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        splashScreen.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
       
        
    }
    
    func UpdateInfo(location: String) {
        
        var allDates = [String]()
        var allCommentsForDetailedView = [String]() // Add new var for all comments
        var allClothesForForecastTableView = [[String]]()
        var allTempsdays = [String]()
        var allTempsdaysIcons = [String]()
        var allHours = [String]()
        var allHourlyTemps = [String]()
        var allHourlyTempsIcons = [String]()
        let current_ = Current()
        let currentLocation : CLLocation!
        currentLocation = locationManager.location
        if (currentLocation != nil)
        {
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
                    allTempsdaysIcons.append("https:" + iconUrl)
                    guard let astro = day1["astro"] as? [String: AnyObject] else {return}
                    guard var sunrise = astro["sunrise"] as? String? else {return}
                    guard var sunset = astro["sunset"] as? String? else {return}
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
                    comment_ = methods.GetFutureComment(day: newDay, avgmorning: newDay.AllHours![7].temperature!, avgday: newDay.AllHours![12].temperature!, avgevening: newDay.AllHours![18].temperature!)
                    realComment = comment_.0
                    allClothesForForecastTableView.append(comment_.1)
                    allCommentsForDetailedView.append(realComment)
                    allTempsdays.append("\(Int(round(newDay.AllHours![12].temperature!)))°  \(Int(round(newDay.AllHours![0].temperature!)))°")
                    newDay.date = date_!
                    allDays.append(newDay)
                }
                self.allCommentsForDetailedView = allCommentsForDetailedView
                self.allClothesForForecastTableView = allClothesForForecastTableView
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
                    for i in (self.hour)..<(self.hour)+12 {
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
                        var comment = methods.GetCurrentComment(Current : current_, day : forecastday_)
                        comment += methods.GetThunderComment(forecastday: forecastday_)
                        self.currentAdvice.attributedText = NSMutableAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])

                }
                }.resume()
        }
        }
    
    private let weaLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Wea", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Bold", size: 75)!])
        text.backgroundColor = .clear
        text.layer.shadowColor = UIColor.white.cgColor
        text.layer.shadowOpacity = 1
        text.layer.shadowOffset = CGSize.zero
        text.layer.shadowRadius = 30
        return text
    }()
    
    private let theLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "the", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    
    private let rLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "r", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Bold", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    
    func catchNotification(notification: Notification) -> Void {
        guard let name = notification.userInfo!["name"] else {return}
        UpdateInfo(location: "\(name)")
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView.effect = nil
            self.view.layoutIfNeeded()
                let initialIndex = 0
                let indexPath = IndexPath(item: initialIndex, section: 0)
                self.forecastCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.forecastTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedOutside()
        UpdateInfo(location: "Current location")
        view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.backgroundColor = .lightBlue
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateFavourits), name: NSNotification.Name(rawValue: "upF"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "closeSVC"), object: nil, queue: nil, using: catchNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(CloseSVC), name: NSNotification.Name(rawValue: "closeSVCA"), object: nil)
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
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
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(Animation), userInfo: nil, repeats: false)
        Animate()
        UpdateInfo(location: "Current location")
       
    }
    
    private func Animate() {
        self.theLabel.frame.origin.x = 0
        self.weaLabel.frame.origin.x = 0
        UIView.animate(withDuration: 2, delay: 0.25, options: [.autoreverse, .repeat], animations: {
            self.theLabel.frame.origin.x += 155
            self.weaLabel.frame.origin.x -= 100
        })
    }
    
    @objc private func Animation() {
            UIView.animate(withDuration: 2, animations: {
                self.splashScreen.alpha = 0
                self.weaLabel.alpha = 0
                self.theLabel.alpha = 0
                self.rLabel.alpha = 0
            })
        self.splashScreen.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


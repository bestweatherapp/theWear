//
//  SettingsViewController.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 26.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let datePickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 35
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.shadowColor = UIColor.myGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 10
        view.isHidden = true
        return view
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.backgroundColor = .clear
        picker.layer.cornerRadius = 35
        picker.datePickerMode = UIDatePickerMode.time
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    }
    
    private let closeDatePicker: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(CloseDatePicker), for: .touchUpInside)
        return button
    }()
    @objc func CloseDatePicker() {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePickerView.alpha = 0
            self.blurEffect.alpha = 0
            self.view.layoutIfNeeded()
        })
        self.blurEffect.isHidden = true
        self.datePickerView.isHidden = true
    }
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100), for: .normal)
        button.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        return button
    }()
    @objc func okButtonPressed() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        onMorning.setTitle(selectedDate, for: .normal)
        UserDefaults.standard.setValue(selectedDate, forKey: "RemindHour")
        UIView.animate(withDuration: 0.5, animations: {
            self.datePickerView.alpha = 0
            self.blurEffect.alpha = 0
            self.view.layoutIfNeeded()
        })
        self.blurEffect.isHidden = true
        self.datePickerView.isHidden = true
    }
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(CloseSettings), for: .touchUpInside)
        return button
    }()
    
    private let topLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let notificationLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let genderLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    private let genderForLineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.attributedText = NSAttributedString(string: "Who are you?", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    private let notifyInMorning: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.attributedText = NSAttributedString(string: "Send notifications \nin the morning", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)])
        text.numberOfLines = 2
        return text
    }()
    
    private let onMorning: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(UserDefaults.standard.string(forKey: "RemindHour"), for: .normal)
        button.setTitleColor(UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100), for: .normal)
        button.addTarget(self, action: #selector(MorningView), for: .touchUpInside)
        return button
    }()
    
    @objc func MorningView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePickerView.alpha = 1
            self.blurEffect.alpha = 1
            self.view.layoutIfNeeded()
        })
        self.blurEffect.isHidden = false
        self.datePickerView.isHidden = false
    }
    
    let blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isHidden = true
        return blurView
    }()
    
    private let tempLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.attributedText = NSAttributedString(string: "Temperature", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)])
        return text
    }()
    
    private let windLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.attributedText = NSAttributedString(string: "Wind", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)])
        return text
    }()
    
    private let pressureLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.attributedText = NSAttributedString(string: "Pressure", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)])
        return text
    }()
    
    private let notificationsLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.attributedText = NSAttributedString(string: "Notifications", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)])
        return text
    }()
    
    private let notificationForLineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.attributedText = NSAttributedString(string: "Notifications", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    private let manButton: UIButton = {
        let manGender = UIButton()
        manGender.setTitle("Man", for: .normal)
        manGender.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80), for: .normal)
        manGender.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
        manGender.addTarget(self, action: #selector(manWasChoosen), for: .touchUpInside)
        return manGender
    }()
    @objc func manWasChoosen() {
        if UserDefaults.standard.string(forKey: "Gender") == "Man" { } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.manButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
                self.womanButton.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
                self.view.layoutIfNeeded()
            })
            UserDefaults.standard.setValue("Man", forKey: "Gender")
        }
        if UserDefaults.standard.string(forKey: "Gender") == nil {
            UserDefaults.standard.setValue("Man", forKey: "Gender")
        }
    }
    private let womanButton: UIButton = {
        let womanGender = UIButton()
        womanGender.setTitle("Woman", for: .normal)
        womanGender.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80), for: .normal)
        womanGender.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
        womanGender.addTarget(self, action: #selector(womanWasChoosen), for: .touchUpInside)
        return womanGender
    }()
    @objc func womanWasChoosen() {
        if UserDefaults.standard.string(forKey: "Gender") == "Woman" { } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.womanButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
                self.manButton.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
                self.view.layoutIfNeeded()
            })
            UserDefaults.standard.setValue("Woman", forKey: "Gender")
        }
        if UserDefaults.standard.string(forKey: "Gender") == nil {
            UserDefaults.standard.setValue("Woman", forKey: "Gender")
        }
    }
    
    private let temperatureForLineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.attributedText = NSAttributedString(string: "Temperature", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return label
    }()
    
    private let tempSegmentedControl: UISegmentedControl = {
         let tempChoose = ["°C", "°F"]
        let sc = UISegmentedControl(items: tempChoose)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.tintColor = .white
        sc.layer.borderWidth = 1
        sc.layer.borderColor = UIColor.dark.cgColor
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.layer.cornerRadius = 15
        sc.backgroundColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        sc.addTarget(self, action: #selector(changeTemp), for: .valueChanged)
        return sc
    }()
    
    private let windSegmentedControl: UISegmentedControl = {
        let windChoose = ["mPs", "kPh"]
        let sc = UISegmentedControl(items: windChoose)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .white
        sc.layer.borderWidth = 1
        sc.layer.borderColor = UIColor.dark.cgColor
        sc.layer.cornerRadius = 15
        sc.backgroundColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(changeWind), for: .valueChanged)
        return sc
    }()
    
    private let pressureSegmentedControl: UISegmentedControl = {
        let pressureChoose = ["x", "y"]
        let sc = UISegmentedControl(items: pressureChoose)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .white
        sc.layer.borderWidth = 1
        sc.layer.borderColor = UIColor.dark.cgColor
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.layer.cornerRadius = 15
        sc.backgroundColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        sc.addTarget(self, action: #selector(changePressure), for: .valueChanged)
        return sc
    }()
    
    @objc func CloseSettings() {
         NotificationCenter.default.post(name: Notification.Name(rawValue: "closeSVC"), object: nil, userInfo: ["name":"Current location"])
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Layout()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm" //Your date format
        let date = dateFormatter.date(from: UserDefaults.standard.string(forKey: "RemindHour")!)
        datePicker.date = date!
    
       
        view.backgroundColor = .white
    }
    @objc func changeTemp(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(0, forKey: "Temp")
        case 1:
            UserDefaults.standard.set(1, forKey: "Temp")
        default:
            UserDefaults.standard.set(0, forKey: "Temp")
        }
    }
    
    @objc func changeWind(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(0, forKey: "Wind")
        case 1:
            UserDefaults.standard.set(1, forKey: "Wind")
        default:
            UserDefaults.standard.set(0, forKey: "Wind")
        }
    }
    
    @objc func changePressure(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(0, forKey: "Pressure")
        case 1:
            UserDefaults.standard.set(1, forKey: "Pressure")
        default:
            UserDefaults.standard.set(0, forKey: "Pressure")
        }
    }
    
    private let notificationsSwitch: UISwitch = {
        let nSwitch = UISwitch()
        nSwitch.setOn(false, animated: false)
        nSwitch.translatesAutoresizingMaskIntoConstraints = false
        nSwitch.onTintColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 100)
        nSwitch.thumbTintColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        nSwitch.backgroundColor = .white
        nSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return nSwitch
    }()
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("Notifications on")
        } else {
            print("Notifications off")
        }
    }
    
    private func Layout() {
        [closeButton, topLine, tempLabel, temperatureForLineLabel, windLabel, pressureLabel, notificationsLabel, notifyInMorning, onMorning, notificationLine, genderLine, notificationForLineLabel, genderForLineLabel, manButton, womanButton, tempSegmentedControl, windSegmentedControl, pressureSegmentedControl, notificationsSwitch, blurEffect, datePickerView].forEach {view.addSubview($0)}
        datePickerView.addSubview(closeDatePicker)
        datePickerView.addSubview(datePicker)
        datePickerView.addSubview(okButton)
        if UserDefaults.standard.string(forKey: "Gender") == "Man" {
            self.manButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        } else {
            self.womanButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        }
        
        var padding: CGFloat = 0
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
            padding = 22
        case 1334:
            print("iPhone 7")
            padding = 33
        case 1920:
            print("iPhone 7+")
            padding = 40.8
        case 2436:
            print("iPhone X")
            padding = 33
        default:
            return
        }

        
        // Temperature
        tempSegmentedControl.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor).isActive = true
        tempSegmentedControl.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: padding), size: .init(width: 90, height: 30))
        
        // Wind
        windSegmentedControl.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: padding), size: .init(width: 90, height: 30))
        windSegmentedControl.centerYAnchor.constraint(equalTo: windLabel.centerYAnchor).isActive = true
    
        // Pressure
        pressureSegmentedControl.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: padding), size: .init(width: 90, height: 30))
        pressureSegmentedControl.centerYAnchor.constraint(equalTo: pressureLabel.centerYAnchor).isActive = true
        
        // Notifications
        notificationsSwitch.centerYAnchor.constraint(equalTo: notificationsLabel.centerYAnchor).isActive = true
        notificationsSwitch.centerXAnchor.constraint(equalTo: tempSegmentedControl.centerXAnchor).isActive = true
        
        // Date Picker
        datePickerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 175, left: 75, bottom: 175, right: 75), size: .init())
        closeDatePicker.anchor(top: datePickerView.topAnchor, leading: nil, bottom: nil, trailing: datePickerView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 25), size: .init(width: 25, height: 25))
        datePicker.anchor(top: closeDatePicker.bottomAnchor, leading: datePickerView.leadingAnchor, bottom: datePickerView.bottomAnchor, trailing: datePickerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 35, right: 0), size: .init())
        okButton.anchor(top: datePicker.bottomAnchor, leading: datePickerView.leadingAnchor, bottom: datePickerView.bottomAnchor, trailing: datePickerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init())
        
        
        // Blur effect
        blurEffect.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init())
        
        
        
        
        
        
        topLine.anchor(top: closeButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 0.5))
        
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 20), size: .init(width: 27, height: 27))
        
        tempLabel.anchor(top: topLine.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: padding, bottom: 0, right: 0), size: .init(width: 120, height: 0))
        temperatureForLineLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        temperatureForLineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temperatureForLineLabel.centerYAnchor.constraint(equalTo: topLine.centerYAnchor).isActive = true
        
        windLabel.anchor(top: tempLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: padding, bottom: 0, right: 0), size: .init(width: 100, height: 0))
        
        pressureLabel.anchor(top: windLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: padding, bottom: 0, right: 0), size: .init(width: 100, height: 0))
        
        notificationLine.anchor(top: pressureLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 35, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 0.5))
        notificationForLineLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        notificationForLineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notificationForLineLabel.centerYAnchor.constraint(equalTo: notificationLine.centerYAnchor).isActive = true
        
        notificationsLabel.anchor(top: notificationLine.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: padding, bottom: 0, right: 0), size: .init(width: 150, height: 0))
        
        notifyInMorning.anchor(top: notificationsLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: padding, bottom: 0, right: 0), size: .init())
        
        onMorning.centerYAnchor.constraint(equalTo: notifyInMorning.centerYAnchor).isActive = true
        onMorning.heightAnchor.constraint(equalToConstant: 20).isActive = true
        onMorning.centerXAnchor.constraint(equalTo: pressureSegmentedControl.centerXAnchor).isActive = true
        onMorning.widthAnchor.constraint(equalToConstant: 70).isActive = true
        onMorning.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        genderLine.anchor(top: notifyInMorning.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 35, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 0.5))
        genderForLineLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        genderForLineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genderForLineLabel.centerYAnchor.constraint(equalTo: genderLine.centerYAnchor).isActive = true
        
        manButton.anchor(top: genderForLineLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: (padding * 2.5), bottom: 0, right: 0), size: .init())
        womanButton.anchor(top: genderForLineLabel.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: (padding * 2.5)), size: .init())
        
    }
}

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
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(CloseSettings), for: .touchUpInside)
        return button
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
        button.setTitle("7:00", for: .normal)
        button.setTitleColor(UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100), for: .normal)
        button.addTarget(self, action: #selector(MorningView), for: .touchUpInside)
        return button
    }()
    
    @objc func MorningView() {
        UIView.animate(withDuration: 0.3) {
            self.datePickerView.isHidden = false
        }
    }
    
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
    
    private let tempSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.layer.cornerRadius = 20
        sc.backgroundColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        sc.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return sc
    }()
    
    @objc func CloseSettings() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Layout()
        view.backgroundColor = .white
    }
    
    @objc func changeValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            print("1")
        case 2:
            print("2")
        default:
            print("none")
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        print("Switch value is \(sender.isOn)")
    }
    
    private func Layout() {
        view.addSubview(closeButton)
        view.addSubview(tempLabel)
        view.addSubview(windLabel)
        view.addSubview(pressureLabel)
        view.addSubview(notificationsLabel)
        view.addSubview(notifyInMorning)
        view.addSubview(onMorning)
        let tempChoose = ["°C", "°F"]
        let tempSegmentedControl = UISegmentedControl(items: tempChoose)
        tempSegmentedControl.selectedSegmentIndex = 0
        tempSegmentedControl.tintColor = .white
        tempSegmentedControl.layer.borderWidth = 1
        tempSegmentedControl.layer.borderColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100).cgColor
        tempSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tempSegmentedControl.layer.cornerRadius = 15
        tempSegmentedControl.backgroundColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        tempSegmentedControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        view.addSubview(tempSegmentedControl)
        
        tempSegmentedControl.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor).isActive = true
        tempSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        tempSegmentedControl.widthAnchor.constraint(equalToConstant: 90).isActive = true
        tempSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let windChoose = ["mPs", "kPh"]
        let windSegmentedControl = UISegmentedControl(items: windChoose)
        windSegmentedControl.selectedSegmentIndex = 0
        windSegmentedControl.tintColor = .white
        windSegmentedControl.layer.borderWidth = 1
        windSegmentedControl.layer.borderColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100).cgColor
        windSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        windSegmentedControl.layer.cornerRadius = 15
        windSegmentedControl.backgroundColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        windSegmentedControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        view.addSubview(windSegmentedControl)
        
        windSegmentedControl.centerYAnchor.constraint(equalTo: windLabel.centerYAnchor).isActive = true
        windSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        windSegmentedControl.widthAnchor.constraint(equalToConstant: 90).isActive = true
        windSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let pressureChoose = ["x", "y"]
        let pressureSegmentedControl = UISegmentedControl(items: pressureChoose)
        pressureSegmentedControl.selectedSegmentIndex = 0
        pressureSegmentedControl.tintColor = .white
        pressureSegmentedControl.layer.borderWidth = 1
        pressureSegmentedControl.layer.borderColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100).cgColor
        pressureSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        pressureSegmentedControl.layer.cornerRadius = 15
        pressureSegmentedControl.backgroundColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        pressureSegmentedControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        view.addSubview(pressureSegmentedControl)
        
        pressureSegmentedControl.centerYAnchor.constraint(equalTo: pressureLabel.centerYAnchor).isActive = true
        pressureSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        pressureSegmentedControl.widthAnchor.constraint(equalToConstant: 90).isActive = true
        pressureSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let notificationsSwitch = UISwitch()
        notificationsSwitch.setOn(false, animated: false)
        notificationsSwitch.translatesAutoresizingMaskIntoConstraints = false
        //notificationsSwitch.tintColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        notificationsSwitch.onTintColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 100)
        notificationsSwitch.thumbTintColor = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 100)
        notificationsSwitch.backgroundColor = .white
        notificationsSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        view.addSubview(notificationsSwitch)
        
        notificationsSwitch.centerYAnchor.constraint(equalTo: notificationsLabel.centerYAnchor).isActive = true
        notificationsSwitch.centerXAnchor.constraint(equalTo: pressureSegmentedControl.centerXAnchor).isActive = true
        notificationsSwitch.widthAnchor.constraint(equalToConstant: 65).isActive = true
        notificationsSwitch.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(datePickerView)
        datePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        datePickerView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        datePickerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        

        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        tempLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        tempLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        windLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 20).isActive = true
        windLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        windLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        pressureLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 20).isActive = true
        pressureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        pressureLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        notificationsLabel.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor, constant: 60).isActive = true
        notificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        notificationsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        notifyInMorning.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 40).isActive = true
        notifyInMorning.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        onMorning.centerYAnchor.constraint(equalTo: notifyInMorning.centerYAnchor).isActive = true
        onMorning.heightAnchor.constraint(equalToConstant: 20).isActive = true
        onMorning.centerXAnchor.constraint(equalTo: pressureSegmentedControl.centerXAnchor).isActive = true
        onMorning.widthAnchor.constraint(equalToConstant: 70).isActive = true
        onMorning.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }
}

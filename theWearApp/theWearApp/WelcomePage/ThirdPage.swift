//
//  ThirdPage.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 03.06.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit
import UserNotifications

class ThirdPage: UICollectionViewCell {
    
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 80).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5
        return view
    }()
    
    let allowNotifications = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        LayOut()
    }
    @objc func AllowNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                UserDefaults.standard.set(1, forKey: "AllowUserNotifications")
            } else {
                UserDefaults.standard.set(0, forKey: "AllowUserNotifications")
            }
        }
    }
    
    func LayOut() {
        addSubview(popUpView)
        popUpView.addSubview(allowNotifications)
        
        allowNotifications.setTitle("Allow", for: .normal)
        allowNotifications.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80), for: .normal)
        allowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
        allowNotifications.translatesAutoresizingMaskIntoConstraints = false
        allowNotifications.addTarget(self, action: #selector(AllowNotifications), for: .touchUpInside)
        
        popUpView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 120, left: 50, bottom: 120, right: 50), size: .init())
        
        allowNotifications.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        allowNotifications.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


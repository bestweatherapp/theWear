
import UIKit
import UserNotifications
import CoreLocation

class ThirdPage: UICollectionViewCell {
    
    let locationManager = CLLocationManager()
    
    private let text: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 2
        text.sizeToFit()
        text.attributedText = NSAttributedString(string: "Just one more thing...", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return text
    }()
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "for3page"))
        return image
    }()
    
    private let setNotifications: UILabel = {
        let text = UILabel()
        text.sizeToFit()
        text.textAlignment = .center
        text.numberOfLines = 2
        text.attributedText = NSAttributedString(string:"Would you like to get\n weather notifications?", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return text
    }()
    
    private let setLocation: UILabel = {
        let text = UILabel()
        text.sizeToFit()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string:"Let us use your location?", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor.dark])
        return text
    }()
    
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
    let doNotallowNotifications = UIButton()
    
    let allowLocation = UIButton()
    let doNotAllowLocation = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        LayOut()
    }
    
    @objc func AllowLocation() {
        locationManager.requestAlwaysAuthorization()
        if UserDefaults.standard.integer(forKey: "Location") == 1 { } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.allowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 19)
                self.doNotAllowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
                self.layoutIfNeeded()
            })
            UserDefaults.standard.set(1, forKey: "Location")
        }
        if UserDefaults.standard.integer(forKey: "Location") != 0 && UserDefaults.standard.integer(forKey: "Location") != 1 {
            UserDefaults.standard.set(1, forKey: "Location")
        }
    }
    
    @objc func DoNotAllowLocation() {
        if UserDefaults.standard.integer(forKey: "Location") == 0 {
            self.doNotAllowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 19)
            self.allowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
            self.layoutIfNeeded()
             UserDefaults.standard.set(0, forKey: "Location")
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.doNotAllowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 19)
                self.allowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
                self.layoutIfNeeded()
            })
            UserDefaults.standard.set(0, forKey: "Location")
        }
        if UserDefaults.standard.integer(forKey: "Location") != 0 && UserDefaults.standard.integer(forKey: "Location") != 1 {
            UserDefaults.standard.set(0, forKey: "Location")
        }
    }
    
    @objc func AllowNotifications() {
          print(UserDefaults.standard.integer(forKey: "Notifications"))
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                UserDefaults.standard.set(1, forKey: "Notifications")
                UserDefaults.standard.set("07:00", forKey: "RemindHour")
            } else {
                UserDefaults.standard.set(0, forKey: "Notifications")
            }
        }
        if UserDefaults.standard.integer(forKey: "Notifications") == 1 { } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.allowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 19)
                self.doNotallowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
                self.layoutIfNeeded()
            })
            UserDefaults.standard.set(1, forKey: "Notifications")
        }
        if UserDefaults.standard.integer(forKey: "Notifications") != 0 && UserDefaults.standard.integer(forKey: "Notifications") != 1 {
            UserDefaults.standard.set(1, forKey: "Notifications")
        }
       //  scheduleNotification(atDate:createDate(hour: 07, minute: 00) , title: "Daily forecast")
    }
    
    @objc func DonotAllowNotifications() {
        print(UserDefaults.standard.integer(forKey: "Notifications"))
        if UserDefaults.standard.integer(forKey: "Notifications") == 0 {
            self.doNotallowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 21)
            self.allowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
            self.layoutIfNeeded()
        } else if (UserDefaults.standard.integer(forKey: "Notifications") == 1 ||
            UserDefaults.standard.integer(forKey: "Notifications") != 0) {
            UIView.animate(withDuration: 0.3, animations: {
                self.doNotallowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 19)
                self.allowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
                self.layoutIfNeeded()
            })
            UserDefaults.standard.set(0, forKey: "Notifications")
        }
        UserDefaults.standard.set("07:00", forKey: "RemindHour")
    }
    
    func LayOut() {
        addSubview(popUpView)
        [text, image, allowNotifications, setNotifications, doNotallowNotifications, setLocation, allowLocation, doNotAllowLocation].forEach {popUpView.addSubview($0)}
        
        var fontForAdditionText: CGFloat = 0
        var padding: CGFloat = 0
        var imageSize: CGFloat = 0
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
        case 1334:
            fontForAdditionText = 16
            padding = 6
            imageSize = 100
        case 1920:
            fontForAdditionText = 14
            imageSize = 120
            padding = 12
        case 2436:
            print("iPhone X")
        default:
            return
        }
        
        image.anchor(top: popUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: imageSize, height: imageSize))
        image.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        popUpView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 75, left: 30, bottom: 75, right: 30), size: .init())
        
        text.anchor(top: image.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: padding * 3, left: 0, bottom: 0, right: 0), size: .init())
        text.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        
        allowNotifications.setTitle("Of course", for: .normal)
        allowNotifications.setTitleColor(UIColor.dark, for: .normal)
        allowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
        allowNotifications.addTarget(self, action: #selector(AllowNotifications), for: .touchUpInside)
        
        doNotallowNotifications.setTitle("No", for: .normal)
        doNotallowNotifications.setTitleColor(UIColor.dark, for: .normal)
        doNotallowNotifications.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
        doNotallowNotifications.addTarget(self, action: #selector(DonotAllowNotifications), for: .touchUpInside)
        
        allowLocation.setTitle("Sure", for: .normal)
        allowLocation.setTitleColor(UIColor.dark, for: .normal)
        allowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
        allowLocation.addTarget(self, action: #selector(AllowLocation), for: .touchUpInside)
        
        doNotAllowLocation.setTitle("No", for: .normal)
        doNotAllowLocation.setTitleColor(UIColor.dark, for: .normal)
        doNotAllowLocation.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 18)
        doNotAllowLocation.addTarget(self, action: #selector(DoNotAllowLocation), for: .touchUpInside)
        
        popUpView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 75, left: 30, bottom: 75, right: 30), size: .init())
        setNotifications.anchor(top: text.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: padding * 3, left: 0, bottom: 0, right: 0), size: .init())
        setNotifications.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        
        setLocation.anchor(top: allowNotifications.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: padding * 3, left: 0, bottom: 0, right: 0), size: .init())
        setLocation.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        
        allowNotifications.anchor(top: setNotifications.bottomAnchor, leading: popUpView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: padding * 3, left: padding * 5, bottom: 0, right: 0), size: .init(width: 100, height: 40))
        
        doNotallowNotifications.anchor(top: setNotifications.bottomAnchor, leading: nil, bottom: nil, trailing: popUpView.trailingAnchor, padding: .init(top: padding * 3, left: 0, bottom: 0, right: padding * 5), size: .init(width: 60, height: 40))
        
        allowLocation.anchor(top: setLocation.bottomAnchor, leading: popUpView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: padding * 3, left: padding * 5, bottom: 0, right: 0), size: .init(width: 100, height: 40))
        
        doNotAllowLocation.anchor(top: setLocation.bottomAnchor, leading: nil, bottom: nil, trailing: popUpView.trailingAnchor, padding: .init(top: padding * 3, left: 0, bottom: 0, right: padding * 5), size: .init(width: 60, height: 40))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


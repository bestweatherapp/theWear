//
//  WelcomePage.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 23.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

extension UIColor {
    static var dark = UIColor(red: 36/255, green: 34/255, blue: 34/255, alpha: 1)
    static var lightBlue = UIColor(red: 124/255, green: 214/255, blue: 255/255, alpha: 1)
}
class WelcomePage: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pages = [
        Page(imageName: "page1", headerText: "theWear - это лучшее погодное приложение", bodyText: "\n\n\nОно предоставляет точнейший прогноз погоды, но также вы сможете посмотреть совет по одежде, которую следовало бы надеть на текущий момент или предстоящий день"),
        Page(imageName: "page2", headerText: "Бла бла бла", bodyText: "\n\n\nТут должно быть какое-нибудь дополнительное описание, но мне лень"),
        Page(imageName: "page3", headerText: "Пользуйтесь уведомлениями", bodyText: "\n\n\nБлагодаря уведомлениям вы сможете получать изменённый прогноз погоды, сводку по погоде с утра на предстоящий день и много много другого, поэтому подключайте уведомления без регистрации и смс")
    ]
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "defaultWelcome")
        view.frame = view.bounds
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .dark
        pc.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.9)
        return pc
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.dark, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.dark, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        previousButton.setTitle("Back", for: .normal)
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        if indexPath.item == 2 {
            nextButton.setTitle("Start", for: .normal)
        } else {
           nextButton.setTitle("Next", for: .normal)
        }
        if pageControl.currentPage == indexPath.item {
//            After that WelcomePage will be closed and will never appear again
//            UserDefaults.standard.set(true, forKey: "firstTimeOpened")
//            let mainVC = ViewController()
//            present(mainVC, animated: true, completion: nil)
        }
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        if indexPath.item == 0 {
            previousButton.setTitle("", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlue
        setupBottomControls()
        collectionView?.backgroundColor = .clear
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "pageId")
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

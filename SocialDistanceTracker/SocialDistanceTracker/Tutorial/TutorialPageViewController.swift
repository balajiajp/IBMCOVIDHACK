//
//  TutorialPageViewController.swift
//  SocialDistanceTracker
//
//  Created by NivasK on 26/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    fileprivate var items: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        decoratePageControl()
        
        populateItems()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func decoratePageControl() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [TutorialPageViewController.self])
        pc.currentPageIndicatorTintColor = .orange
        pc.pageIndicatorTintColor = .gray
    }
    
    fileprivate func populateItems() {
        let heading = ["Social Distancing", "Contact & Violator Tracking", "Non Smart Phone User Support"]
        let description = ["This application is for both store keepers(Vendors) and comon users.\n\n Social distancing will be calculated based on device’s bluetooth.\n\n Vendor/User can also add trusted device by scanning their QR code in mobile. So proximity will not trigger for those users/devices", "Vendor/user should geo tag their shop/home within the app so user who visit shop and not making any transaction will also be monitored.\n\n User’s last 21 days GPS location will also be stored locally or remotely. \n\n Violator’s QR code color will be changed or restricted to scan while making any purchase until successful self assessment in app.", "Vendors should only sell products to buyers who has unique QR code by scanning their QR code in App or just by asking their Aadhar/mobile number."]

        for (index, t) in heading.enumerated() {
            let c = createCarouselItemControler(with: heading[index], descriptionText: description[index], color: .white)
            items.append(c)
        }
    }
    
    fileprivate func createCarouselItemControler(with titleText: String?, descriptionText: String?, color: UIColor?) -> UIViewController {
        let c = UIViewController()
        c.view = CarouselItem(heading: titleText, descriptiontxt: descriptionText, background: color)
        return c
    }
}


// MARK: - DataSource

extension TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = items.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}

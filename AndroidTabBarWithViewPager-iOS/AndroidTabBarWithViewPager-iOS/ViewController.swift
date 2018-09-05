//
//  ViewController.swift
//  AndroidTabBarWithViewPager-iOS
//
//  Created by Sulaiman Khan on 4/9/18.
//  Copyright © 2018 Sulaiman Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pageManager:RMPageManagerViewController?
    var viewControllers: [UIViewController] = []
    var titles:[RMSegmentedViewDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTabViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupTabViews() {
        for i in 0..<5 {
            if let viewController = UIStoryboard.mainStoryBoard().instantiateViewController(withIdentifier: "DummyViewController") as? DummyViewController {
                viewController.name = "ViewController no \(i+1)"
                self.viewControllers.append(viewController)
                
                let dataModel = RMSegmentedViewDataModel.init("Tab \(i+1)", badge: nil)
                self.titles.append(dataModel)
            }
        }
        self.pageManager = RMPageManagerViewController.init(viewContollers: self.viewControllers, dataModels: self.titles)
        if let manager = self.pageManager {
            self.view.addSubview(manager.view)
            self.addChildViewController(manager)
        }
        }

}


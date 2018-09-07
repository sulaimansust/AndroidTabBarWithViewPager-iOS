//
//  ViewController.swift
//  AndroidTabBarWithViewPager-iOS
//
//  Created by Sulaiman Khan on 4/9/18.
//  Copyright © 2018 Sulaiman Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pageManager:SKPageManagerViewController?
    var viewControllers: [UIViewController] = []
    var titles:[SKSegmentedViewDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTabViews()
        self.setupNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupTabViews() {
        for i in 0..<3 {
            if let viewController = UIStoryboard.mainStoryBoard().instantiateViewController(withIdentifier: "DummyViewController") as? DummyViewController {
                viewController.name = "ViewController no \(i+1)"
                self.viewControllers.append(viewController)
                
                let dataModel = SKSegmentedViewDataModel.init("Tab \(i+1)", badge: nil)
                self.titles.append(dataModel)
            }
        }
        self.pageManager = SKPageManagerViewController.init(viewContollers: self.viewControllers, dataModels: self.titles)
        if let manager = self.pageManager {
            self.view.addSubview(manager.view)
            self.addChildViewController(manager)
        }
    }
    
    private func setupNavigationBar() -> Void {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.edgesForExtendedLayout = []
        
        self.navigationItem.title = "Android Tab Bar"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Left ", style: .plain, target: self, action: nil)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Right", style: .plain, target: self, action: nil)
// 
    }

}


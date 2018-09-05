//
//  File.swift
//  AndroidTabBarWithViewPager-iOS
//
//  Created by Sulaiman Khan on 5/9/18.
//  Copyright © 2018 Sulaiman Khan. All rights reserved.
//

import Foundation
import UIKit

class DummyViewController : UIViewController{
    var name: String?
        @IBOutlet weak var nameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.text = self.name ?? "Default name"
    }
    
}

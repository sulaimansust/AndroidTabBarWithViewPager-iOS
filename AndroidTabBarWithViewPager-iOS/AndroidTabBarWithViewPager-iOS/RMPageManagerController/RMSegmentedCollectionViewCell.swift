//
//  RMSegmentedCollectionViewCell.swift
//  Messenger
//
//  Created by Sulaiman Khan on 3/10/18.
//  Copyright © 2018 Ring Inc. All rights reserved.
//

import Foundation
import UIKit

class RMSegmentedCollectionViewCell : UICollectionViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var badgeLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var badgeView: UIView!


	class func nib () -> UINib {
		return UINib.init(nibName: nibName(), bundle: Bundle.main)
	}
	
	class func nibName() -> String {
		return "RMSegmentedCollectionViewCell"
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.layoutIfNeeded()
		
		self.badgeLabel.clipsToBounds = true
		self.badgeLabel.layer.cornerRadius = self.badgeLabel.frame.size.height / 2
		
	}
	
	func selectedFont () -> UIFont {
		return UIFont.init(name: "HelveticaNeue-Medium", size: 14.0)!
	}
	
	func normalFont () -> UIFont {
		return UIFont.init(name: "HelveticaNeue", size: 13.0)!
	}
	
	func setCellSelected (selected: Bool) -> Void {
		if selected {
			self.separatorView.isHidden = false
			//TODO: Here title label text color need to be appprimary color
			self.titleLabel.textColor = UIColor.gray
			self.titleLabel.font = self.selectedFont()
		} else {
			self.separatorView.isHidden = true
			self.titleLabel.textColor = UIColor.darkGray
			self.titleLabel.font = self.normalFont()
		}
	}
	
	func configureCellWith(segmentedViewDataModel: RMSegmentedViewDataModel) -> Void {
		self.titleLabel.text = segmentedViewDataModel.titleString
		
		if let stringBadge = segmentedViewDataModel.badgeString {
			if stringBadge.count > 0 {
				self.badgeLabel.text = segmentedViewDataModel.badgeString
				self.badgeView.isHidden = false
			} else {
				self.badgeView.isHidden = true
			}
		} else {
			self.badgeView.isHidden = true
		}
		
		
	}
	
	
}

//
//  RMSegmentedView.swift
//  Messenger
//
//  Created by Sulaiman Khan on 3/10/18.
//  Copyright © 2018 Ring Inc. All rights reserved.
//

import Foundation
import UIKit

struct RMSegmentedViewDataModel {
	var titleString : String?
	var badgeString : String?
	
    init(_ title: String?, badge: String?) {
		self.titleString = title
		self.badgeString = badge
	}
	
}

public enum ScrollingItemType {
	case backgroundView, collectionView, none
}

public protocol RMSegmentedViewDelegate: class  {
	func segmentedView(_ segmentedView: RMSegmentedView, didSelectedIndex index: Int) -> Void
}


public class RMSegmentedView : UIView {
	
	@IBOutlet weak var selectedTabImageView: UIImageView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var selectedIndex:Int!
	var delegate:RMSegmentedViewDelegate?
	
	var lastScrollingValue : CGFloat!
	var isScrollingRemote : Bool = false
	var isLastCollectionScroll : Bool = false
	var currentScrollingType : ScrollingItemType!
	
	var segementedDataModels : [RMSegmentedViewDataModel]!
	
	class func  viewWithSegments(segmentsArray: [RMSegmentedViewDataModel]) -> RMSegmentedView {
		let segmentedView = initViewUsingNib()
		segmentedView.segementedDataModels = segmentsArray
		segmentedView.setupViews()
		return segmentedView
	}
	
	class func nibName() -> String {
		return "RMSegmentedView"
	}
	
	class func initViewUsingNib() -> RMSegmentedView {
		let segmentedView = Bundle.main.loadNibNamed(nibName(), owner: self, options: nil)![0] as! RMSegmentedView
		return segmentedView
		
//		let vc = UIViewController.init(nibName: nibName(), bundle: Bundle.main)
		
//		return vc.view as! RMSegmentedView
	}
	
	
	
	func endOfOriginY() -> CGFloat {
		return self.frame.origin.y + self.frame.size.height
	}
	
	func setupViews () -> Void {
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		self.layer.shadowOpacity = 0.5
		self.layer.shadowRadius = 0.5
		
		self.lastScrollingValue = 0
		self.selectedIndex = 0
		
		self.currentScrollingType = .none
		
		self.setupCollectionView()
		self.setupTabImageView()
	}
	
	
	func setupCollectionView() -> Void {
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		self.collectionView.register(RMSegmentedCollectionViewCell.nib(), forCellWithReuseIdentifier: RMSegmentedCollectionViewCell.nibName())
		
		//TODO: May be problem in this section
		let layout  =  RMSegmentedCollectionViewLayout.init()
		
		layout.itemSize = CGSize(width: self.itemWidth(), height: self.collectionView.frame.size.height)
		
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.sectionInset = UIEdgeInsets.zero
		layout.scrollDirection = .horizontal
		
		self.collectionView.collectionViewLayout = layout
		
		self.collectionView.reloadData()
		self.addLongPressGesture()
		
	}
	
	func setupTabImageView() -> Void {
		var frame = self.selectedTabImageView.frame
		
		frame.size.width = self.itemWidth()
		self.selectedTabImageView.frame = frame

	}
	
	func itemWidth () -> CGFloat {
		let  screenWidth = UIScreen.main.bounds.size.width
		
		var itemWidth = screenWidth / 3
		
		if self.segementedDataModels.count < 3 {
			itemWidth = screenWidth / CGFloat( self.segementedDataModels.count )
		}
		
		return itemWidth
		
	}
	
	func addLongPressGesture() -> Void {
		let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
		
		longPressGesture.delegate = self
		longPressGesture.delaysTouchesBegan = true
		
		self.collectionView.addGestureRecognizer(longPressGesture)
		
	}
	
	/*
	No usage in StickerMarket, has usage in Messages and other ViewControllers
	*/
	
	@objc internal func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) -> Void {
		if gestureRecognizer.state != .ended {
			return
		}
		
//		let point = gestureRecognizer.location(in: self.collectionView)
//
//		let indexPath = self.collectionView.indexPathForItem(at: point)
//
//		if let index = indexPath {
//			if self.selectedIndex == index.row {
//				var segmentedDataModel = self.segementedDataModels[index.row]
//
//				if segmentedDataModel.titleString == "Message" {
//
//				}
//
//			}
//		}
		
	}
	
 func reloadWithSelectedIndex(index: Int) -> Void {
		self.selectedIndex = index
		self.collectionView.reloadData()
		self.lastScrollingValue = 0
		self.isScrollingRemote = false
		self.reloadSubViewFrameToCurrentPosition()
	}
	
 func reloadSubViewFrameToCurrentPosition() -> Void {
		let indexPath = IndexPath.init(row: self.selectedIndex, section: 0)
		
		self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
		
		self.selectedTabImageView.frame = self.getInViewFrameOfCellAt(index: self.selectedIndex)
		
		self.isLastCollectionScroll = false
		self.currentScrollingType = .none
	}
	fileprivate func getInViewFrameOfCellAt(index: Int) -> CGRect {
		
		let indexPath = IndexPath.init(row: self.selectedIndex, section: 0)
		let attribute : UICollectionViewLayoutAttributes = self.collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)!
		
		var frame = attribute.frame
		frame = self.collectionView.convert(frame, to: self)
		return frame
	}
	
	func  scrollingFromRemoteWith(scrollingValue: CGFloat) -> Void {
		
		if self.isLastCollectionScroll {
			self.reloadSubViewFrameToCurrentPosition()
		}
		
		self.isScrollingRemote = true
		
		if self.currentScrollingType == .none {
			self.currentScrollingType = .backgroundView
			
			if scrollingValue > 0 {
				if self.selectedIndex == 0 || self.selectedIndex == self.segementedDataModels.count - 2 {
					self.currentScrollingType = .backgroundView
				} else {
					if self.selectedIndex == self.segementedDataModels.count - 1  || self.selectedIndex == 1 {
						self.currentScrollingType = .backgroundView
					}
				}
			}
			
		}
		
		if self.currentScrollingType == .backgroundView {
			
			var frame = selectedTabImageView.frame
			frame.origin.x += (scrollingValue - self.lastScrollingValue) * self.itemWidth()
			
			if frame.origin.x > 0 && frame.origin.x < self.frame.size.width - frame.size.width {
				self.selectedTabImageView.frame = frame
			}
			
		} else {
		
			let xOffSet = self.collectionView.contentOffset.x + (scrollingValue - self.lastScrollingValue) * self.itemWidth()
			if xOffSet >= 0 && xOffSet <= self.collectionView.contentSize.width - self.frame.size.width {
				self.collectionView.contentOffset = CGPoint(x: xOffSet, y: self.collectionView.contentOffset.y)
			}
			
		}
		
		self.lastScrollingValue = scrollingValue
		self.isScrollingRemote = false
		
		
	}
	
	func updateSegmentWithDataModel(segmentDataModel: RMSegmentedViewDataModel, at segmentIndex: Int) -> Void {
		self.segementedDataModels[segmentIndex] = segmentDataModel
		self.collectionView.reloadData()
	}
	
	
	
}

extension RMSegmentedView : UICollectionViewDelegate {
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let cell = collectionView.cellForItem(at: indexPath)
		
		let frame = cell?.convert(cell!.bounds, to: self)
		
		self.selectedTabImageView.frame = frame!
		
		self.reloadWithSelectedIndex(index: indexPath.row)
		
		if self.selectedIndex > 0 && self.selectedIndex < self.segementedDataModels.count - 1 {
			
			UIView.animate(withDuration: 0.3, animations: {
				self.selectedTabImageView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
				self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
			}) {
				success in
				
				self.isScrollingRemote = false
			}
		}
		
		if self.delegate != nil {
			self.delegate?.segmentedView(self, didSelectedIndex: indexPath.row)
		}
		
		
	}
}


extension RMSegmentedView : UICollectionViewDataSource {
	
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.segementedDataModels.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell: RMSegmentedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RMSegmentedCollectionViewCell.nibName(), for: indexPath) as! RMSegmentedCollectionViewCell
		
		let segmentDataModel = self.segementedDataModels[indexPath.row]
		cell.configureCellWith(segmentedViewDataModel: segmentDataModel)
		cell.setCellSelected(selected: indexPath.row == self.selectedIndex)
		
		return cell
	}
	
	
}

extension RMSegmentedView : UIGestureRecognizerDelegate {

}

extension RMSegmentedView : UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if self.isScrollingRemote {
			return
		}
		
		let indexPath = IndexPath.init(row: self.selectedIndex, section: 0)
		
		let collectionViewCell = self.collectionView.cellForItem(at: indexPath)
		if let cell = collectionViewCell {
			let frame = cell.convert(cell.bounds, to: self)
			self.selectedTabImageView.frame = frame
		}
		
		self.isLastCollectionScroll = true
		
	}
}

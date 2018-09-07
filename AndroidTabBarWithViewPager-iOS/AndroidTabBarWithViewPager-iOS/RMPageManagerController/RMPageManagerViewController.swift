//
//  RMPageManagerViewController.swift
//  Messenger
//
//  Created by Sulaiman Khan on 3/10/18.
//  Copyright © 2018 Ring Inc. All rights reserved.
//

import Foundation
import UIKit

//MARK: Need to check initialization if ok
@objc class RMPageManagerViewController : UIViewController {
	
	//MARK: Local Variables
	var disableSegmentView : Bool = false
	
	var segmentedView : RMSegmentedView!
	var pageViewController : UIPageViewController!
	
	var viewControllers:[UIViewController]?
	var segmentedDataModels:[RMSegmentedViewDataModel]?
	
	 init(viewContollers:[UIViewController],dataModels:[RMSegmentedViewDataModel]) {
		super.init(nibName: nil, bundle: nil)
		
		self.viewControllers = viewContollers
		self.segmentedDataModels = dataModels
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.edgesForExtendedLayout = []
		self.setupSegmentedView()
		self.setupPageViewController()
		
	}
	
	fileprivate func setupSegmentedView() -> Void {
		
		if !self.disableSegmentView {
			self.segmentedView = RMSegmentedView.viewWithSegments(segmentsArray: self.segmentedDataModels!)
			self.segmentedView.delegate = self
			self.view.addSubview(segmentedView)
		}
		
		let segmentOriginY = self.view.frame.origin.y
		
		self.segmentedView.frame = CGRect(x: 0, y: segmentOriginY, width: self.view.frame.size.width, height: self.segmentedView.frame.size.height)
		
	}
	
	fileprivate func setupPageViewController() -> Void {
		
		self.pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
		self.pageViewController.dataSource = self
		self.pageViewController.delegate = self
		
		self.pageViewController.view.frame = CGRect(x: 0, y: self.segmentedView.endOfOriginY(), width: self.view.frame.size.width,
		                                            height: self.view.frame.size.height - self.segmentedView.endOfOriginY())
		
		self.pageViewController.view.backgroundColor = UIColor.clear
		
		if self.viewControllers!.count > 0 {
			self.pageViewController.setViewControllers([self.viewControllers![0]], direction: .forward, animated: false, completion: nil)
		}
		
		self.addChildViewController(self.pageViewController)
		self.pageViewController.view.layer.zPosition = -1000.0
		
		self.view.addSubview(self.pageViewController.view)
		
		for view in self.pageViewController.view.subviews {
			if view is UIScrollView {
			    let scrollView = view as! UIScrollView
		        scrollView.delegate = self
			}
		}
		
	}
	
	fileprivate func setCurrentViewControllerAt(index: Int) -> Void {
		
		if let currentViewController = self.pageViewController.viewControllers?[0] {
			
			let currentIndex = self.viewControllers?.index(of:currentViewController )
			if index == currentIndex {
				return
			}
			
			var direction: UIPageViewControllerNavigationDirection = .reverse
			
			if currentIndex! < index {
				direction = .forward
			}
			
			self.pageViewController.setViewControllers([self.viewControllers![index]], direction: direction, animated: false, completion: nil)
			
			self.didSelectPageViewControllerAt(index: index)
			
		}
	}
	
	@objc func  selectViewControllerAt(index: Int) -> Void {
		self.setCurrentViewControllerAt(index: index)
		self.segmentedView.reloadWithSelectedIndex(index: index)
	}
	
	@objc func setBadgeStringAtSegmentWith(badgeString: String, segmentIndex: Int ) -> Void {
        var segmentDataModel = self.segmentedDataModels![segmentIndex]

		var badge = badgeString
		
		if Int(badge) == 0 {
			badge = ""
		}
		
		segmentDataModel.badgeString = badge
		self.segmentedDataModels![segmentIndex] = segmentDataModel
		self.segmentedView.updateSegmentWithDataModel(segmentDataModel: segmentDataModel, at: segmentIndex)
		
	}
	
	func didSelectPageViewControllerAt(index: Int) -> Void {
		
	}
	
}

extension RMPageManagerViewController : UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		let controllerIndex = self.viewControllers!.index(of: viewController)
		
		if let index = controllerIndex{
			if index > 0 {
				return self.viewControllers![index-1]
			}
		}
		
		return nil
	}
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		let controllerIndex = self.viewControllers!.index(of: viewController)
		
		if let index = controllerIndex{
			if index < self.viewControllers!.count - 1 {
				return self.viewControllers![index+1]
			}
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if let viewController = pageViewController.viewControllers?[0] {
			let controllerIndex = self.viewControllers!.index(of: viewController)
			
			if let index = controllerIndex {
				self.didSelectPageViewControllerAt(index: index)
				self.segmentedView.reloadWithSelectedIndex(index: index)
			}
		}
	}
	
}

extension RMPageManagerViewController : UIPageViewControllerDelegate {
	
}

extension RMPageManagerViewController : UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let scrollingValue = (scrollView.contentOffset.x - scrollView.frame.size.width) / scrollView.frame.size.width
		
		if !scrollingValue.isNaN && scrollingValue != 0 {
			self.segmentedView.scrollingFromRemoteWith(scrollingValue: scrollingValue)
		}
		
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		self.segmentedView.reloadSubViewFrameToCurrentPosition()
	}
}



extension RMPageManagerViewController : RMSegmentedViewDelegate {
	
	func segmentedView(_ segmentedView: RMSegmentedView, didSelectedIndex index: Int) {
		self.setCurrentViewControllerAt(index: index)
	}
}

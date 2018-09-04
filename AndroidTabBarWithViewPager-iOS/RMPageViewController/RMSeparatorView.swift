//
//  RMSeparatorView.swift
//  Messenger
//
//  Created by Sulaiman Khan on 2/13/18.
//   
//

import Foundation
import UIKit

class RMSeparatorView: UIView {
	
	var seperatorLineColor:UIColor!
	var seperatorLineBackgroundColor:UIColor!
	var seperatorLineThickness:CGFloat!
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initDefaults()
	}
	
	required init?(coder: NSCoder){
		super.init(coder: coder)!
		self.initDefaults()
	}
	
	
	fileprivate func initDefaults() ->Void{
		self.backgroundColor = RMSeparatorView.defaultSeparatorBackgroundColor()
		self.seperatorLineColor = RMSeparatorView.defaultSeparatorColor()
		self.seperatorLineBackgroundColor = RMSeparatorView.defaultSeparatorBackgroundColor()
		self.seperatorLineThickness = RMSeparatorView.defaultSeparatorThickness()
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		self.backgroundColor = self.seperatorLineBackgroundColor
		
		let context = UIGraphicsGetCurrentContext()
		context?.setStrokeColor(self.seperatorLineColor.cgColor)
		context?.setLineWidth(self.seperatorLineThickness)
		context?.move(to: CGPoint(x: 0.0, y: 0.0))
		
		var startPoint, endPoint: CGPoint
		if self.bounds.width < self.bounds.height {
			startPoint = CGPoint(x: (self.bounds.width - self.seperatorLineThickness) * 0.5 , y: 0)
			endPoint = CGPoint(x: (self.bounds.width - self.seperatorLineThickness) * 0.5 , y: self.bounds.height)
		} else {
			startPoint = CGPoint(x: 0, y: (self.bounds.height - self.seperatorLineThickness) * 0.5)
			endPoint = CGPoint(x: self.bounds.width, y: (self.bounds.height - self.seperatorLineThickness ) * 0.5)
		}
		
		context?.move(to: startPoint)
		context?.addLine(to: endPoint)
		context?.strokePath()
		
	}
	
    class func defaultSeparatorColor() -> UIColor {
		return UIColor(white: 0.667 , alpha: 0.7)
	}
	
	class func defaultSeparatorBackgroundColor() -> UIColor {
		return UIColor.clear
	}
	class func defaultSeparatorThickness() -> CGFloat {
		return 0.3
	}
	
	func setSeparatorColor(separatorColor: UIColor) -> Void {
		self.seperatorLineColor = separatorColor
		self.setNeedsDisplay()
	}
	
	func setSeparatorBackgroundColor(backGroundColor:UIColor) -> Void {
		self.seperatorLineBackgroundColor = backgroundColor
		self.setNeedsDisplay()
	}
	
	func setSeparatorThickness(separatorThickNess: CGFloat) -> Void {
		self.seperatorLineThickness = separatorThickNess
		self.setNeedsDisplay()
	}
}

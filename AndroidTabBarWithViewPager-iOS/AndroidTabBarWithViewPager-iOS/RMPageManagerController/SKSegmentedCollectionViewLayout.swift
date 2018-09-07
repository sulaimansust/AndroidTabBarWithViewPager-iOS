//
//  SKSegmentedCollectionViewLayout.swift
//  
//
//  Created by Sulaiman Khan on 3/10/18.
//
//

import Foundation
import UIKit

class SKSegmentedCollectionViewLayout: UICollectionViewFlowLayout {
	
	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		
		super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
		
		var candidateAttributes : UICollectionViewLayoutAttributes?
		
		let cvBounds = self.collectionView?.bounds
		if let bounds = cvBounds {
			let halfWidth = bounds.size.width * 0.5
			let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
			
			let layoutAttributeArray = self.layoutAttributesForElements(in: bounds)
			
			
			if let attributeArray = layoutAttributeArray {
				for attribute:UICollectionViewLayoutAttributes in attributeArray {
					
					// == Skip comparison with non-cell items (headers and footers) == //
					if attribute.representedElementCategory !=  .cell {
						continue
					}
					
					if candidateAttributes == nil {
						candidateAttributes = attribute
						continue
					}
					
					if fabs(attribute.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
						candidateAttributes = attribute
					}
					
					
				}
				return CGPoint(x: (candidateAttributes?.center.x)! - halfWidth, y: proposedContentOffset.y)
			}
			
		}
		return CGPoint.zero
	}
	
}

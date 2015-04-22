//
//  CustomCollectionViewLayout.swift
//  MultiDirectionCollectionView
//
//  Created by Kyle Andrews on 4/20/15.
//  Copyright (c) 2015 Credera. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    
    // Used for calculating each cells CGRect on screen.
    // CGRect will define the Origin and Size of the cell.
    let CELL_HEIGHT = 30.0
    let CELL_WIDTH = 100.0
    let STATUS_BAR = UIApplication.sharedApplication().statusBarFrame.height
    
    // Dictionary to hold the UICollectionViewLayoutAttributes for
    // each cell. The layout attribtues will define the cell's size 
    // and position (x, y, and z index). I have found this process
    // to be one of the heavier parts of the layout. I recommend
    // holding onto this data after it has been calculated in either 
    // a dictionary or data store of some kind for a smooth performance.
    var cellAttrsDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    
    // Defines the size of the area the user can move around in
    // within the collection view.
    var contentSize = CGSize.zeroSize
    
    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    override func prepareLayout() {
  
        // Cycle through each section of the data source.
        if collectionView?.numberOfSections() > 0 {
            for section in 0...collectionView!.numberOfSections()-1 {
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItemsInSection(section) > 0 {
                    for item in 0...collectionView!.numberOfItemsInSection(section)-1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = NSIndexPath(forItem: item, inSection: section)
                        let xPos = Double(item) * CELL_WIDTH
                        let yPos = Double(section) * CELL_HEIGHT
                        
                        var cellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        // Save the attributes.
                        cellAttrsDictionary[cellIndex] = cellAttributes
                        
                    }
                }
                
            }
        }
        
        // Update content size.
        let contentWidth = Double(collectionView!.numberOfItemsInSection(0)) * CELL_WIDTH
        let contentHeight = Double(collectionView!.numberOfSections()) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values.array {
            if CGRectIntersectsRect(rect, cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return false
    }
    
}

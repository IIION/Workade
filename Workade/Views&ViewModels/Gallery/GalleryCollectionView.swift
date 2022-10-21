//
//  GalleryCollectionView.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/20.
//

import UIKit

protocol TwoLineLayoutDelegate: AnyObject {
    var columnSpacing: CGFloat { get set }
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class UICollectionViewTwoLineLayout: UICollectionViewFlowLayout {
    
    weak var delegate: TwoLineLayoutDelegate?
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else { return }
        
        let numberOfColumns: Int = 2
        let cellPadding: CGFloat = (delegate?.columnSpacing ?? 20) / 2
        let cellWidth: CGFloat = (contentWidth - cellPadding * 2) / CGFloat(numberOfColumns)
        
        let xOffSet: [CGFloat] = [0, cellWidth]
        var yOffSet: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var column: Int = 0
        
        collectionView.frame = collectionView.frame.insetBy(dx: cellPadding, dy: 0)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let imageHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + imageHeight
            
            let frame = CGRect(x: xOffSet[column],
                               y: yOffSet[column],
                               width: cellWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffSet[column] = yOffSet[column] + height
            
            column = yOffSet[0] > yOffSet[1] ? 1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

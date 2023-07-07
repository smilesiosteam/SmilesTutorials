//
//  CollectionViewAutoScroller.swift
//  House
//
//  Created by Shmeel Ahmed on 04/01/2023.
//  Copyright © 2023 Ahmed samir ali. All rights reserved.
//

import UIKit

class CollectionViewAutoScroller: NSObject {
    var itemsCount = 0
    var collectionView: UICollectionView?
    weak var timer: Timer?
    var currentIndex = 0
    var scrollDidFire: ((Int) -> Void)?
    
    init(collectionView: UICollectionView, itemsCount: Int, currentIndex: Int) {
        self.itemsCount = itemsCount
        self.collectionView = collectionView
        self.currentIndex = currentIndex
        super.init()
        if itemsCount > 0 {
            self.startTimer()
        }
    }
    
    func resetAutoScroller() {
        timer?.invalidate()
        itemsCount = 0
        currentIndex = 0
    }
    
    // -------------------------------------------------------------------------------
    //    Timer Controls
    // -------------------------------------------------------------------------------
    func startTimer(interval: Double = 5.0) {
        guard itemsCount > 0 else {return}
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if self.itemsCount == 0 {
                self.stopTimer()
            }
            if self.currentIndex < self.itemsCount {
                let indexPath = IndexPath(item: self.currentIndex, section: 0)
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) { [weak self] in
                    if let collection = self?.collectionView, collection.isValid(indexPath: indexPath){
                        self?.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    }
                } completion: { (success) in
                    
                }
                self.scrollDidFire?(indexPath.row)
                self.currentIndex = self.currentIndex + 1
            } else {
                self.scrollDidFire?(0)
                self.currentIndex = 1
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
                    self?.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                } completion: { (success) in
                    
                }
            }
        }
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

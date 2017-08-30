//
//  CaptureItemsViewController.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 4/23/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import UIKit

class CaptureItemsViewController: UIViewController {
    let columnCount = 3
    let padding = 5
    let spacing = 5
    
    let kCaptureItemCollectionCellIdentifier = "CaptureItemCollectionCell"
    
    @IBOutlet var collectionView: UICollectionView!
    
    var captureStack: CaptureStack!
    var selectedItems = Set<Int>()

    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsetsMake(CGFloat(padding), CGFloat(padding), CGFloat(padding), CGFloat(padding))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonTapped))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueShowPlayerView" {
            if let vc = segue.destination as? PlayerViewController {
                vc.captureItem = sender as? CaptureVideoItem
            }
        }
     }

    
    //MARK: - IBActions
    
    //MARK: - Other Functions
    
    func deleteButtonTapped() {
        captureStack.removeItems(set: selectedItems)
        self.collectionView.reloadData()
    }

}

extension CaptureItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.captureStack.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCaptureItemCollectionCellIdentifier, for: indexPath
        ) as! CaptureItemCollectionCell
        cell.model = self.captureStack.list[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedItems.insert(indexPath.row)
        let captureItem = self.captureStack.list[indexPath.row]
        self.performSegue(withIdentifier: "SegueShowPlayerView", sender: captureItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedItems.remove(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var screenWidth = UIScreen.main.bounds.width
        screenWidth -= CGFloat(padding * 2)
        screenWidth -= CGFloat(spacing * (columnCount - 1))
        
        screenWidth /= CGFloat(columnCount)
        return CGSize.init(width: screenWidth, height: screenWidth)
    }
}

//
//  ImagesPhotoCollectionView.swift
//  RedditImage
//
//  Created by Manuel Cipolotti on 30/04/21.
//

import UIKit

class ImagesPhotoController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    var imagesList: [ImagePhoto] = []
    
    
    var imageCollectionView: UICollectionView?
    var viewController: UIViewController?
    
    init(collectionView: UICollectionView,
         viewController: UIViewController) {
        self.imageCollectionView = collectionView
        self.viewController = viewController
    }
    
    func reloadData(list: [ImagePhoto]) {
        self.imagesList = list
        self.imageCollectionView?.reloadData()
        self.imageCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat = 3
        var collectionWidth = collectionView.bounds.width
        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                collectionWidth = collectionView.bounds.width
                if UIDevice.current.userInterfaceIdiom == .pad {
                    columns = 6
                } else {
                    columns = 3
                }
            } else {
                collectionWidth = collectionView.bounds.width
                if UIDevice.current.userInterfaceIdiom == .pad {
                    columns = 3
                } else {
                    columns = 2
                }
            }
        }
        let spacing: CGFloat = 10
        let totalHorizontalSpacing = (columns - 1) * spacing
        let itemWidth = (collectionWidth - totalHorizontalSpacing) / columns
        let itemSize = CGSize.init(width: itemWidth,
                                   height: itemWidth)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.viewController as? ImagePhotoListViewDelegate {
            vc.setSelected(index: indexPath.row)
        }
        if self.viewController?.shouldPerformSegue(withIdentifier: "detailImage", sender: nil) ?? false {
            self.viewController?.performSegue(withIdentifier: "detailImage", sender: nil)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell {
            let imageList = self.imagesList[indexPath.row]
            cell.imagePhoto.loadImageAsync(with: imageList.url)
            return cell
        } else {
            return UICollectionViewCell.init()
        }
    }
    
}

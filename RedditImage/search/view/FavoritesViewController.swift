//
//  FvoritesViewController.swift
//  RedditImage
//
//  Created by Manuel Cipolotti on 30/04/21.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController, ImagePhotoListViewDelegate {
    

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var canc = Set<AnyCancellable>()
    var imagePhotoController: ImagesPhotoController? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imagePhotoController = ImagesPhotoController.init(collectionView: self.imageCollectionView,
                                                               viewController: self)
        self.imageCollectionView.delegate = self.imagePhotoController
        self.imageCollectionView.dataSource = self.imagePhotoController
        
        ImagesPresenter.instance.$favoritesImagesList.sink(receiveValue: { list in
            
            DispatchQueue.main.async(execute: {
                if let list = list {
                    self.imagePhotoController?.reloadData(list: list)
                } else {
                }
            })
            
            
        }).store(in: &self.canc)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImagesPresenter.instance.getFavoritesImages()
    }

    // MARK: - ImagePhotoListViewDelegate
    func setSelected(index: Int) {
        ImagesPresenter.instance.getFavoriteImageSelected(index: index)
    }

}

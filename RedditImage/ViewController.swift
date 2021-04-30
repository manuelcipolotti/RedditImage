//
//  ViewController.swift
//  RedditImage
//
//  Created by Manuel Cipolotti Beta on 28/04/2021.
//

import UIKit
import Combine

class ViewController: UIViewController, UITextFieldDelegate, ImagePhotoListViewDelegate {
    
    
    

    var canc = Set<AnyCancellable>()
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var noTextSearchView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var imagesList: [ImagePhoto] = []
    
    var imagePhotoController: ImagesPhotoController? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchText.addRightImage(imageName: "search-plus", arrow: false)
        searchText.addPadding(.left(8))
        
        self.refreshButton.isHidden = true
        self.noDataFoundView.isHidden = true
        self.noTextSearchView.isHidden = false
        
        self.imagePhotoController = ImagesPhotoController.init(collectionView: self.imageCollectionView,
                                                               viewController: self)
        self.imageCollectionView.delegate = self.imagePhotoController
        self.imageCollectionView.dataSource = self.imagePhotoController

        ImagesPresenter.instance.$imagesList.sink(receiveValue: { list in
            
            DispatchQueue.main.async(execute: {
                if let list = list {
                    self.imagesList = list
                    self.imagePhotoController?.reloadData(list: list)
//                    self.imageCollectionView.reloadData()
//                    self.imageCollectionView.collectionViewLayout.invalidateLayout()
                    self.refreshButton.isHidden = false
                    if list.count == 0 {
                        self.noDataFoundView.isHidden = false
                        self.noTextSearchView.isHidden = true
                        self.imageCollectionView.isHidden = true
                    } else {
                        self.noDataFoundView.isHidden = true
                        self.noTextSearchView.isHidden = true
                        self.imageCollectionView.isHidden = false
                    }
                } else {
                    self.refreshButton.isHidden = true
                    self.noDataFoundView.isHidden = true
                    self.noTextSearchView.isHidden = false
                }
            })
            
            
        }).store(in: &self.canc)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imageCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImagesPresenter.instance.isFavorites(okAction: { favorite in
                                                self.favoritesButton.isHidden = !favorite
                                             })

    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        if let searchText = self.searchText.text {
            if searchText.count > 0 {
                ImagesPresenter.instance.getImages(keyword: searchText)
            } else {
                ImagesPresenter.instance.getImages(keyword: "")
            }
        } else {
            ImagesPresenter.instance.getImages(keyword: "")
        }
    }
    
    // MARK: - ImagePhotoListViewDelegate
    func setSelected(index: Int) {
        ImagesPresenter.instance.getImageSelected(index: index)
    }

    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Only one word: no space o special chars
        return string.rangeOfCharacter(from: CharacterSet.letters) != nil || string == ""
    }
    
    @IBAction func searchChangedText(_ sender: Any) {
        if let searchTextField = sender as? UITextField, let searchText = searchTextField.text {
            if searchText.count > 0 {
                ImagesPresenter.instance.getImages(keyword: searchText)
            } else {
                ImagesPresenter.instance.getImages(keyword: "")
            }
        } else {
            ImagesPresenter.instance.getImages(keyword: "")
        }
    }
    
}


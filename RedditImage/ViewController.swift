//
//  ViewController.swift
//  RedditImage
//
//  Created by Manuel Cipolotti Beta on 28/04/2021.
//

import UIKit
import Combine

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    var canc = Set<AnyCancellable>()
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var noTextSearchView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imagesList: [ImagePhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchText.addRightImage(imageName: "search-plus", arrow: false)
        searchText.addPadding(.left(8))
        
        self.refreshButton.isHidden = true
        self.noDataFoundView.isHidden = true
        self.noTextSearchView.isHidden = false

        ImagesPresenter.instance.$imagesList.sink(receiveValue: { list in
            
            DispatchQueue.main.async(execute: {
                if let list = list {
                    self.imagesList = list
                    self.imageCollectionView.reloadData()
                    self.imageCollectionView.collectionViewLayout.invalidateLayout()
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
        print("itemWidth: \(itemWidth)")
        print("collectionWidth: \(collectionWidth)")
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if self.emailFormatoErrato.isEnabled {
//            self.emailFormatoErrato.isHidden = false
//        } else {
//            self.emailFormatoErrato.isHidden = true
//        }
//
//        self.isConfermaActionEnabled()
    }

}


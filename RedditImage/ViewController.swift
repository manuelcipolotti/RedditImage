//
//  ViewController.swift
//  RedditImage
//
//  Created by Manuel Cipolotti Beta on 28/04/2021.
//

import UIKit
import Combine

class ViewController: UIViewController, UITextFieldDelegate {

    var canc = Set<AnyCancellable>()
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchText.addRightImage(imageName: "search-plus", arrow: false)
        searchText.addPadding(.left(8))
        
        
        ImagesPresenter.instance.$imagesList.sink(receiveValue: { list in
            
            if let list = list {
                self.refreshButton.isHidden = false
                if list.count == 0 {
                    self.noDataFoundView.isHidden = false
                    self.imageCollectionView.isHidden = true
                } else {
                    self.noDataFoundView.isHidden = true
                    self.imageCollectionView.isHidden = false
                }
            } else {
                self.refreshButton.isHidden = true
                self.noDataFoundView.isHidden = true
            }
            
        }).store(in: &self.canc)
        
        
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


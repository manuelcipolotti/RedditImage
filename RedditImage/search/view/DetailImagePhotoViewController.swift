//
//  DetailImagePhotoViewController.swift
//  RedditImage
//
//  Created by Manuel Cipolotti Beta on 29/04/2021.
//

import UIKit
import Combine

class DetailImagePhotoViewController: UIViewController {

    @IBOutlet weak var zoomPhotoImageView: ZoomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var priorButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var removeFavoriteButton: UIButton!
    @IBOutlet weak var addFavoriteButton: UIButton!
    var canc = Set<AnyCancellable>()

    var imagePhoto: ImagePhoto?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    func refreshView(imageSelected: ImagePhotoDetailView?) {
        DispatchQueue.main.async(execute: {
            if let imageSelected = imageSelected {
                self.zoomPhotoImageView.setImage(imageSelected.url)
                self.titleLabel.text = imageSelected.title
                self.authorLabel.text = imageSelected.author
                self.priorButton.isHidden = imageSelected.first
                self.nextButton.isHidden = imageSelected.last
                let imagePhoto = ImagePhoto.init(imagePhotoDetail: imageSelected)
                self.imagePhoto = imagePhoto
                ImagesPresenter.instance.isFavorite(imagePhoto: imagePhoto,
                                                     okAction: { favorite in
                                                        self.addFavoriteButton.isHidden = favorite
                                                        self.removeFavoriteButton.isHidden = !favorite
                                                     })

                
            } else {
                self.priorButton.isHidden = true
                self.nextButton.isHidden = true
                if let image = UIImage.init(named: "notFound") {
                    self.zoomPhotoImageView.setImage(image)
                }
            }
        })

    }
    
    func setupView() {
        ImagesPresenter.instance.$imageSelected.sink(receiveValue: { imageSelected in
            self.refreshView(imageSelected: imageSelected)
        }).store(in: &self.canc)
    }
    
    
    @IBAction func priorImageAction(_ sender: Any) {
        ImagesPresenter.instance.getPrior()
    }

    @IBAction func nextImageAction(_ sender: Any) {
        ImagesPresenter.instance.getNext()
    }

    @IBAction func zoomOutAction(_ sender: Any) {
        self.zoomOutButton.isHidden = true
        self.zoomInButton.isHidden = false
        self.detailView.isHidden = true
    }

    @IBAction func zoomInAction(_ sender: Any) {
        self.zoomOutButton.isHidden = false
        self.zoomInButton.isHidden = true
        self.detailView.isHidden = false
    }
    
    @IBAction func addFovoriteAction(_ sender: Any) {
        if let imagePhoto = self.imagePhoto {
            
            ImagesPresenter.instance.setFavorite(imagePhoto: imagePhoto,
                                                 okAction: {
                                                    self.removeFavoriteButton.isHidden = false
                                                    self.addFavoriteButton.isHidden = true
                                                 },
                                                 koAction: {
                                                    print("Errore in salvataggio")
                                                 })
        }
    }
    
    @IBAction func removeFovoriteAction(_ sender: Any) {
        if let imagePhoto = self.imagePhoto {
            ImagesPresenter.instance.removeFavorite(imagePhoto: imagePhoto,
                                                 okAction: {
                                                    self.removeFavoriteButton.isHidden = true
                                                    self.addFavoriteButton.isHidden = false
                                                 },
                                                 koAction: {
                                                    print("Errore in salvataggio")
                                                 })
        }
    }

}

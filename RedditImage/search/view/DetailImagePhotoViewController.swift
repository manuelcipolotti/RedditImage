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
    var canc = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ImagesPresenter.instance.$imageSelected.sink(receiveValue: { imageSelected in
            
            DispatchQueue.main.async(execute: {
                if let imageSelected = imageSelected {
                    self.zoomPhotoImageView.setImage(imageSelected.url)
                    self.titleLabel.text = imageSelected.title
                    self.authorLabel.text = imageSelected.author
                    self.priorButton.isHidden = imageSelected.first
                    self.nextButton.isHidden = imageSelected.last
                } else {
                    self.priorButton.isHidden = true
                    self.nextButton.isHidden = true
                    if let image = UIImage.init(named: "notFound") {
                        self.zoomPhotoImageView.setImage(image)
                    }
                }
            })
            
            
        }).store(in: &self.canc)

        
    }
    
    @IBAction func priorImageAction(_ sender: Any) {
        ImagesPresenter.instance.getPrior()
    }

    @IBAction func nextImageAction(_ sender: Any) {
        ImagesPresenter.instance.getNext()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

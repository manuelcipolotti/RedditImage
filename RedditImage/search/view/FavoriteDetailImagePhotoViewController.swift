//
//  FavoriteDetailImagePhotoViewController.swift
//  RedditImage
//
//  Created by Manuel Cipolotti on 30/04/21.
//

import UIKit

class FavoriteDetailImagePhotoViewController: DetailImagePhotoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        ImagesPresenter.instance.$favoriteImageSelected.sink(receiveValue: { imageSelected in
            self.refreshView(imageSelected: imageSelected)
        }).store(in: &self.canc)
    }

    
    @IBAction override func priorImageAction(_ sender: Any) {
        ImagesPresenter.instance.getFavoritePrior()
    }

    @IBAction override func nextImageAction(_ sender: Any) {
        ImagesPresenter.instance.getFavoriteNext()
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

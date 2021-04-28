//
//  ViewController.swift
//  RedditImage
//
//  Created by Manuel Cipolotti Beta on 28/04/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchText.addRightImage(imageName: "search-plus", arrow: false)
        searchText.addPadding(.left(8))
    }


}


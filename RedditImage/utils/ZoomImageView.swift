//
//  ZoomImageView.swift
//  RedditImage
//
//  Created by Manuel Cipolotti Beta on 29/04/2021.
//

import UIKit

class ZoomImageView: UIScrollView, UIScrollViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
    }

    private func commonInit() {
        // Setup image view
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Setup scroll view
        minimumZoomScale = 1
        maximumZoomScale = 3
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        
    }
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }

    func setImage(_ imageName: String) {
        self.imageView.loadImageAsync(with: imageName)
    }

    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

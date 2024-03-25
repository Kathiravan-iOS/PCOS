//
//  viewreportVC.swift
//  Pcos
//
//  Created by SAIL on 15/02/24.
//

import UIKit

class view_reportVC: UIViewController {
    @IBOutlet weak var viewreportImageView: UIImageView!
    var imageUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    func loadImage() {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.viewreportImageView.image = UIImage(data: data)
                self?.viewreportImageView.layer.borderColor = UIColor.black.cgColor
                self?.viewreportImageView.layer.borderWidth = 2.0
                self?.viewreportImageView.layer.cornerRadius = 8.0
                self?.viewreportImageView.clipsToBounds = true
            }
        }.resume()
    }

}

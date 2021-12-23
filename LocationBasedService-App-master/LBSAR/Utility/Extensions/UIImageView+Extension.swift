//
//  UIImageView+Extension.swift
//  LBSAR
//
//  Created by ajt on 2021/12/16.
//

import UIKit

extension UIImageView {
    
    func setImageWith(url: URL, placeholderImage: UIImage) {
        self.image = placeholderImage
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}

//
//  GalleryViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/24.
//

import Foundation
import UIKit

class GalleryViewModel {
    var images: [UIImage] = []
    
    func fetchImages() {
        //TODO: 서버에서 이미지 불러오기
        self.images = [
            UIImage(named: "GalleryTestImage1") ?? UIImage(),
            UIImage(named: "GalleryTestImage2") ?? UIImage(),
            UIImage(named: "GalleryTestImage3") ?? UIImage(),
            UIImage(named: "GalleryTestImage4") ?? UIImage(),
            UIImage(named: "GalleryTestImage1") ?? UIImage(),
            UIImage(named: "GalleryTestImage2") ?? UIImage(),
            UIImage(named: "GalleryTestImage3") ?? UIImage(),
            UIImage(named: "GalleryTestImage4") ?? UIImage()
        ]
    }
}

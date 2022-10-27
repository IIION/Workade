//
//  MagazineListViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import UIKit

@MainActor
class MagazineDetailViewModel {
    private let manager = NetworkingManager.shared
        
    var data: MagazineBinder<[MagazineDetailModel]> = MagazineBinder([])
    
    func fetchMagazine(url: URL?) async {
        var magazineDetailData: [MagazineDetailModel] = []
        
        guard let dataUrl = url else { return }
        
        let result = await manager.request(url: dataUrl)
        guard let result = result else { return }
        
        do {
            let magazineData = try JSONDecoder().decode(MagazineDataModel.self, from: result)
            magazineData.magazineData.forEach { detailData in
                magazineDetailData.append(detailData)
            }
        } catch {
            print(error)
        }
        
        data.value = magazineDetailData
    }
    
    func fetchURL(urlString: String) -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
}

class MagazineBinder<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
        
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ val: T) {
        value = val
    }
}

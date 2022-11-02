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
    private let bookmarkManager = BookmarkManager.shared
    
    var data: Binder<[MagazineDetailModel]> = Binder([])
    
    init() {
        bindingBookmarkManager()
    }
    
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
    
    var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        bookmarkManager.clickedMagazineId.bindAndFire(at: .magazine) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    func notifyClickedMagazineId(title id: String, key: String) {
        bookmarkManager.notifyClickedMagazineId(title: id, key: key)
    }
}

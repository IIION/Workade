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
        
    func fetchMagazine(url: URL?) async -> [MagazineDetailModel] {
        var magazineDetailData: [MagazineDetailModel] = []
        
        guard let dataUrl = url else { return [] }
        
        let result = await manager.request(url: dataUrl)
        guard let result = result else { return [] }
        
        do {
            let magazineData = try JSONDecoder().decode(MagazineDataModel.self, from: result)
            magazineData.magazineData.forEach { detailData in
                magazineDetailData.append(detailData)
            }
        } catch {
            print(error)
        }
        print(magazineDetailData)
        return magazineDetailData
    }
    
    func fetchURL(urlString: String) -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
}

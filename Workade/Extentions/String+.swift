//
//  String+.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/11/23.
//

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}

//
//  UIView+.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/11/23.
//
import UIKit

extension UIScrollView {
    // 스크롤 뷰를 이미지로 변환하는 함수
    func toImage() -> UIImage? {
        // 기존 offset과 frame 값을 저장
        // 기존 값들을 변경하고, 이미지 변환 이후 원래 값으로 되돌려줌.
        let savedContentOffset = contentOffset
        let savedFrame = frame
        let captureSize = CGSize(width: contentSize.width, height: contentSize.height)
        
        // bitmap image context를 생성
        // size: 비트맵 context 사이즈 (= 생성될 이미지의 사이즈)
        // opaque: 생성될 이미지의 투명도 여부 (투명도가 있으면 true, 단 불투명도일때가 퍼포먼스가 높은 특징 존재)
        // scale: 0.0이면 디바이스의 화면에 맞게 이미지가 결정
        UIGraphicsBeginImageContextWithOptions(captureSize, false, 0.0)
        
        // 오프셋을 0으로 맞춰줘, 스크롤뷰 최상단부터 캡쳐될 수 있도록 함.
        contentOffset = CGPoint.zero
        // 스크롤 뷰의 프레임을 content 영역으로 변경. 얘를 안해주면 화면 크기만큼 밖에 캡쳐 안됨.
        frame = CGRect(x: 0, y: 0, width: captureSize.width, height: captureSize.height)
        
        // 스크롤 뷰 프레임 영역을 bitmap image context에 그림.
        layer.render(in: UIGraphicsGetCurrentContext()!)
        // image context로 부터 이미지 얻기.
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // offset과 프레임을 원래대로 변경 (변경 안하면 스크롤 안됨).
        // offset을 원래 offset 위치로 변경하여 스크롤이 최상단으로 가지 안도록 함.
        contentOffset = savedContentOffset
        frame = savedFrame
        
        // 스택 맨 위에서 현재 비트맵 기반 그래픽 컨텍스트를 제거하며 비트맵 image context 종료.
        UIGraphicsEndImageContext()
        
        return image
    }
}

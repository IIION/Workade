//
//  ShareView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/11/22.
//

import UIKit
import KakaoSDKTemplate
import KakaoSDKCommon
import KakaoSDKShare

class ShareView: UIView {
    var magazine: MagazineModel
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .rgb(0xF2F2F7)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        return divider
    }()
    
    private lazy var shareViewContrainer: UIView = {
        let shareViewContrainer = UIView()
        shareViewContrainer.translatesAutoresizingMaskIntoConstraints = false
        
        return shareViewContrainer
    }()
    
    private lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.text = "주변에 공유하기"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var buttonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var kakaoShareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoButton"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.kakaoShare()
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var clipboardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ClipboardButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var defaultShareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "DefaultButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(magazine: MagazineModel) {
        self.magazine = magazine
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(shareViewContrainer)
        NSLayoutConstraint.activate([
            shareViewContrainer.topAnchor.constraint(equalTo: topAnchor),
            shareViewContrainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareViewContrainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareViewContrainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(shareLabel)
        NSLayoutConstraint.activate([
            shareLabel.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            shareLabel.leadingAnchor.constraint(equalTo: shareViewContrainer.leadingAnchor),
            shareLabel.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(defaultShareButton)
        NSLayoutConstraint.activate([
            defaultShareButton.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            defaultShareButton.trailingAnchor.constraint(equalTo: shareViewContrainer.trailingAnchor),
            defaultShareButton.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(clipboardButton)
        NSLayoutConstraint.activate([
            clipboardButton.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            clipboardButton.trailingAnchor.constraint(equalTo: defaultShareButton.leadingAnchor, constant: -14),
            clipboardButton.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
        
        shareViewContrainer.addSubview(kakaoShareButton)
        NSLayoutConstraint.activate([
            kakaoShareButton.topAnchor.constraint(equalTo: shareViewContrainer.topAnchor),
            kakaoShareButton.trailingAnchor.constraint(equalTo: clipboardButton.leadingAnchor, constant: -14),
            kakaoShareButton.bottomAnchor.constraint(equalTo: shareViewContrainer.bottomAnchor)
        ])
    }
}

extension ShareView {
    private func kakaoShare() {
        if ShareApi.isKakaoTalkSharingAvailable() {
            let appLink = Link(iosExecutionParams: ["title": magazine.title, "imageURL": magazine.imageURL, "introduceURL": magazine.introduceURL])
            let button = Button(title: "앱에서 보기", link: appLink)
            let content = Content(title: "워케이드만이 알려주는 워케이션 꿀팁!", imageUrl: URL(string: magazine.imageURL)!, description: magazine.title, link: appLink)
            let template = FeedTemplate(content: content, buttons: [button])
            if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                    ShareApi.shared.shareDefault(templateObject: templateJsonObject) {(linkResult, error) in
                        if let error = error {
                            print("error : \(error)")
                        } else {
                            print("defaultLink(templateObject:templateJsonObject) success.")
                            guard let linkResult = linkResult else { return }
                            UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        } else {
            // 카카오톡 미설치시. 웹 공유 사용 권장
            print("카카오톡 미설치")
        }
    }
    
}

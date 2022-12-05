//
//  DesignSystem.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/19.
//

import SwiftUI

struct DesignSystem: View {
    enum DesignSystemCase: String {
        case font
        case color
    }
    
    @State private var systemCase: DesignSystemCase = .font
    
    var body: some View {
        VStack {
            Picker("시스템 설정", selection: $systemCase) {
                Text("Font").tag(DesignSystemCase.font)
                Text("Color").tag(DesignSystemCase.color)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            
            if systemCase == .font {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Title1")
                        .font(Font(UIFont.customFont(for: .title1)))
                    Text("Title2")
                        .font(Font(UIFont.customFont(for: .title2)))
                    Text("Title3")
                        .font(Font(UIFont.customFont(for: .title3)))
                    Text("Headline")
                        .font(Font(UIFont.customFont(for: .headline)))
                    Text("CaptionHeadline")
                        .font(Font(UIFont.customFont(for: .captionHeadline)))
                    Text("Subheadline")
                        .font(Font(UIFont.customFont(for: .subHeadline)))
                    Group {
                        Text("ArticleBody")
                            .font(Font(UIFont.customFont(for: .articleBody)))
                        Text("Footnote")
                            .font(Font(UIFont.customFont(for: .footnote)))
                        Text("Footnote2")
                            .font(Font(UIFont.customFont(for: .footnote2)))
                        Text("Caption")
                            .font(Font(UIFont.customFont(for: .caption)))
                        Text("Caption2")
                            .font(Font(UIFont.customFont(for: .caption2)))
                        Text("Tag")
                            .font(Font(UIFont.customFont(for: .tag)))
                    }
                }
            } else {
                HStack(alignment: .top, spacing: 10) {
                    VStack(spacing: 20) {
                        Group {
                            Color(UIColor.theme.workadeBlue)
                                .frame(width: 44, height: 44)
                            Color(UIColor.theme.workadeBackgroundBlue)
                                .frame(width: 44, height: 44)
                        }
                        Color(UIColor.theme.primary)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.secondary)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.tertiary)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.quaternary)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.background)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.groupedBackground)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.subGroupedBackground)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.labelBackground)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.sectionBackground)
                            .frame(width: 44, height: 44)
                    }
                    
                    VStack(spacing: 20) {
                        Text("Content Color")
                            .font(.title3)
                        Color(UIColor.theme.contentRed)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.contentYellow)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.contentGreen)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.contentBlue)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.contentPurple)
                            .frame(width: 44, height: 44)
                        Color(UIColor.theme.contentPink)
                            .frame(width: 44, height: 44)
                    }
                }
            }
        }
    }
}

struct DesignSystem_Previews: PreviewProvider {
    static var previews: some View {
        DesignSystem()
    }
}

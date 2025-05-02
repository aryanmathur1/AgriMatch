//
//  BannerView.swift
//  Shopping
//

import SwiftUI

struct BannerView: View {
    let banners: [BannerModel]
    let completion: (BannerModel) -> Void

    fileprivate var itemWidth: CGFloat {
        return screenWidth - 40
    }

    fileprivate var itemHeight: CGFloat {
        return itemWidth * CGFloat(1080.0/2160.0)
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20.0) {
                ForEach(banners) { banner in
                    CreateItemView(banner)
                }
            }
            .padding(.horizontal, 20.0)
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .frame(height: itemHeight)
    }
}

//MARK: - Item View

extension BannerView {

    @ViewBuilder
    private func CreateItemView(_ banner: BannerModel) -> some View {
        Button {
            completion(banner)
        } label: {
            ZStack(alignment: .leading) {
                CreateCoverImage(banner)
                CreateInfoView(banner)
            }
        }
        .buttonStyle(.plain)
    }
}

//MARK: - Cover Image

extension BannerView {

    @ViewBuilder
    private func CreateCoverImage(_ banner: BannerModel) -> some View {
        AsyncImage(url: URL(string: banner.imageURL)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(.rect(cornerRadius: 20.0))
                    .frame(width: itemWidth, height: itemHeight)
            } else {
                Color.gray
                    .frame(width: itemWidth, height: itemHeight)
                    .clipShape(.rect(cornerRadius: 20.0))
            }
        }
    }
}

//MARK: - Info View

extension BannerView {

    @ViewBuilder
    private func CreateInfoView(_ banner: BannerModel) -> some View {
        let maxWidth: CGFloat = itemWidth * 0.6

        let learnTxt = "Learn More"
        let learnWidth = learnTxt.estimatedTextRect(font: .montBold(size: 16.0)).width + 10
        let learnHeight: CGFloat = 35.0

        VStack(alignment: .leading, spacing: 5.0) {
            Text(banner.title)
                .font(.montSemiBold(size: 16.0))
                .lineLimit(2)
                .truncationMode(.tail)
                .foregroundStyle(.white)
                .frame(width: maxWidth, alignment: .leading)

            Rectangle()
                .fill(.white.opacity(0.5))
                .frame(width: maxWidth*0.5, height: 1.0)

            Text(banner.description)
                .font(.montRegular(size: 13.0))
                .lineLimit(2)
                .foregroundStyle(.white)
                .frame(width: maxWidth, alignment: .leading)

            Text(learnTxt)
                .font(.montBold(size: 13.0))
                .foregroundStyle(.black)
                .frame(width: learnWidth, height: learnHeight)
                .background(.white)
                .clipShape(.rect(cornerRadius: learnHeight/2))
                .offset(y: 10.0)
        }
        .padding(.leading, 20.0)
    }
}

//
//  ProductCellView.swift
//  Shopping
//
//

import SwiftUI
let imageRatio: CGFloat = 1440/1080

struct ProductCellView: View {
    
    //MARK: - Properties
    private var product: Product
    private let itemWidth: CGFloat
    private let completion: (Product) -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    //MARK: - Initialize
    init(product: Product, itemWidth: CGFloat, completion: @escaping (Product) -> Void) {
        self.product = product
        self.itemWidth = itemWidth
        self.completion = completion
    }
    
    //MARK: - Contents
    var body: some View {
        CreateItemView()
    }
}

//MARK: - Item View

extension ProductCellView {
    
    @ViewBuilder
    private func CreateItemView() -> some View {
        Button {
            completion(product)
            
        } label: {
            VStack(spacing: 10.0) {
                ZStack(alignment: .topTrailing) {
                    //TODO: - Cover View
                    CreateCoverView()
                }
                
                VStack(spacing: 5.0) {
                    //TODO: - Name View
                    CreateNameView()
                    
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

//MARK: - Cover View

extension ProductCellView {
    
    @ViewBuilder
    private func CreateCoverView() -> some View {
        if let urlString = product.imageLinks.first, urlString.hasPrefix("http"),
           let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: itemWidth, height: itemWidth * imageRatio)
                        .clipShape(.rect(cornerRadius: (7/100)*itemWidth))
                        .shadow(
                            color: DarkMode.shared.white_blackColor(colorScheme).opacity(colorScheme == .dark ? 0.5 : 0.2),
                            radius: 2.0,
                            x: 0.0,
                            y: 0.5
                        )
                } else {
                    Color.gray
                        .frame(width: itemWidth, height: itemWidth * imageRatio)
                        .clipShape(.rect(cornerRadius: (7/100)*itemWidth))
                }
            }
        } else {
            Image(uiImage: .tshirt1)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: itemWidth, height: itemWidth * imageRatio)
                .clipShape(.rect(cornerRadius: (7/100)*itemWidth))
                .shadow(
                    color: DarkMode.shared.white_blackColor(colorScheme).opacity(colorScheme == .dark ? 0.5 : 0.2),
                    radius: 2.0,
                    x: 0.0,
                    y: 0.5
                )
        }
    }

}

//MARK: - Name View

extension ProductCellView {
    
    @ViewBuilder
    private func CreateNameView() -> some View {
        Text(product.name)
            .font(.montRegular(size: itemWidth*0.07))
            .lineLimit(2)
            .foregroundStyle(.gray)
            .frame(width: itemWidth*0.9, alignment: .leading)
    }
}

#Preview {
    let itemWidth: CGFloat = (screenWidth-70) / 2.0
    ProductCellView(
        product: Product.shared(),
        itemWidth: itemWidth
    ) { _ in }
}

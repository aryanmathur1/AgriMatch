//
//  NewArrivalView.swift
//  Shopping
//
//

import SwiftUI

struct NewArrivalView: View {
    
    //MARK: - Properties
    private var products: [Product]
    
    @Binding private var path: NavigationPath
    @Binding private var productListTitle: String
    
    //Chiều cao của ProductCell
    @State private var productHeight: CGFloat = 0.0
    
    //MARK: - Initializes
    init(
        products: [Product],
        path: Binding<NavigationPath>,
        productListTitle: Binding<String>
    ) {
        self.products = products
        self._path = path
        self._productListTitle = productListTitle
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(spacing: 10.0) {
            //TODO: - Title View
            CreateTitleView()
            
            //TODO: - Item View
            CreateItemView()
        }
    }
}

//MARK: - Title View

extension NewArrivalView {
    
    @ViewBuilder
    private func CreateTitleView() -> some View {
        HStack {
            //TODO: - Title
            Text("Favorite Plants")
                .font(.montSemiBold(size: 25.0))
            
            Spacer()
            
            //TODO: - View All
//            Button {
//                productListTitle = "New Arrivals"
//                
//            } label: {
//                Text("View All")
//                    .font(.montBold(size: 16.0))
//            }
//            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20.0)
        .frame(width: screenWidth, height: 50.0)
    }
}

//MARK: - Item View

extension NewArrivalView {
    
    @ViewBuilder
    private func CreateItemView() -> some View {
        let itemWidth: CGFloat = (screenWidth-40) / 1.3
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20.0) {
                ForEach(products, id: \.self) { product in
                    ProductCellView(product: product, itemWidth: itemWidth) { product in
                        print("product.id: \(product.id)")
                    }
                    .id(product.id)
                    .modifier(GetHeightModifier(height: $productHeight))
                }
                .scrollTransition { effect, phase in
                    effect.scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                }
            }
            .padding(.horizontal, (screenWidth-itemWidth)/2-20)
            .scrollTargetLayout()
        }
        .padding(.horizontal, 20.0)
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .frame(
            width: screenWidth,
            height: productHeight != 0 ? productHeight : screenWidth
        )
    }
}

#Preview {
    @Previewable @State var product: Product? = Product.shared()
    @Previewable @State var path = NavigationPath()
    @Previewable @State var productListTitle = "New Arrivals"
    
    NewArrivalView(
        products: [
            Product.shared(),
            Product.shared(),
            Product.shared(),
            Product.shared(),
            Product.shared()
        ],
        path: $path,
        productListTitle: $productListTitle
    )
}

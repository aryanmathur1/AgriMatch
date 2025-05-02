//
//  HomeView.swift
//  Shopping
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HomeView: View {

    //MARK: - Properties
    @Binding private var tabSelection: Int
    @Binding private var showTabBar: Bool
    @Binding private var path: NavigationPath

    @State private var productListTitle: String = ""
    @State private var dynamicBanners: [BannerModel] = []

    @State private var acceptedPlants: [Product] = []
    @State private var rejectedPlants: [Product] = []

    @State private var testProducts: [Product] = [
        Product.shared(),
        Product.shared(),
        Product.shared(),
        Product.shared(),
        Product.shared()
    ]

    @Environment(\.colorScheme) private var colorScheme

    //MARK: - Initializes
    init(
        tabSelection: Binding<Int>,
        showTabBar: Binding<Bool>,
        path: Binding<NavigationPath>
    ) {
        self._tabSelection = tabSelection
        self._showTabBar = showTabBar
        self._path = path
    }

    //MARK: - Contents
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .top) {
                DarkMode.shared.backgroundColor(colorScheme)
                CreateContentView()
            }
            .setupNavigationBar(
                title: "Home",
                colorScheme: colorScheme,
                leftNavBar: { CreateLeftBar() },
                rightNavBar: { CreateRightBar() }
            )
            .onAppear {
                if !showTabBar {
                    showTabBar = true
                }
                fetchAcceptedPlants()
                fetchRejectedPlants()
            }
        }
    }
}

// MARK: - Nav Bar

extension HomeView {
    @ViewBuilder
    private func CreateLeftBar() -> some View {
        Button { print("toggleMenu") } label: {
            CreateIconView(.iconMenuLeft)
        }.buttonStyle(.plain)
    }

    @ViewBuilder
    private func CreateRightBar() -> some View {
        Button { print("tabSelection") } label: {
            CreateIconView(.iconBagRight)
        }.buttonStyle(.plain)
    }

    @ViewBuilder
    private func CreateIconView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundStyle(DarkMode.shared.defaultColor(colorScheme))
            .frame(width: 40.0, height: 40.0)
    }
}

// MARK: - Content View

extension HomeView {
    @ViewBuilder
    private func CreateContentView() -> some View {
        VStack(spacing: 20.0) {
            ScrollView {
                LazyVStack(spacing: 20.0) {
                    
                    //PlantingTipsView(acceptedPlants: acceptedPlants)
                    
                    //CreateBannerView()
                    CreateNewArrivalView()
                    CreateFeaturedView()
                    
                }
                .padding(.bottom, spaceBottom)
                .padding(.top, 20.0)
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - Sub Views

extension HomeView {
    @ViewBuilder
    private func CreateBannerView() -> some View {
        BannerView(banners: dynamicBanners) { banner in
            print("Tip tapped: \(banner.title)")
        }
    }

    @ViewBuilder
    private func CreateNewArrivalView() -> some View {
        NewArrivalView(
            products: acceptedPlants,
            path: $path,
            productListTitle: $productListTitle
        )
    }

    @ViewBuilder
    private func CreateFeaturedView() -> some View {
        FeaturedView(
            products: rejectedPlants,
            path: $path,
            productListTitle: $productListTitle
        )
    }
}

// MARK: - Firestore Fetching

extension HomeView {
    private func fetchAcceptedPlants() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(uid).collection("acceptedPlants").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Failed to fetch accepted plants: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self.acceptedPlants = snapshot?.documents.compactMap { doc -> Product? in
                    let data = doc.data()
                    let name = data["plantName"] as? String ?? "Unknown Plant"
                    let imageURL = data["imageURL"] as? String ?? ""
                    return Product(
                        name: name,
                        price: 0.0,
                        oldPrice: 0.0,
                        imageLinks: [imageURL],
                        sizes: [],
                        colors: [],
                        description: "",
                        isFav: false,
                        rating1: 0,
                        rating2: 0,
                        rating3: 0,
                        rating4: 0,
                        rating5: 0
                    )
                } ?? []

                AITipService().fetchAITips(from: self.acceptedPlants.map { $0.name }) { tips in
                    self.dynamicBanners = tips.map {
                        BannerModel(
                            id: $0.id,
                            title: $0.title,
                            description: $0.description,
                            relatedPlants: $0.relatedPlants,
                            imageURL: "https://source.unsplash.com/800x600/?\($0.imagePrompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                        )
                    }
                }
            }
        }
    }

    private func fetchRejectedPlants() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(uid).collection("rejectedPlants").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Failed to fetch rejected plants: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self.rejectedPlants = snapshot?.documents.compactMap { doc -> Product? in
                    let data = doc.data()
                    let name = data["plantName"] as? String ?? "Unknown Plant"
                    let imageURL = data["imageURL"] as? String ?? ""
                    return Product(
                        name: name,
                        price: 0.0,
                        oldPrice: 0.0,
                        imageLinks: [imageURL],
                        sizes: [],
                        colors: [],
                        description: "",
                        isFav: false,
                        rating1: 0,
                        rating2: 0,
                        rating3: 0,
                        rating4: 0,
                        rating5: 0
                    )
                } ?? []
            }
        }
    }
}

//
//  IntroView.swift
//  FarmerApp
//
//  Created by vibhun naredla on 3/22/25.
//

import SwiftUI

struct IntroView: View {
    /// Called when onboarding is finished
    var onFinished: (() -> Void)? = nil

    @State private var activePage: Page = .page1

    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack {
                Spacer(minLength: 0)
                
                MorphingSymbolView(
                    symbol: activePage.rawValue,
                    config: .init(
                        font: .system(size: 150,  weight: .bold),
                        frame: .init(width: 250, height: 200),
                        radius: 30,
                        foregroundColor: Color("AgriCream")
                    )
                )
                
                TextContents(size: size)
                
                Spacer(minLength: 0)
                
                IndicatorView()
                
                ContinueButton()
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) {
                HeaderView()
            }
        }
        .background {
            ZStack {
                LinearGradient(
                    colors: [Color("AgriGreen"), Color("AgriLightGreen"), Color("AgriCream")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Image("leafPattern")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.05)
                    .ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    func TextContents(size: CGSize) -> some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.title)
                        .lineLimit(1)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .kerning(1.1)
                        .frame(width: size.width)
                        .foregroundColor(Color("AgriDark"))
                }
            }
            .offset(x: -activePage.index * size.width)
            .animation(.smooth(duration: 0.7, extraBounce: 0), value: activePage)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.subTitle)
                        .font(.callout)
                        .foregroundColor(Color("AgriDark").opacity(0.7))
                        .multilineTextAlignment(.center)
                        .frame(width: size.width)
                }
            }
            .offset(x: -activePage.index * size.width)
            .animation(.smooth(duration: 0.9, extraBounce: 0), value: activePage)
        }
        .padding(.top, 15)
        .frame(width: size.width, alignment: .leading)
    }

    @ViewBuilder
    func IndicatorView() -> some View {
        HStack(spacing: 6) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                Capsule()
                    .fill(.white.opacity(activePage == page ? 1 : 0.4))
                    .frame(width: activePage == page ? 25 : 8, height: 8)
            }
        }
        .animation(.smooth(duration: 0.5, extraBounce: 0), value: activePage)
        .padding(.bottom, 12)
    }

    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                activePage = activePage.previousPage
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .contentShape(.rect)
            }
            .opacity(activePage != .page1 ? 1 : 0)
            
            Spacer(minLength: 0)
            
            Button("Skip") {
                activePage = .page4
            }
            .fontWeight(.semibold)
            .opacity(activePage != .page4 ? 1 : 0)
        }
        .foregroundStyle(Color("AgriDark"))
        .animation(.snappy(duration: 0.35, extraBounce: 0), value: activePage)
        .padding(15)
    }

    @ViewBuilder
    func ContinueButton() -> some View {
        Button {
            if activePage == .page4 {
                onFinished?() // call this when onboarding is done
            } else {
                activePage = activePage.nextPage
            }
        } label: {
            Text(activePage == .page4 ? "Get Started with AgriMatch" : "Continue")
                .contentTransition(.identity)
                .foregroundStyle(Color("AgriDark"))
                .padding(.vertical, 15)
                .frame(maxWidth: activePage == .page4 ? 220 : 180)
                .background(Color("AgriCream"), in: .capsule)
        }
        .padding(.bottom, 15)
        .animation(.smooth(duration: 0.5, extraBounce: 0), value: activePage)
    }
}

#Preview {
    ContentView()
}

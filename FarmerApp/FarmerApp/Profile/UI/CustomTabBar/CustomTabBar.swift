//
//  CustomTabBar.swift
//  Shopping
//
//

import SwiftUI

struct CustomTabBar: View {
    
    //MARK: - Properties
    @Binding var tabSelection: Int
    
    //Environment
    @Environment(\.colorScheme) private var colorScheme
    
    //MARK: - Contents
    var body: some View {
        let midSize: CGFloat = screenWidth * (200/1000)
        let defaultColor = DarkMode.shared.defaultColor(colorScheme)
        
        ZStack() {
            BeziperCurvePath(midPoint: 0)
                .foregroundStyle(DarkMode.shared.backgroundColor(colorScheme))
                .shadow(
                    color: Color(uiColor: .lightGray),
                    radius: 0.4
                )
            
            HStack(spacing: 0.0) {
                ForEach(0..<TabModel.allCases.count, id: \.self) { index in
                    let tab = TabModel.allCases[index]
                    let isCurrentTab = tabSelection == index+1
                    let isMid = index == 2
                    
                    Button {
                        tabSelection = index + 1
                        
                    } label: {
                        VStack(spacing: 0.0) {
                            //TODO: - Icon
                            tab.image
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .aspectRatio(isMid ? 0.5 : 0.6, contentMode: .fit)
                                .frame(
                                    width: isMid ? midSize : 35.0,
                                    height: isMid ? midSize : 35.0)
                                .foregroundStyle(
                                    isMid
                                    ? DarkMode.shared.black_whiteColor(colorScheme)
                                    : (isCurrentTab ? defaultColor : .gray)
                                )
                                .background {
                                    if isMid {
                                        Circle().fill(defaultColor)
                                    }
                                }
                                .offset(y: isMid ? -(midSize/2) : 0.0)
                            
                            //TODO: - Text
                            if index != 2 {
                                Text(tab.rawValue)
                                    .font(.montMedium(size: 11.0))
                                    .foregroundStyle(isCurrentTab ? defaultColor : .gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .offset(y: index != 2 ? -10 : 0)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxHeight: midSize)
    }
}

//MARK: - BeziperCurvePath

struct BeziperCurvePath: Shape {
    
    var midPoint: CGFloat
    
    var animatableData: CGFloat {
        get { return midPoint }
        set { midPoint = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let maxW: CGFloat = 1000.0
            let maxH: CGFloat = 315.0
            
            let tabW = rect.width
            let tabH = tabW * (maxH/maxW)
            
            path.move(
                to: CGPoint(x: tabW*(688.57/maxW)-midPoint, y: 0.0)
            )
            path.addLine(
                to: CGPoint(x: tabW*(688.56/maxW)-midPoint, y: 0.0)
            )
            path.addCurve(
                to: CGPoint(x: tabW*(602.09/maxW)-midPoint, y: tabH*(-53.06/maxH)),
                control1: CGPoint(x: tabW*(652.05/maxW)-midPoint, y: 0.0),
                control2: CGPoint(x: tabW*(618.97/maxW)-midPoint, y: tabH*(-20.68/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(580.5/maxW)-midPoint, y: tabH*(-82.13/maxH)),
                control1: CGPoint(x: tabW*(596.55/maxW)-midPoint, y: tabH*(-63.68/maxH)),
                control2: CGPoint(x: tabW*(589.31/maxW)-midPoint, y: tabH*(-73.49/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(501.13/maxW)-midPoint, y: tabH*(-115/maxH)),
                control1: CGPoint(x: tabW*(559.33/maxW)-midPoint, y: tabH*(-102.88/maxH)),
                control2: CGPoint(x: tabW*(530.77/maxW)-midPoint, y: tabH*(-114.71/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(418.68/maxW)-midPoint, y: tabH*(-81.32/maxH)),
                control1: CGPoint(x: tabW*(469.99/maxW)-midPoint, y: tabH*(-115.29/maxH)),
                control2: CGPoint(x: tabW*(440.67/maxW)-midPoint, y: tabH*(-103.31/maxH)))
            path.addCurve(
                to: CGPoint(x: tabW*(397.52/maxW)-midPoint, y: tabH*(-52.3/maxH)),
                control1: CGPoint(x: tabW*(410.03/maxW)-midPoint, y: tabH*(-72.67/maxH)),
                control2: CGPoint(x: tabW*(402.93/maxW)-midPoint, y: tabH*(-62.88/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(311.44/maxW)-midPoint, y: 0.0),
                control1: CGPoint(x: tabW*(381.02/maxW)-midPoint, y: tabH*(-20.07/maxH)),
                control2: CGPoint(x: tabW*(347.64/maxW)-midPoint, y: 0.0)
            )
            path.addLine(
                to: CGPoint(x: 0.0, y: 0.0)
            )
            path.addLine(
                to: CGPoint(x: 0.0, y: tabH*(200/maxH))
            )
            path.addLine(
                to: CGPoint(x: tabW*(1000/maxW), y: tabH*(200/maxH))
            )
            path.addLine(
                to: CGPoint(x: tabW*(1000/maxW), y: 0.0)
            )
            path.addLine(
                to: CGPoint(x: tabW*(688.57/maxW), y: 0.0)
            )
            path.closeSubpath()
        }
    }
}

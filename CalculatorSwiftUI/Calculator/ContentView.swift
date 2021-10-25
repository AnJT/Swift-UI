//
//  ContentView.swift
//  AppTest
//
//  Created by anjt on 2021/9/27.
//

import SwiftUI

enum CalculatorButton: String{
    case zero, one, two, three, four, five, six, seven, eight, nine
    case decimal
    case equal, plus, minux, multiply, devide
    case ac, plusMinus, percent
    
    var title: String{
        switch self{
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .decimal: return "."
        case .equal: return "="
        case .plus: return "+"
        case .minux: return "-"
        case .multiply: return "×"
        case .devide: return "÷"
        case .ac: return "AC"
        case .plusMinus: return "+/-"
        case .percent: return "%"
        }
    }
    
    var backgroundColor: Color{
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
            return Color(.darkGray)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        default:
            return Color(.orange)
        }
    }
}

// Env object
class GlobalEnvironment: ObservableObject{
    @Published var display = "1+1=3"
    
    func receiveInput(calculatorButton: CalculatorButton) {
        self.display = calculatorButton.title
    }
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[CalculatorButton]] = [
        [.ac, .plusMinus, .percent, .devide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minux],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack(alignment: .bottom){
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            GeometryReader{ screen in
                VStack{
                    HStack{
                        Spacer()
                        Text(env.display)
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .frame(width: screen.size.width, height: screen.size.height * 0.4, alignment: .bottomTrailing)
                    }
                
                    GeometryReader{ geometry in
                        VStack(spacing: buttonSpacer(width: geometry.size.width, height: geometry.size.height)){
                            ForEach(buttons, id: \.self){ row in
                                HStack(spacing: buttonSpacer(width: geometry.size.width, height: geometry.size.height)){
                                    ForEach(row, id: \.self){ button in
                                        CalculatorButtonView(button: button, width: buttonWidth(button: button, width: geometry.size.width, height: geometry.size.height),height: buttonHeight(width: geometry.size.width, height: geometry.size.height))
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width:screen.size.width)
            }
        }
    }
    
    private func buttonWidth(button:CalculatorButton, width:CGFloat, height:CGFloat)->CGFloat{
        let spacer = buttonSpacer(width: width, height: height)
        if button == .zero{
            return (width - 3 * spacer) / 4 * 2 + spacer
        }
        return (width - 3 * spacer) / 4
    }
    
    private func buttonHeight(width:CGFloat, height:CGFloat)->CGFloat{
        let spacer = buttonSpacer(width: width, height: height)
        return (height - 4 * spacer) / 5
    }
    
    private func buttonSpacer(width:CGFloat, height:CGFloat)->CGFloat{
        return min(width, height) / 30
    }
}

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    var width: CGFloat
    var height: CGFloat
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View{
        Button(action: {
            self.env.receiveInput(calculatorButton: self.button)
        }, label: {
            Text(button.title)
                .frame(width: width, height: height, alignment: .center)
                .background(button.backgroundColor)
                .foregroundColor(.white)
                .font(.title)
                .cornerRadius(height / 5)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}

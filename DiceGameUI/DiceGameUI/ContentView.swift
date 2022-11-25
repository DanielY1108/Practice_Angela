//
//  ContentView.swift
//  DiceGameUI
//
//  Created by JinSeok Yang on 2022/11/08.
//

import SwiftUI

struct ContentView: View {
    
    @State private var leftDiceNumber = 1
    @State private var rightDiceNumber = 1
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("diceeLogo")
                Spacer()
                HStack() {
                    DiceImageView(n: leftDiceNumber)
                    DiceImageView(n: rightDiceNumber)
                }
                .padding(.horizontal)
                Spacer()
                Button("Roll") {
                    self.rollPressed()
                }
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding(.horizontal)  // 배경 크기를 키우려면 padding을 색 설정하기 전에 넣어야함
                .background(Color.red)
            }
            .padding(.init(top: 1, leading: 1, bottom: 1, trailing: 1))
        }
    }
    
    func rollPressed() {
        self.leftDiceNumber = Int.random(in: 1...6)
        self.rightDiceNumber = Int.random(in: 1...6)
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DiceImageView: View {
    let n: Int
    var body: some View {
        Image("dice\(n)")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}

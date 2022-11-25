//
//  ContentView.swift
//  My Card
//
//  Created by JinSeok Yang on 2022/11/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.45, green: 0.73, blue: 1.00)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("myProfile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150, alignment: .center)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 3)
                    }
                Text("Daniel Yang")
                    .font(Font.custom("Pacifico-Regular", size: 40))
                    .bold()
                    .foregroundColor(.white)
                Text("IOS Developer")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                Text("안녕하세요")
                Divider()
                InfoView(text: "+82 10 8894 1108" , imageName: "phone.fill")
                InfoView(text: "scarlet040@gmail.com", imageName: "envelope.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




//
//  InfoView.swift
//  My Card
//
//  Created by JinSeok Yang on 2022/11/08.
//

import SwiftUI

struct InfoView: View {
    let text : String
    let imageName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(height: 40, alignment: .center)
            .overlay {
                HStack {
                    Image(systemName: imageName)
                        .foregroundColor(.green)
                    Text(text)
                        .bold()
                }
            }
            .padding(.all)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(text: "hello", imageName: "phone.fill")
            .previewLayout(.sizeThatFits)
    }
}

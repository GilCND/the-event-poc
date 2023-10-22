//
//  ImageCard.swift
//  theevent-poc
//
//  Created by Felipe Gil on 2023-10-21.
//

import SwiftUI
import os

enum ImageCardSize: CaseIterable {
    case big, small
    
    var selectedSize: CGSize {
        switch self {
        case .big:
            return CGSize(width: 300, height: 300)
        case .small:
            return CGSize(width: 150, height: 150)
        }
    }
}

struct ImageCard: View {
    let size: ImageCardSize
    let url: String
    let title: String? = nil

    var body: some View {
        VStack (spacing: 5) {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(40)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.selectedSize.width, height: size.selectedSize.height)
                    .shadow(color:.gray ,radius: 8, y: 2)
                    .padding(.leading, 0)
            } placeholder: {
                ProgressView()
                    .frame(width: size.selectedSize.width, height: size.selectedSize.height)
            }
            VStack {
                Text(title ?? "")
                    .foregroundStyle(Color(.white))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .frame(width: size.selectedSize.width)
        .onAppear(perform: {
            Logger.viewCycle.debug("Image URL:\(url)")
        })
    }
}


#Preview {
    ImageCard(size: .small, url: "https://songleap.s3.amazonaws.com/venues/The+Velvet+Unicorn.png")
}

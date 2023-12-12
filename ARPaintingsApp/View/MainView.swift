//
//  ConteMainViewntView.swift
//  ARPaintingsApp
//
//  Created by Ariel Ortiz on 12/4/23.
//

import SwiftUI
import RealityKit
import ARKit
import Combine
import PhotosUI


struct MainView: View {
    
    @StateObject var viewModel = PaintingViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARRepresentable(selectedModel: $viewModel.selectedModel)
            
            VStack{
                
                HStack{
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(viewModel.images) { image in
                                                                
                                Image(uiImage: image.img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(viewModel.selectedModel?.image == image.img ? .blue : .clear, lineWidth: 2)
                                    )
                                    .padding(1)
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.selectedModel = CustomPainting(img: image.img)
                                        }
                                    }
                                    .contextMenu{
                                        Button {
                                            DispatchQueue.main.async {
                                                withAnimation {
                                                    viewModel.removeImage(img: image)
                                                }
                                            }
                                            
                                        } label: {
                                            Label {
                                                Text("Remove")
                                            } icon: {
                                                Image(systemName: "trash")
                                            }
                                            
                                        }
                                        
                                    }
                                
                            }
                            
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 3)
                                        
                    PhotosPicker(
                        selection: $viewModel.imageSelection,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                            
                        }
                        .padding(.vertical)
                        .padding(.trailing)
                }
                .frame(height: 70)
                .background(.ultraThinMaterial)
                
            }
            
        }
        
        
    }
    
    
  
}



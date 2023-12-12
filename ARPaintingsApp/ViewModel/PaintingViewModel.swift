//
//  PaintingViewModel.swift
//  ARPaintingsApp
//
//  Created by Ariel Ortiz on 12/4/23.
//

import SwiftUI
import PhotosUI

class PaintingViewModel: ObservableObject{
    @Published var selectedModel: CustomPainting?
    @Published var images = [ImagePainting]()
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)
    }
    
    
    @Published var image: UIImage?
    
    @Published private(set) var imageState: ImageState = .empty {
        didSet{
            switch imageState {
            case .empty:
                break
            case .loading(_):
                print("loading")
                break
            case .success(let uIImage):
                images.append(ImagePainting(img: uIImage))
                selectedModel = CustomPainting(img: uIImage)
                print("success")
            case .failure(_):
                print("error")
                break
            }
        }
    }
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    enum TransferError: Error {
        case importFailed
    }
    
    struct ImageToEdit: Transferable {
        let image: UIImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                return ImageToEdit(image: uiImage)
            }
        }
    }
    

    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ImageToEdit.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    
    func removeImage(img: ImagePainting){
        self.images = self.images.filter { i in
            return i.id != img.id
        }
    }
}

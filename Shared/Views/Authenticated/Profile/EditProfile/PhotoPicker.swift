//
//  PhotoPicker.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/18/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
 
    @Binding var avatarImageData: Data?
    @EnvironmentObject var primaryUserData: UserFetchServiceResultModel

    
    func makeUIViewController(context: Context) -> UIViewController {
        let picker  = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                 let imageData = image.jpegData(compressionQuality: 0.6)
                        
                // image data
                photoPicker.avatarImageData = imageData
                
            }
            

            picker.dismiss(animated: true)

        }
    }
}
 

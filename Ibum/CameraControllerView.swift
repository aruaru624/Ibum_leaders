//
//  CameraControllerView.swift
//  Ibum
//
//  Created by tanaka niko on 2025/07/12.
//
import SwiftUI
import UIKit

//struct CameraControllerView: UIViewControllerRepresentable {
////    @Binding var quest:String
////    @Binding var isActive: Bool
//    
////    @Environment(\.isPresentedCamera) var isPresented
//    @Environment(\.dismiss) var dismiss
//    
//    @EnvironmentObject var shareValue: isPresenteCamera
//    
////    @StateObject private var isPresentedCamera = isPresenteCamera()
//    
//    // UIViewControllerを作成するメソッド
//        func makeUIViewController(context: Context) -> UIViewController {
//            print("aaa")
//            // 指定のUIViewControllerを作成する
//            if let controller = CameraViewController() as? CameraViewController{
//                print("hoge")
//                controller.quest = quest
//                controller.dismissToRoot = {
//                    isActive = false  // NavigationLinkの状態を false → pop に戻す
//                }
//                return controller
//            }
//            print("hogehoge")
//            let cameraViewController = CameraViewController()
//            return cameraViewController
//        }
//
//        // UIViewControllerを更新するメソッド
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//            
//        }
//}

//
//struct ImagePickerView : UIViewControllerRepresentable {
////    @Binding var image : UIImage?
//
//    typealias UIViewControllerType = UIImagePickerController
//
//    class Coordinator : NSObject,
//                        UINavigationControllerDelegate,
//                        UIImagePickerControllerDelegate {
//    var parent : ImagePickerView
//
//    init(parent : ImagePickerView){
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker : UIImagePickerController,
//         didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]){
////            if let selectedImage = info[.originalImage] as? UIImage {
////                parent.image = selectedImage
////            }
//            picker.dismiss(animated : true)
//        }
//
//        func imagePickerControllerDidCancel(_ picker : UIImagePickerController){
//            picker.dismiss(animated : true)
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent : self)
//    }
//
//    func makeUIViewController(context : Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.cameraCaptureMode = .photo
//        picker.allowsEditing = true
//        if UIImagePickerController.isFlashAvailable(for: picker.cameraDevice) {
//          // UIの状態に合わせて変えましょう
//            picker.cameraFlashMode = .auto
//        } else {
//            // フラッシュが利用できないカメラです
//        }
//        
//        picker.cameraDevice = .rear
//        picker.showsCameraControls = true
//        picker.videoQuality = .typeHigh
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController : UIImagePickerController, context : Context){}
//}

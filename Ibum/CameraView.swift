import AVFoundation
import UIKit
import SwiftUI
import SwiftData

class CameraViewController: UIViewController{
    
    lazy var silhouetteUIview = UIImageView()
    
    var dismissToRoot: (() -> Void)?
    
    @StateObject private var isPresentedCamera = isPresenteCamera()
    
    @Environment(\.modelContext) private var context
    
    var quest:String = ""
    
    var flag = true
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        setupSilhouetteView()
        setupShutterButton()
    }
    
    var captureSession = AVCaptureSession()
    
    func setupCaptureSession(){
        captureSession.sessionPreset = .photo
    }
    
    var mainCamera:AVCaptureDevice?
    var innerCamera: AVCaptureDevice?
    var currentDevice:AVCaptureDevice?
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        print(devices)
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        // 起動時のカメラを設定
        currentDevice = mainCamera
    }
    
    // キャプチャーの出力データを受け付けるオブジェクト
    var photoOutput : AVCapturePhotoOutput?

    // 入出力データの設定
    func setupInputOutput() {
        do {
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            // 指定した入力をセッションに追加
            captureSession.addInput(captureDeviceInput)
            // 出力データを受け取るオブジェクトの作成
            photoOutput = AVCapturePhotoOutput()
            // 出力ファイルのフォーマットを指定
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    // プレビュー表示用のレイヤ
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?

    // カメラのプレビューを表示するレイヤの設定
    func setupPreviewLayer() {
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // プレビューレイヤが、カメラのキャプチャーを縦横比を維持した状態で、表示するように設定
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤの表示の向きを設定
        self.cameraPreviewLayer?.connection?.videoRotationAngle = 90
//        self.cameraPreviewLayer?.frame = view.frame
//        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
        
        //カメラ用のviewを生成
        let cameraUIview = UIView()
        cameraUIview.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.width / 9 * 16))
        self.view.addSubview(cameraUIview)
        cameraUIview.translatesAutoresizingMaskIntoConstraints = false
        cameraUIview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true

        
        //camerauiviewにcameralayerを追加
        self.cameraPreviewLayer?.frame = cameraUIview.frame
        cameraUIview.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
        
        captureSession.startRunning()
        
    }
    
    func setupSilhouetteView(){
        
//        toggle.backgroundColor = .cyan
        
        //toggleボタンをnavigationbarに追加
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: .none)
        
        //シルエット表示用のviewを作成
        
        silhouetteUIview.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.width / 9 * 16))
        silhouetteUIview.image = UIImage(named: String(quest) + ".PNG")
        silhouetteUIview.alpha = (flag ? 0.5 : 0)
//        silhouetteUIview.backgroundColor = .systemPink
        silhouetteUIview.contentMode = .scaleToFill
        self.view.addSubview(silhouetteUIview)
        silhouetteUIview.translatesAutoresizingMaskIntoConstraints = false
        silhouetteUIview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        silhouetteUIview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        silhouetteUIview.heightAnchor.constraint(equalToConstant: self.view.frame.width / 9 * 16).isActive = true
        silhouetteUIview.widthAnchor.constraint(equalToConstant: self.view.frame.width ).isActive = true
        
        lazy var latticeUIview = UIImageView()
        latticeUIview.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.width / 9 * 16))
        latticeUIview.image = UIImage(named: "lattice.PNG")
        latticeUIview.contentMode = .scaleToFill
        self.view.addSubview(latticeUIview)
        latticeUIview.translatesAutoresizingMaskIntoConstraints = false
        latticeUIview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        latticeUIview.heightAnchor.constraint(equalToConstant: self.view.frame.width / 9 * 16).isActive = true
        latticeUIview.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        latticeUIview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        

        
        //toggleボタンを作成
        lazy var toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = .init(red: 151/255, green: 254/255, blue: 237/255, alpha: 1)
        self.view.addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        toggle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        toggle.addTarget(self, action: #selector(toggleChange), for: .valueChanged)
        
    }
    
    func setupShutterButton(){
        lazy var shutterButton = UIButton()
        shutterButton.tintColor = .white
        shutterButton.layer.borderColor = UIColor.white.cgColor
        shutterButton.frame.size = CGSize(width: 60, height: 60)
        shutterButton.layer.borderWidth = 5
        shutterButton.clipsToBounds = true
        shutterButton.layer.cornerRadius = min(shutterButton.frame.width, shutterButton.frame.height) / 2
        shutterButton.addTarget(self, action: #selector(buttonTopped), for: .touchUpInside)
        self.view.addSubview(shutterButton)
        
        //ボタンにautolayoutを設定
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        shutterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        shutterButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        shutterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        shutterButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        
        
    }
    
    @objc func buttonTopped(){
        let settings = AVCapturePhotoSettings()
        // フラッシュの設定
        settings.flashMode = .auto
//        // カメラの手ぶれ補正
//        settings.
        // 撮影された画像をdelegateメソッドで処理
//        let image =AVCapturePhotoOutput(session: captureSession)
        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
        
    }

    @objc func toggleChange(){
        flag.toggle()
        silhouetteUIview.alpha = (flag ? 0.5 : 0)
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate{
    // 撮影した画像データが生成されたときに呼び出されるデリゲートメソッド
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            // Data型をUIImageオブジェクトに変換
            let uiImage = UIImage(data: imageData)!
            uiImage.cgImage?.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.width / 9 * 16)))
//            uiImage.size =  /*CGSize(width: self.view.frame.width, height: self.view.frame.width / 9 * 16)*/
            if let context = AppDelegate.shared.modelContext {

                    let trimmingView = PhotoTrimmingView (
                        dismissToRoot: {
                            self.dismiss(animated: false) {  // まずViewControllerを閉じる
                                self.dismissToRoot?()  // HomeViewまで戻す
                            }
                        },
                        onDismiss: {},
                        image: uiImage,
                        questTitle:quest
                        
                    ).environment(\.modelContext, context)
                let controller = UIHostingController(rootView:trimmingView)
                controller.modalPresentationStyle = .overFullScreen
                print(quest)
                present(controller, animated: true)
            }
//            // 写真ライブラリに画像を保存
//            UIImageWriteToSavedPhotosAlbum(uiImage!, nil,nil,nil)
           

        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var quest:String
    @Binding var isActive: Bool
    
//    @Environment(\.isPresentedCamera) var isPresented
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var shareValue: isPresenteCamera
    
    @StateObject private var isPresentedCamera = isPresenteCamera()
    
    // UIViewControllerを作成するメソッド
        func makeUIViewController(context: Context) -> UIViewController {
            print("aaa")
            // 指定のUIViewControllerを作成する
            if let controller = CameraViewController() as? CameraViewController{
                print("hoge")
                controller.quest = quest
                controller.dismissToRoot = {
                    isActive = false  // NavigationLinkの状態を false → pop に戻す
                }
                return controller
            }
            print("hogehoge")
            let cameraViewController = CameraViewController()
            return cameraViewController
        }

        // UIViewControllerを更新するメソッド
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

            
//            print(isPresentedCamera.isOn)
//            if !isPresentedCamera.isOn{
////                isPresentedCamera.isOn = true
//                dismiss()
//            }

            
        }
}

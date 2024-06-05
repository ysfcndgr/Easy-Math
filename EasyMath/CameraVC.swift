//
//  CameraVC.swift
//  EasyMath
//
//  Created by Can on 16.03.2024.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage: UIImage?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure()
    }


    @IBAction func didTappedShootButton(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private func configure() {
        // Preset the session for taking photo in full resolution
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // Get the front and back-facing camera for taking photos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
            }
        }
        
        currentDevice = backFacingCamera
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
            return
        }
        
        // Configure the session with the output for capturing still images
        stillImageOutput = AVCapturePhotoOutput()
        
        // Configure the session with the input and the output devices
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(stillImageOutput)
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        // Bring the camera button to front
        view.bringSubviewToFront(cameraButton)
        captureSession.startRunning()
        
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }
        
        // Get the image from the photo buffer
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        stillImage = UIImage(data: imageData)
    }
}

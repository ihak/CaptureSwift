//
//  CaptureViewController.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/15/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {

    enum CameraMode {
        case photo, video
    }
    
    @IBOutlet var flashButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var modeButton: UIButton!
    @IBOutlet var captureStackView: CaptureStackView!
    
    @IBOutlet var captureButton: UIButton!
    
    let cameraEngine = CameraEngine()
    var mode: CameraMode = .photo
    var photosLimit = 2
    var videoLimit = 10
    
    var backFlashMode: AVCaptureFlashMode = .auto
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cameraEngine.startSession()
        
        // Set the flash mode to a default value of .auto
        setFlashMode(flashMode: backFlashMode)
    }
    
    override func viewDidLayoutSubviews() {
        if let layer = self.cameraEngine.previewLayer {
            layer.frame = self.view.bounds
            self.view.layer.insertSublayer(layer, at: 0)
            self.view.layer.masksToBounds = true
            
            self.cameraEngine.rotationCamera = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    //MARK: - IBActions
    @IBAction func flashButtonTapped(_ sender: AnyObject) {
        if let flashMode = self.cameraEngine.flashMode {
            switch flashMode {
                case .on:
                    setFlashMode(flashMode: .off)
                case .off:
                    setFlashMode(flashMode: .auto)
                case .auto:
                    setFlashMode(flashMode: .on)
            }
        }
    }

    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
        switchCaptureDevice()
    }

    @IBAction func cameraModeButtonTapped(_ sender: AnyObject) {
        switch mode {
        case .photo:
            setCameraMode(mode: .video)
            modeButton.setTitle("Mode: Video", for: .normal)
        case .video:
            setCameraMode(mode: .photo)
            modeButton.setTitle("Mode: Photo", for: .normal)
        }
    }
    
    @IBAction func captureButtonTapped(_ sender: AnyObject) {
        switch mode {
        case .photo:
            self.capturePhoto()
        case .video:
            self.captureVideo()
        }
    }

    //MARK: - Other Functions
    
    func switchCaptureDevice() {
        // Set the flash mode to off when device is switched
        if self.cameraEngine.cameraDevice.currentPosition == .back {
            self.cameraEngine.flashMode = .off
            self.flashButton.isHidden = true
        }
        else {
            setFlashMode(flashMode: backFlashMode)
            self.flashButton.isHidden = false
        }
        
        self.cameraEngine.switchCurrentDevice()
        
        switch self.cameraEngine.cameraDevice.currentPosition {
            case .front:
                self.cameraButton.setTitle("Camera: Front", for: .normal)
            case .back:
                self.cameraButton.setTitle("Camera: Back", for: .normal)
            case .unspecified:
                self.cameraButton.setTitle("Camera: Nil", for: .normal)
        }
    }

    func setCameraMode(mode: CameraMode) {
        self.mode = mode
    }
    
    func setFlashMode(flashMode: AVCaptureFlashMode) {
        // Set flash mode only for back camera
        guard self.cameraEngine.cameraDevice.currentPosition == .back else {
            return
        }
        
        self.cameraEngine.flashMode = flashMode
        self.backFlashMode = flashMode
        
        switch flashMode {
        case .on:
            flashButton.setTitle("Flash: On", for: .normal)
        case .off:
            flashButton.setTitle("Flash: Off", for: .normal)
        case .auto:
            flashButton.setTitle("Flash: Auto", for: .normal)
        }
    }
    
    func capturePhoto() {
        self.cameraEngine.capturePhoto { (image, error) -> (Void) in
            if let _ = error {
                print("Unable to capture image. " + error!.localizedDescription)
            }
            else {
                if let photo = image {
                    print(photo.description)
                    
                    self.captureStackView.captureStack.push(image: photo)
                    
                    if self.captureStackView.captureStack.list.count == self.photosLimit {
                        self.captureButton.isEnabled = false
                        self.captureButton.alpha = 0.5
                    }
                }
            }
        }
    }
    
    func captureVideo() {
        
    }
}

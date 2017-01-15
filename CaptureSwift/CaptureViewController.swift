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
    
    @IBOutlet var captureButton: UIButton!
    
    let cameraEngine = CameraEngine()
    var mode: CameraMode = .photo
    var photosLimit = 10
    var videoLimit = 10
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cameraEngine.startSession()
    }
    
    override func viewDidLayoutSubviews() {
        if let layer = self.cameraEngine.previewLayer {
            layer.frame = self.view.bounds
            self.view.layer.insertSublayer(layer, at: 0)
            self.view.layer.masksToBounds = true
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
                    self.cameraEngine.flashMode = .off
                    flashButton.setTitle("Flash: Off", for: .normal)
                case .off:
                    self.cameraEngine.flashMode = .auto
                    flashButton.setTitle("Flash: Auto", for: .normal)
                case .auto:
                    self.cameraEngine.flashMode = .on
                    flashButton.setTitle("Flash: On", for: .normal)
            }
        }
    }

    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
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

    @IBAction func cameraModeButtonTapped(_ sender: AnyObject) {
        switch mode {
        case .photo:
            mode = .photo
            modeButton.setTitle("Mode: Photo", for: .normal)
        case .video:
            mode = .video
            modeButton.setTitle("Mode: Video", for: .normal)
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

    func capturePhoto() {
        
    }
    
    func captureVideo() {
        
    }

}

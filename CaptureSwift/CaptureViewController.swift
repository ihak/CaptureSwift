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
    
    @IBOutlet var cameraButtonContainerView: UIView!
    @IBOutlet var cameraButtonView: UIView!
    @IBOutlet var camerButtonImageView: UIImageView!
    
    @IBOutlet var countLabelContainer: UIView!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var captureButton: UIButton!
    
    let kFillAnimation = "kFillAnimation"
    let cameraEngine = CameraEngine()
    var mode: CameraMode = .photo
    var photosLimit = 5
    var videoLimit = 5.0
    
    var videoProgressStrokeLayer: CAShapeLayer?
    
    var backFlashMode: AVCaptureFlashMode = .auto
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cameraEngine.rotationCamera = true
        self.cameraEngine.startSession()
        
        // Set the flash mode to a default value of .auto
        setFlashMode(flashMode: backFlashMode)
        
        cameraButtonView.layer.cornerRadius = 30.0
        cameraButtonView.layer.borderWidth = 1.0
        cameraButtonView.layer.borderColor = UIColor(colorLiteralRed: 184.0/256.0, green: 184.0/256.0, blue: 184.0/256.0, alpha: 1.0).cgColor
        
        cameraButtonContainerView.layer.cornerRadius = 35.0
        
        captureStackView.layer.cornerRadius = 5.0
        countLabelContainer.layer.cornerRadius = 5.0
        
        countLabel.text = "0 /\(photosLimit)"
        
        self.navigationItem.title = "Take Photo"
        
        captureStackView.delegate = self
    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(UInt8(UIInterfaceOrientation.landscapeLeft.rawValue) | UInt8(UIInterfaceOrientation.landscapeRight.rawValue) | UInt8(UIInterfaceOrientation.portrait.rawValue)))
//    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueShowCaptureItemCollectionView" {
            if let destinationVC = segue.destination as? CaptureItemsViewController {
                destinationVC.captureStack = self.captureStackView.captureStack
            }
        }
    }
    
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
    func hideControls() {
        self.flashButton.isHidden = true
        self.cameraButton.isHidden = true
        self.modeButton.isHidden = true
    }
    
    func showControls() {
        self.flashButton.isHidden = false
        self.cameraButton.isHidden = false
        self.modeButton.isHidden = false
    }
    
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
    
    func startVideoProgressAnimation() {
        let rect = self.view.convert(self.cameraButtonContainerView.bounds, from: nil)
            
        let startAngle = Double.pi * 1.5
        let endAngle = startAngle + (Double.pi * 2)
        
        videoProgressStrokeLayer = CAShapeLayer()
        videoProgressStrokeLayer?.fillColor   = UIColor.clear.cgColor
        videoProgressStrokeLayer?.strokeColor = UIColor(colorLiteralRed: 18.0/256.0, green: 76.0/256.0, blue: 155.0/256.0, alpha: 1.0).cgColor
        videoProgressStrokeLayer?.lineWidth   = 4
        videoProgressStrokeLayer?.borderColor = UIColor.clear.cgColor
        
        let innerbezierPath = UIBezierPath()
        innerbezierPath.addArc(withCenter: CGPoint(x: rect.size.width/2, y: rect.size.height / 2), radius: rect.size.width/2, startAngle: CGFloat(startAngle), endAngle: CGFloat((endAngle - startAngle) * 1 + startAngle), clockwise: true)
        videoProgressStrokeLayer?.path = innerbezierPath.cgPath
        
        self.cameraButtonContainerView.layer.addSublayer(videoProgressStrokeLayer!)
        
        let fillStrokeAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        
        
        fillStrokeAnimation.duration = videoLimit
        fillStrokeAnimation.fromValue = NSNumber(floatLiteral: 0.0)
        fillStrokeAnimation.toValue = NSNumber(floatLiteral: 1.0)
        fillStrokeAnimation.isRemovedOnCompletion = false
        fillStrokeAnimation.fillMode = kCAFillModeForwards
        fillStrokeAnimation.delegate = self
        
        
        videoProgressStrokeLayer?.add(fillStrokeAnimation, forKey: kFillAnimation)
    }
    
    func resetVideoProgress() {
        DispatchQueue.main.async {
            self.videoProgressStrokeLayer?.removeFromSuperlayer()
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
                    
                    DispatchQueue.main.async {
                        if self.captureStackView.captureStack.list.count == self.photosLimit {
                            self.captureButton.isEnabled = false
                            self.captureButton.alpha = 0.5
                        }
                        
                        self.countLabel.text = "\(self.captureStackView.captureStack.list.count) /\(self.photosLimit)"
                    }
                }
            }
        }
    }
    
    func captureVideo() {
        startVideoProgressAnimation()
        let captureVideoItem = CaptureVideoItem()

        if let url = captureVideoItem.url {
            
            self.cameraEngine.blockCompletionProgress = { progress in
                print("progress: \(progress)")
            }
            
            self.cameraEngine.startRecordingVideo(url, blockCompletion: { (url, error) -> (Void) in
                self.resetVideoProgress()
                
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
                print("Video saved at : \(String(describing: url?.absoluteURL))")
                
                if let videoURL = url {
                    self.captureStackView.captureStack.push(url: videoURL)
                    
                    DispatchQueue.main.async {
                        self.countLabel.text = "\(self.captureStackView.captureStack.list.count) /\(self.photosLimit)"
                    }
                }
            })
        }
    }
    
    func stopVideoRecording() {
        self.cameraEngine.stopRecordingVideo()
    }
}

extension CaptureViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.stopVideoRecording()
        }
    }
}


extension CaptureViewController: CaptureStackViewDelegate {
    func captureStackViewDidTap(captureStackView: CaptureStackView) {
        self.performSegue(withIdentifier: "SegueShowCaptureItemCollectionView", sender: nil)
    }
}

extension CaptureViewController {
    func mirrorVideo(inputURL: URL, completion: @escaping (_ outputURL : URL?) -> ())
    {
        let videoAsset: AVAsset = AVAsset( url: inputURL )
        let clipVideoTrack = videoAsset.tracks( withMediaType: AVMediaTypeVideo ).first! as AVAssetTrack
        
        let composition = AVMutableComposition()
        composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.width)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        var transform:CGAffineTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        transform = transform.translatedBy(x: -clipVideoTrack.naturalSize.width, y: 0.0)
//        transform = transform.rotated(by: CGFloat(Double.pi/2))
        transform = transform.translatedBy(x: 0.0, y: -clipVideoTrack.naturalSize.width)
        
        transformer.setTransform(transform, at: kCMTimeZero)
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export
        
        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPreset640x480)!
        let path = inputURL.deletingLastPathComponent()
        let fileName = inputURL.lastPathComponent.replacingOccurrences(of: ".mp4", with: "-flipped.mp4")
        let filePath = path.appendingPathComponent(fileName)
        let croppedOutputFileUrl = filePath
        exportSession.outputURL = croppedOutputFileUrl
        exportSession.outputFileType = AVFileTypeMPEG4
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                DispatchQueue.main.async(execute: {
                    completion(croppedOutputFileUrl)
                })
                return
            } else if exportSession.status == .failed {
                print("Export failed - \(String(describing: exportSession.error))")
            }
            
            completion(nil)
            return
        }
    }
}

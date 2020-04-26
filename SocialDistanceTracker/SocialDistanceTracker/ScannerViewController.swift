//
//  ScannerViewController.swift
//  SocialDistanceTracker
//
//  Created by Vivek John on 27/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class STDScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var startStopButton: UIButton!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private let permissionsManager = CameraPermissionsManager()
    var person : PersonModel = PersonModel()
    var viewModel = ScannerViewModel()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        self.showSpinner(onView: self.view)
        startStopButton.setTitle("Start", for: .normal)
        // checking permission for camera
        permissionsManager.performCameraAuthorization(forController: self) { responseStatus in
            if responseStatus == .authorized {
                self.setUpScannerView()
            } else {
                self.removeSpinner()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer?.frame = cameraContainerView.layer.bounds
        if let connection = self.previewLayer?.connection {
            let orientation = self.view.window?.windowScene?.interfaceOrientation ?? UIInterfaceOrientation.portrait
            let previewLayerConnection : AVCaptureConnection = connection

            if (previewLayerConnection.isVideoOrientationSupported) {
                switch (orientation) {
                    case .landscapeRight:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                    case .landscapeLeft:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                    case .portraitUpsideDown:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                    default:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }
    
    // MARK: Camera Settings
    
    // setting camera view for scanning
    func setUpScannerView() {
        // Setup Camera Capture
        captureSession = AVCaptureSession()
        
        // Get the default camera
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else { //simulator
            captureSession = nil
            viewModel.failed()
            return
        }
        
        // Now the camera is setup add a metadata output
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else { //simulator
            captureSession = nil
            viewModel.failed()
            return
        }
        
        // Setup the UI to show the camera
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraContainerView.layer.addSublayer(previewLayer)
        
        self.viewModel.qrCodeBounds.alpha = 0
        cameraContainerView.addSubview(self.viewModel.qrCodeBounds)
        
        captureSession.startRunning()
        self.removeSpinner()
        startStopButton.setTitle("Stop", for: .normal)
    }
    
    // Displaying boarder for scanned QRCode
    func showQRCodeBounds(frame: CGRect?) {
        guard let frame = frame else { return }
        
        self.viewModel.qrCodeBounds.layer.removeAllAnimations()
        self.viewModel.qrCodeBounds.alpha = 1
        self.viewModel.qrCodeBounds.frame = frame
        UIView.animate(withDuration: 0.2, delay: 1, options: [], animations: {
            self.viewModel.qrCodeBounds.alpha = 0
        })
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Show bounds
            let qrCodeObject = previewLayer.transformedMetadataObject(for: readableObject)
            showQRCodeBounds(frame: qrCodeObject?.bounds)
            self.viewModel.parseData(parsedString: stringValue)
            startStopPressed(self)
        }
    }
    
    // MARK: Button Action

    //Button action for start and stop scanning
    @IBAction func startStopPressed(_ sender: Any) {
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
            startStopButton.setTitle("Start", for: .normal)
        }
        else {
            captureSession?.startRunning()
            startStopButton.setTitle("Stop", for: .normal)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //Button action for displaying Trusted Device Popup
    @IBAction func clickActionTrustedDevice(_ sender: Any) {
        if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrustedDeviceViewController") {
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
            presentedViewController.view.backgroundColor = .clear
            self.present(presentedViewController, animated: true, completion: nil)
        }
    }
}

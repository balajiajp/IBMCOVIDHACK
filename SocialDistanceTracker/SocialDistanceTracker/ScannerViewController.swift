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

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet var trustedDeviceButton: UIButton!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private let permissionsManager = CameraPermissionsManager()
    var person : PersonModel = PersonModel()
    var viewModel = ScannerViewModel()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer?.frame = cameraContainerView.layer.bounds
        if let connection = self.previewLayer?.connection {
            
            let previewLayerConnection : AVCaptureConnection = connection
            
            if (previewLayerConnection.isVideoOrientationSupported) {
                previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
        self.hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
        self.showNavigationBar()
    }
    
    // setup screen
    func loadUI() {
        view.backgroundColor = UIColor.black
        self.showSpinner(onView: self.view)
        startStopButton.setTitle("Start", for: .normal)
        if (UIApplication.shared.delegate as! AppDelegate).userTypeIsVendor {
            trustedDeviceButton.isHidden = true
        }
        // checking permission for camera
        permissionsManager.performCameraAuthorization(forController: self) { responseStatus in
            if responseStatus == .authorized {
                self.setUpScannerView()
            } else {
                self.removeSpinner()
            }
        }
    }
    
    // MARK: Camera Settings
    
    // setting camera view for scanning
    func setUpScannerView() {
        // Setup Camera Capture
        captureSession = AVCaptureSession()
        
        // Get the default camera
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            self.removeSpinner()
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            self.removeSpinner()
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else { //simulator
            captureSession = nil
            viewModel.showAlertForScanComplete(title: PresenterUtilsAppValues.Error, message: PresenterUtilsAppValues.ScanningFailed, viewController: self)
            self.removeSpinner()
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
            viewModel.showAlertForScanComplete(title: PresenterUtilsAppValues.Error, message: PresenterUtilsAppValues.ScanningFailed, viewController: self)
            self.removeSpinner()
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
            UIDevice.vibrate()
            
            // Show bounds
            let qrCodeObject = previewLayer.transformedMetadataObject(for: readableObject)
            showQRCodeBounds(frame: qrCodeObject?.bounds)
            self.viewModel.parseData(parsedString: stringValue, viewController: self)
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
    
    @IBAction func clickActionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

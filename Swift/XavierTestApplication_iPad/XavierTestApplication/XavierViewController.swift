//
//  XavierViewController.swift
//  Paging_Swift
//
//  Copyright (c) 2015 SimonComputing. All rights reserved.
//

import UIKit
import Foundation

class XavierViewController: UIViewController, SCIXavierClientProtocol, XMLParserDelegate, UIScrollViewDelegate {
    
    fileprivate var xavierVC:SCIXavierViewController?
    fileprivate var reImage:UIImage?
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func start(_ sender: AnyObject) {
        self.clearTextView()
        let app = UIApplication.shared
        
        if (app.statusBarOrientation.isPortrait) {
            self.startXavier()
        } else {
            self.startXavierLandscape()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        rotateForLabel()
    }
    
    @objc func onRawMrz(_ rawMrz: String!) -> Void {
        print("\n=====> onRawMrz() - \(rawMrz)")
        self.insertToTextView("Raw MRZ:\n")
        
        self.insertToTextView("========\n")
        
        self.insertToTextView(rawMrz as NSString!)
        self.insertToTextView("\n")
    }
    
    @objc func onParsedJsonFromlMrz(_ parsedJsonFromlMrz: String!) {
        print("\n=====> onParsedJsonFromlMrz() - \(parsedJsonFromlMrz)")
        
        self.insertToTextView("JSON from MRZ:\n")
        self.insertToTextView("===========\n")
        self.insertToTextView(parsedJsonFromlMrz as NSString!)
        
        self.insertToTextView("\n")
    }
    
    @objc func onParsedXmlFromlMrz(_ parsedXmFromlMrz: String!) -> Void {
        print("\n=====> onParsedXmlFromlMrz() - \(parsedXmFromlMrz)")
        
        /* Uncomment this code to output data in XML format
         self.insertToTextView("XML from MRZ:\n")
         self.insertToTextView("===========\n")
         self.insertToTextView(parsedXmFromlMrz as NSString!)
         
         
         self.insertToTextView("\n")
         */
    }
    
    @objc func onMetrics(_ metrics: SCIMetrics!) -> Void{
        print("\n=====> onMetrics()")
        self.insertToTextView("Metrics:\n")
        self.insertToTextView("======\n")
        
        self.insertToTextView("Total OCR time: \(metrics.endOfWidget - metrics.startOfWidget)" as NSString!)
        
        self.insertToTextView(" (secs)\n")
        
        self.insertToTextView("Number of MRZ candidates found: \(metrics.numberOfCandidates)" as NSString!)
        self.insertToTextView("\n")
        
        self.insertToTextView("Number of scans: \(metrics.numberOfCandidates)" as NSString!)
        self.insertToTextView("\n")
        
        self.insertToTextView("Image analysis average duration: \(metrics.imageAnalysis)" as NSString!)
        self.insertToTextView(" (secs)\n")
        self.insertToTextView("\n")
    }
    
    @objc func onMrzCaptureCompleted() {
        print("\n=====> onCaptureCompleted()")
    }
    
    @objc func onError(_ errorMessage: String!) {
        print("\n=====> onError() - \(errorMessage)")
        self.insertToTextView("Error:\n")
        self.insertToTextView("======\n")
        
        self.insertToTextView(errorMessage as NSString!)
    }
    
    @objc func onClose() {
        print("\n=====> onClose()")
    }
    
    @objc func onCapturedImage(_ image: UIImage!) {
        print("\n======> onCapturedImage")
        DispatchQueue.main.async(execute: {
            
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
            self.imageView.image = image
        })
    }
    
    @objc func onCapturedBarcode(_ barcode: String!) {
        print("\n=====> onCaptureBarcode() - \(barcode)")
        self.insertToTextView(barcode as NSString!)
        self.insertToTextView("\n")
    }
    
    func startXavier() -> Void {
        xavierVC = SCIXavierViewController(true)
        xavierVC?._clientProtocol = self
        self.present(xavierVC!, animated: false, completion: {() -> Void in print("Xavier is started")})
    }
    
    func startXavierLandscape() -> Void {
        xavierVC = SCIXavierViewController(false)
        xavierVC?._clientProtocol = self
        self.present(xavierVC!, animated: false, completion: {() -> Void in print("Xavier is started")})
    }
    
    fileprivate func insertToTextView(_ insertingString:NSString!) -> Void {
        DispatchQueue.main.async(execute: {
            var range:NSRange? = self.resultTextView!.selectedRange
            
            self.resultTextView.textAlignment = .left
            self.resultTextView.font = UIFont(name: (self.resultTextView?.font?.fontName)!, size: 15)
            
            var currentString = self.resultTextView!.text as NSString
            currentString = currentString.substring(to: (range?.location)!) as NSString
            
            self.resultTextView!.isScrollEnabled = true
            self.resultTextView!.text = (currentString as String) + (insertingString as String)
            range?.location += insertingString.length
            self.resultTextView!.selectedRange = range!
            self.resultTextView!.isScrollEnabled = true
        })
    }
    
    fileprivate func clearTextView() -> Void {
        resultTextView.text = ""
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        rotateForLabel()
    }
    
    func rotateForLabel() -> Void {
        let app = UIApplication.shared
        
        if (app.statusBarOrientation.isPortrait) {
            startBtn.setTitle("Portrait Capture", for: UIControlState())
        } else {
            startBtn.setTitle("Landscape Capture", for: UIControlState())
        }
    }
    
}


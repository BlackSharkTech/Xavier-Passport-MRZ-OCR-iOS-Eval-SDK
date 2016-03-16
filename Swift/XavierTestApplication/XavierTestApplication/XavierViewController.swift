//
//  XavierViewController.swift
//  Paging_Swift
//
//  Copyright (c) 2015 SimonComputing. All rights reserved.
//

import UIKit
import Foundation

class XavierViewController: UIViewController, SCIXavierClientProtocol, NSXMLParserDelegate, UIScrollViewDelegate {
    private var xavierVC:SCIXavierViewController?
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func start(sender: AnyObject) {
        self.clearTextView()
        let app = UIApplication.sharedApplication()
        
        if (app.statusBarOrientation.isPortrait) {
            self.startXavier()
        } else {
            self.startXavierLandscape()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.viewController = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        rotateForLabel()
    }
    
    @objc func onRawMrz(rawMrz: String!) -> Void {
        print("\n=====> onParsedXmlFromlMrz() - \(rawMrz)")
        self.insertToTextView("Raw MRZ:\n")
        self.insertToTextView("========\n")
        
        self.insertToTextView(rawMrz)
        self.insertToTextView("\n")
    }
    
    @objc func onParsedXmlFromlMrz(parsedXmFromlMrz: String!) -> Void {
        print("\n=====> onParsedXmlFromlMrz() - \(parsedXmFromlMrz)")
        
        self.insertToTextView("XML from MRZ:\n")
        self.insertToTextView("===========\n")
        self.insertToTextView(parsedXmFromlMrz)
        self.insertToTextView("\n")
    }
    
    @objc func onMetrics(metrics: SCIMetrics!) -> Void{
        print("\n=====> onMetrics()")
        self.insertToTextView("Metrics:\n")
        self.insertToTextView("======\n")

        self.insertToTextView("Total OCR time: \(metrics.endOfWidget - metrics.startOfWidget)")

        self.insertToTextView(" (secs)\n")
        
        self.insertToTextView("Number of MRZ candidates found: \(metrics.numberOfCandidates)")
        self.insertToTextView("\n")
        
        self.insertToTextView("Number of scans: \(metrics.numberOfCandidates)")
        self.insertToTextView("\n")
        
        self.insertToTextView("Image analysis average duration: \(metrics.imageAnalysis)")
        self.insertToTextView(" (secs)\n")
        self.insertToTextView("\n")
    }
    
    @objc func onMrzCaptureCompleted() {
        print("\n=====> onMrzCaptureCompleted()")
    }
    
    @objc func onError(errorMessage: String!) {
        print("\n=====> onError() - \(errorMessage)")
        self.insertToTextView("Error:\n")
        self.insertToTextView("======\n")
        
        self.insertToTextView(errorMessage)
    }
    
    func startXavier() -> Void {
        xavierVC = SCIXavierViewController(true, andLicenseEmail: "test@hotmail.com", andLicenseKey: "E12345678")
        xavierVC?._clientProtocol = self
        self.presentViewController(xavierVC!, animated: false, completion: {() -> Void in print("Xavier is started")})
    }
    
    func startXavierLandscape() -> Void {
        xavierVC = SCIXavierViewController(false, andLicenseEmail: "test@hotmail.com", andLicenseKey: "E12345678")
        xavierVC?._clientProtocol = self
        self.presentViewController(xavierVC!, animated: false, completion: {() -> Void in print("Xavier is started")})
    }
    
    private func insertToTextView(insertingString:NSString!) -> Void {
        dispatch_async(dispatch_get_main_queue(), {
            var range:NSRange? = self.resultTextView!.selectedRange
            var currentString = self.resultTextView!.text as NSString
            currentString = currentString.substringToIndex((range?.location)!)
            
            self.resultTextView!.scrollEnabled = true
            self.resultTextView!.text = (currentString as String) + (insertingString as String)
            range?.location += insertingString.length
            self.resultTextView!.selectedRange = range!
            self.resultTextView!.scrollEnabled = true
        })
    }
    
    private func clearTextView() -> Void {
        resultTextView.text = ""
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        rotateForLabel()
    }
    
    func rotateForLabel() -> Void {
        let app = UIApplication.sharedApplication()
        
        if (app.statusBarOrientation.isPortrait) {
            startBtn.setTitle("Portrait Capture", forState: UIControlState.Normal)
        } else {
            startBtn.setTitle("Landscape Capture", forState: UIControlState.Normal)
        }
    }
    
}
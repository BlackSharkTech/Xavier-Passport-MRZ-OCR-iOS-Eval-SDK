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
    private var isGun:Bool?
    private var reImage:UIImage?
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
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
        
        var format = NSPropertyListFormat.XMLFormat_v1_0 //format of the property list
        var plistData:[String:AnyObject] = [:]  //our data
        let plistPath:String? = NSBundle.mainBundle().pathForResource("Xavier", ofType: "plist")! //the path of the data
        let plistXML = NSFileManager.defaultManager().contentsAtPath(plistPath!)! //the data in XML format
        do{ //convert the data to a dictionary and handle errors.
            plistData = try NSPropertyListSerialization.propertyListWithData(plistXML,options: .MutableContainersAndLeaves,format: &format)as! [String:AnyObject]
            
            let target = plistData["target capture"] as! String
            
            if(target == "gun serial") {
                isGun = true
            } else {
                isGun = false
            }
        }
        catch{ // error condition
            print("Error reading plist: \(error), format: \(format)")
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        rotateForLabel()
    }
    
    @objc func onRawMrz(rawMrz: String!) -> Void {
        if(isGun == false) {
            print("\n=====> onRawMrz() - \(rawMrz)")
            self.insertToTextView("Raw MRZ:\n")
        } else {
            print("\n=====>  onRawSerial- \(rawMrz)")
            self.insertToTextView("Raw Serial No:\n")
        }
        
        self.insertToTextView("========\n")
        
        self.insertToTextView(rawMrz)
        self.insertToTextView("\n")
    }
    
    @objc func onParsedXmlFromlMrz(parsedXmFromlMrz: String!) -> Void {
//        if(isGun == false) {
//            print("\n=====> onParsedXmlFromlMrz() - \(parsedXmFromlMrz)")
//            
//            self.insertToTextView("XML from MRZ:\n")
//            self.insertToTextView("===========\n")
//            self.insertToTextView(parsedXmFromlMrz)
//        } else {
//            print("\n=====> onParsedFromSerial() - \(parsedXmFromlMrz)")
//            
//            self.insertToTextView("\n")
//        }
//
//        self.insertToTextView("\n")
    }
    
    @objc func onMetrics(metrics: SCIMetrics!) -> Void{
        print("\n=====> onMetrics()")
//        self.insertToTextView("Metrics:\n")
//        self.insertToTextView("======\n")
//
//        self.insertToTextView("Total OCR time: \(metrics.endOfWidget - metrics.startOfWidget)")
//
//        self.insertToTextView(" (secs)\n")
//        
//        self.insertToTextView("Number of MRZ candidates found: \(metrics.numberOfCandidates)")
//        self.insertToTextView("\n")
//        
//        self.insertToTextView("Number of scans: \(metrics.numberOfCandidates)")
//        self.insertToTextView("\n")
//        
//        self.insertToTextView("Image analysis average duration: \(metrics.imageAnalysis)")
//        self.insertToTextView(" (secs)\n")
//        self.insertToTextView("\n")
    }
    
    @objc func onMrzCaptureCompleted() {
        print("\n=====> onCaptureCompleted()")
    }
    
    @objc func onError(errorMessage: String!) {
        print("\n=====> onError() - \(errorMessage)")
//        self.insertToTextView("Error:\n")
//        self.insertToTextView("======\n")
//        
//        self.insertToTextView(errorMessage)
    }
    
    @objc func onClose() {
        print("\n=====> onClose()")
    }
    
    @objc func onCapturedImage(image: UIImage!) {
        print("\n======> onCapturedImage")
        dispatch_async(dispatch_get_main_queue(), {
            
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.imageView.image = image
        })
    }
    
    func startXavier() -> Void {
        xavierVC = SCIXavierViewController(true)
        xavierVC?._clientProtocol = self
        self.presentViewController(xavierVC!, animated: false, completion: {() -> Void in print("Xavier is started")})
    }
    
    func startXavierLandscape() -> Void {
        xavierVC = SCIXavierViewController(false)
        xavierVC?._clientProtocol = self
        self.presentViewController(xavierVC!, animated: false, completion: {() -> Void in print("Xavier is started")})
    }
    
    private func insertToTextView(insertingString:NSString!) -> Void {
        dispatch_async(dispatch_get_main_queue(), {
            var range:NSRange? = self.resultTextView!.selectedRange
            
            self.resultTextView.textAlignment = .Center
            self.resultTextView.font = UIFont(name: (self.resultTextView?.font?.fontName)!, size: 24)
            
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
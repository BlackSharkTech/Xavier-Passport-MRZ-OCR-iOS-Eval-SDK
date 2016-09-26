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
    fileprivate var isGun:Bool?
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
        
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
        var plistData:[String:AnyObject] = [:]  //our data
        let plistPath:String? = Bundle.main.path(forResource: "Xavier", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)! //the data in XML format
        do{ //convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML,options: .mutableContainersAndLeaves,format: &format)as! [String:AnyObject]
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        rotateForLabel()
    }
    
    @objc func onRawMrz(_ rawMrz: String!) -> Void {
        if(isGun == false) {
            print("\n=====> onRawMrz() - \(rawMrz)")
            self.insertToTextView("Raw MRZ:\n")
        } else {
            print("\n=====>  onRawSerial- \(rawMrz)")
            self.insertToTextView("Raw Serial No:\n")
        }
        
        self.insertToTextView("========\n")
        
        self.insertToTextView(rawMrz as NSString!)
        self.insertToTextView("\n")
    }
    
    @objc func onParsedXmlFromlMrz(_ parsedXmFromlMrz: String!) -> Void {
        if(isGun == false) {
            print("\n=====> onParsedXmlFromlMrz() - \(parsedXmFromlMrz)")
            
            self.insertToTextView("XML from MRZ:\n")
            self.insertToTextView("===========\n")
            self.insertToTextView(parsedXmFromlMrz as NSString!)
        } else {
            print("\n=====> onParsedFromSerial() - \(parsedXmFromlMrz)")
            
            self.insertToTextView("\n")
        }

        self.insertToTextView("\n")
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
            self.resultTextView.font = UIFont(name: (self.resultTextView?.font?.fontName)!, size: 12)
            
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

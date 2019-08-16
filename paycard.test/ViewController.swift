//
//  ViewController.swift
//  paycard.test
//
//  Created by jamie yew on 31/07/2019.
//  Copyright © 2019 mal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardRecognizerDelegate {
    
    @IBOutlet weak var camera: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    
    var recognizer: CardRecognizer!
    var startCountdown: Bool! = false
    var timer: Int! = 5
    var viewTest: UIView!
    var holoDetected: Bool! = false
    var blockDetected: Bool! = false
    var patternDetected: Bool! = false
    var isTest: Bool! = true
    var isProcessing: Bool! = false
    var start: CFAbsoluteTime!
    
    enum Api:Int{
        case Hologram = 1
        case Block
        case Pattern
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        recognizer = CardRecognizer(delegate: self, container: camera, frameColor: UIColor.green)
//        self.recognizer.frameImageView.isHidden = true;
//        self.recognizer.edgesWrapperView?.isHidden = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recognizer.startCamera()
        start = CFAbsoluteTimeGetCurrent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recognizer.stopCamera()
    }
    
    func getCroppedImage(image : UIImage, completion : @escaping (UIImage) -> ()){
        
        var final = UIImage()
        
        DispatchQueue.main.async {
            
            final = image.resizeImage(targetSize: self.view?.frame.size ?? CGSize.zero)
            let cameraFrame = self.camera.frame
            final = final.croppedInRect(rect: CGRect(x: self.recognizer.frameImageView.frame.origin.x + 15, y: cameraFrame.origin.y - 12, width: self.recognizer.frameImageView.frame.size.width, height: cameraFrame.size.height + 2)) ?? image
            print("\(final.size)")
            completion(final)
        }
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }

    //Mark - Delegates
    func didRecognize(_ result: Bool, with buffer: CMSampleBuffer) {
        let time = Int(CFAbsoluteTimeGetCurrent() - start)
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)!
        let ciimage = CIImage(cvPixelBuffer: pixelBuffer)
        let scaledImage = ciimage.oriented(forExifOrientation: 1)
        let image : UIImage = self.convert(cmage: scaledImage)
        
        if(!holoDetected && !blockDetected){
//            time % 2 == 0 &&
            if(!isProcessing){
                isProcessing = true
                sendImage(image: image, apiType: Api.Hologram.rawValue)
            }
        } else if (holoDetected && !blockDetected) {
            
//            DispatchQueue.main.async {
//                self.recognizer.frameImageView.isHidden = false;
//                self.recognizer.edgesWrapperView?.isHidden = false;
//            }
            
            if(result){
                if(timer > 0){
                    print("Hold Still")
                    timer -= 1
                    print(timer)
                } else {
                    print("Capture")
                    if(viewTest == nil){
                        viewTest = recognizer.frameImageView
                    }
                    let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)!
                    let ciimage = CIImage(cvPixelBuffer: pixelBuffer)
                    let scaledImage = ciimage.oriented(forExifOrientation: 1)
                    let image = UIImage(ciImage: scaledImage)
                    
                    DispatchQueue.main.async {
                        self.imageView.isHidden = false
                        self.imageView.image = image
                    }
                    
                    getCroppedImage(image: image) { (finalImage) in
                        DispatchQueue.main.async {
                            self.recognizer.stopCamera()
                            self.camera.isHidden = true
                            self.iv2.isHidden = false
//                            self.iv2.image = finalImage
                            
                            if(!self.isProcessing){
                                self.isProcessing = true
                                self.sendImage(image: finalImage, apiType: Api.Block.rawValue)
                            }

                            print("Capture")
                        }
                    }
                    
                }
            } else {
                timer = 5
//                print("False \(String(describing: timer))")
            }
        } else {
            print("Finish")
        }
    }
    
    func sendImage(image: UIImage??, apiType: Int!){
        //create the url with URL
        var url: URL!
        let uuid: String? = UIDevice.current.identifierForVendor?.uuidString
    
        let base64 = image??.jpegData(compressionQuality: 1)?.base64EncodedString(options: .lineLength64Characters)
        let parameters: [String: String] = ["data": base64 ?? "", "uuid":uuid ?? ""]
//        print(parameters)
        
        if(apiType == Api.Hologram.rawValue && !holoDetected){
            url = URL(string: "http://192.168.0.165:5000/webEKYC/hologramCheck")! //change the url
        } else if(apiType == Api.Block.rawValue){
            url = URL(string: "http://192.168.0.165:5000/webEKYC/getBlocks")! //change the url
        } else if(apiType == Api.Pattern.rawValue){
            url = URL(string: "http://192.168.0.165:5000/webEKYC/patternMatch")! //change the url
        }
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            self.isProcessing = false
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: (\(httpResponse.statusCode))")
                let status = httpResponse.statusCode
                if(status == 200){
                    do {
                        //create json object from data
                        if let json: [[String: Any]] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                            self.processBody(json: json, apiType: apiType)
                        } else {
                            print("Cannot parse json")
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                } else {
                    if(error != nil){
                        print(error!)
                    }
                }
            }
        })
        task.resume()
    }
    
    func processBody(json: [[String:Any]]!, apiType:Int!){
        if(apiType == Api.Hologram.rawValue && !self.holoDetected){
            print("Hologram \(String(describing: json))")
            
            if let holo: Bool = json[0]["hologramCheck"] as? Bool {
                if(holo == true){
                    DispatchQueue.main.async {
                        self.holoDetected = true
                        self.recognizer.frameImageView.isHidden = false;
                        self.recognizer.edgesWrapperView?.isHidden = false;
                    }
                }
            }
        } else if (apiType == Api.Block.rawValue) {
            print("Block \(String(describing: json))")
            self.blockDetected = true
            
            for i in 0..<json.count{
                if(i == 0){
                    if let base64: String = json[i]["face"] as? String{
                        
                        let decodedData = Data(base64Encoded: base64)!
                        let image = UIImage(data: decodedData)
//                        let image = String(data: decodedData, encoding: .utf8)!
                        print(decodedData.count)
                        DispatchQueue.main.async {
                            self.iv2.image = image
                        }
                    }
                } else {
                    if let blockClass: String = json[i]["class"] as? String{
                        print("block class \(blockClass)")
                    }
                    if let base64: String = json[i]["image"] as? String{
                        
                        let decodedData = Data(base64Encoded: base64)!
                        let image = UIImage(data: decodedData)
//                        let image = String(data: decodedData, encoding: .utf8)!
                        print(decodedData.count)
                    }
                }
            }
        } else if (apiType == Api.Pattern.rawValue){
            if let pattern: Bool = json[0]["patternMatch"] as? Bool {
                if(pattern == true){
                    print("Pattern Match")
                }
            }
        }
    }
}

extension UIImage{
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    
    func croppedInRect(rect: CGRect) -> UIImage? {
        func rad(_ degree: Double) -> CGFloat {
            return CGFloat(degree / 180.0 * .pi)
        }
        
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -self.size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -self.size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -self.size.width, y: -self.size.height)
        default:
            rectTransform = .identity
        }
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
        
        var cgImage = self.cgImage
        
        if cgImage == nil{
            
            let ciContext = CIContext()
            if let ciImage = self.ciImage{
                cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
            }
        }
        
        if let imageRef = cgImage?.cropping(to: rect.applying(rectTransform)){
            let result = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
            return result
        }
        
        
        return nil
        
    }
    
    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            else {
                return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}


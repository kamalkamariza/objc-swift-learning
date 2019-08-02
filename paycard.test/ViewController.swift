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
    
    var recognizer: CardRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        recognizer = CardRecognizer(delegate: self, container: camera, frameColor: UIColor.green)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recognizer.startCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recognizer.stopCamera()
    }

    //Mark - Delegates
    func didRecognize(_ result: Bool) {
        if(result){
            print("True")
        } else {
            print("False")
        }
    }
}


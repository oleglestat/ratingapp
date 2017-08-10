//
//  PhotoSearchViewController.swift
//  WN8
//
//  Created by Oleg Chmut on 10/8/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import UIKit
import TesseractOCR

class PhotoSearchViewController: UIViewController, G8TesseractDelegate {
  
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let tesseract = G8Tesseract(language: "eng") {
      tesseract.delegate = self
      tesseract.charWhitelist = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-_[]"
      tesseract.pageSegmentationMode = .auto
      tesseract.image = UIImage(named: "trainingRoom")?.g8_blackAndWhite()
      tesseract.recognize()
      
      textView.text = tesseract.recognizedText
    }
  }
  
  func progressImageRecognition(for tesseract: G8Tesseract!) {
    print("Recognition Progress \(tesseract.progress) %")
  }
}

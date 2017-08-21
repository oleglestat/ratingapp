//
//  PhotoSearchViewController.swift
//  WN8
//
//  Created by Oleg Chmut on 10/8/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import UIKit
import GPUImage

class PhotoSearchViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    filterImage(image: UIImage(named: "random"))
  }
  
  func filterImage(image: UIImage?){
    var endImage: UIImage!
    if let imageToProcess = image {
      let saturation = SaturationAdjustment()
      saturation.saturation = 0.0
      let trashFilter = AverageLuminanceThreshold()
      trashFilter.thresholdMultiplier = 0.85
      let invertFilter = ColorInversion()
      endImage = imageToProcess.filterWithPipeline{input, output in
        input --> saturation --> invertFilter --> trashFilter --> output
      }
    }
    let pngImage = UIImagePNGRepresentation(endImage)!
    do {
      let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
      let fileURL = URL(string:"test.png", relativeTo:documentsDir)!
      try pngImage.write(to:fileURL, options:.atomic)
      print(documentsDir)
    } catch {
      print("Couldn't write to file with error: \(error)")
    }
  }
}

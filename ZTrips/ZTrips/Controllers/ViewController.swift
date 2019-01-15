//
//  ViewController.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 02/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    DataDownloader().download { (places) in
      print(places!)
    }
  }
}


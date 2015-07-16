//
//  ViewController.swift
//  BWWalkthroughExample
//
//  Created by Yari D'areglia on 17/09/14.
//  Copyright (c) 2014 Yari D'areglia. All rights reserved.
//

import UIKit

extension ViewController: BWWalkthroughViewControllerDelegate {
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        println("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

class ViewController: UIViewController {
    
    let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
    let pattern = "walk"
    let numberOfViewControllers = 10
    
    var vcs = [UIViewController]()
    var walkthrough: BWWalkthroughViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkthrough = stb.instantiateViewControllerWithIdentifier(pattern) as! BWWalkthroughViewController
        walkthrough.delegate = self
    }
    
    @IBAction func showWalkthrough(){
        for idx in 0..<numberOfViewControllers {
            vcs.append(stb.instantiateViewControllerWithIdentifier(pattern + "\(idx)") as! UIViewController)
        }
        
        for idx in 1..<numberOfViewControllers {
            walkthrough.addViewController(vcs[idx])
        }
        walkthrough.addViewController(vcs[0])
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
}


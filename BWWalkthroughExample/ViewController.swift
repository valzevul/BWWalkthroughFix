import UIKit

extension ViewController: BWWalkthroughViewControllerDelegate {
    
    // MARK: - Walkthrough delegate
    
    func walkthroughPrevButtonPressed() {
        if walkthrough.currentPage < 2 {
            return
        }
        
        walkthrough.loadAtIndex(walkthrough.currentPage - 2, vc: vcs[walkthrough.currentPage - 2])
        
        if walkthrough.currentPage + 2 >= walkthrough.numberOfPages {
            return
        }
        
        walkthrough.controllers[walkthrough.currentPage + 2]?.view.removeFromSuperview()
        walkthrough.controllers[walkthrough.currentPage + 2] = nil
    }
    
    func walkthroughNextButtonPressed() {
        if walkthrough.currentPage + 2 >= walkthrough.numberOfPages {
            return
        }
        walkthrough.loadAtIndex(walkthrough.currentPage + 2, vc: vcs[walkthrough.currentPage + 2])
        
        if walkthrough.currentPage < 2 {
            return
        }
        
        walkthrough.controllers[walkthrough.currentPage - 2]?.view.removeFromSuperview()
        walkthrough.controllers[walkthrough.currentPage - 2] = nil
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

class ViewController: UIViewController {
    
    let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
    let pattern = "walk"
    let numberOfViewControllers = 15
    
    var vcs = [UIViewController]()
    var walkthrough: BWWalkthroughViewController! {
        didSet {
            walkthrough.numberOfPages = numberOfViewControllers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkthrough = stb.instantiateViewControllerWithIdentifier(pattern) as! BWWalkthroughViewController
        walkthrough.delegate = self
    }
    
    func loadVisiblePages() {
        walkthrough.loadAtIndex(0, vc: vcs[0])
        walkthrough.loadAtIndex(1, vc: vcs[1])
        walkthrough.loadAtIndex(2, vc: vcs[2])
    }
    
    @IBAction func showWalkthrough(){
        vcs = []
        walkthrough.controllers = []
        
        for idx in 0..<numberOfViewControllers {
            vcs.append(stb.instantiateViewControllerWithIdentifier(pattern + "\(idx)") as! UIViewController)
        }
        
        for _ in 0..<numberOfViewControllers {
            walkthrough.controllers.append(nil)
        }
        
        loadVisiblePages()
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
}


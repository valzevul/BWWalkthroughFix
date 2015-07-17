import UIKit

extension ViewController: BWWalkthroughViewControllerDelegate {
    
    // MARK: - Walkthrough delegate
    
    func walkthroughPrevButtonPressed() {
        if walkthrough.currentPage < 2 {
            return
        }
        
        walkthrough.loadAtIndex(walkthrough.currentPage - 2, vc: instantiateVC(walkthrough.currentPage - 2))
        
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
        walkthrough.loadAtIndex(walkthrough.currentPage + 2, vc: instantiateVC(walkthrough.currentPage + 2))
        
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
        walkthrough.loadAtIndex(0, vc: instantiateVC(0))
        walkthrough.loadAtIndex(1, vc: instantiateVC(1))
        walkthrough.loadAtIndex(2, vc: instantiateVC(2))
    }
    
    func instantiateVC(idx: Int) -> UIViewController {
        return stb.instantiateViewControllerWithIdentifier(pattern + "\(idx)") as! UIViewController
    }
    
    @IBAction func showWalkthrough(){
        walkthrough.controllers = []
        
        for _ in 0..<numberOfViewControllers {
            walkthrough.controllers.append(nil)
        }
        
        loadVisiblePages()
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
}


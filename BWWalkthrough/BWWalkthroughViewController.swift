
import UIKit

@objc protocol BWWalkthroughViewControllerDelegate{
    
    @objc optional func walkthroughCloseButtonPressed()
    @objc optional func walkthroughNextButtonPressed()
    @objc optional func walkthroughPrevButtonPressed()
    @objc optional func walkthroughPageDidChange(pageNumber:Int)
}

@objc protocol BWWalkthroughPage{
    @objc func walkthroughDidScroll(position:CGFloat, offset:CGFloat)
}


@objc class BWWalkthroughViewController: UIViewController, UIScrollViewDelegate{
    
    // MARK: - Public properties -
    
    weak var delegate: BWWalkthroughViewControllerDelegate?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var nextButton: UIButton?
    @IBOutlet var prevButton: UIButton?
    @IBOutlet var closeButton: UIButton?
    
    var currentPage: Int {
        get {
            let page = Int((scrollview.contentOffset.x / view.bounds.size.width))
            return page
        }
    }

    
    // MARK: - Private properties -
    internal var numberOfPages: Int = 0
    private let scrollview: UIScrollView!
    internal var controllers: [UIViewController?] = []
    private var lastViewConstraint: NSArray?
    
    
    // MARK: - Overrides -
    
    required init(coder aDecoder: NSCoder) {
        scrollview = UIScrollView()
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.pagingEnabled = true
        controllers = Array()
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        scrollview = UIScrollView()
        controllers = Array()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollview.delegate = self
        scrollview.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.insertSubview(scrollview, atIndex: 0)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scrollview]-0-|", options:nil, metrics: nil, views: ["scrollview":scrollview]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollview]-0-|", options:nil, metrics: nil, views: ["scrollview":scrollview]))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        pageControl?.numberOfPages = controllers.count
        pageControl?.currentPage = 0
    }
    
    
    // MARK: - Internal methods -
    
    @IBAction func nextPage(){
        
        if (currentPage + 1) < controllers.count {
            delegate?.walkthroughNextButtonPressed?()
            
            var frame = scrollview.frame
            frame.origin.x = CGFloat(currentPage + 1) * frame.size.width
            scrollview.scrollRectToVisible(frame, animated: true)
        }
    }
    
    @IBAction func prevPage(){
        
        if currentPage > 0 {
            delegate?.walkthroughPrevButtonPressed?()
            
            var frame = scrollview.frame
            frame.origin.x = CGFloat(currentPage - 1) * frame.size.width
            scrollview.scrollRectToVisible(frame, animated: true)
        }
    }

    @IBAction func close(sender: AnyObject){
        delegate?.walkthroughCloseButtonPressed?()
    }

    func insertVC(vcn: UIViewController?, idx: Int) { // New method to move VCs
        if let vc = vcn {
            controllers[idx] = vc // Choose position
            scrollview.addSubview(vc.view)
            
            let bounds = self.view.bounds // Create bounds instead of constraints
            vc.view.frame = CGRectMake(CGFloat(idx) * bounds.width, 0, bounds.width, bounds.height)
            vc.view.setTranslatesAutoresizingMaskIntoConstraints(true)
            vc.view.autoresizingMask = UIViewAutoresizing.allZeros // Resize
            
            scrollview.contentSize = CGSizeMake(CGFloat(controllers.count) * bounds.width, bounds.height)
        }
    }
    
    func addViewController(vcn: UIViewController?) { // For compatability with old versions
        insertVC(vcn, idx: controllers.count)
    }
    
    func loadAtIndex(idx: Int, vc: UIViewController) { // To update the screen
        insertVC(vc, idx: idx)
        updateUI()
    }

    
    private func updateUI(){
        pageControl?.currentPage = currentPage
        delegate?.walkthroughPageDidChange?(currentPage)
        
        if currentPage == controllers.count - 1 {
            nextButton?.hidden = true
        } else {
            nextButton?.hidden = false
        }
        
        if currentPage == 0 {
            prevButton?.hidden = true
        } else {
            prevButton?.hidden = false
        }
    }
    
    // MARK: - Scrollview Delegate -
    
    func scrollViewDidScroll(sv: UIScrollView) {
        for var i = 0; i < controllers.count; i++ {
            if let vc = controllers[i] as? BWWalkthroughPage{
                let mx = ((scrollview.contentOffset.x + view.bounds.size.width) - (view.bounds.size.width * CGFloat(i))) / view.bounds.size.width
                if (mx < 2 && mx > -2.0) {
                    vc.walkthroughDidScroll(scrollview.contentOffset.x, offset: mx)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateUI()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        updateUI()
    }
    
    
    /* WIP */
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("CHANGE")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("SIZE")
    }
}

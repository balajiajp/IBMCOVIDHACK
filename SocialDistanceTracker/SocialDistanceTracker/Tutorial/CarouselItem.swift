import Foundation
import UIKit

@IBDesignable
class CarouselItem: UIView {
    static let CAROUSEL_ITEM_NIB = "CarouselItem"
    
    @IBOutlet var vwContent: UIView!
    @IBOutlet var vwBackground: UIView!

    @IBOutlet var headingTxt: UILabel!
    @IBOutlet var descriptionTxt: UILabel!

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    convenience init(heading: String? = "", descriptiontxt: String? = "", background: UIColor? = .red) {
        self.init()
        headingTxt.text = heading
        descriptionTxt.text = descriptiontxt
        
        vwBackground.backgroundColor = background
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(CarouselItem.CAROUSEL_ITEM_NIB, owner: self, options: nil)
        vwContent.frame = bounds
        vwContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(vwContent)
    }
}

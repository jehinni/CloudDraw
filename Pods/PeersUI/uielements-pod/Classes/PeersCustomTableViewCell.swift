import UIKit

public enum PeersTableViewCellType {
    case normal
    case inactive
    case playing
}

extension PeersTableViewCellType {
    
    var backgroundColor: UIColor {
        switch self {
        case .normal, .inactive:
            return UIColor.white
        case .playing:
            return PeersColors.rosePink.color
        }
    }
    
    var alpha: CGFloat {
        switch self {
        case .normal, .playing:
            return 1
        case .inactive:
            return 0.5
        }
    }
}

open class PeersCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak open var cellContainer: UIView!
    @IBOutlet weak open var playerImage: UIImageView!
    @IBOutlet weak open var playerName: UILabel!
    @IBOutlet weak open var playerPoints: UILabel!
    @IBOutlet weak open var playerRating: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    open var cellType: PeersTableViewCellType = .normal {
        didSet {
            setupUI()
        }
    }
    
    override open func layoutSubviews() {
        setupUI()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.cellContainer.layer.cornerRadius = 6
        self.backgroundColor = UIColor.clear
        self.cellContainer.backgroundColor = cellType.backgroundColor
        self.cellContainer.alpha = cellType.alpha
        
        playerRating.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 22)
        playerRating.tintColor = PeersColors.darkBlue.color
        
        playerName.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 20)
        playerName.tintColor = PeersColors.darkBlue.color
        
        playerPoints.font = PeersFonts.BarlowSemiCondensed.semiBold.font(size: 22)
        playerPoints.tintColor = PeersColors.darkBlue.color
        
        playerImage.layer.cornerRadius = playerImage.frame.width / 2
    }
}

////
////  PeersTabelViewCell.swift
////  uielements-pod
////
////  Created by Manuela Müller on 09.06.19.
////
//
//public enum PeersTableViewCellType {
//    case normal
//    case inactive
//    case playing
//}
//
//extension PeersTableViewCellType {
//
//    var backgroundColor: UIColor {
//        switch self {
//        case .normal:
//            return UIColor.white
//        case .inactive:
//            return PeersColors.lightGrey.color
//        case .playing:
//            return PeersColors.lightPink.color
//        }
//    }
//}
//
//@IBDesignable
//open class PeersTableViewCell: UITableViewCell {
//
//
//    @IBOutlet weak var playerRating: UILabel!
//    @IBOutlet weak var playerImage: UIImageView!
//    @IBOutlet weak var playerName: UILabel!
//    @IBOutlet weak var playerPoints: UILabel!
//
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    open var cellType: PeersTableViewCellType = .normal {
//        didSet {
//            setupUI(cellType)
//        }
//    }
//
//    override open func layoutSubviews() {
//        setupUI(cellType)
//    }
//
//    private func setupUI(_ type: PeersTableViewCellType) {
//        self.layer.cornerRadius = 10
//        self.backgroundColor = cellType.backgroundColor
//        playerRating.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 22)
//        playerRating.tintColor = PeersColors.darkBlue.color
//
//        playerName.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 20)
//        playerName.tintColor = PeersColors.darkBlue.color
//
//        playerPoints.font = PeersFonts.BarlowSemiCondensed.semiBold.font(size: 22)
//        playerPoints.tintColor = PeersColors.darkBlue.color
//
//        playerImage.layer.cornerRadius = playerImage.frame.width / 2
//        playerImage.image = PeersImages.profile.image
//
//
//    }
//
//}
//
//open class TableViewController: UITableViewController {
//
//
//}

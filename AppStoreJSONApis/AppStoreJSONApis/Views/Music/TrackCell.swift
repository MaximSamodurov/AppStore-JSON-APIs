
import UIKit

class TrackCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
    let subTitleLabel = UILabel(text: "Subtitle Label", font: .systemFont(ofSize: 17), numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage(imageLiteralResourceName: "star")
        imageView.constrainWidth(constant: 80)
        
        let verticalStackView = VerticalStackView(arrangedSubViews: [
        nameLabel,
        subTitleLabel
        ],spacing: 4)
        
        let stackView = UIStackView(arrangedSubviews: [
        imageView, verticalStackView
        ], customSpacing: 16)
        
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        //центрует не только по ширине но и высоте
        stackView.alignment = .center
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

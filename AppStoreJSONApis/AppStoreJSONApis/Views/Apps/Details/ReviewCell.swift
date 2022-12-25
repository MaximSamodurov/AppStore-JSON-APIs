
import UIKit

class ReviewCell: UICollectionViewCell {
    
    //create subViewElements
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    
    let starsStackView: UIStackView = {
        var arrangedSubViews = [UIView]()
        (0..<5).forEach({ (_) in
            let image = UIImage(named: "star")
            let imageView = UIImageView(image: image!)
            //shrink star image to the right size
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            arrangedSubViews.append(imageView)
        })
        // add blank UIView() for right size of stars
        arrangedSubViews.append(UIView())
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        return stackView
        
    }()
    
    let bodyLabel = UILabel(text: "Review Body\nReview Body\nReview Body\nReview Body\nReview Body", font: .systemFont(ofSize: 18), numberOfLines: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubViews: [
            UIStackView(arrangedSubviews: [
                titleLabel, authorLabel
            ], customSpacing: 8),
            starsStackView,
            bodyLabel
        ], spacing: 12)
        // set priority to avoid truncating titleLabel
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        addSubview(stackView)
//        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

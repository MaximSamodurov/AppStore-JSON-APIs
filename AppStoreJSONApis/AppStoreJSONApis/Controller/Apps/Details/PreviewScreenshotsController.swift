
import UIKit

class PreviewScreenshotsController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var app: Result? {
        didSet {
            collectionView.reloadData()
        }
    }

    class ScreenshotCell: UICollectionViewCell {
        
        let imageView = UIImageView(cornerRadius: 12)
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(imageView)
            imageView.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // downcasting for using ScreenshotCell like one of the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotCell
        let screenShotUrl = self.app?.screenshotUrls[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: screenShotUrl ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 250, height: view.frame.height)
    }
}


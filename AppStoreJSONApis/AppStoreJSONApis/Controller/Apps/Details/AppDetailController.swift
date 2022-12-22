
import UIKit


class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var appId: String! {
        didSet {
            print("Here is appId", appId!)
            // fetch data
            let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, err) in
                //get data back
                let app = result?.results.first
                self.app = app
                //reload collectionView
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    // set the local instance of our data
    var app: Result?
    
    let detailsCellId = "detailsCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailsCellId)
        navigationItem.largeTitleDisplayMode = .never // made small titles 
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellId, for: indexPath) as! AppDetailCell
        cell.nameLabel.text = app?.trackName
        cell.releaseNotesLabel.text = app?.releaseNotes
        cell.appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
        cell.priceButton.setTitle(app?.formattedPrice, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //calculate the size for our cell
        let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        // to proper layout without any cut the text
        dummyCell.releaseNotesLabel.text = app?.releaseNotes
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}


import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var apps = [FeedResult]()

    let cellId = "cellId"
    
    var appGroup: AppGroup?
    
//    let closeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(imageLiteralResourceName: "close_button"), for: .normal)
//        button.tintColor = .darkGray
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        return button
//    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    
    // во втором экране переход на третий экран по клику на любое из приложений из списка
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = self.apps[indexPath.item].id
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // когда разворачивается второй экран что что бы была кнопка
//        if mode == .fullscreen {
//            setupCloseButton()
//        } else if mode == .small {
//            collectionView.isScrollEnabled = false
        //        }

        collectionView.backgroundColor = .white
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
//    override var prefersStatusBarHidden: Bool { return true }
    
//    func setupCloseButton() {
//        view.addSubview(closeButton)
//        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
//    }
    
    
    // для отступов
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen {
            return .init(top: 40, left: 24, bottom: 12, right: 24)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // что бы получить на втором экране полный список всех приложений а не только 4
        if mode == .fullscreen {
            return apps.count
        }
        return min(4, apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        cell.app = self.apps[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 74
        
        // размеры ячеек на двух экранах
        if mode == .fullscreen {
            return .init(width: view.frame.width - 48, height: height)
        } else {
            return .init(width: view.frame.width, height: height)
        }
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    fileprivate let mode: Mode
    
    
    // для того что бы close_button не появлялся на первом экране
    enum Mode {
        case small, fullscreen
    }
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

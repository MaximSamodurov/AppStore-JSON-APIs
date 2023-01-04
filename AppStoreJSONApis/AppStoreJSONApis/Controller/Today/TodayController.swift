
import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var items = [TodayItem]()
    
    // add animated spiner before finished fetched data
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    // если tabBar не перерисовывается после закрытия fullscreen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        fetchData()
        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        var topPaidApps: AppGroup?
        var topFreeApps: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopPaidApps { ( appGroup, err ) in
            if let err = err {
                print(err)
            }
            topPaidApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps { ( appGroup, err ) in
            if let err = err {
                print(err)
            }
            topFreeApps = appGroup
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.notify(queue: .main) {
            print("Finished Fetching")
            self.activityIndicatorView.stopAnimating()
            self.items = [
                TodayItem.init(category: "Life Hack", title: "Utilizing Your Time", image: UIImage(imageLiteralResourceName: "garden"), description: "All The Tools and apps you need to intelegently organize your life right way.", backgroundColor: .white, cellType: .single, apps: []),
                
                TodayItem.init(category: "Daily List", title: topPaidApps?.feed.title ?? "", image: UIImage(imageLiteralResourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topPaidApps?.feed.results ?? []),
                
                TodayItem.init(category: "Daily List", title: topFreeApps?.feed.title ?? "", image: UIImage(imageLiteralResourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topFreeApps?.feed.results ?? []),
                
                TodayItem(category: "Holidays", title: "Travel On Budget", image: UIImage(imageLiteralResourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.986785233, green: 0.9638366103, blue: 0.7270910144, alpha: 1), cellType: .single, apps: [])
            ]
            self.collectionView.reloadData()
        }
    }
    
    var appFullScreenController: AppFullScreenController!
    
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullScreen(indexPath: indexPath)
        }
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullScreenController = AppFullScreenController()
        appFullScreenController.todayItem = items[indexPath.row]
        // удаление popUp при нажатии
        appFullScreenController.dismissHandler = {
            self.handleRemoveRedView()
        }
        appFullScreenController.view.layer.cornerRadius = 16
        self.appFullScreenController = appFullScreenController
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        // что бы новый cell накладывался на уже существующий cell
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // что бы новый cell появлялся ровно на месте cell под ним
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        // to capture starting Frame of redView
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullScreenController.view!

        fullscreenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(fullscreenView)
        
        // что бы header из файла AppFullScreenController отображался
        addChild(appFullScreenController)
        
        // убираем баг с прокручиванем страницы (true в handleRemover)
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        // проверка optional что бы не было ошибок с constraint ниже
        guard let startingFrame = self.startingFrame else  { return }
        
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded() // starts animation
    }
    
    var anchoredConstraints: AnchoredConstraints?
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            // для того что бы при раскрытии убирался нижний таб бар
            self.tabBarController?.tabBar.frame.origin.y += 100
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0, 0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
        }
    }
    
    fileprivate func showSingleAppFullScreen(indexPath: IndexPath) {
        //#1
        setupSingleAppFullscreenController(indexPath)
        
        //#2 setup fullscreen on its starting position
        setupAppFullscreenStartingPosition(indexPath)
        
        //#3 begin fullscren animation
        beginAnimationAppFullscreen()
    }
    
    var startingFrame: CGRect?
    
    // удаление popUp при нажатии
    @objc func handleRemoveRedView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.appFullScreenController.tableView.scrollToRow(at: [0, 0], at: .top, animated: true)
            
            guard let startingFrame = self.startingFrame else { return }
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            // для того что бы таб бар снова появлялся
            self.tabBarController?.tabBar.frame.origin.y -= 100
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0, 0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 15
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullScreenController.view.removeFromSuperview()
            self.appFullScreenController.removeFromParent()
            // убираем баг с прокручиванем страницы (true в handleRemover)
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem =  items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        
        let collectionView = gesture.view
        
        
        var superview = collectionView?.superview
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].apps
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                return
            }
            
            superview = superview?.superview
        }
        
        
    }
    
    static let cellSize: CGFloat = 500
    
    // set from horizontal cells to verticalcells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    //setup upper bound between edge of screen and first cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}

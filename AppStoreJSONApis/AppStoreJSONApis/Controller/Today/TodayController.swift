
import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let items = [
        TodayItem.init(category: "Life Hack", title: "Utilizing Your Time", image: UIImage(imageLiteralResourceName: "garden"), description: "All The Tools and apps you need to intelegently organize your life right way.", backgroundColor: .white),
        TodayItem.init(category: "Holidays", title: "Travel On A Budget", image: UIImage(imageLiteralResourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.986785233, green: 0.9638366103, blue: 0.7270910144, alpha: 1))
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var appFullScreenController: AppFullScreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let appFullScreenController = AppFullScreenController()
        appFullScreenController.todayItem = items[indexPath.row]
        let redView = appFullScreenController.view!
        
        // удаление popUp при нажатии
        
        appFullScreenController.dismissHandler = {
            self.handleRemoveRedView()
        }
        
        redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(redView)
        
        // что бы header из файла AppFullScreenController отображался
        addChild(appFullScreenController)
        
        self.appFullScreenController = appFullScreenController
        
        // что бы новый cell накладывался на уже существующий cell
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // что бы новый cell появлялся ровно на месте cell под ним
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        // to capture starting Frame of redView
        self.startingFrame = startingFrame
        
        //translateAutoResizingMask для того что бы анимация заработала
        redView.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = redView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = redView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = redView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded() // starts animation
        
        redView.layer.cornerRadius = 16
        
        // от маленького cell до раскрытия на весь экра с анимацией
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            // для того что бы при раскрытии убирался нижний таб бар
            self.tabBarController?.tabBar.frame.origin.y += 100
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0, 0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
            
        }
    }
    
    var startingFrame: CGRect?
    
    // удаление popUp при нажатии
    @objc func handleRemoveRedView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.appFullScreenController.tableView.scrollToRow(at: [0, 0], at: .top, animated: true)
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            // для того что бы таб бар снова появлялся
            self.tabBarController?.tabBar.frame.origin.y -= 100
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0, 0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 15
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullScreenController.view.removeFromSuperview()
            self.appFullScreenController.removeFromParent()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
        cell.todayItem = items[indexPath.item]
        return cell
    }
    
    // set from horizontal cells to verticalcells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    //setup upper bound between edge of screen and first cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
}

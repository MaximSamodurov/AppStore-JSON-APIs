
import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("animated fullscreen")
        
        let appFullScreenController = AppFullScreenController()
        let redView = appFullScreenController.view!
        
        // удаление popUp при нажатии
        redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        
        view.addSubview(redView)
        
        // что бы header из файла AppFullScreenController отображался
        addChild(appFullScreenController)
        
        // что бы новый cell накладывался на уже существующий cell
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // что бы новый cell появлялся ровно на месте cell под ним
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        // to capture starting Frame of redView
        self.startingFrame = startingFrame
        
        redView.frame = startingFrame
        redView.layer.cornerRadius = 16
        
        // от маленького cell до раскрытия на весь экра с анимацией
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            redView.frame = self.view.frame
            
            // для того что бы при раскрытии убирался нижний таб бар
            self.tabBarController?.tabBar.frame.origin.y += 100
        }
        
    }
    
    var startingFrame: CGRect?
    
    // удаление popUp при нажатии
    @objc func handleRemoveRedView(gesture: UITapGestureRecognizer) {
//        gesture.view?.removeFromSuperview()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            gesture.view?.frame = self.startingFrame ?? .zero
            
            // для того что бы таб бар снова появлялся
            self.tabBarController?.tabBar.frame.origin.y -= 100

            
        }, completion: { _ in
            gesture.view?.removeFromSuperview()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
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

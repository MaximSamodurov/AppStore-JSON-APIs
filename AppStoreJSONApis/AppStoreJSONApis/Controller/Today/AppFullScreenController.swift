
import UIKit

class AppFullScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dismissHandler: (() ->())?
    var todayItem: TodayItem?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        if scrollView.contentOffset.y > 100 {
            if floatingContainer.transform == .identity {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                    let translationY = -90 - UIApplication.shared.statusBarFrame.height
                    self.floatingContainer.transform = .init(translationX: 0, y: translationY)
                }
            }
        } else {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.floatingContainer.transform = .identity
            }
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
        
    let statusBarHeight: CGFloat = {
        var heightToReturn: CGFloat = 0.0
             for window in UIApplication.shared.windows {
                 if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                     heightToReturn = height
                 }
             }
        return heightToReturn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // clipToBounds что бы cornerRadius показывался правильно
        view.clipsToBounds = true
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        // datasource что бы появилось отображение в tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        setupCloseButton()
        
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        // растянуть цвет бэкграунда
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .init(top: 0, left: 0, bottom: statusBarHeight, right: 0)
        
        setupFloatingControls()
    }
    
    
    let floatingContainer = UIView()

    @objc fileprivate func handleTap() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.floatingContainer.transform = .init(translationX: 0, y: -90)
        }
    }
    
    fileprivate func setupFloatingControls() {
//        floatingContainer.backgroundColor = .red
        // clipsToBounds - что бы после blurVisualEffect работал cornerRadius
        floatingContainer.clipsToBounds = true
        floatingContainer.layer.cornerRadius = 16
        view.addSubview(floatingContainer)
        
//        let bottomPadding = UIApplication.shared.statusBarFrame.height
        floatingContainer.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: 90))
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainer.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        // add subViews
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.constrainHeight(constant: 68)
        imageView.constrainWidth(constant: 68)
        let getButton = UIButton(title: "GET")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        
        let verticalStackView = VerticalStackView(arrangedSubViews: [
            UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
            UILabel(text: "Utilizing Your Time", font: .systemFont(ofSize: 16))
        ], spacing: 4)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,verticalStackView,
            getButton
        ], customSpacing: 16)
        
        floatingContainer.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
                                
    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "close_button"), for: .normal)
        button.tag = 1
        button.tintColor = UIColor(white: 0.4, alpha: 1)
        return button
    }()
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = AppFullScreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }
        let cell = AppFullNameDescription()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        }
        return UITableView.automaticDimension
    }
}

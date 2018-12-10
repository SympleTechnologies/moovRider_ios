//
//  LoginRootViewController.swift
//  Moov_Rider
//
//  Created by Henry Chukwu on 12/7/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// See https://github.com/xmartlabs/XLPagerTabStrip for details on pager control

class LoginRootViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet var spacerView: UIView!
    @IBOutlet var topBarHeight: NSLayoutConstraint!

    var selectedPageIndex: Int?

    fileprivate let barBackgroundColor = UIColor(red:0.19, green:0.55, blue:0.27, alpha:1)
    fileprivate var activity: UIActivityIndicatorView?

    override func viewDidLoad() {
        view.backgroundColor = barBackgroundColor

        spacerView.backgroundColor = UIColor(red:0.78, green:0.8, blue:0.82, alpha:1)
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 1, green: 0.09803921569, blue: 0.3960784314, alpha: 1)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 2.0
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.font = .systemFont(ofSize: 14)
            newCell?.label.font = .boldSystemFont(ofSize: 14)
        }
        navigationController?.navigationBar.isTranslucent = false
        super.viewDidLoad()
        // Show activity indicator
        activity = UIActivityIndicatorView()
        activity!.color = UIColor.black
        activity!.center = self.view.center
        activity!.bounds = self.view.bounds
        activity!.backgroundColor = UIColor.white
        self.view.addSubview(activity!)
        activity!.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedPageIndex == 1 {
            self.moveToViewController(at: 1, animated: false)
        }
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        activity?.stopAnimating()
        activity?.isHidden = true
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController

        return [loginVC, registerVC]
    }

}

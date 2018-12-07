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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = barBackgroundColor

        spacerView.backgroundColor = barBackgroundColor
        settings.style.buttonBarBackgroundColor = barBackgroundColor
        settings.style.buttonBarItemBackgroundColor = barBackgroundColor
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.font = .systemFont(ofSize: 14)
            newCell?.label.font = .boldSystemFont(ofSize: 14)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedPageIndex == 1 {
            self.moveToViewController(at: 1, animated: true)
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController

        return [loginVC, registerVC]
    }

}

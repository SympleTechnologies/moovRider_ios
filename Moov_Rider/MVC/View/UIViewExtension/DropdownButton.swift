//
//  DropdownButton.swift
//  Moov_Rider
//
//  Created by Henry Chukwu on 12/9/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

protocol DropdownDelegate {
    func dropdownMenuPressed(deaneryName: String)
}

class DropdownBtn: UIButton, DropdownDelegate {

    var dropView = DropdownView()
    var button = UIButton()
    var deanary = ""

    var height = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        dropView = DropdownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }

    var isOpen = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true

            NSLayoutConstraint.deactivate([self.height])
            if self.dropView.tableView.contentSize.height > 250 {
                self.height.constant = 250
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }

            NSLayoutConstraint.activate([self.height])

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false

            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }

    func dismissDropdown() {
        isOpen = false

        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: DropdownDelegate
    func dropdownMenuPressed(deaneryName: String) {
        self.setTitle(deaneryName, for: .normal)
        self.button.isEnabled = true
        self.button.alpha = 1
        self.deanary = deaneryName
        self.dismissDropdown()
    }
}

class DropdownView: UIView, UITableViewDelegate, UITableViewDataSource {

    var dropdownOptions = [String]()

    var tableView = UITableView()

    var delegate: DropdownDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.clear
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)

        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = dropdownOptions[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.dropdownMenuPressed(deaneryName: dropdownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}


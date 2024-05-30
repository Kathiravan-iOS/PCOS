//
//  ViewController.swift
//  Sidemenu
//
//  Created by Haris Madhavan on 07/11/23.
//

import UIKit

class ViewController2: UIViewController {
    var sideMenu: SideMenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = SideMenuViewController()
        addChild(sideMenu!)
        view.addSubview(sideMenu!.view)
        sideMenu!.didMove(toParent: self)
    
        sideMenu!.view.frame = CGRect(x: -view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeSideMenu))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func menuAction(_ sender: Any) {
        openSideMenu()
    }
    
    @objc func openSideMenu() {
        UIView.animate(withDuration: 0.5) {
            self.sideMenu?.view.frame.origin.x = 0
        }
    }
    
    @objc func closeSideMenu() {
        UIView.animate(withDuration: 0.5) {
            self.sideMenu?.view.frame.origin.x = -self.view.frame.size.width
        }
    }
    
}

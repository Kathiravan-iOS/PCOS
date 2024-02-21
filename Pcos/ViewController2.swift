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
        
        // Create and add the side menu view controller
        sideMenu = SideMenuViewController()
        addChild(sideMenu!)
        view.addSubview(sideMenu!.view)
        sideMenu!.didMove(toParent: self)
        
        // Position the side menu offscreen
        sideMenu!.view.frame = CGRect(x: -view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        // Add tap gesture to close the side menu
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

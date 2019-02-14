//
//  PostLaunchViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class PostLaunchViewController: UIViewController {
    
    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Outlets
    @IBOutlet weak var iconBaluchon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Animate icon resize
        UIView.animate(withDuration: 0.5, animations: {
            self.iconBaluchon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.iconBaluchon.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.iconBaluchon.alpha = 0
            }, completion: { (succes) in
                // Navigate to the CurrencyViewController
                if succes {
                    let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                    let vc = sb.instantiateViewController(withIdentifier: "TabBar") as? CustomTabBarViewController
                    self.present(vc!, animated: false, completion: nil)
                }
            })
        }
    }
}

//
//  PostLaunchViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class PostLaunchViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var iconBgk: DesignableView!
    @IBOutlet weak var iconBaluchon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Animate the icon disparition
        UIView.animate(withDuration: 0.2, animations: {
            self.iconBaluchon.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
        
        // Animate the background resize
        UIView.animate(withDuration: 0.3, animations: {
            self.iconBgk.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.iconBgk.transform = CGAffineTransform(scaleX: 20, y: 20)
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

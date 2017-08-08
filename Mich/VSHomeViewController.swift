//
//  VSHomeViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 8/8/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class VSHomeViewController: SlidingMenuPresentingViewController {
    var destinationBattleId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showvsnotification" {
            guard let vc = segue.destination as? VSJSQViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.battleId = self.destinationBattleId
            vc.battle = nil
            vc.senderDisplayName = (UIApplication.shared.delegate as! AppDelegate).user?.username
            vc.senderId = String((UIApplication.shared.delegate as! AppDelegate).user!.id!)
        }
    }
}

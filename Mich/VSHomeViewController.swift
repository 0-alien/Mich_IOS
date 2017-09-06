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
        currentIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showvsnotification" {
            guard let vc = segue.destination as? VSJSQViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.battleId = self.destinationBattleId
            vc.battle = nil
            vc.senderDisplayName = (UIApplication.shared.delegate as! AppDelegate).user?.username
            vc.senderId = String((UIApplication.shared.delegate as! AppDelegate).user!.id!)
        } else if segue.identifier == "showmybattles" {
            (segue.destination as! VSViewController).whichBattleList = 1
        } else if segue.identifier == "showtopbattles" {
            (segue.destination as! VSViewController).whichBattleList = 2
        } else if segue.identifier == "showactivebattles" {
            (segue.destination as! VSViewController).whichBattleList = 3
        } else if segue.identifier == "randombattle" {
            (segue.destination as! RandomVSViewController).isSpectate = false
        } else if segue.identifier == "randomspectate" {
            (segue.destination as! RandomVSViewController).isSpectate = true
        }
    }
}

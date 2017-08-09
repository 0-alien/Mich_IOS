//
//  VSViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/29/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class VSViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var whichBattleList: Int! {
        didSet {
            
        }
    }
    var battles = [Battle]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(VSViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 30
        self.tableView.rowHeight = 80
        self.tableView.refreshControl = refreshControl
        if whichBattleList == 0 {
            MichVSTransport.getMyBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetBattles: onGetBattlesSuccess, errorCallbackForGetBattles: onError)
        } else if whichBattleList == 1 {
            MichVSTransport.getTopBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetTopBattles: onGetBattlesSuccess, errorCallbackForGetTopBattles: onError)
        } else {
            MichVSTransport.getActiveBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetActiveBattles: onGetBattlesSuccess, errorCallbackForGetActiveBattles: onError)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VSTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VSTableViewCell", for: indexPath) as! VSTableViewCell
        cell.hostUserName.text = battles[indexPath.row].host?.username
        cell.guestUserName.text = battles[indexPath.row].guest?.username
        cell.vsFirst.af_setImage(withURL: Foundation.URL(string: (battles[indexPath.row].host?.avatar)!)!)
        cell.vsSecond.af_setImage(withURL: Foundation.URL(string: (battles[indexPath.row].guest?.avatar)!)!)
        cell.vsFirst = cell.vsFirst.circle
        cell.vsSecond = cell.vsSecond.circle
        return cell
    }

    func activeSeeMore(_ button: UIButton) {
        performSegue(withIdentifier: "vsseague", sender: self)
    }
    
    func moreSeeMore(_ button: UIButton) {
        performSegue(withIdentifier: "vsseague", sender: self)
    }
    
    func myBattles(_ button: UIButton) {
        performSegue(withIdentifier: "vsseague", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showvs" {
            guard let vc = segue.destination as? VSJSQViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let cell = sender as? VSTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            let indexPath = tableView.indexPath(for: cell)
            if battles[(indexPath?.row)!].myBattle! {
                vc.senderId = String(((UIApplication.shared.delegate as! AppDelegate).user?.id)!) // String(battles[(indexPath?.row)!].host!.id!)
                vc.senderDisplayName = (UIApplication.shared.delegate as! AppDelegate).user?.username // battles[indexPath!.row].host?.username
            }
            else {
                vc.senderId = String(battles[(indexPath?.row)!].host!.id!)
                vc.senderDisplayName = battles[indexPath!.row].host?.username
            }
            vc.battleId = battles[(indexPath?.row)!].id
            if battles[(indexPath?.row)!].status == 3 { //damtavrebulia da azri ar
                vc.battle = battles[(indexPath?.row)!]
            }
            else {
                vc.battle = nil // 0 da 1 is shemtxvevashi sheidzleba statusi shecvlili iyos da axlidan moaq info
            }
        }
    }
    
    // MARK: callbacks
    func onGetBattlesSuccess(resp: [Battle]) {
        self.battles = resp
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func onError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: refreshcontrol
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        if whichBattleList == 0 {
            MichVSTransport.getMyBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetBattles: onGetBattlesSuccess, errorCallbackForGetBattles: onError)
        } else if whichBattleList == 1 {
            MichVSTransport.getTopBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetTopBattles: onGetBattlesSuccess, errorCallbackForGetTopBattles: onError)
        } else {
            MichVSTransport.getActiveBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetActiveBattles: onGetBattlesSuccess, errorCallbackForGetActiveBattles: onError)
        }
    }
    
    // MARK: navigatioin
    @IBAction func unwindToVSPage(sender: UIStoryboardSegue) {
        for i in 0 ..< self.battles.count {
            if self.battles[i].id == (sender.source as! VSJSQViewController).battle.id {
                self.battles.remove(at: i)
                break
            }
        }
        self.tableView.reloadData()
    }
}

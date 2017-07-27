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

class VSViewController: SlidingMenuPresentingViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var destinationBattleId: Int = -1
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
        currentIndex = 1
        self.tableView.refreshControl = refreshControl
        MichVSTransport.getMyBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetBattles: onGetBattlesSuccess, errorCallbackForGetBattles: onError)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: self.tableView!.frame.size.width, height: 15);
        if (section == 1) {
            return VSTableViewSectionHeader(frame: frame, labelName: " Active Now", seeMoreCount: 11, listener: self, selector: #selector(VSViewController.activeSeeMore(_:)))
        }
        else if (section == 0) {
            return VSTableViewSectionHeader(frame: frame, labelName: " My Battles", seeMoreCount: 11, listener: self, selector: #selector(VSViewController.myBattles(_:)))
        }
        else {
            return VSTableViewSectionHeader(frame: frame, labelName: " More Conversations", seeMoreCount: 3, listener: self, selector: #selector(VSViewController.moreSeeMore(_:)))
        }
    }*/
    
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
        else if segue.identifier == "showvsnotification" {
            guard let vc = segue.destination as? VSJSQViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.battleId = self.destinationBattleId
            vc.battle = nil
            vc.senderDisplayName = (UIApplication.shared.delegate as! AppDelegate).user?.username
            vc.senderId = String((UIApplication.shared.delegate as! AppDelegate).user!.id!)
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
        MichVSTransport.getBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetBattles: onGetBattlesSuccess, errorCallbackForGetBattles: onError)
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

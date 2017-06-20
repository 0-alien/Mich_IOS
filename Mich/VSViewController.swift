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
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    private var channelRefHandle: FIRDatabaseHandle?
    private var channels: [Channel] = []
    var destinationBattleId: Int = -1
    var battles = [Battle]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 30
        self.tableView.rowHeight = 80
        currentIndex = 1
        MichVSTransport.getBattles(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetBattles: onGetBattlesSuccess, errorCallbackForGetBattles:
        onError)
        observeChannels()
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
    
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 { // 3
                self.channels.append(Channel(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
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
            vc.battle = battles[(indexPath?.row)!]
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
    }
    
    func onError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class Channel {
    var id: String
    var name: String
    init (id: String, name: String) {
        self.id = id
        self.name = name
    }
}


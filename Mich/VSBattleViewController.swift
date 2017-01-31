//
//  VSBattleViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/13/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSBattleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarExtension: UIView!
    @IBOutlet weak var first: UIImageView!
    @IBOutlet weak var second: UIImageView!
    @IBOutlet weak var battleTableView: UITableView!
    @IBOutlet weak var firstPointCnt: UILabel!
    @IBOutlet weak var secondPointCnt: UILabel!
    
    var data = [BattleTableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        battleTableView.dataSource = self
        battleTableView.delegate = self
        var min = Swift.min(first.frame.size.width, first.frame.size.height)
        first.frame.size = CGSize(width: min, height: min)
        min = Swift.min(second.frame.size.width, second.frame.size.height)
        second.frame.size = CGSize(width: min, height: min)
        first.image = first.image?.circle
        second.image = second.image?.circle
        first.backgroundColor = UIColor.white.withAlphaComponent(0)
        second.backgroundColor = UIColor.white.withAlphaComponent(0)
        navBarExtension.backgroundColor = UIColor.red.withAlphaComponent(0)
        battleTableView.rowHeight = UITableViewAutomaticDimension
        battleTableView.estimatedRowHeight = 44.0
        for i in 0 ..< 10 {
            let cell: BattleTableViewCell = BattleTableViewCell()
            if (i % 2 == 0) {
                cell.label = "DAWDWAD"
                cell.isFirst = true
            }
            else {
                cell.isFirst = false
                cell.label = "dawdwadawdawdawdn nfn ainfinwaienfiewnaifnew kjgdfn fsad jsadfjksadff ojasdfoh sdiaugf u8dshofi jsdaojhfi o"
            }
            cell.hasImage = false
            data.append(cell)
        }
        battleTableView.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: false)
        let tap = UITapGestureRecognizer(target: self, action: #selector(VSBattleViewController.hideKeyboard))
        tap.numberOfTapsRequired = 1
        battleTableView.addGestureRecognizer(tap)
        tableViewScrollToBottom(animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clicked(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func firstTapped(_ sender: Any) {
        firstPointCnt.text = String(Int(firstPointCnt.text!)! + 1)
        showAnimation()
    }
   
    @IBAction func secondTapped(_ sender: Any) {
        secondPointCnt.text = String(Int(secondPointCnt.text!)! + 1)
        showAnimation()
    }
    
    private func showAnimation() {
        let img = UIImageView(image: UIImage(named: "fire_icon"))
        let coef = self.view.frame.size.width / 2.0 / img.frame.size.width
        img.frame = self.view.frame.insetBy(dx: self.view.frame.size.width / 4.0, dy: self.view.frame.size.height / 2.0 - img.frame.size.height * coef / 2.0)
        img.frame.origin.y = self.view.frame.size.height / 2.0 - img.frame.size.height
        self.view.addSubview(img)
        UIView.animate(withDuration: 1, animations: {
            img.alpha = 0
        })
    }
    
    //Mark: Battle Table View delegate + data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (data[indexPath.row].isFirst!) {
            if (data[indexPath.row].hasImage!) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BattleTableViewCellAWithPicture") as! BattleTableViewCellAWithPicture
                cell.sentImage.image = data[indexPath.row].image
                if (data[indexPath.row].image?.size.width)! > cell.frame.size.width - 60 - 8.0 * 2 {
                    let newLength = cell.frame.size.width - 60 - 8.0 * 2
                    let coef = newLength / (data[indexPath.row].image?.size.width)!
                    cell.sentImageHeight.constant = (data[indexPath.row].image?.size.height)! * coef
                }
                let tap = UITapGestureRecognizer(target: self, action: #selector(VSBattleViewController.firstTapped(_:)))
                tap.numberOfTapsRequired = 2
                cell.addGestureRecognizer(tap)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BattleTableViewCellA") as! BattleTableViewCellA
                cell.label?.text = data[indexPath.row].label
                let tap = UITapGestureRecognizer(target: self, action: #selector(VSBattleViewController.firstTapped(_:)))
                tap.numberOfTapsRequired = 2
                cell.addGestureRecognizer(tap)
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BattleTableViewCellB") as! BattleTableViewCellB
            cell.label.text = data[indexPath.row].label
            let tap = UITapGestureRecognizer(target: self, action: #selector(VSBattleViewController.secondTapped(_:)))
            tap.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tap)
            return cell
        }
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.textFieldBottomConstraint.constant = 0.0
            } else {
                self.textFieldBottomConstraint.constant = (endFrame?.size.height ?? 0.0) + 20.0
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {self.view.layoutIfNeeded()
            self.battleTableView.scrollToRow(at: IndexPath(row: self.data.count - 1, section: 0), at: .bottom, animated: false)}, completion: nil)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell: BattleTableViewCell = BattleTableViewCell()
        cell.label = textField.text
        cell.isFirst = true
        cell.hasImage = false
        data.append(cell)
        textField.text = ""
        self.battleTableView.reloadData()
        battleTableView.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: false)
        return true
    }
    func hideKeyboard() {
        textField.resignFirstResponder()
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            let numberOfSections = self.battleTableView.numberOfSections
            let numberOfRows = self.battleTableView.numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.battleTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    @IBAction func showLocalLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        let cell: BattleTableViewCell = BattleTableViewCell()
        cell.isFirst = true
        cell.hasImage = true
        cell.image = image
        cell.label = ""
        data.append(cell)
        battleTableView.reloadData()
        tableViewScrollToBottom(animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
}


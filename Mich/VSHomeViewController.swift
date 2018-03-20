//
//  VSHomeViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 8/8/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import GoogleMaps;
import GooglePlaces;

class VSHomeViewController: SlidingMenuPresentingViewController, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    var destinationBattleId: Int!
    
    @IBOutlet weak var topBattles: UIButton!
    @IBOutlet weak var myBattles: UIButton!
    @IBOutlet weak var active: UIButton!
//    @IBOutlet weak var counrtyFilterBTN: UIBarButtonItem!
    @IBOutlet weak var filterTX: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBattles.layer.shadowOpacity = 0.3;
        topBattles.layer.shadowRadius = 1.0;
        topBattles.layer.shadowColor = UIColor.black.cgColor;
        topBattles.layer.shadowOffset = CGSize(width: -4, height: 4)
        topBattles.layer.masksToBounds = false

        myBattles.layer.shadowOpacity = 0.3;
        myBattles.layer.shadowRadius = 1.0;
        myBattles.layer.shadowColor = UIColor.black.cgColor;
        myBattles.layer.shadowOffset = CGSize(width: -4, height: 4)
        myBattles.layer.masksToBounds = false
        
        active.layer.shadowOpacity = 0.3;
        active.layer.shadowRadius = 1.0;
        active.layer.shadowColor = UIColor.black.cgColor;
        active.layer.shadowOffset = CGSize(width: -4, height: 4)
        active.layer.masksToBounds = false
 
        filterTX.clearButtonMode = UITextFieldViewMode.always;
        
        currentIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showvsnotification" {
            guard let vc = segue.destination as? ChatContainerViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.battleId = self.destinationBattleId
        } else if segue.identifier == "showmybattles" {
            (segue.destination as! VSViewController).whichBattleList = 0
        } else if segue.identifier == "showtopbattles" {
            (segue.destination as! VSViewController).whichBattleList = 1
        } else if segue.identifier == "showactivebattles" {
            (segue.destination as! VSViewController).whichBattleList = 2
        } else if segue.identifier == "randombattle" {
            (segue.destination as! RandomVSViewController).isSpectate = false
            (segue.destination as! RandomVSViewController).country = filterTX.text!;

        } else if segue.identifier == "randomspectate" {
            (segue.destination as! RandomVSViewController).isSpectate = true
            (segue.destination as! RandomVSViewController).country = filterTX.text!;
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == filterTX){
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        filterTX.text = place.name;
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

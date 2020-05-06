//
//  MainViewController.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 05.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var nextMatchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func goMatchDetails(_ sender: Any) {
        guard let vc = createMatchDetails() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createMatchDetails() -> MatchDetailsViewController? {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MatchDetailsViewController.identifier) as! MatchDetailsViewController
        
        guard let text = nextMatchTextField.text else { return nil }
        guard let index = Int(text) else { return nil }
        guard let match = matchForTest[safe: index] else { return nil }
        
        vc.setupMatch(match: match)
        return vc
    } 
} 

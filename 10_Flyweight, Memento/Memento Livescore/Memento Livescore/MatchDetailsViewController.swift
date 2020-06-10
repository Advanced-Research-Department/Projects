//
//  MatchDetailsViewController.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 06.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import UIKit

class MatchDetailsViewController: UIViewController {
    
    @IBOutlet private weak var screenNumberLabel: UILabel!
    @IBOutlet private weak var homeTeamLabel: UILabel!
    @IBOutlet private weak var awayTeamLabel: UILabel!
    @IBOutlet private weak var nextMatchTextField: UITextField!
    
    private var match: SimpleMatch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Created MatchDetails:", match?.homeTeam ?? "homeTeam", "vs", match?.awayTeam ?? "awayTeam")
        
        setupViews()
        removePreviousScreen()
    }
    
    deinit {
        print("Deinit MatchDetails:", match?.homeTeam ?? "homeTeam", "vs", match?.awayTeam ?? "awayTeam")
    }
    
    private func setupViews() {
        guard let match = match else { return }
        
        screenNumberLabel.text = String(match.testNumber)
        homeTeamLabel.text = match.homeTeam
        awayTeamLabel.text = match.awayTeam
        
        homeTeamLabel.textColor = match.isHomeTeamWin ? .green : .red
        awayTeamLabel.textColor = match.isHomeTeamWin ? .red : .green
    }
    
    private func removePreviousScreen() {
        guard let viewControllers = navigationController?.viewControllers else { return }
         
        // viewControllers.count - 1 -> current screen
        // viewControllers.count - 2 -> previous screen
        if let _ = viewControllers[safe: viewControllers.count - 2] as? MainViewController {
            return 
        }
        
        navigationController?.viewControllers.remove(at: viewControllers.count - 2)
    }
    
    func setupMatch(match: SimpleMatch) {
        self.match = match 
    }
    
    @IBAction func goMatchDetails(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MatchDetailsViewController.identifier) as! MatchDetailsViewController
        
        guard let text = nextMatchTextField.text else { return }
        guard let index = Int(text) else { return }
        guard let match = matchForTest[safe: index] else { return }
        
        save()
        
        vc.setupMatch(match: match)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func backClicked(_ sender: Any) { 
        if let match = restore(),
            let viewControllers = navigationController?.viewControllers {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: MatchDetailsViewController.identifier) as! MatchDetailsViewController
            vc.setupMatch(match: match)
            navigationController?.viewControllers.insert(vc, at: viewControllers.count - 1)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension MatchDetailsViewController: MementoProtocol {
    
    func save() {
        guard let match = match else { return }
        AppContext.shared.appState.matchDetailsCaretaker.add(match: match)
    }
    
    func restore() -> SimpleMatch? {
        return AppContext.shared.appState.matchDetailsCaretaker.undo() as? SimpleMatch
    }
}

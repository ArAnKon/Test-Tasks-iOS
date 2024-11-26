//
//  ViewController.swift
//  RockPaperScissors
//
//  Created by ArAnKon.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var ComputerLabel: UILabel!
    @IBOutlet var PickerView: UIPickerView!
    @IBOutlet var SelectedLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var playerScoreLabel: UILabel!
    @IBOutlet var computerScoreLabel: UILabel!
    @IBOutlet var difficultySegment: UISegmentedControl!
    
    let option = ["Rock", "Paper", "Scissors", "Lizard", "Spock"]
    var countdownTimer: Timer?
    var countdown = 3
    var playerScore = 0
    var computerScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var playerScore = 0
        var computerScore = 0
        
        func updateScores(playerChoice: String, computerChoice: String) {
//
            
            SelectedLabel.text = "You chose: Rock"
            resultLabel.adjustsFontSizeToFitWidth = true
            resultLabel.minimumScaleFactor = 0.5
            resultLabel.numberOfLines = 1
            playerScoreLabel.text = "Player Score: \(playerScore)"
            computerScoreLabel.text = "Computer Score: \(computerScore)"
        }
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return option[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return option.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SelectedLabel.text = "You chose: \(option[row])"
    }
    
    @IBAction func StartButtonPressed(_ sender: UIButton) {
        startCountdown()
    }
    
    func startCountdown() {
        countdown = 3
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    
    @objc func updateCountdown() {
        if countdown > 0 {
            ComputerLabel.text = "\(countdown)"
            countdown -= 1
        } else {
            countdownTimer?.invalidate()
            ComputerLabel.text = "Computer chose: \(computerChoice())"
            winLogic()
        }
    }
    
    func computerChoice() -> String {
        let selectedDifficulty = difficultySegment.selectedSegmentIndex
                if selectedDifficulty != 3 {
                    return option.randomElement() ??  option[4]// Easy Mode
        } else {
            // Hard Mode: Counter the player's choice
            let playerChoice = SelectedLabel.text?
                .replacingOccurrences(of: "You chose: ", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            switch playerChoice {
            case "Rock": return "Paper"
            case "Paper": return "Scissors"
            case "Scissors": return "Rock"
            case "Lizard": return "Rock"
            case "Spock": return "Spock"
            default: return option.randomElement() ?? "Rock"
            }
        }
    }
    
    func winLogic() {
        guard let playerChoice = SelectedLabel.text?
            .replacingOccurrences(of: "You chose: ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines),
              let computerChoice = ComputerLabel.text?
            .replacingOccurrences(of: "Computer chose: ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines) else {
            resultLabel.text = "Error: Missing choices"
            return
        }
        
        let winCases = [
            ("Rock", "Scissors"), ("Rock", "Lizard"),
            ("Paper", "Rock"), ("Paper", "Spock"),
            ("Scissors", "Paper"), ("Scissors", "Lizard"),
            ("Lizard", "Paper"), ("Lizard", "Spock"),
            ("Spock", "Rock"), ("Spock", "Scissors"),
            ("Spock", "Lizard"), ("Spock", "Paper")
        ]
        
        if playerChoice == computerChoice {
            resultLabel.text = "It's a tie!"
        } else if winCases.contains(where: { $0.0 == playerChoice && $0.1 == computerChoice }) {
            resultLabel.text = "You Won!"
            playerScore += 1
        } else {
            resultLabel.text = "You Lost!"
            computerScore += 1
        }
        
        playerScoreLabel.text = "Player Score: \(playerScore)"
        computerScoreLabel.text = "Computer Score: \(computerScore)"
        
        // Animation for the resultLabel
        UIView.animate(withDuration: 0.5, animations: {
            self.resultLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.resultLabel.transform = .identity
            }
        })
        
        startButton.setTitle("Play Again", for: .normal)
    }
}

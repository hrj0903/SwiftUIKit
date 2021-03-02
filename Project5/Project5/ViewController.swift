//
//  ViewController.swift
//  Project5
//
//  Created by hrj on 2021/02/23.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        //How to find the path to a file in your bundle It’s common to store resource data like text files and sound effects inside your bundle, but loading them must be done in a particular way to avoid problems. Rather than try to figure out the layout of your bundle at runtime, the correct thing to do is call the path(forResource:) method if you’re looking for a string path, or url(forResource:) if you’re looking for a URL.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // "try? mean: call this code, and if it throws an error just send me back nil instead."
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        //The reason we use isEmpty is because some collection types, such as string, have to calculate their size by counting over all the elements they contain, so reading count == 0 can be significantly slower than using isEmpty.
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func startGame() {
        //Line 1 sets our view controller's title to be a random word in the array, which will be the word the player has to find.
        title = allWords.randomElement()
        //Line 2 removes all values from the usedWords array, which we'll be using to store the player's answers so far.
        usedWords.removeAll(keepingCapacity: true)
        //That table view is given to us as a property because our ViewController class comes from UITableViewController, and calling reloadData() forces it to call numberOfRowsInSection again, as well as calling cellForRowAt repeatedly.
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        //So action in means that it accepts one parameter in, of type UIAlertAction.
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        if isSame(word: lowerAnswer) {
            showErrorMessage(errorTitle: "Word is the same!", errorMessage: "Don't cheat on me!")
        } else {
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(lowerAnswer, at: 0)

                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)

                        return
                    } else {
                        showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                    }
                } else {
                    showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
                }
            } else {
                guard let title = title?.lowercased() else  { return }
                showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word form \(title)")
            }
        }
    }

    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        if word.count < 3 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func isSame(word: String) -> Bool {
        return word == title
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

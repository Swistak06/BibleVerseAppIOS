//
//  BookViewController.swift
//  BibleVerseApp
//
//  Created by RMS2018 on 26.04.2019.
//  Copyright © 2019 swistak. All rights reserved.
//

import UIKit



class BookViewController: UITableViewController {
    
    var isOldTestament = true
    
    var oldTBooks = ["Genesis","Exodus","Leviticus","Numbers","Deuteronomy", "Joshua", "Judges", "Ruth","1 Samuel", "2 Samuel",
                     "1 Kings","2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nahemiah", "Esther", "Job","Psalms","Proverbs",
                     "Ecceliastes","Song of solomon","Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos",
                     "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    var newTBooks = ["Matthew","Mark","Luke","John", "Acts", "Romans", "1 Corinthians","2 Corinthians", "Galatians",
                     "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy",
                     "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John",
                     "2 John", "3 John", "Jude", "Revelation"]
    var books = ["alfa"]
    var chosenIndex = 0
    var isNewTestamentDisplayed = false

    @IBOutlet var BookTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //BookTable.backgroundColor = BookTable.
        if isOldTestament{
            books = oldTBooks
        }
        else{
            books = newTBooks
        }
        
        //BookTable.backgroundColor = UIColor.red
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = books[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenIndex = indexPath.row
        performSegue(withIdentifier: "ChooseBook", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ChooseBook"){
            let vc = segue.destination as! ViewController
            vc.book = books[chosenIndex]
        }
    }
    
}

class ReplaceSegue: UIStoryboardSegue {
    
    override func perform() {
        source.navigationController?.setViewControllers([destination], animated: true)
    }
}

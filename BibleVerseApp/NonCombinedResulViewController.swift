//
//  NonCombinedResulViewController.swift
//  BibleVerseApp
//
//  Created by RMS2018 on 12.04.2019.
//  Copyright © 2019 swistak. All rights reserved.
//

import UIKit

class NonCombinedResulViewController: UIViewController {

    
    @IBOutlet weak var BookLabel: UILabel!
    @IBOutlet weak var ChapterLabel: UILabel!
    @IBOutlet weak var ResultTextView: UITextView!
    
    var bookName = ""
    var chapter = ""
    var resultText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BookLabel.text = bookName
        ChapterLabel.text = chapter
        ResultTextView.text = resultText
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

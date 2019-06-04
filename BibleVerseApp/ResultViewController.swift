//
//  ResultViewController.swift
//  BibleVerseApp
//
//  Created by RMS2018 on 29.03.2019.
//  Copyright © 2019 swistak. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController{

    @IBOutlet weak var ResultTV: UITextView!
    @IBOutlet weak var ResultTVHC: NSLayoutConstraint!
    
    @IBOutlet weak var BookNameLabel: UILabel!
    @IBOutlet weak var ChapterLabel: UILabel!
    var verseBible : String = ""
    var bookName : String = ""
    var chapter : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ResultTV.text = verseBible
        BookNameLabel.text = bookName
        ChapterLabel.text = chapter
        //ResultTV.isScrollEnabled = false
        //ResultTV
        print(verseBible)
        self.navigationItem.backBarButtonItem?.title = "BACK"
        //print(self.ResultTV.contentSize.height)
        //ResultTVHC.constant = self.ResultTV.contentSize.height
    }
    

}

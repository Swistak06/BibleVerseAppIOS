//
//  Verse.swift
//  BibleVerseApp
//
//  Created by RMS2018 on 12.04.2019.
//  Copyright © 2019 swistak. All rights reserved.
//

import Foundation

struct Verse{
    var bookName : String
    var verseNumber : String
    var text : String
    var chapter : String
    
    init(bookName : String, verseNumber : String, text : String, chapter : String){
        self.bookName = bookName
        self.verseNumber = verseNumber
        self.text = text
        self.chapter = chapter
    }
}

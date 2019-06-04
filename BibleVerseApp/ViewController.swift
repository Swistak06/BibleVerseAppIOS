//
//  ViewController.swift
//  BibleVerseApp
//
//  Created by RMS2018 on 22.03.2019.
//  Copyright © 2019 swistak. All rights reserved.
//

import UIKit

extension String{
    var isNotInt: Bool{
        return Int(self) == nil
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var AppTitle: UITextView!
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var BookNameTextView: UITextField!
    @IBOutlet weak var ChapterNumberTextView: UITextField!
    
    @IBOutlet weak var VerseBeginTextView: UITextField!
    @IBOutlet weak var VerseEndTextView: UITextField!
    
    @IBOutlet weak var CombinedTextSwitch: UISwitch!
    @IBOutlet weak var ErrorLabel: UILabel!

    
    var resultText = "Text"
    var book = ""
    var chapter = "0"
    var enableOldTestament = true
    
    func clearTextViews() {
        BookNameTextView.text = ""
        ChapterNumberTextView.text = ""
        VerseBeginTextView.text = ""
        VerseEndTextView.text  = ""
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if UIDevice.current.userInterfaceIdiom == .phone{
            return .allButUpsideDown
        } else{
            return .all
        }
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake{
           clearTextViews()
        }
    }
    
    @IBAction func ShowOldTestamentBooks(_ sender: Any) {
        enableOldTestament = true
        self.performSegue(withIdentifier: "ShowBookList", sender: self)
    }
    
    @IBAction func ShowNewTestamentBooks(_ sender: Any) {
        enableOldTestament = false
        self.performSegue(withIdentifier: "ShowBookList", sender: self)
    }
    @IBAction func SearchButtonAction(_ sender: UIButton){
        
        var verse = "1"
        var urlString = " "
        let endNum = Int(VerseEndTextView.text!)
        let beginNum = Int(VerseBeginTextView.text!)
        
        if BookNameTextView.text == "" || ChapterNumberTextView.text == "" || ChapterNumberTextView.text!.isNotInt || VerseBeginTextView.text == "" || (endNum != nil && beginNum != nil && endNum!<=beginNum! || (VerseBeginTextView.text!.isNotInt && VerseEndTextView.text!.isNotInt)){
        
            showErrorMessage(errMSG: "Incorrect data")
        }
        else{
            if VerseEndTextView.text == ""{
                verse = VerseBeginTextView.text!
            }
            else{
                verse = VerseBeginTextView.text! + "-" + VerseEndTextView.text!
            }
            
            urlString = "https://bible-api.com/" + BookNameTextView.text!.replacingOccurrences(of: " ",with:"+") + "+" + ChapterNumberTextView.text!+":"+verse
            
            print(urlString)
            
            let apiURl = URL(string : urlString)!
    
            resultText = sendRequest(url: apiURl)

            self.performSegue(withIdentifier: "CombinedApiRes", sender: self)



        }
    }
    
    func sendRequest (url : URL) -> String{
        
        let semaphore = DispatchSemaphore(value: 0)
        var verseText : String = ""
        var arr: Array<Verse> = Array()
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            if error == nil{
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])
                let jsonDict = jsonResponse as? [String: Any]
                
                if let error = (jsonDict?["error"] as? String){
                    self.showErrorMessage(errMSG: "Verses not found")
                    self.book = "Verses not found"
                    self.chapter = ""
                }
                else if(self.CombinedTextSwitch.isOn){
                    if let verses = (jsonDict?["text"] as? String){
                        verseText = verses
                    }
                    if let array = (jsonDict?["verses"] as? [[String : Any]]){
                        self.book = (array.first?["book_name"] as! String)
                        self.chapter = "Chapter " + String(array.first?["chapter"] as! Int)
                    }
                }
                else{
                    if let array = (jsonDict?["verses"] as? [[String : Any]]){
                        var i = 0
                        for object in array{
                            let bookName = object["book_name"] as! String
                            let verseNumber = String(object["verse"] as! Int)
                            let vt = object["text"] as! String
                            let chapter = String(object["chapter"] as! Int)
                            arr.append(Verse(bookName: bookName, verseNumber: verseNumber,text: vt,chapter: chapter))
                            if( i == 0){
                                self.book = arr[i].bookName
                                self.chapter = "Chapter " + arr[i].chapter
                            }
                            verseText += "Verse " + arr[i].verseNumber + "\n"
                            verseText += arr[i].text + "\n"
                            i = i + 1
                        }
                    }
                    else{
                        semaphore.signal()
                        // Problem z odczytaniem danych
                        self.showErrorMessage(errMSG: "Cannot load data")
                    }
                }
                semaphore.signal()
            }
            else{
                self.showErrorMessage(errMSG: "Problem with connection")
                self.book = "Problem with connection"
                self.chapter = " "
                semaphore.signal()
                //Nie pozwoli zmieni sceny, komunikat o problemie z api call'em
            }
        }
        task.resume()
        
        semaphore.wait()
        return verseText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "CombinedApiRes"){
            let vc = segue.destination as! ResultViewController
            vc.verseBible = self.resultText
            vc.chapter = self.chapter
            vc.bookName = self.book
        }
        else if segue.identifier == "ShowBookList"{
            let vc = segue.destination as! BookViewController
            vc.isOldTestament = self.enableOldTestament
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        BookNameTextView.text = book
        self.ErrorLabel.text = " "
        VerseBeginTextView.delegate = self
        VerseEndTextView.delegate = self
        BookNameTextView.delegate = self
        ChapterNumberTextView.delegate = self
        
        //Setting up listeners
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardDidShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillChangeFrameNotification,object: nil)
    }
    
    func showErrorMessage(errMSG : String){
        self.ErrorLabel?.text = errMSG
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute:{
             self.ErrorLabel?.text = " "
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.delegate = self
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if activeTextField == VerseBeginTextView || activeTextField == VerseEndTextView{
            if notification.name == UIResponder.keyboardDidShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
                view.frame.origin.y = -keyboardRect.height
            }
        }
        if notification.name == UIResponder.keyboardWillHideNotification{
            view.frame.origin.y = 0
        }

    }
    
    var activeTextField : UITextField!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}




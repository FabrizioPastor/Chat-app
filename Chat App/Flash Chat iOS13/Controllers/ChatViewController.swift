//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "1@2.com", body: "Hello!"),
        Message(sender: "1@2.com", body: "What's up?!"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        title = "⚡️FlashChat"
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

    }
    
    /**
     ENVÍA MENSAJE
     */
    @IBAction func sendPressed(_ sender: UIButton) {
        
        guard let sender = Auth.auth().currentUser, let message = messageTextfield.text else {return}
        
        db.collection("messages").addDocument(data: [
            "sender": sender,
            "body": message
        ]) { error in
            if let e = error {
                print("There was an issue saving the data to firestore. \(e)")
            }else {
                print("Succesfully saved the data")
            }
        }
        
    }
    

    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Errors singing out: %@", signOutError)
        }
        
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.messageText?.text = messages[indexPath.row].body
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Do something
        print(tableView)
    }
}

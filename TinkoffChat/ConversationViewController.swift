//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 25.03.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MessageCellConfiguration: class
    {
        var text : String? {get set}
        var received : Bool {get set}
    }


class MessegesCell: MessageCellConfiguration {
    
    var text : String?
    var received : Bool
    
    init() {
        self.text = nil
        self.received = false
         }
    
    init(text: String?,
         received: Bool
        ) {
        self.text = text
        self.received = received
        }
}


class ConversationViewController: UIViewController, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate {

    
    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageTextView: UITextField!
    
    var user:ConversationCellConfiguration = ConversationCell()
    var name: String = ""
    var session: MCSession?
    var peerId: MCPeerID?
    var message: String = ""
    
    var communicatorManager: CommunicatorManager = CommunicatorManager()
    
    var messeges = [MessegesCell]()
    
    
    override func loadView()
    {
        super.loadView()
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton)
    {
        let message = messageTextView.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if message.isEmpty {
            return
        }
        print("send message \(message)")
        communicatorManager.sendMessage(message: message, to: name)
        messeges.append(MessegesCell(text: message, received: false))
        messagesTableView.reloadData()
        messageTextView.text = ""
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        communicatorManager.delegate = self
        
        self.title = name
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.estimatedRowHeight = 44
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedSectionFooterHeight = 10
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {return 1}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {return messeges.count}
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {return " \n " }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if messeges[indexPath.row].received
        {
             let cell = messagesTableView.dequeueReusableCell(withIdentifier: "UserMessegeCell") as! UserMessage
            cell.textLabelMessage.text = messeges[indexPath.row].text
            return cell
        }
        else
        {
            let cell = messagesTableView.dequeueReusableCell(withIdentifier: "FriendMessegeCell") as! FriendMessage
            cell.textLabelMessage.text = messeges[indexPath.row].text
            return cell
        }
            
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        messagesTableView.estimatedRowHeight = 100
        messagesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
        
}

extension ConversationViewController: CommunicatorManagerDelegate {
    func updateConversationList() {
        
    }
    func handleCommunicateError(error: Error) {
        print("Error occured during communication \(error)")
    }
    
    func didRecieveMessage(text: String) {
        DispatchQueue.main.async {
            self.messeges.append(MessegesCell(text: text, received: true))
            self.messagesTableView.reloadData()
        }
    }
}

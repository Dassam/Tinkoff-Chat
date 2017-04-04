//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 25.03.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

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
    
    
    var user:ConversationCellConfiguration = ConversationCell()
    
    var name: String = "" 
    var message: String = ""
    
    
    var Messeges = [MessegesCell]()
    
    
    override func loadView()
    {
        super.loadView()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = name
        
        
        Messeges =
            [
                MessegesCell(text: "Hello",  received: true),
                MessegesCell(text: "GoodBye",  received: false),
                MessegesCell(text: "How are you",  received: true),
                MessegesCell(text: "I am ok",  received: false),
                MessegesCell(text: "Текст сообщения не должен заходить на последнюю четверть ширины ячейки.",  received: true),
                MessegesCell(text: "Текст сообщения не должен заходить на первую четверть ширины ячейки.",  received: false)
                ]
        
        self.messagesTableView.dataSource = self
        self.messagesTableView.delegate = self
        self.messagesTableView.estimatedRowHeight = 44
        self.messagesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {return 1}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {return 6}
    
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if Messeges[indexPath.row].received
        {
             let cell = messagesTableView.dequeueReusableCell(withIdentifier: "UserMessegeCell") as! UserMessage
            cell.textLabelMessage.text = Messeges[indexPath.row].text
            return cell
        }
        else
        {
            let cell = messagesTableView.dequeueReusableCell(withIdentifier: "FriendMessegeCell") as! FriendMessage
            cell.textLabelMessage.text = Messeges[indexPath.row].text
            return cell
        }
            
    }
        
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        messagesTableView.estimatedRowHeight = 100
        messagesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
        
}


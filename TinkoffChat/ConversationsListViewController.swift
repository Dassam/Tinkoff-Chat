//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 25.03.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMesseges : Bool {get set}
}

class ConversationCell: ConversationCellConfiguration {
    var name : String?
    var message : String?
    var date : Date?
    var online : Bool
    var hasUnreadMesseges : Bool
    
    init() {
        self.name = nil
        self.message = nil
        self.date = nil
        self.online = false
        self.hasUnreadMesseges = false
    }
    
    init(name: String?,
         message: String?,
         date: Date?,
         online: Bool,
         hasUnreadMesseges: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMesseges = hasUnreadMesseges
    }
}


class ConversationsListViewController: UIViewController, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableUsersList: UITableView!
    
    let ONLINE = 0
    let OFFLINE = 1
    var peersOnline = [ConversationCell]()
    var peersOffline = [ConversationCell]()
    var communicatorManager = CommunicatorManager()
    
    
    override func loadView()
    {
        super.loadView()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        communicatorManager.delegate = self
        
        peersOnline = []
        
        peersOffline = [
            ConversationCell(name: "Mike", message: "i m ok",  date: Date(), online: false, hasUnreadMesseges: true),
            ConversationCell(name: "Sara", message: "go away",  date: Date(), online: false, hasUnreadMesseges: false),
            ConversationCell(name: "Nplwn", message: "irrfrrfm ok",  date: Date(), online: false, hasUnreadMesseges: true),
            ConversationCell(name: "Cdjrn", message: "frfrrffrfrfr away",  date: Date(), online: false, hasUnreadMesseges: false),
            ConversationCell(name: "Cnfmm", message: "i m rfrwfqff",  date: Date(), online: false, hasUnreadMesseges: true),
            ConversationCell(name: "Eeee", message: "goefwefwefwefaway",  date: Date(), online: false, hasUnreadMesseges: false)
            ]
        
        self.tableUsersList.dataSource = self
        self.tableUsersList.delegate = self
        self.tableUsersList.estimatedRowHeight = 44
        self.tableUsersList.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    
    func numberOfSections(in tableUsersList: UITableView) -> Int
    {return 2}
    
    
    func tableView(_ tableUsersList: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == ONLINE
        {return peersOnline.count}
        else
        {return peersOffline.count}
    }
    
    func tableView(_ tableUsersList: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == ONLINE
        {return "Online"}
        else
        {return "History"}
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var user: ConversationCell
        if indexPath.section == ONLINE
        {
            user = peersOnline[indexPath.row]
        } else
        {
            user = peersOffline[indexPath.row]
        }
        if user.online {
            cell.backgroundColor = UIColor.yellow
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenConversationSegue" {
            if let destination = segue.destination as? ConversationViewController {
                let path = tableUsersList.indexPathForSelectedRow
                let cell = tableUsersList.cellForRow(at: path!) as! CompanionCell
                destination.name = cell.nameLabel.text!
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableUsersList.dequeueReusableCell(withIdentifier: "MessegeCell") as! CompanionCell
        var user: ConversationCell
        if indexPath.section == ONLINE
        {
            user = peersOnline[indexPath.row]
        } else {
            user = peersOffline[indexPath.row]
        }
        cell.nameLabel.text = user.name
        cell.messageLabel.text = user.message
        
        if user.hasUnreadMesseges {
            cell.messageLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
        } else {
            cell.messageLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        }
        
        if user.message == nil
        {
           cell.messageLabel.font = UIFont(name:"Body", size: 14.0)
            cell.messageLabel.text = "No messages yet"
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.timeLabel.text = dateFormatter.string(for: user.date!)
    
        return cell
    }

    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    


}

extension ConversationsListViewController: CommunicatorManagerDelegate {
    func updateConversationList() {
        peersOnline = communicatorManager.getPeersOnline()
        tableUsersList.reloadData()
    }
    func handleCommunicateError(error: Error) {
        print("Error occured during communication \(error)")
    }
}

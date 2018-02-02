//
//  ChatViewController.swift
//  Parse-Chat
//
//  Created by Chris lin on 2/1/18.
//  Copyright © 2018 Chris lin. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageField: UITextField!
    
    var messages:NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        // Auto size row height based on cell autolayout constraints
        messageTableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        messageTableView.estimatedRowHeight = 50
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }

    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        
        chatMessage["text"] = messageField.text ?? ""
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func onTimer(){
        var query = PFQuery(className: "Message")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    self.messages.removeAllObjects()
                    for object in objects {
                        self.messages.add(object)
                    }
                }
                self.messageTableView.reloadData()
            } else {
                // Log details of the failure
                print("Error")
            }
        
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let m = messages[indexPath.row] as! PFObject
        let mes = m.object(forKey: "text") as! String
        cell.chatLabel.text = mes
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

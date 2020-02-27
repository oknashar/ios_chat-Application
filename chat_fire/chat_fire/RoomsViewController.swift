//
//  RoomsViewController.swift
//  chat_fire
//
//  Created by OKNASHAR on 2/27/20.
//  Copyright © 2020 OKNASHAR. All rights reserved.
//

import UIKit
import Firebase
class RoomsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var nameRomeTextField: UITextField!
    
    @IBOutlet weak var roomsTable: UITableView!
    var rooms = [Room]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomsTable.delegate = self
        self.roomsTable.dataSource = self
        observeRooms()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser == nil){
            self.presentLoginScreen()
        }
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.presentLoginScreen()
    }
    
    func presentLoginScreen(){
        let formScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        self.present(formScreen, animated: true, completion: nil)
    }
    
    
    @IBAction func didPressCreateNewRoom(_ sender: Any) {
        guard let roomName = self.nameRomeTextField.text,roomName.isEmpty == false else{
            return
        }
        
        let databaseRef = Database.database().reference()
        let room = databaseRef.child("rooms").childByAutoId()
        let dataArray:[String :Any] = ["roomName":roomName]
        room.setValue(dataArray) { (error, ref) in
            if(error == nil){
                self.nameRomeTextField.text = ""
            }
        }
        
        
    }
    
    func observeRooms(){
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String:Any]{
                if let roomName =  dataArray["roomName"] as? String{
                    let room = Room.init(roomName: roomName)
                    self.rooms.append(room)
                    self.roomsTable.reloadData()
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell")!
        let room = self.rooms[indexPath.row]
        cell.textLabel?.text = room.roomName
        return cell
    }
    
    
   
    
    
}

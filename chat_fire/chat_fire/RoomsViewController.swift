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
 
    
    @IBOutlet weak var roomsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomsTable.delegate = self
        self.roomsTable.dataSource = self
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell")!
        
        cell.textLabel?.text = "Omar"
        return cell
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

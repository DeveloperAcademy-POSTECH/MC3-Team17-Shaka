//
//  WeatherNotificationViewController.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/28.
//

import UIKit

class WeatherNotificationViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "WeatherCell"
    let myData = ["감전", "파도", "태풍"]
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell: UITableViewCell = self.weatherTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
          cell.textLabel?.text = myData[indexPath.row]
          return cell
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
    }
}

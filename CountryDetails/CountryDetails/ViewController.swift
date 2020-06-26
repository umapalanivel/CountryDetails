//
//  ViewController.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView = UITableView()
    var titleLabel :String?
    var countryDetails = [Rows]()
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        title = "PhotoApp"
        networkRequestCall()
        pullToRefresh()
    }
   
    /* intial setting up of tableView*/
    
     func configureTableView() {
            
            tableView = UITableView(frame: self.view.bounds,style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 230
            tableView.showsVerticalScrollIndicator = false
            tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "Cell")
            self.view.addSubview(tableView)
     }
    
    /* fetching data from remote api*/
     func networkRequestCall (){
            
            guard let url = URL(string: Url.apiURL) else{return}
            let networkProcessor = NetworkProcessor(url: url)
            networkProcessor.downLoadJSONFromURL{(results) in
                DispatchQueue.main.async { [unowned self] in
                    print(results.title)
                    self.titleLabel = results.title
                    self.countryDetails = results.rows ?? []
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    /* pull to refresh implemetation*/
     func pullToRefresh() {
          refreshControl = UIRefreshControl()
          refreshControl.attributedTitle = NSAttributedString(string: "Loading")
          refreshControl.addTarget(self, action: #selector(ViewController.populateData), for: UIControl.Event.valueChanged)
          self.tableView.addSubview(refreshControl)
     }
    
     @objc func populateData() {
         self.networkRequestCall()
     }
}

extension ViewController :UITableViewDelegate,UITableViewDataSource {

 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return countryDetails.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CountryTableViewCell
     let detailsList = countryDetails[indexPath.row]
     cell.loadCell(details: detailsList)
     return cell
 }
 
}

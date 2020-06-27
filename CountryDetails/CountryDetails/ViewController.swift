//
//  ViewController.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var titleLabel :String?
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    var countryDetails = [Rows]()
    var dataList : [DataModel]  = [DataModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        networkRequestCall()
        refreshBtn()
        
        //Adding activityIndicator while downloading
               activityIndicator.startAnimating()
               activityIndicator.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(activityIndicator)
               activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
               
    }
   
    /* intial setting up of tableView*/
    
     func configureTableView() {
            tableView.showsVerticalScrollIndicator = false
            tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "Cell")
     }
    
    /* fetching data from remote api*/
     func networkRequestCall (){
            
            guard let url = URL(string: Url.apiURL) else{return}
            let networkProcessor = NetworkProcessor(url: url)
            networkProcessor.downLoadJSONFromURL{(results) in
                DispatchQueue.main.async { [unowned self] in
                    print(results.title)
                    self.activityIndicator.stopAnimating()
                    self.titleLabel = results.title
                    self.title = self.titleLabel
                    self.countryDetails = results.rows ?? []
                    self.loadData()
                    self.tableView.reloadData()
                   }
            }
        }
    /* pull to refresh implemetation*/
     func refreshBtn() {
          //Add reload button
          let rightButton = UIBarButtonItem(title: "Reload", style: UIBarButtonItem.Style.plain, target: self, action: #selector(populateData))
          self.navigationItem.rightBarButtonItem = rightButton
     }
    
     @objc func populateData() {
         activityIndicator.startAnimating()
         self.networkRequestCall()
     }
    
    func loadData()  {
    
            for values in self.countryDetails  {
                 let titles = values.title ?? "No title available"
                 //Loading default description for nil value from json
                 let descriptions = values.description ?? "No Description available"
                      if let imageUrl = URL(string: values.imageHref ?? "nil"){
                                //Place the default image from assets if imageurl not found
                                 let imgdata = try? Data(contentsOf: imageUrl)
                                 if imgdata == nil
                                 {
                                     let img = UIImage(named: "Flag")
                                  self.dataList.append(DataModel(photoImage:img,title: titles,description: descriptions))
                                 }
                                 else
                                 {
                                     let image = UIImage(data: imgdata!)
                                     self.dataList.append(DataModel(photoImage:image,title: titles,description: descriptions))
                                 }
                         
                      
                             
                         }
               }
            
        }
    
    // MARK: - UITableView methods
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryDetails.count
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CountryTableViewCell
         let currentLastItem = dataList[indexPath.row]
         cell.data = currentLastItem
         return cell
    }
       
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
     }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
     }
}


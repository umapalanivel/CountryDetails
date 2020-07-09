//
//  ViewController.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,ViewModelDelegate {
    
    let viewModel = ViewModel()
    var titleLabel :String?
    var activityIndicator = UIActivityIndicatorView(style: .gray)
//    var countryDetails = [Rows]()
//    var dataList : [DataModel]  = [DataModel]()
    var refreshCtrl = UIRefreshControl()
    var image = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.delegate = self
        viewModel.downloadDataFromServer()
        updateUIEvents()
        configureTableView()
        pullToRefresh()
        
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
    
     func updateUIEvents (){
            DispatchQueue.main.async { [unowned self] in
                self.activityIndicator.stopAnimating()
                self.refreshCtrl.endRefreshing()
             }
      }
    
    /* pull to refresh implemetation*/
     func pullToRefresh() {
        refreshCtrl = UIRefreshControl()
        refreshCtrl.attributedTitle = NSAttributedString(string: "Loading")
        refreshCtrl.addTarget(self, action: #selector(ViewController.populateData), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshCtrl)
    }
    
     @objc func populateData() {
         viewModel.downloadDataFromServer()
         self.updateUIEvents()
     }
    
   /*viewmodel delegate method to update UI on main thread and display alertview for error msg*/
  func updateTitle() {
      DispatchQueue.main.async {
          self.title = self.viewModel.titleForViewController
          if(self.viewModel.errorMsg != nil) {
            let alert = UIAlertController(title: "Error", message: self.viewModel.errorMsg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
      }
    }
  
    func didFinishUpdates() {
           DispatchQueue.main.async {
             self.tableView?.reloadData()
           }
    }
    
    // MARK: - UITableView methods
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.dataList.count
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CountryTableViewCell
        let currentLastItem = self.viewModel.dataList[indexPath.row]
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



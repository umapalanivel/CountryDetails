//
//  ViewController.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,ViewModelDelegate{
    let viewModel = ViewModel()
    let NETWORK_OFFLINE = "You are offline! Connect to Internet."
    var titleLabel :String?
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    var refreshCtrl = UIRefreshControl()
    var image = UIImage()
    var isNetworkReachable = false
    let reachability = try? Reachability()
    var cellHeights = [IndexPath: CGFloat]()
    override func viewDidLoad(){
        super.viewDidLoad()
        viewModel.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 93/255.0, green: 188/255.0, blue: 210/255.0, alpha: 1.0)
        /* Network Validation from server is done in NetworkProccessor file to handle negative cases*/
        viewModel.downloadDataFromServer()
        updateUIEvents()
        configureTableView()
        pullToRefresh()
        setupReachabilityHandler()
        //Adding activityIndicator while downloading
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
  
   override func viewWillAppear(_ animated: Bool) {
       NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
       reachability?.whenUnreachable = { _ in
      print("Not reachable")
    }
    do{
      try reachability?.startNotifier()
    }catch{}
  }
    
   /* intial setting up of tableView*/
    func configureTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "Cell")
     }
    
    func updateUIEvents (){
      DispatchQueue.main.async { [unowned  self] in
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
  
   func setupReachabilityHandler(){
      if reachability?.connection == Reachability.Connection.unavailable{
      isNetworkReachable = false
    }else{
      isNetworkReachable = true
    }
  }
    
   @objc func reachabilityChanged(note: Notification){
      let reachability = note.object as! Reachability
      switch reachability.connection {
      case .wifi, .cellular:
        self.isNetworkReachable = true
      case .none, .unavailable:
        self.isNetworkReachable = false
    }
     updateNetworkReachbility()
  }
  
    func updateNetworkReachbility(){
    DispatchQueue.main.async {
       if !self.isNetworkReachable{
         let alert = UIAlertController(title: "No Network", message: self.NETWORK_OFFLINE, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
      }
    }
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
      let  offset:CGPoint = self.tableView!.contentOffset
      self.tableView?.reloadData()
      self.tableView.layoutIfNeeded()
      self.tableView.contentOffset = offset
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
  
  
 

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
      print("Cell height: \(cell.frame.size.height)")
      cellHeights[indexPath] = cell.frame.size.height
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableView.automaticDimension

  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if let height =  self.cellHeights[indexPath] {
      print("Height: \(height)")
      return height
    }
    return UITableView.automaticDimension
  }
  
  
}



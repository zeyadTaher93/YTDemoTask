//
//  ViewController.swift
//  YTDemoTask
//
//  Created by zeyad on 3/24/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: ChannelListViewModel = {
           return ChannelListViewModel()
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }

    func initView() {
        self.navigationItem.title = "YouTube Channels"
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: "ChannelCell")
        tableView.delegate = self
        tableView.dataSource = self
        
       }
    
    func initVM() {
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty, .error:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                case .loading:
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                case .populated:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 1.0
                    })
                }
            }
        }
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()

    }
    func showAlert( _ message: String ) {
           let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
           alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }

}

extension HomeVC: UITableViewDelegate , UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelCell else {
                fatalError("Cell not exists")
            }
            
            let cellVM = viewModel.getCellViewModel( at: indexPath )
            cell.channelCellViewModel = cellVM
            
            return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

}

//
//  CategoriesViewController.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift
import AFNetworking

class CategoriesTableViewController: UITableViewController {

    var dataSource: Results<Category>?
    var isIpadOrIphonePlus: Bool = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.isIpadOrIphonePlus = self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad ||
            (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone && self.traitCollection.displayScale == 3.0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.showDetailTargetDidChange),
                                               name: NSNotification.Name.UIViewControllerShowDetailTargetDidChange,
                                               object: nil)
        let realm = try! Realm()
        
        let loadObjects = { () -> Void in
            
            DispatchQueue.main.async {
                self.dataSource = realm.objects(Category.self)
                self.tableView.reloadData()
            };
        }
        
        let createDatabase = { () -> Void in
            
            let networkHandler: NetworkHandler = NetworkHandler()
            networkHandler.jSonWith("https://www.reddit.com/reddits.json", andReturn: { (dic, error) in
                
                if error == nil
                {
                    let storeHandler: StoreHandler = StoreHandler()
                    storeHandler.createLocalDataBaseWith(dic!)
                    loadObjects()
                }
            });
        }
        
        let manager: AFNetworkReachabilityManager = AFNetworkReachabilityManager.shared()
        manager.setReachabilityStatusChange { (status) in
            
            if status == AFNetworkReachabilityStatus.notReachable
            {
                let message: AGPushNote = AGPushNote()
                message.setDefaultUI()
                message.message = "Funcionando en modo Offline"
                message.iconImage = UIImage(named: "no_wifi")
                message.showAtBottom = true
                
                AGPushNoteView.showNotification(message)
                AGPushNoteView.setCloseAction({})
                AGPushNoteView.setMessageAction({ (pushNote) in })
                loadObjects()
            }
            else
            {
                AGPushNoteView.close(completion: {})
                createDatabase()
            }
        };
        
        manager.startMonitoring()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDetailTargetDidChange(_ notification: Notification) {
        /*
         Whenever the target for showDetailViewController: changes, update all
         of our cells (to ensure they have the right accessory type).
         */
        for cell in tableView.visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                tableView(tableView, willDisplay: cell, forRowAt: indexPath)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       
        return 67.0;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let data = dataSource
        {
            return data.count + 1
        }
        else
        {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let identifier: String = (isIpadOrIphonePlus) ? "CategoryCell_iPad" : "CategoryCell"
        let cell: CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CategoryTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        let categoryCell: CategoryTableViewCell = cell as! CategoryTableViewCell
        
        if (indexPath.row == 0)
        {
            let imageName: String  = (isIpadOrIphonePlus) ? "all_ipad_image" : "all_iphone_image"
            categoryCell.categoryLabel.text = "Mostrar todo"
            categoryCell.categoryImage.image = UIImage(named: imageName)
        }
        else
        {
            let category: Category = dataSource![indexPath.row - 1]
            categoryCell.categoryLabel.text = (category.name == "Undefined") ? "Sin Categoría" : category.name
            categoryCell.categoryImage.image = UIImage(named: category.imageName!)
        }
        
        let showDisclosure: Bool = self.willShowingDetailViewControllerPushWithSender(self)
        categoryCell.accessoryType = (showDisclosure) ? UITableViewCellAccessoryType.disclosureIndicator : UITableViewCellAccessoryType.none
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath: IndexPath? = self.tableView.indexPathForSelectedRow;
        
        if (segue.identifier == "ShowApp")
        {
            let controller: AppsTableViewController = segue.destination as! AppsTableViewController
            controller.category = (indexPath!.row == 0) ? nil : self.dataSource![indexPath!.row - 1];
        }
        else if (segue.identifier == "ShowApp_iPad")
        {
            let navController: UINavigationController =  segue.destination as! UINavigationController
            let controller: AppsCollectionViewController = navController.viewControllers.first as! AppsCollectionViewController
            controller.category = (indexPath!.row == 0) ? nil : self.dataSource![indexPath!.row - 1];
        }
    }
}

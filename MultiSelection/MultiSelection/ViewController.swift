//
//  ViewController.swift
//  MultiSelection
//
//  Created by mac on 26/09/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    var BankArray = NSArray()
    var SelectedBank = NSMutableArray()
    
    var SearchResultArray = NSArray()
    var searchEnabled:Bool = false
    
    let searchBar:UISearchBar = UISearchBar()
    var SearchButtonOutlet = UIBarButtonItem()
    var RefreshBtnOutlet = UIBarButtonItem()

    @IBOutlet weak var tableviewoutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BankArray = ["ICICI Bank", "BOI Bank", "AXIS Bank", "HDFC Bank", "CITY Bank", "PUNJAB Bank","UNION Bank", "SBI Bank","DENA Bank", "PAYTM Bank", "GOOGLE PAY", "PHONE PE", "BHIM", "AMZONE","FLIPKART", "SNAPDEAL"];
        //self.tableviewoutlet.isEditing = true
        
        searchBar.placeholder = "Search Your Bank!"
        searchBar.tintColor = UIColor.blue
        searchBar.returnKeyType = .search
        //searchBar.scopeButtonTitles = ["Name", "Date", "Price", "Location"]
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor.clear
        searchTextField?.textColor = UIColor.orange
        
        searchBar.delegate = self
        
        
        SearchButtonOutlet = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(SearchButtonTap))
        RefreshBtnOutlet = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(RefreshTap))
        
        self.AddSearchBarInNavigationBar()
        
    }
    
    func AddSearchBarInNavigationBar(){
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItems = [RefreshBtnOutlet, SearchButtonOutlet]
    }
    
    @objc func SearchButtonTap(){
        navigationItem.rightBarButtonItems = nil
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        navigationItem.titleView = searchBar
    }
    
    @objc func RefreshTap(){
        SelectedBank.removeAllObjects()
        tableviewoutlet.reloadData()
    }
    
    //MARK: # Search Bar Delegate And Data Source
    
    func updateFilteredContent(forAirlineName airlineName: String?, scope: String?) {
        if airlineName == nil { SearchResultArray = BankArray } else {
            if (scope == "0") {
                let pred = NSPredicate(format: "SELF contains[cd] %@", airlineName!)
                let search = BankArray.filtered(using: pred)
                SearchResultArray = search as NSArray
                tableviewoutlet.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateFilteredContent(forAirlineName: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        print("selectedScope: \(selectedScope)")
        print(searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count ?? 0) == 0 {
            searchEnabled = false
            //searchBar.showsCancelButton = false
            tableviewoutlet.reloadData()
        } else {
            searchEnabled = true
            searchBar.showsCancelButton = true
            navigationItem.rightBarButtonItem = nil
            updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchEnabled = false
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.AddSearchBarInNavigationBar()
        tableviewoutlet.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count ?? 0) == 0 {
            searchBar.resignFirstResponder()
        } else {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            searchEnabled = true
            self.AddSearchBarInNavigationBar()
            updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
        }
    }
    
    func ShowHalfBottomVC(){
        let HalfVC = self.storyboard?.instantiateViewController(withIdentifier: "HalfBottomVC") as! HalfBottomVC
        HalfVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(HalfVC, animated: true, completion: nil)
    }
    
}

//MARK: @ TableView Delegate And Data Source

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchEnabled{
            return SearchResultArray.count
        }else{
            return BankArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiTableViewCell", for: indexPath) as! MultiTableViewCell
        
        //cell.BankNAme.layer.shadowColor = UIColor.orange.cgColor
        //cell.BankNAme.layer.shadowOffset = CGSize(width: 2, height: 2)
        //cell.BankNAme.layer.shadowRadius = 5
        //cell.BankNAme.layer.shadowOpacity = 1
        
        if searchEnabled {
            cell.BankNAme.text = SearchResultArray[indexPath.row] as? String
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if SelectedBank.contains(SearchResultArray[indexPath.row]) {
                cell.ImageOut.image = #imageLiteral(resourceName: "Check")
                cell.emoji.text = "😀"
                cell.conversationSelected = true
            }else{
                cell.ImageOut.image = nil
                cell.emoji.text = "😔"
                cell.conversationSelected = false
            }
        }else{
            cell.BankNAme.text = BankArray[indexPath.row] as? String
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if SelectedBank.contains(BankArray[indexPath.row])  {
                cell.ImageOut.image = #imageLiteral(resourceName: "Check")
                cell.emoji.text = "😀"
                cell.conversationSelected = true
            }else{
                cell.ImageOut.image = nil
                cell.emoji.text = "😔"
                cell.conversationSelected = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MultiTableViewCell
        
        if searchEnabled {
            if cell.conversationSelected == true {
                cell.conversationSelected = false
                cell.ImageOut.image = nil
                cell.emoji.text = "😔"
                SelectedBank.remove(SearchResultArray[indexPath.row])
            }else {
                cell.conversationSelected = true
                cell.ImageOut.image = #imageLiteral(resourceName: "Check")
                cell.emoji.text = "😀"
                SelectedBank.add(SearchResultArray[indexPath.row])
            }
        }else{
            if cell.conversationSelected == true {
                cell.conversationSelected = false
                cell.ImageOut.image = nil
                cell.emoji.text = "😔"
                SelectedBank.remove(BankArray[indexPath.row])
            }else {
                cell.conversationSelected = true
                cell.ImageOut.image = #imageLiteral(resourceName: "Check")
                cell.emoji.text = "😀"
                SelectedBank.add(BankArray[indexPath.row])
            }
        }
    }
    
    //**************************************************************************************************************
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! MultiTableViewCell
        let More =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
            cell.emoji.text = "😎"
        })
        More.image = UIImage(named: "Check")
        More.backgroundColor = .red
        let More2 =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
            cell.emoji.text = "👿"
        })
        More2.image = UIImage(named: "Check")
        More2.backgroundColor = .blue
        let More3 =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
            cell.emoji.text = "🤡"
            self.ShowHalfBottomVC()
        })
        More3.image = UIImage(named: "Check")
        More3.backgroundColor = .lightGray
        let confrigation = UISwipeActionsConfiguration(actions: [More, More2, More3])
        
        return confrigation
    }
    
    
    //**************************************************************************************************************
    
    /*
     // TableView Swap And delete cell for row
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     //tableviewoutlet.reloadData()
     }
     }
     */
    
    //**************************************************************************************************************
    
    /*
     // Tableview Cell Move To Other Index
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
     return .none
     }
     
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
     let movedObject = self.BankArray[sourceIndexPath.row]
     BankArray.remove(at: sourceIndexPath.row)
     BankArray.insert(movedObject, at: destinationIndexPath.row)
     debugPrint("\(sourceIndexPath.row) => \(destinationIndexPath.row)")
     // To check for correctness enable: self.tableView.reloadData()
     }
     */
}


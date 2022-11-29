//
//  ViewController.swift
//  WhiteHouse Petitions
//
//  Created by GGS-BKS on 11/10/22.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)

    }
    var isSearchBarEmpty: Bool {
       return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    var petitions = [Petition]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults = [Petition]()
    override func viewDidLoad() {

        
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Show", style: .done, target: self, action: #selector(restart))
        let urlString:String
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
      
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    self?.parse(json: data)
                }
            }else{
                self?.showError()}
        }
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Petitions"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
    }
    @objc func restart(){
        let ac = UIAlertController(title: "Credits", message: "Data is coming from We the people of API of whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac,animated: true)
    }
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from:json){
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return searchResults.count
        }else{
            return petitions.count
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let petition = petitions[indexPath.row]
        let petition : Petition
        //  let searchResult = searchResults[indexPath.row]
        if isSearchBarEmpty{
            petition = petitions[indexPath.row]
//             petition = searchResults[indexPath.row]
        }
        else{
            petition = searchResults[indexPath.row]
//             petition = petitions[indexPath.row]
        }
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
//        cell.textLabel?.text = searchResult.title
//        cell.detailTextLabel?.text = searchResult.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    func showError(){
        DispatchQueue.main.async {
            [weak self ] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem in loading the feed; please trry again later", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac,animated: true)
        }
    }
    func filterContentForSearchText(_ searchText: String) {
        if searchText == ""{
            searchResults = petitions
        }else{
            searchResults = []
            for x in petitions{
                if x.title.lowercased().contains(searchText.lowercased()){
                    print(x.title)
                    searchResults.append(x)
                }

            }

        }
          tableView.reloadData()
        
        
    }
}


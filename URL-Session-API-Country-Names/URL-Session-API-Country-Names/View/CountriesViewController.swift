import UIKit

class CountriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    var searchText = ""


    var viewModel = CountriesViewModel()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        callApi()
    }
    deinit {
        print("view removed from memory")
    }
    func configure() {
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string : "Loading...")
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender: )), for: .valueChanged)
        tableView.refreshControl = refreshControl
        countrySearchBar.delegate = self
        countrySearchBar.returnKeyType = UIReturnKeyType.done
//        tableView.reloadData()

    }
    @objc func pullToRefresh(sender : UIRefreshControl){
        sender.endRefreshing()
        tableView.reloadData()
    }
    func callApi() {
        viewModel.fetchDataByDelegate()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        countrySearchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
}

extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.countryNames(for: section)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.cityLabel.text = viewModel.cityNames(for: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // or any height that fits your design
    }
    
}
// MARK: ---- VIEWMODEL TO VIEW DELEGATES ---
extension CountriesViewController:CountriesViewModelToViewDelegate{
    func didRecieveCountries() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailToRecieveCountries(error: String) {
        print(error)
    }
}
extension CountriesViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        tableView.reloadData()
    }
}

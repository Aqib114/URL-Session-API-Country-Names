import UIKit

class CountriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel = CountriesViewModel()
    
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
    }
    
    func callApi() {
        viewModel.fetchDataByDelegate()
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

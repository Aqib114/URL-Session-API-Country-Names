import Foundation

class CountriesViewModel {
    
    var countriesDictionary = [String: [Datum]]()
    weak var delegate: CountriesViewModelToViewDelegate?
    var searchText = ""

    deinit {
        print("viewmodel removed")
    }
   
    func fetchDataByDelegate() {
        let urlString = "https://countriesnow.space/api/v0.1/countries/population/cities"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let unwrappedData = data {
                do {
                    let currentResponse = try JSONDecoder().decode(Welcome.self, from: unwrappedData)
                    self.countriesDictionary = Dictionary(grouping: currentResponse.data) { $0.country }
                    self.delegate?.didRecieveCountries()
                } catch let err {
                    self.delegate?.didFailToRecieveCountries(error: err.localizedDescription)
                }
            } else {
                self.delegate?.didFailToRecieveCountries(error: error?.localizedDescription ?? "")
            }
        }
        .resume()
    }
    
    func numberOfSections() -> Int {
        return filteredCountries().count
    }
    
    func countryNames(for section: Int) -> String {
        let countries = filteredCountries()
        return countries[section]
    }
    
    func numberOfRows(in section: Int) -> Int {
        let country = filteredCountries()[section]
        let cities = countriesDictionary[country] ?? []
        return cities.filter {
            searchText.isEmpty || $0.city.lowercased().contains(searchText.lowercased())
        }.count
    }
    
    func cityNames(for indexPath: IndexPath) -> String? {
        let country = filteredCountries()[indexPath.section]
        let cities = countriesDictionary[country]?.filter {
            searchText.isEmpty || $0.city.lowercased().contains(searchText.lowercased())
        }
        return cities?[indexPath.row].city
    }
    
    private func filteredCountries() -> [String] {
        let countries = Array(countriesDictionary.keys).sorted()
        return countries.filter {
            searchText.isEmpty || $0.uppercased().contains(searchText.uppercased())
        }
    }
}

protocol CountriesViewModelToViewDelegate: AnyObject {
    func didRecieveCountries()
    func didFailToRecieveCountries(error: String)
}

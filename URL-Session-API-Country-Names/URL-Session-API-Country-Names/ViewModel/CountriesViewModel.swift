import Foundation


class CountriesViewModel{
    
    var countriesDictionary = [String: [Datum]]()
    weak var delegate: CountriesViewModelToViewDelegate?
    deinit {
        print("viewmodel removed")
    }
    /*func getCountries(completion: @escaping () -> Void) {
     let urlString = "https://countriesnow.space/api/v0.1/countries/population/cities"
     self.fetchData(urlString: urlString) { [weak self] countries, error in
     if let countries {
     self?.countriesDictionary = Dictionary(grouping: countries.data) { $0.country }
     completion()
     } else if let error {
     print("Error fetching countries: \(error)")
     }
     }
     }
     
     func fetchData(urlString : String , completion : @escaping (Welcome? , String?)  -> Void){
     
     guard let url =  URL(string : urlString)
     else
     {
     completion(nil, "Invalid URL")
     return
     }
     URLSession.shared.dataTask(with: url) { data, response, error in
     if let unwrappedData = data {
     do{
     let currentResponse = try JSONDecoder().decode(Welcome.self, from: unwrappedData)
     completion(currentResponse, nil)
     
     }
     catch let err{
     print(err.localizedDescription)
     completion(nil , "Error")
     }
     }else{
     completion(nil , "Error")
     }
     }
     .resume()
     }*/
    func fetchDataByDelegate(){
        let urlString = "https://countriesnow.space/api/v0.1/countries/population/cities"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let unwrappedData = data {
                do{
                    let currentResponse = try JSONDecoder().decode(Welcome.self, from: unwrappedData)
                    self.countriesDictionary = Dictionary(grouping: currentResponse.data) { $0.country }
                    self.delegate?.didRecieveCountries()
                }
                catch let err{
                    self.delegate?.didFailToRecieveCountries(error: err.localizedDescription)
                    
                }
            }else{
                self.delegate?.didFailToRecieveCountries(error: error?.localizedDescription ?? "")
            }
        }
        .resume()
    }
    
    func numberOfSections() -> Int{
        //print("total sections:\(countriesDictionary.keys.count)")
        return countriesDictionary.keys.count
    }
    func countryNames(for section : Int) -> String{
        
        var countries = Array(countriesDictionary.keys)
        countries.sort()
        //print("section tital at \(section) :",countries[section] )
        return countries[section]
    }
    func numberOfRows(in section: Int) -> Int{
        
        let countries = Array(countriesDictionary.keys)
        let country = countries[section]
        let cities = countriesDictionary[country] ?? []
        return cities.count
    }
    func cityNames(for indexPath : IndexPath) -> String?
    {
        var countries = Array(countriesDictionary.keys)
        let country = countries[indexPath.section]
        let cities = countriesDictionary[country] ?? []
        return cities[indexPath.row].city
        
    }
}


protocol CountriesViewModelToViewDelegate:AnyObject{
    func didRecieveCountries()
    func didFailToRecieveCountries(error:String)
}

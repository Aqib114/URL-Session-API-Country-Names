import Foundation

struct Welcome: Codable {
    let error: Bool
    let msg: String
    let data: [Datum]
}
struct Datum: Codable {
    let city, country: String
   
}

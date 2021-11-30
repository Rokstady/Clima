import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double                      // the name of the method should match with the name of the method in the JSON data, which we are copyed from the our API
}

struct Weather: Codable {
    let discription: String
    let id: Int
}

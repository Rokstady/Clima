import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherMAnager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1d0a6c9efb5cdf4cc6f6ce75e71bfa36&units=metric"
    //realy importent to add "https" in our code to secure our connection
    
    var deleagate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat = \(latitude)&lon = \(longitude)"
        performRequest(with: urlString) //Network procces like we did before with CityName, that will trigger our delegate method didUpdateWeather wich will update our temperatureLabel and our condotionImageView
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.deleagate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.deleagate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            deleagate?.didFailWithError(error: error)
            return nil
        }
    }
}

//    func performRequest(urlString: String) {
//
////        1. Create a URLx
//
//        if let url = URL(string: urlString) {
//
////        2. Create a URLSession
//
//            let session = URLSession(configuration: .default)
//
////        3. Give the session a task
//
//           let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
//
////        4. Start the task
//
//            task.resume()
//        }


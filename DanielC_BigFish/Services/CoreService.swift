import Foundation

class CoreService: NSObject {
    
    func sendRequest(request: URLRequest, callback: @escaping (Data?, URLResponse?, Error?)->()){
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            callback(data, response, error)
        }.resume()
    }
}

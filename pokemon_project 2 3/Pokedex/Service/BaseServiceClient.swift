import Foundation

typealias ServiceCallResult = Result<Data, ServiceCallError>

enum ServiceRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

struct ServiceCallError: Error {
    let message: String
    let code: Int?
}

final class BaseServiceClient {
    func get(from url: URL, completion: @escaping (ServiceCallResult) -> ()) {
        // Creat a URL Request and set method/headers
        var request = URLRequest(url: url)     //NOTE:- The default HTTP method is “GET”.
        request.httpMethod = ServiceRequestMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Create the URL Session and the task to perform
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            self?.responseHandler(data: data, response: response, error: error, completion: completion)
        }
        
        // Start the task
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

extension BaseServiceClient {
    // Method to parse  response from `URLSessionDataTask` and complete
    // with something meaningful to the app
    private func responseHandler(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (ServiceCallResult) -> ()) {
        // Check for errors
        if let responseError = error {
            let serviceCallError = ServiceCallError(message: responseError.localizedDescription, code: nil)
            completion(.failure(serviceCallError))
            return
        }
        
        // Check if we can parse response
        guard let httpResponse = response as? HTTPURLResponse else {
            let serviceCallError = ServiceCallError(message: "Could not parse HTTP response", code: nil)
            completion(.failure(serviceCallError))
            return
        }
        
        // Check for response codes outside of 200s (success range)
        guard 200 ... 299 ~= httpResponse.statusCode else {
            let message: String = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            let serviceCallError = ServiceCallError(message: message, code: httpResponse.statusCode)
            completion(.failure(serviceCallError))
            return
        }
        
        // Check if we have data
        guard let responseData = data else {
            let serviceCallError = ServiceCallError(message: "No Data", code: nil)
            completion(.failure(serviceCallError))
            return
        }
        
        // Everything checks out! Completes with `Data`
        completion(.success(responseData))
    }
}

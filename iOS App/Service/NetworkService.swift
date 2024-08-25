import Foundation

final class NetworkService {

    func fetchTodos(completion: @escaping ([TaskEntity]) -> Void) {
        var result: [TaskEntity] = []
        
        guard let url = URL(string: Constants.URL.DUMMY_JSON) else {
            completion(result)
            return
        }

        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(result)
                return
            }
            
            guard let data = data else {
                completion(result)
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let decoder = JSONDecoder()
                    let todosResponse = try decoder.decode(DummyEntity.self, from: data)
                    
                    todosResponse.todos.forEach({ dummy in
                        result.append(
                            .init(id: UUID(),
                                  title: dummy.todo,
                                  isDone: dummy.completed))
                    })
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
        }
        .resume()
    }
    
}

import Foundation

final class NetworkService {
    
    private let storageService = StorageService.shared
    
    func fetchTodos(callback: @escaping () -> ()) {
        
        guard let url = URL(string: Constants.URL.DUMMY_JSON) else {
            callback()
            return
        }
        
        let session = URLSession.shared
        
        let today: Date = .now
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    callback()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    callback()
                }
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let decoder = JSONDecoder()
                    let todosResponse = try decoder.decode(DummyEntity.self, from: data)
                    
                    todosResponse.todos.forEach({ dummy in
                        
                        let task: TaskEntity = .init(
                            id: UUID(),
                            title: dummy.todo,
                            creationDate: today,
                            isDone: dummy.completed)
                        
                        self.storageService.addTask(
                            task: task,
                            completion: { isSuccess in
                                if !isSuccess {
                                    return
                                }
                            })
                    })
                    
                    UserDefaults.standard.setValue(true, forKey: Constants.Defaults.IS_LOADED_DUMMY)
                    
                } catch {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    callback()
                }
            }
        }
        .resume()
    }
    
}

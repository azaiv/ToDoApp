import Foundation

final class NetworkService {
    
    private let storageService = StorageService.shared
    
    func fetchTodos(callback: @escaping () -> ()) {
        
        guard let url = URL(string: Constants.URL.DUMMY_JSON) else {
            parseTodosFromFile(callback: callback)
            return
        }
        
        let session = URLSession.shared
        let today: Date = .now
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.parseTodosFromFile(callback: callback)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.parseTodosFromFile(callback: callback)
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
                    DispatchQueue.main.async {
                        self.parseTodosFromFile(callback: callback)
                    }
                }
                DispatchQueue.main.async {
                    callback()
                }
            }
        }
        .resume()
    }

    
    private func parseTodosFromFile(callback: @escaping () -> ()) {
        guard let filePath = Bundle.main.path(forResource: "todos", ofType: "json") else {
            callback()
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let decoder = JSONDecoder()
            let todosResponse = try decoder.decode(DummyEntity.self, from: data)
            
            let today: Date = .now
            
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
        
        callback()
    }

    
}

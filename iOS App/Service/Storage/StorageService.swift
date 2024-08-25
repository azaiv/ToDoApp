import Foundation
import CoreData

class StorageService {
    
    static let shared = StorageService()
    
    private let context: NSManagedObjectContext

    private init() {
        self.context = CoreDataStack.shared.context
    }

    func addTask(task: TaskEntity,
                 completion: @escaping (Bool) -> Void) {
        context.perform {
            
            let taskObject = TaskObject(context: self.context)
            
            taskObject.id = task.id
            taskObject.title = task.title
            taskObject.details = task.details
            taskObject.creationDate = task.creationDate
            taskObject.isDone = task.isDone
            
            do {
                try self.context.save()
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    func fetchTasks(completion: @escaping ([TaskEntity]) -> Void) {
        context.perform {
            
            let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
            
            do {
                let tasks = try self.context.fetch(request)
                
                var taskEntity: [TaskEntity] = []
                
                tasks.forEach({ task in
                    taskEntity.append(
                        .init(id: task.id,
                              title: task.title,
                              details: task.details,
                              creationDate: task.creationDate,
                              isDone: task.isDone))
                })
                completion(taskEntity)
            } catch {
                print(error.localizedDescription)
                completion([])
            }
        }
    }

    func updateTask(task: TaskEntity, completion: @escaping (Bool) -> Void) {
        
        let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let result = try context.fetch(request)
            
            guard let taskObject = result.first else {
                completion(false)
                return
            }
            
            taskObject.id = task.id
            taskObject.title = task.title
            taskObject.details = task.details
            taskObject.isDone = task.isDone
            
            try context.save()
            
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }

    }

    func deleteTask(task: TaskEntity, completion: @escaping (Bool) -> Void) {
        
        let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            
            guard let taskObject = result.first else {
                completion(false)
                return
            }
            
            self.context.delete(taskObject)
            
            try self.context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
}

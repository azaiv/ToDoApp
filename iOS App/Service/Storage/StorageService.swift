import Foundation
import CoreData

class StorageService {
    
    static let shared = StorageService()
    
    private let context: NSManagedObjectContext
    private let backgroundQueue = DispatchQueue(label: "backgroundTasksQueue", qos: .background)
    
    private init() {
        self.context = CoreDataStack.shared.context
    }

    func addTask(task: TaskEntity, completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            self.context.perform {
                let taskObject = TaskObject(context: self.context)
                
                taskObject.id = task.id
                taskObject.title = task.title
                taskObject.details = task.details
                taskObject.creationDate = task.creationDate
                taskObject.isDone = task.isDone

                do {
                    try self.context.save()
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }

    func fetchTasks(completion: @escaping ([TaskEntity]) -> Void) {
        backgroundQueue.async {
            self.context.perform {
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
                    DispatchQueue.main.async {
                        completion(taskEntity.sorted(by: { $1.creationDate < $0.creationDate }))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
        }
    }

    func updateTask(task: TaskEntity, completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            self.context.perform {
                let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

                do {
                    let result = try self.context.fetch(request)

                    guard let taskObject = result.first else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                        return
                    }

                    taskObject.id = task.id
                    taskObject.title = task.title
                    taskObject.details = task.details
                    taskObject.creationDate = task.creationDate
                    taskObject.isDone = task.isDone

                    try self.context.save()
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }

    func deleteTask(task: TaskEntity, completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            self.context.perform {
                let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

                do {
                    let result = try self.context.fetch(request)

                    guard let taskObject = result.first else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                        return
                    }

                    self.context.delete(taskObject)

                    try self.context.save()
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }
}

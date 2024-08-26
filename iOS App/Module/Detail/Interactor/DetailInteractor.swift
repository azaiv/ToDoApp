import Foundation

protocol DetailInteractorProtocol: AnyObject {
    func getTask() -> TaskEntity
}

class DetailInteractor: DetailInteractorProtocol {

    weak var presenter: DetailPresenterProtocol?
   
    var taskEntity: TaskEntity?
    
    init(taskEntity: TaskEntity?) {
        self.taskEntity = taskEntity
    }
    
    func getTask() -> TaskEntity {
        guard let taskEntity = taskEntity else {
            let newEntity: TaskEntity = .init(
                id: UUID(),
                title: "",
                details: "",
                creationDate: Date(),
                isDone: false)
            self.taskEntity = newEntity
            return newEntity
        }
        
        return taskEntity
    }

}

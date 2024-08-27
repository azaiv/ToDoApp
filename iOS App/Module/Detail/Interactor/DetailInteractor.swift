import Foundation

protocol DetailInteractorProtocol: AnyObject {
    var isEditable: Bool { get }
    func getTask() -> TaskEntity
}

class DetailInteractor: DetailInteractorProtocol {
    
    weak var presenter: DetailPresenterProtocol?
    
    var isEditable: Bool
    var taskEntity: TaskEntity?
    
    init(taskEntity: TaskEntity?) {
        self.taskEntity = taskEntity
        self.isEditable = taskEntity != nil
    }
    
    func getTask() -> TaskEntity {
        guard let taskEntity = taskEntity else {
            let newEntity: TaskEntity = .init(
                id: UUID(),
                title: "",
                details: "",
                creationDate: .now,
                isDone: false)
            self.taskEntity = newEntity
            return newEntity
        }
        return taskEntity
    }
    
}

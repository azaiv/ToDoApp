import Foundation
import CoreData


@objc(TaskObject)
public class TaskObject: NSManagedObject {

}

extension TaskObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskObject> {
        return NSFetchRequest<TaskObject>(entityName: "TaskObject")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var details: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var isDone: Bool

}

extension TaskObject : Identifiable {

}

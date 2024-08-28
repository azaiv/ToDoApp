import XCTest
@testable import ToDoApp

final class StorageServiceTests: XCTestCase {
    
    let storageService = StorageService.shared
    
    var tasks: [TaskEntity] = []
    
    let newTask: TaskEntity = .init(
        id: UUID(),
        title: "new task",
        creationDate: .now,
        isDone: false)

    override func setUpWithError() throws {
        removeAllTasks()
    }

    override func tearDownWithError() throws {
        tasks = []
    }

    func testAddTask() {
        
        let expectation = self.expectation(description: "fetchingTasks")
        
        storageService.addTask(
            task: newTask, 
            completion: { isSuccess in
                self.storageService.fetchTasks(completion: { tasks in
                    self.tasks = tasks
                    expectation.fulfill()
                })
            })
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertTrue(self.tasks.count == 1)
        }
    
    }
    
    func testCompleteTask() {
        
        let expectation = self.expectation(description: "completedTask")
        
        storageService.addTask(task: newTask) { isSuccess in
            guard isSuccess else {
                XCTFail("Failed to add task")
                expectation.fulfill()
                return
            }
            
            self.updateTaskStatusToDone(for: self.newTask.id) { isSuccess in
                guard isSuccess else {
                    XCTFail("Failed to update task status")
                    expectation.fulfill()
                    return
                }
                
                self.storageService.fetchTasks { tasks in
                    if let taskIndex = self.tasks.firstIndex(where: { $0.id == self.newTask.id }) {
                        XCTAssertTrue(self.tasks[taskIndex].isDone)
                    } else {
                        XCTFail("Task not found")
                    }
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testRemoveTask() {
        
        let expectation = self.expectation(description: "removeTask")
        
        storageService.addTask(task: newTask) { isSuccess in
            guard isSuccess else {
                XCTFail("Failed to add task")
                expectation.fulfill()
                return
            }
            
            self.removeTask(withId: self.newTask.id) { isRemoved in
                guard isRemoved else {
                    XCTFail("Failed to remove task")
                    expectation.fulfill()
                    return
                }
                
                self.storageService.fetchTasks { tasks in
                    self.tasks = tasks
                    XCTAssertFalse(self.tasks.contains(where: { $0.id == self.newTask.id }))
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    private func updateTaskStatusToDone(for taskId: UUID, completion: @escaping (Bool) -> Void) {
        self.storageService.fetchTasks { tasks in
            self.tasks = tasks
            guard let index = self.tasks.firstIndex(where: { $0.id == taskId }) else {
                completion(false)
                return
            }
            
            self.tasks[index].isDone = true
            self.storageService.updateTask(task: self.tasks[index]) { isSuccess in
                completion(isSuccess)
            }
        }
    }
    
    private func removeTask(withId taskId: UUID, completion: @escaping (Bool) -> Void) {
        self.storageService.fetchTasks { tasks in
            self.tasks = tasks
            guard let taskToDelete = self.tasks.first(where: { $0.id == taskId }) else {
                completion(false)
                return
            }
            
            self.storageService.deleteTask(task: taskToDelete) { isSuccess in
                completion(isSuccess)
            }
        }
    }
    
    private func removeAllTasks() {
        storageService.fetchTasks(completion: { tasks in
            if !tasks.isEmpty {
                tasks.forEach({ task in
                    self.storageService.deleteTask(task: task,
                                                   completion: { isSuccess in
                        print("Delete task: \(task.title)")
                    })
                })
                
            }
            self.tasks = []
        })
    }

}

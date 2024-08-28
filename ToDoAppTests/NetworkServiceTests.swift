import XCTest
@testable import ToDoApp

final class NetworkServiceTests: XCTestCase {
    
    let storageService = StorageService.shared
    var networkService: NetworkService!
    
    var dummy: [TaskEntity] = []
    
    override func setUpWithError() throws {
        networkService = NetworkService()
        removeAllTasks()
    }
    
    override func tearDownWithError() throws {
        networkService = nil
    }
    
    func testFetchDummy() {
        let expectation = self.expectation(description: "fetchingTasks")
        
        networkService.fetchTodos {
            self.storageService.fetchTasks { tasks in
                self.dummy = tasks
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertTrue(self.dummy.count == 30)
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
            self.dummy = []
        })
    }
    
}

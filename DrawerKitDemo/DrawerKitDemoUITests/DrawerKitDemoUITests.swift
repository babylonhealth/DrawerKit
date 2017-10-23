import XCTest

class DrawerKitDemoUITests: XCTestCase {
    
    var app: XCUIApplication!
    let drawerY: CGFloat = 500.0
    
    enum ElementState: String {
        case exists = "exists == true"
        case notexists = "exists == false"
    }
    
    fileprivate enum Identifiers {
        static let mainCanvas = "mainCanvas"
        static let closeButton = "drawerClose"
        static let drawerTitle = "drawerTitle"
        static let drawerImage = "saturnImage"
    }
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testClickAnywhereToClose() {
        let mainCanvase = app.buttons[Identifiers.mainCanvas]
        XCTAssertFalse(isDrawerOpen())
        mainCanvase.tap()
        XCTAssertTrue(isDrawerOpen())
        XCTAssertFalse(isDrawerFullyOpen())
        
        app.tap()
        XCTAssertFalse(isDrawerOpen())
    }
    
    func testClickButtonToClose() {
        let mainCanvase = app.buttons[Identifiers.mainCanvas]
        XCTAssertFalse(isDrawerOpen())
        mainCanvase.tap()
        XCTAssertTrue(isDrawerOpen())
        XCTAssertFalse(isDrawerFullyOpen())
        
        let closeButton = app.buttons[Identifiers.closeButton]
        closeButton.tap()
        XCTAssertFalse(isDrawerOpen())
    }
    
    func testOpenDrawerAndClose() {
        let mainCanvase = app.buttons[Identifiers.mainCanvas]
        mainCanvase.tap()
        
        let drawer = app.staticTexts[Identifiers.drawerTitle].firstMatch
        let start = drawer.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = mainCanvase.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        start.press(forDuration: 0.05, thenDragTo: end)
        XCTAssertTrue(isDrawerFullyOpen())
        
        drawer.swipeDown()
        XCTAssertFalse(isDrawerFullyOpen())
    }
    
    func testCloseFullyOpenDrawer() {
        let mainCanvase = app.buttons[Identifiers.mainCanvas]
        mainCanvase.tap()
        
        let drawer = app.staticTexts[Identifiers.drawerTitle]
        drawer.swipeUp()

        let closeButton = app.buttons[Identifiers.closeButton]
        closeButton.tap()
        XCTAssertFalse(isDrawerOpen())
        XCTAssertFalse(isDrawerFullyOpen())
    }
    
    private func isDrawerOpen() -> Bool {
        let drawer = app.staticTexts[Identifiers.drawerTitle]
        if tryWaitFor(element: drawer, withState: .exists) {
            return drawer.isHittable
        } else {
            return false
        }
    }
    
    private func isDrawerFullyOpen() -> Bool {
        let image = app.images[Identifiers.drawerImage]
        if tryWaitFor(element: image, withState: .exists) {
            return app.images[Identifiers.drawerImage].frame.origin.y < drawerY
        } else {
            return false
        }
    }
    
    @discardableResult
    private func tryWaitFor(element: XCUIElement, withState state: ElementState, waiting forTimeout: TimeInterval = 5.0) -> Bool {
        let myPredicate = NSPredicate(format: state.rawValue)
        
        let myExpectation = expectation(for: myPredicate, evaluatedWith: element, handler: nil)
        let result = XCTWaiter().wait(for: [myExpectation], timeout: forTimeout) == XCTWaiter.Result.completed
        return result
    }
}

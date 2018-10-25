import XCTest

class DrawerKitDemoUITests: XCTestCase {
    
    var app: XCUIApplication!
    let transitionTimeout: TimeInterval = 1.0
    
    enum ElementState: String {
        case exists = "exists == true"
        case notexists = "exists == false"
    }
    
    fileprivate enum Identifiers {
        static let mainCanvas = "mainCanvas"
        static let closeButton = "drawerClose"
        static let drawerDescription = "drawerDescription"
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
        let mainCanvas = app.buttons[Identifiers.mainCanvas]
        XCTAssertFalse(isDrawerOpen())
        mainCanvas.tap()
        XCTAssertTrue(isDrawerOpen())
        XCTAssertFalse(isDrawerFullyOpen())
        
        app.tap()
        XCTAssertFalse(isDrawerOpen())
    }
    
    func testClickButtonToClose() {
        let mainCanvas = app.buttons[Identifiers.mainCanvas]
        XCTAssertFalse(isDrawerOpen())
        mainCanvas.tap()
        XCTAssertTrue(isDrawerOpen())
        XCTAssertFalse(isDrawerFullyOpen())
        
        let closeButton = app.buttons[Identifiers.closeButton]
        closeButton.tap()
        XCTAssertFalse(isDrawerOpen())
    }
    
    func testOpenDrawerAndClose() {
        let mainCanvas = app.buttons[Identifiers.mainCanvas]
        mainCanvas.tap()
        
        let drawer = app.staticTexts[Identifiers.drawerDescription].firstMatch
        let start = drawer.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = mainCanvas.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        start.press(forDuration: 0.05, thenDragTo: end)
        XCTAssertTrue(isDrawerFullyOpen())

        end.press(forDuration: 0.05, thenDragTo: start)
        XCTAssertFalse(isDrawerFullyOpen())
    }
    
    func testCloseFullyOpenDrawer() {
        let mainCanvas = app.buttons[Identifiers.mainCanvas]
        mainCanvas.tap()
        
        let drawer = app.staticTexts[Identifiers.drawerDescription]
        drawer.swipeUp()

        let closeButton = app.buttons[Identifiers.closeButton]
        closeButton.tap()
        XCTAssertFalse(isDrawerOpen())
        XCTAssertFalse(isDrawerFullyOpen())
    }

    func testTouchesPassthrough() {
        let mainCanvas = app.buttons[Identifiers.mainCanvas]
        mainCanvas.doubleTap()

        let alertButton = app.buttons["Alert"]
        let alert = app.alerts["Alert"]

        XCTAssertTrue(alertButton.isHittable)
        alertButton.tap()

        XCTAssertTrue(alert.exists)
        alert.buttons.firstMatch.tap()

        let drawer = app.staticTexts[Identifiers.drawerDescription].firstMatch
        let start = drawer.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = mainCanvas.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        start.press(forDuration: 0.05, thenDragTo: end)

        XCTAssertFalse(alertButton.isHittable)

        end.press(forDuration: 0.05, thenDragTo: start)

        XCTAssertTrue(alertButton.isHittable)
        alertButton.tap()

        XCTAssertTrue(alert.exists)
        alert.buttons.firstMatch.tap()
    }
    
    private func isDrawerOpen() -> Bool {
        let drawer = app.staticTexts[Identifiers.drawerDescription]
        if tryWaitFor(element: drawer, withState: .exists, waiting: transitionTimeout) {
            return drawer.isHittable
        } else {
            return false
        }
    }
    
    private func isDrawerFullyOpen() -> Bool {
        let image = app.images[Identifiers.drawerImage]
        if tryWaitFor(element: image, withState: .exists, waiting: transitionTimeout) {
            return app.images[Identifiers.drawerImage].frame.minY < app.frame.maxY
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

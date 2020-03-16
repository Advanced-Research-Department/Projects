import UIKit

enum MajorAppState {
    case notInitialized(rootDidLoaded: Bool)
    case active
    case maintenance(hasConfig: Bool)
    case inactive(forceUpdate: Bool)
}

enum AppEvents {
    case rootDidLoad
    // env config
    case environmentConfigUpdated
    case environmentConfigFailed
    // app update available
    case updateShown
    case updateSelected
    case updateCanceled
    // app delegate
    case appWillEnterBackground
    case appDidEnterBackground
    case appWillEnterForeground
    case appDidEnterForeground
}

enum AppUpdateState {
    case none
    case available
    case mandatory
}

class AppState {
    var environmentConfig: EnvironmentConfig?
    class EnvironmentConfig {
        var maintenance: Bool?
    }
    var environmentConfigList: EnvironmentConfigList?
    class EnvironmentConfigList {
        var updateInfo: UpdateInfo?
        class UpdateInfo {
            var state: AppUpdateState = .none
        }
    }
}

class RootNavigator {
    enum Destination {
        case sportsBook
        case update(force: Bool)
        case maintenance
        case poorConnection
    }
    
    func navigate(to destination: Destination) {
        PrintFormatHelper.printLine(text: "navigate to \(destination)", newLine: false)
    }
}

class AppStateMachine {
    let appState: AppState = AppState()
    
    private var majorState: MajorAppState = .notInitialized(rootDidLoaded: false) {
        didSet {
            PrintFormatHelper.printLine(text: "\(oldValue)", newLine: false)
            PrintFormatHelper.printLine(text: "\(majorState)", newLine: false)
        }
    }
    
    let rootNavigator = RootNavigator()
    let reachabilityHelper = ReachabilityHelper()
    
    func process(event: AppEvents) {
        PrintFormatHelper.printLine(text: "\(event)", newLine: true)
        
        switch (majorState, event) {
        // starting event
        case (.notInitialized(rootDidLoaded: false), .rootDidLoad): onRootDidLoad()
        // initializing
        // config failed, no valid example
        case (.notInitialized(rootDidLoaded: true), .environmentConfigFailed): fallthrough
        case (.maintenance(hasConfig: false), .environmentConfigFailed): onFirstEnvironmentConfigFailed()
        // config uploaded
        case (.notInitialized(rootDidLoaded: true), .environmentConfigUpdated): fallthrough
        case (.maintenance, .environmentConfigUpdated): fallthrough
        case (.active, .environmentConfigUpdated): onEnvironmentConfigUpdated()
        // optional update shown
        case (.active, .updateCanceled): fallthrough
        case (.active, .updateSelected): onOptionalUpdateSelected()
            
        default: break
        }
    }
    
    // MARK: - start events
    private func onRootDidLoad() {
        majorState = .notInitialized(rootDidLoaded: true)
        
        if appState.environmentConfig != nil {
            onEnvironmentConfigUpdated()
        }
    }
    
    // MARK: - config updates
    private func onEnvironmentConfigUpdated() {
        let appUpdateState = appState.environmentConfigList?.updateInfo?.state ?? .none
        if appUpdateState == .mandatory {
            rootNavigator.navigate(to: .update(force: true))
            majorState = .inactive(forceUpdate: true)
        } else if appUpdateState == .available, AppUpdateHelper.updateWasShown == false {
            rootNavigator.navigate(to: .update(force: false))
            majorState = .active
        } else if appState.environmentConfig?.maintenance ?? false {
            rootNavigator.navigate(to: .maintenance)
            majorState   = .maintenance(hasConfig: true)
        } else {
            rootNavigator.navigate(to: .sportsBook)
            majorState = .active
        }
    }
    
    private func onFirstEnvironmentConfigFailed() {
        if reachabilityHelper.isReachable {
            if ConfigFailAtemptsHelper.checkMainConfigFailAtemptReachedMax() {
                rootNavigator.navigate(to: .maintenance)
                majorState = .maintenance(hasConfig: false)
            }
        } else {
            rootNavigator.navigate(to: .poorConnection)
        }
    }

    // MARK: - app update
    private func onOptionalUpdateSelected() {
        rootNavigator.navigate(to: .sportsBook)
    }
}

struct AppUpdateHelper {
    static var updateWasShown: Bool = false
}

class ReachabilityHelper {
    var isReachable: Bool = true
}

struct ConfigFailAtemptsHelper {
    static private let maxMainConfigFailAtempt: Int = 3
    static private var mainConfigFailAtempt: Int = 0
    
    static func checkMainConfigFailAtemptReachedMax() -> Bool {
        mainConfigFailAtempt += 1
        return mainConfigFailAtempt > maxMainConfigFailAtempt
    }
}

struct PrintFormatHelper {
    static var lineCompponents = [String]()
    static func printLine(text: String, newLine: Bool) {
        if newLine {
            var msg = ""
            for c in lineCompponents {
                if !c.isEmpty {
                    msg += c.padding(toLength: 50, withPad: " ", startingAt: 0)
                }
            }
            if !msg.isEmpty {
                print(msg)
            }
            lineCompponents.removeAll()
        }
        
        lineCompponents.append(text)
    }
}

let stateMachine = AppStateMachine()
stateMachine.process(event: .appDidEnterForeground)

let environmentConfig = AppState.EnvironmentConfig()
stateMachine.appState.environmentConfig = environmentConfig
stateMachine.process(event: .environmentConfigUpdated)

stateMachine.process(event: .rootDidLoad)

stateMachine.process(event: .appWillEnterBackground)
stateMachine.process(event: .appDidEnterBackground)

stateMachine.process(event: .appWillEnterForeground)
stateMachine.process(event: .appDidEnterForeground)

//stateMachine.process(event: .environmentConfigUpdated)

PrintFormatHelper.printLine(text: "end", newLine: true)

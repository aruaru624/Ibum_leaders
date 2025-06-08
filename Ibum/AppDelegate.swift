import UIKit
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    // AppDelegateのシングルトン参照（必要なら）
    static let shared = AppDelegate()
    
    // ModelContextを外部に渡すために保持
    var modelContext: ModelContext?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // 必要な初期化処理
        return true
    }
}

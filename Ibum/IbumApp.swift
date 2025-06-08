import SwiftUI
import SwiftData

@main
struct IbumApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // AppDelegateとの連携
       @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

       // SwiftData用のModelContainer
       let container: ModelContainer

       init() {
           do {
               container = try ModelContainer(for: Quest.self,Photo.self)
               // AppDelegateにModelContextを渡す
               AppDelegate.shared.modelContext = container.mainContext
           } catch {
               fatalError("ModelContainerの初期化に失敗しました: \(error)")
           }
       }
    
    @StateObject private var isPresentedCamera = isPresenteCamera()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(container)
                .environmentObject(isPresentedCamera)
                
        }
        
    }
        
    
}

func seedInitialDataIfNeeded(modelContext: ModelContext) async {
    let fetchDescriptor = FetchDescriptor<Quest>()
    
    // すでにデータがあれば何もしない
    if let count = try? modelContext.fetchCount(fetchDescriptor), count > 0 {
        return
    }
    
    let items = [
        Quest(title: "笑顔でピース", ids: [], tags: [.kantan,.genki], favorite: false, clear: false),
        Quest(title: "自信のかたまり", ids: [], tags: [.cool,.zensin], favorite: false, clear: false),
        Quest(title: "横顔", ids: [], tags: [.cool,.kao], favorite: false, clear: false),
        Quest(title: "風になびく", ids: [], tags: [.cool], favorite: false, clear: false),
        Quest(title: "お願いの姿勢", ids: [], tags: [.kantan,.zensin], favorite: false, clear: false)
    ]

    for item in items {
        modelContext.insert(item)
    }

    try? modelContext.save()
}


//extension EnvironmentValues {
//    @Entry var isPresentedCamera: Bool = false
//    
//}

import Foundation
import SwiftData

enum TagSet:String,CaseIterable, Codable{
    case kantan = "かんたん"
    case genki = "元気"
    case cool = "クール"
    case fomal = "フォーマル"
    case casual = "カジュアル"
    case johansin = "上半身"
    case zensin = "全身"
    case kao = "顔"
}

struct QuestDatabase{
    let items = [
        Quest(title: "笑顔でピース", ids: [], tags: [.kantan,.genki], favorite: false, clear: false),
        Quest(title: "自信のかたまり", ids: [], tags: [.cool,.zensin], favorite: false, clear: false),
        Quest(title: "横顔", ids: [], tags: [.cool,.kao], favorite: false, clear: false),
        Quest(title: "風になびく", ids: [], tags: [.cool], favorite: false, clear: false),
        Quest(title: "お願いの姿勢", ids: [], tags: [.kantan,.zensin], favorite: false, clear: false)
    ]
}

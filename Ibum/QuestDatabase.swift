import Foundation
import SwiftData

enum TagSet: String, CaseIterable, Codable {
    case kantan = "かんたん"
    case genki = "元気"
    case cool = "クール"
    case fomal = "フォーマル"
    case casual = "カジュアル"
    case johansin = "上半身"
    case zensin = "全身"
    case kao = "顔"
    case suwari = "座り"
    case egao = "笑顔"
    case ushirosugata = "後ろ姿"
    case ugoki = "動き"
    case shisenari = "視線あり"
    case tachisugata = "立ち姿"
    case pose = "ポーズ"
    case oshare = "おしゃれ"
}


struct QuestDatabase{
    let items = [
        Quest(title: "グッジョブ！", ids: [], tags: [.genki, .pose], favorite: false, clear: false),
        Quest(title: "こっちを見て", ids: [], tags: [.shisenari, .kao], favorite: false, clear: false),
        Quest(title: "さわる", ids: [], tags: [.pose, .johansin], favorite: false, clear: false),
        Quest(title: "ドアップ", ids: [], tags: [.kao, .cool], favorite: false, clear: false),
        Quest(title: "パソコンに向かおう", ids: [], tags: [.fomal, .ushirosugata], favorite: false, clear: false),
        Quest(title: "ポケットに手", ids: [], tags: [.cool, .pose], favorite: false, clear: false),
        Quest(title: "もたれかかり座り", ids: [], tags: [.suwari, .casual], favorite: false, clear: false),
        Quest(title: "横顔", ids: [], tags: [.kao, .cool], favorite: false, clear: false),
        Quest(title: "横向き", ids: [], tags: [.ushirosugata, .cool], favorite: false, clear: false),
        Quest(title: "自信のかたまり", ids: [], tags: [.cool, .pose], favorite: false, clear: false),
        Quest(title: "笑顔でピース", ids: [], tags: [.egao, .genki], favorite: false, clear: false),
        Quest(title: "振り向いてみる", ids: [], tags: [.ushirosugata, .pose], favorite: false, clear: false),
        Quest(title: "足元チェック", ids: [], tags: [.oshare, .tachisugata], favorite: false, clear: false),
        Quest(title: "風になびく", ids: [], tags: [.ugoki, .cool], favorite: false, clear: false),
        Quest(title: "壁によりかかる", ids: [], tags: [.suwari, .casual], favorite: false, clear: false)
    ]

}

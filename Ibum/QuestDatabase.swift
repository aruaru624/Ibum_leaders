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

enum rarity: String,  CaseIterable, Codable,Comparable{

    case common  = "a"   // 通常
    case rare = "b"  // ちょっと特別
    case epic   = "c"    // かなり映える
    case legendary  = "d" // 超映える、主役級
    
    // Comparableに準拠すると、この関数を定義しなければならない（定義することで大小比較が可能になる）
    static func < (lhs: rarity, rhs: rarity) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    var order: Int {
            // CaseIterableに準拠すると、allCasesで全caseの配列を取得できる
            return rarity.allCases.firstIndex(of: self) ?? 0
    }
    
}



struct QuestDatabase{
    let items = [
        Quest(
            title: "グッジョブ！",
            ids: [],
            tags: [.genki, .pose],
            favorite: false,
            clear: false,
            explation: "元気よく親指を立てるポジティブなポーズ",
            recommendedPoses: ["ウインクしながら", "軽く前かがみで", "大きく腕を伸ばして"],
            recommendedLocation: "芝生の上で太陽に向かって",
            rarity: .common
        ),
        Quest(
            title: "こっちを見て",
            ids: [],
            tags: [.shisenari, .kao],
            favorite: false,
            clear: false,
            explation: "視線をこちらに向けて印象を強める構図",
            recommendedPoses: ["顎を引いて", "微笑みながら", "斜めから見つめて"],
            recommendedLocation: "木陰でカメラを見つめるとき",
            rarity: .rare
        ),
        Quest(
            title: "さわる",
            ids: [],
            tags: [.pose, .johansin],
            favorite: false,
            clear: false,
            explation: "髪や頬などを軽く触れる自然な仕草",
            recommendedPoses: ["髪に触れる", "頬に手を当てる", "肩に手を置く"],
            recommendedLocation: "風が吹く並木道で",
            rarity: .rare
        ),
        Quest(
            title: "ドアップ",
            ids: [],
            tags: [.kao, .cool],
            favorite: false,
            clear: false,
            explation: "顔を画面いっぱいに映した迫力のある構図",
            recommendedPoses: ["真顔で見つめる", "片目を隠す", "あごに手を添える"],
            recommendedLocation: "木漏れ日の中で静かに見つめるとき",
            rarity: .epic
        ),
        Quest(
            title: "パソコンに向かおう",
            ids: [],
            tags: [.fomal, .ushirosugata],
            favorite: false,
            clear: false,
            explation: "後ろ姿を活かした作業中の雰囲気",
            recommendedPoses: ["タイピングしている手元", "振り返り気味", "メガネをかけて集中"],
            recommendedLocation: "ベンチで作業中のとき",
            rarity: .common
        ),
        Quest(
            title: "ポケットに手",
            ids: [],
            tags: [.cool, .pose],
            favorite: false,
            clear: false,
            explation: "手をポケットに入れたリラックス感のある立ち姿",
            recommendedPoses: ["片手だけ入れる", "斜め立ち", "肩をすくめる"],
            recommendedLocation: "公園の小道を歩く途中",
            rarity: .common
        ),
        Quest(
            title: "もたれかかり座り",
            ids: [],
            tags: [.suwari, .casual],
            favorite: false,
            clear: false,
            explation: "寄りかかった姿勢で脱力感や自然体を演出",
            recommendedPoses: ["足を伸ばす", "腕をだらんと下げる", "頭を預ける"],
            recommendedLocation: "木の根元で休憩しているとき",
            rarity: .rare
        ),
        Quest(
            title: "横顔",
            ids: [],
            tags: [.kao, .cool],
            favorite: false,
            clear: false,
            explation: "輪郭や目元のラインが際立つ横顔の構図",
            recommendedPoses: ["遠くを見る", "うっすら笑う", "伏し目がち"],
            recommendedLocation: "花壇の前で遠くを見るとき",
            rarity: .epic
        ),
        Quest(
            title: "横向き",
            ids: [],
            tags: [.ushirosugata, .cool],
            favorite: false,
            clear: false,
            explation: "体を横に向けた動きのある見せ方",
            recommendedPoses: ["手を組んで", "腰に手を当てて", "足をクロス"],
            recommendedLocation: "小道を歩きながらふと立ち止まったとき",
            rarity: .rare
        ),
        Quest(
            title: "自信のかたまり",
            ids: [],
            tags: [.cool, .pose],
            favorite: false,
            clear: false,
            explation: "堂々とした立ち姿で自信を表現するポーズ",
            recommendedPoses: ["胸を張って", "腕組み", "足を大きく開いて立つ"],
            recommendedLocation: "並木の中央で立ち止まったとき",
            rarity: .epic
        ),
        Quest(
            title: "笑顔でピース",
            ids: [],
            tags: [.egao, .genki],
            favorite: false,
            clear: false,
            explation: "明るく親しみやすい印象を与える笑顔とピース",
            recommendedPoses: ["顔の近くでピース", "ジャンプしながら", "片足立ち"],
            recommendedLocation: "ピクニック中の芝生で",
            rarity: .rare
        ),
        Quest(
            title: "振り向いてみる",
            ids: [],
            tags: [.ushirosugata, .pose],
            favorite: false,
            clear: false,
            explation: "振り返る瞬間を切り取った躍動感ある構図",
            recommendedPoses: ["肩越しに見つめる", "スカートをなびかせる", "髪を払う仕草"],
            recommendedLocation: "小道で声をかけられた瞬間",
            rarity: .epic
        ),
        Quest(
            title: "足元チェック",
            ids: [],
            tags: [.oshare, .tachisugata],
            favorite: false,
            clear: false,
            explation: "下向きの視線と足元がポイントのファッションポーズ",
            recommendedPoses: ["足を交差", "手をポケット", "下を向いて微笑む"],
            recommendedLocation: "木立の前でコーデを確認するとき",
            rarity: .rare
        ),
        Quest(
            title: "風になびく",
            ids: [],
            tags: [.ugoki, .cool],
            favorite: false,
            clear: false,
            explation: "風を受けて動きのあるシルエットを見せるポーズ",
            recommendedPoses: ["スカートを抑える", "腕を広げる", "風に背を向ける"],
            recommendedLocation: "広場で風を感じたとき",
            rarity: .legendary
        ),
        Quest(
            title: "壁によりかかる",
            ids: [],
            tags: [.suwari, .casual],
            favorite: false,
            clear: false,
            explation: "壁によりかかって気を抜いた自然な雰囲気を出す",
            recommendedPoses: ["片膝を立てる", "顔を上げる", "ぼーっとする"],
            recommendedLocation: "木の幹にもたれて座っているとき",
            rarity: .common
        )
    ]


}

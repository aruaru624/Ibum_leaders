import Foundation
import SwiftData
//クエスト
//・タグ
//・お気に入り
//・画像データ
//・クリア済か否か
//・タイトル

@Model
final class Quest {
    var title: String
    var ids: [String]
    var tags: [TagSet]
    var favorite: Bool
    var clear: Bool
    var explation: String
    var recommendedPoses: [String]
    var recommendedLocation: String
    var rarity: rarity {
            didSet {
                rarityOrder = rarity.order
            }
        }
        var rarityOrder: Int
    

    init(
        title: String,
        ids: [String],
        tags: [TagSet],
        favorite: Bool,
        clear: Bool,
        explation: String,
        recommendedPoses: [String],
        recommendedLocation: String,
        rarity: rarity // ⭐️ 追加
    ) {
        self.title = title
        self.ids = ids
        self.tags = tags
        self.favorite = favorite
        self.clear = clear
        self.explation = explation
        self.recommendedPoses = recommendedPoses
        self.recommendedLocation = recommendedLocation
        self.rarity = rarity
        self.rarityOrder = rarity.order
    }
}



import Foundation
import SwiftData
//クエスト
//・タグ
//・お気に入り
//・画像データ
//・クリア済か否か
//・タイトル

@Model
final class Quest{
    var title:String
    var ids:[String]
    var tags:[TagSet]
    var favorite:Bool
    var clear:Bool
    
    init(title: String, ids: [String], tags: [TagSet], favorite: Bool, clear: Bool) {
        self.title = title
        self.ids = ids
        self.tags = tags
        self.favorite = favorite
        self.clear = clear
    }
}


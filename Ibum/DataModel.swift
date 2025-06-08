import Foundation
import SwiftData

//・保存日
//・元画像のデータ
//・スケール
//・中心座標
//・登録SNS

@Model
final class Photo{
    var saveDate:Date
    var photoData:Data
    var scale:Double
    var centerX:Double
    var centerY:Double
    var registerSns:[String]
    var best:Bool
    var questTitle:String
    var id:String
    
    init(saveDate: Date, photoData: Data, scale: Double, centerX: Double, centerY: Double, registerSns: [String], best: Bool, questTitle: String, id: String) {
        self.saveDate = saveDate
        self.photoData = photoData
        self.scale = scale
        self.centerX = centerX
        self.centerY = centerY
        self.registerSns = registerSns
        self.best = best
        self.questTitle = questTitle
        self.id = id
    }
}



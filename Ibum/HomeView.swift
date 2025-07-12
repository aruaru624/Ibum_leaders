import SwiftUI
import SwiftData
import AVFoundation

struct AchivementGaugeStyle:GaugeStyle{
    
    let gaugeWidth:CGFloat = 30
    let gaugeHeight:CGFloat = 30
    
//    let questCount = 20
    
    @State var questCount = 20
    
    @State var questClearCount = 0
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack{
                TimelineView(.animation) { timeline in
                            GeometryReader { geometry in
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: geometry.size.height * (1 - configuration.value)))
                                    
                                    // stride(from: 開始値, to: 終了値, by: 刻み幅)
                                    /// `by`の刻み幅を`to`に追加しないと右側に隙間が発生しちゃう
                                    stride(from: 0, to: geometry.size.width + 1, by: 1).forEach { x in
                                        let time = timeline.date.timeIntervalSince1970
                                        let y = sin(Double(x) / 180.0 * .pi + time * 1.6) * 5 + Double(geometry.size.height  * (1 - configuration.value))
                                        path.addLine(to: CGPoint(x: x, y: CGFloat(y)))
                                    }
                                    
                                    // 波の下半分を塗りつぶす
                                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                                    path.closeSubpath()
                                }
                                .fill(Color(red: 53/255, green: 162/255, blue: 159/255))
                            }
                        }
                VStack{
                    Text("達成度")
                        .font(.system(size: 20))
                        .foregroundStyle(.gray)
                        .padding(.top,10)
                    HStack(alignment: .center){
                        Text(String(Int(configuration.value * 100)))
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundColor(Color("graphColor"))
                        Text("%")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                    }
                }
                
            }.clipShape(Circle())
            
        }
}


struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var context
    
    @StateObject private var isPresentedCamera = isPresenteCamera()
    
    @State  var chosenQuestPhoto:Photo = Photo(saveDate: Date(), photoData: Data(), scale: 1, centerX: 1, centerY: 1, registerSns: [], best: false, questTitle: "", id: "")
    
    @Query(sort:[SortDescriptor(\Quest.rarityOrder, order: .reverse)]) private var quests: [Quest]
    
    @State var flag = false
    @State var questTitle = ""
    @State var chooseQuest : Quest = Quest(
        title: "グッジョブ！",
        ids: [],
        tags: [.genki, .pose],
        favorite: false,
        clear: false,
        explation: "元気よく親指を立てるポジティブなポーズ",
        recommendedPoses: ["ウインクしながら", "軽く前かがみで", "大きく腕を伸ばして"],
        recommendedLocation: "芝生の上で太陽に向かって",
        rarity: .common
    )
    
    let columns = [GridItem(.flexible(),spacing: 10), GridItem(.flexible(),spacing: 10)]
    
    @State private var showViewController = false
    @State private var showDetailView = false
    @State private var showThankView = false
    @State private var showToSettingAlert = false
    
    @State var questSum:Int = 0
    @State var questClearSum:Int = 0
    
    @State private var selectionValue = 1
    
    @State private var questArray : [Quest] = []
    
    var body: some View {
        
        NavigationStack{
            VStack{
                ZStack{
                    ScrollView(.vertical){
                        VStack{
                            HStack(alignment: .center){
                            
                                ZStack(alignment: .center) {
                                    Gauge(value: questSum > 0 ? Double(questClearSum) / Double(questSum) : 0, in: 0 ... 1){}
                                        .gaugeStyle(AchivementGaugeStyle(questCount: questClearSum, questClearCount: questSum))
                                        .frame(idealWidth:200,idealHeight:200)
                                        .padding(10)
                                        .overlay{
                                            Circle()
                                                .stroke(Color(red: 11/255, green: 102/255, blue: 106/255).opacity(0.4),lineWidth:10)
//                                                .fill(.clear)
//                                                .border(.gray.opacity(0.4),width:10)
                                                .frame(idealWidth:200,idealHeight:200)
                                                
                                                .shadow(radius: 2)
//                                                .padding(5)
                                        }
                                        
    //
                                    
                                }
                            }
                            .padding(.bottom,10)
//                            .padding(10)
                            
//                            HStack{
//                                Text("クエスト一覧")
//                                    .fontWeight(.heavy)
//                                    .font(.system(size: 40))
//                                    .foregroundStyle(Color(red: 7/255, green: 25/255, blue: 82/255))
//                                    .padding(.leading,20)
//                                Spacer()
////                                Button(action:)
//                            }
                            
                            
                            LazyVGrid(columns: columns,spacing:10){
                                ForEach(questArray,id:\.self){ quest in
                                    
                                    ZStack{
                                            
                                        UnevenRoundedRectangle(
                                          topLeadingRadius: 0,
                                          bottomLeadingRadius: 0,
                                          bottomTrailingRadius: 0,
                                          topTrailingRadius: 15,
                                          style: .continuous)
                                        .fill(Color(red: 156/255, green: 219/255, blue: 211/255))
                                    
//                                        .fill(.white)
//                                        .stroke(Color("myTectColor"),lineWidth: 2)
                                        .shadow(color:Color("myTectColor").opacity(0.8),radius: 2)
                                    
//                                            .shadow(radius: 2)
                                        
                                        VStack{
                                            
                                            HStack{
                                                
                                                ForEach(quest.tags,id:\.self){tag in
                                                    Text("#" + String(tag.rawValue))
                                                        .fontWeight(.light)
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(Color("myTectColor"))
                                                    
                                                }
                                                
                                                Spacer()
                                                Image(systemName: (quest.favorite ? "star.fill" : "star"))
                                                    .foregroundStyle(quest.favorite ? Color(red: 53/255, green: 162/255, blue: 159/255) : Color("myTectColor"))
                                                    .onTapGesture{
                                                        quest.favorite.toggle()
                                                        do{
                                                            try context.save()
//                                                            print("saved")
                                                        }catch{
                                                            print(error)
                                                        }
                                                    }
                                                    .padding(.top,2.5)

                                            }
//                                            .padding(2)
                                            .padding([.trailing,.leading],5)
                                            
                                            HStack{
                                                Text(String(quest.title))
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 15))
                                                    .foregroundStyle(Color("myTectColor"))
                                                Spacer()
                                            }.padding(.leading,5)
                                            

    //
                                            if  !quest.photos.isEmpty{
                                            
                                                if let currentPhoto = quest.photos.first,
                                                   let uiImage = UIImage(data: currentPhoto.photoData) {
                                                    ZStack{
                                                        Color.white
                                                            .aspectRatio(2/3, contentMode: .fill)
//                                                            .padding(5)
//                                                        Color(red: 200/255, green:200/255, blue: 200/255)
//                                                            .aspectRatio(2/3, contentMode: .fit)
//                                                            
//                                                            .opacity(1.0)
//                                                            .border(Color(red: 200/255, green:200/255, blue: 200/255), width: 1)
//                                                            .padding(5)
                                                    Image(uiImage: uiImage)
                                                            .resizable()
                                                            .aspectRatio(2/3, contentMode: .fit)
                                                            .padding(5)
//                                                            .opacity(1.0)
                                                    }.padding([.bottom,.leading,.trailing],5)
                                                    
                                                }else{
                                                    ZStack{
                                                        Color.white
                                                            .aspectRatio(2/3, contentMode: .fill)
                                                        Color(red: 200/255, green:200/255, blue: 200/255)
                                                            .aspectRatio(2/3, contentMode: .fit)
//                                                            .padding([.leading,.trailing],5)
                                                            .opacity(1.0)
                                                            .border(Color(red: 200/255, green:200/255, blue: 200/255), width: 1)
//                                                            .padding([.leading,.trailing],5)
                                                            .padding(5)
                                                        Image(systemName: "camera")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding([.leading,.trailing],5)
                                                            .scaleEffect(0.4)
                                                            .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                                                        
                                                            
                    
                                                    }.padding([.bottom,.leading,.trailing],5)
                                                }
                                            } else {
                                                ZStack{
                                                    Color.white
                                                        .aspectRatio(2/3, contentMode: .fill)
                                                    Color(red: 200/255, green:200/255, blue: 200/255)
                                                        .aspectRatio(2/3, contentMode: .fit)
                                                        .opacity(1.0)
                                                        .border(Color(red: 200/255, green:200/255, blue: 200/255), width: 1)
                                                        .padding(5)
                                                    if let image = UIImage(named: String(quest.title)){
                                                        
                                                        Image(uiImage:image)
                                                            .resizable()
                                                            .aspectRatio(2/3, contentMode: .fit)
                                                            .padding(5)
                                                            .colorInvert()
                                                        
                                                        
                                                        
                                                        
                                                    }else{
                                                      
                                                        Image(systemName: "camera")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding([.leading,.trailing],5)
                                                            .scaleEffect(0.4)
                                                            .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                                                        
                                                        
                                                        
                                                        
                                                           
                                                        
                                                        
                                                        
                                                    }
                                                } .padding([.bottom,.leading,.trailing],5)
                                                
                                                
                                            }
                                            HStack{
                                                
                                                switch quest.rarity{
                                                case .common:
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.blue)
//                                                            .padding(5)
//                                                        Text("レア度：コモン")
//                                                            .font(.system(size:10))
//                                                            .foregroundStyle(.white)
                                                        //                                                        .backgroundStyle(.blue)
//                                                            .background(.blue)
//                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                            .padding(1)
                                                        HStack(spacing: 0) { // spacingを0に設定
                                                                    Image(systemName: "sparkles") // SF Symbol
                                                                        .font(.caption) // フォントサイズを調整してテキストに合わせる
                                                                        .foregroundColor(.yellow)
                                                            Text("コモン")
                                                                .font(.system(size:12))
                                                                .foregroundStyle(Color("myTectColor"))
                                                            //                                                        .backgroundStyle(.blue)
    //                                                            .background(.blue)
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                .padding(1)
                                                                }
                                                    }
                                                    
//                                                    .fill(.blue)
//
                                                case .rare:
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.green)
//                                                            .padding(5)
//                                                        Text("レア度：レア")
//                                                            .font(.system(size:10))
//                                                            .foregroundStyle(Color("myTectColor"))
//                                                        //                                                        .backgroundStyle(.blue)
////                                                            .background(.blue)
//                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                            .padding(1)
                                                        HStack(spacing: 0) { // spacingを0に設定
                                                                    Image(systemName: "sparkles") // SF Symbol
                                                                        .font(.caption) // フォントサイズを調整してテキストに合わせる
                                                                        .foregroundColor(.yellow)
                                                            Text("レア")
                                                                .font(.system(size:12))
                                                                .foregroundStyle(Color("myTectColor"))
                                                            //                                                        .backgroundStyle(.blue)
    //                                                            .background(.blue)
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                .padding(1)
                                                                }
                                                        
                                                    }
                                                
                                                
                                                case .epic:
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.purple)
//                                                            .padding(5)
                                                        HStack(spacing: 0) { // spacingを0に設定
                                                                    Image(systemName: "sparkles") // SF Symbol
                                                                        .font(.caption) // フォントサイズを調整してテキストに合わせる
                                                                        .foregroundColor(.yellow)
                                                            Text("エピック")
                                                                .font(.system(size:12))
                                                                .foregroundStyle(Color("myTectColor"))
                                                            //                                                        .backgroundStyle(.blue)
    //                                                            .background(.blue)
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                .padding(1)
                                                                }
//                                                        Text("レア度：エピック")
//                                                            .font(.system(size:10))
//                                                            .foregroundStyle(Color("myTectColor"))
//                                                        //                                                        .backgroundStyle(.blue)
////                                                            .background(.blue)
//                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                            .padding(1)
                                                    }
                                                case .legendary:
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.orange)
//                                                            .padding(5)
                                                        HStack(spacing: 0) { // spacingを0に設定
                                                                    Image(systemName: "sparkles") // SF Symbol
                                                                        .font(.caption) // フォントサイズを調整してテキストに合わせる
                                                                        .foregroundColor(.yellow)
                                                            Text("レジェンド")
                                                                .font(.system(size:12))
                                                                .foregroundStyle(Color("myTectColor"))
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                .padding(1)
                                                                }
//                                                        Text("レア度：レジェンド")
//                                                            .font(.system(size:10))
//                                                            .foregroundStyle(Color("myTectColor"))
                                                        //                                                        .backgroundStyle(.blue)
//                                                            .background(.blue)
//                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                            .padding(1)
//                                                            .padding([.bottom,.trailing],3)
                                                    }
                                                default:
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.gray)
//                                                            .padding(5)
                                                        HStack(spacing: 0) { // spacingを0に設定
                                                                    Image(systemName: "sparkles") // SF Symbol
                                                                        .font(.caption) // フォントサイズを調整してテキストに合わせる
                                                                        .foregroundColor(.yellow)
                                                            Text("なし")
                                                                .font(.system(size:12))
                                                                .foregroundStyle(Color("myTectColor"))
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                .padding(1)
                                                                }
                                            
                                                        //                                                        .backgroundStyle(.blue)
//                                                            .background(.blue)
//                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                            .padding(1)
                                                    }
                                                }
                                            }.padding(.leading,50)
                                            .padding([.bottom,.trailing],2)
                                        }
                                        .onTapGesture {
                                            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                                            if  status == .denied{
                                                showToSettingAlert.toggle()
                                            }
                                            if status == AVAuthorizationStatus.authorized {
                                                questTitle = quest.title
                                                chooseQuest = quest
                                                print(quests.first)
                                                
                                                if(!quest.photos.isEmpty){
                                          
                                                        if let currentPhoto = quest.photos.first,
                                                           let uiImage = UIImage(data: currentPhoto.photoData) {
                                                            chosenQuestPhoto = currentPhoto
                                                            showDetailView = true
                                                        }
                                                    
                                                    
                                                    
                                                }else{
//                                                    showViewController = true
                                                    showThankView = true
                                                }
                                                print("aaaaafsdf")
                                            }else{
                                                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                                                })
                                            }
                                        }
                                    }
//                                    .padding([.trailing,.bottom],10)
//                                    .padding([.leading,.top],5)
//                                    .padding(((questArray.firstIndex(of: quest)!) % 2 == 0) ? (.leading,5) : (.trailing,5))
//                                    .padding(.bottom,5)
                                    .padding(.leading, (questArray.firstIndex(of: quest)!) % 2 == 0 ? 10 : 0)
                                    .padding(.trailing, (questArray.firstIndex(of: quest)!) % 2 == 0 ? 0 : 10)
                                    
                                    
                                    
                                }
                                
                            }
                        }
                        
                        .onAppear{
                            let questdatabase = QuestDatabase()
                            if quests.isEmpty{
                                for item in questdatabase.items{
                                    context.insert(item)
                                }
                                print("saved2")
                            }
                            do{
                                try context.save()
                                print("saved")
                            }catch{
                                print(error)
                            }
                            
                            questSum = quests.count
                            questClearSum = quests.filter { !$0.photos.isEmpty }.count
                            
                            questArray = quests
                        }
                        .onChange(of:quests){
                            questSum = quests.count
                            questClearSum = quests.filter { !$0.photos.isEmpty }.count
                            
                            questArray = quests
                        }
                       
                    }
//                    .toolbar{
//                        ToolbarItem{
//                            Menu {
//                                Button("標準", action: {
////                                    quests = FetchDescriptor<Quest>(
////                                    questArray = quests
////                                    questArray.sort(by: {$0.questTitle < $1.questTitle})
//                                })
//                                Button("お気に入り", action: {
////                                    questArray = quests
////                                    let arr = questArray.filter { $0.favorite == true}
////                                    questArray = arr
//                                })
//                                Button("レア度順", action: {
//                                    
//                                })
//                            } label: {
//                                Label("", systemImage: "list.bullet")
//                            }
//                        }
//                    }
                    .navigationTitle("クエスト一覧")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationDestination(isPresented: $showViewController){
                        CameraView(quest: $questTitle,isActive: $showViewController)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle($questTitle)
                    }
                    .sheet(isPresented:$showDetailView){
                        DetailView(photo: $chosenQuestPhoto,title:chosenQuestPhoto.questTitle,clearSum:$questClearSum)
                    }
                    .alert("カメラ使用不可",isPresented: $showToSettingAlert){
                        Button("戻る"){}
                        Button("設定へ"){
                            
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }message:{
                        Text("カメラの使用を許可してください")
                    }
                    ZStack{
                        Rectangle()
                            .fill(.black)
                            .opacity(0.7)
                            .ignoresSafeArea()
//                            .opacity(flag ? 1 : 0)
                        RoundedRectangle(cornerRadius: 10)
                            .padding(40)
                            .foregroundStyle(.white)
                        
//                            .background(.white)
                        VStack{
                            HStack{
                                Button(action:{
                                    showThankView = false
                                }){
                                    Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .font(.title)
                                            .padding(.leading,5)
        //                            ZStack{
        //                                Circle()
        //                                Image(systemName: "")
        //                            }
                                }
                                Spacer()
                            }
                            Text("撮影よろしくお願いします")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .padding(5)
                            Text("↓のシルエットに当てはめて撮影")
                                .foregroundStyle(.black)
//                            Text(chooseQuest.recommendedLocation)
                            if let image = UIImage(named: String(chooseQuest.title)){
                                Image(uiImage:image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.gray,lineWidth: 2)
                                    }
                            }
                            Button(action: {
                                showThankView = false
                                showViewController = true
                            }){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                                        .padding(10)
                                        .frame(height:70)
                                    Text("撮影する")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .padding(20)
                                }
                                
                            }
                            
                        }
                        .padding(50)
                        
                        
                    }.opacity(showThankView ? 1 : 0)
                }
            }
            
            
            
            
        }
        
    }
}

class isPresenteCamera: ObservableObject {
    
    @Published var isOn = true
    
}


extension Color {
    
    static func rgbColor(red:Int,green:Int,blue:Int) -> Color {
        return self.init(red: Double(red/255), green: Double(green/255), blue: Double(blue/255))
    }
}

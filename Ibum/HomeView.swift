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
                        .foregroundColor(Color("graphColor"))
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
    @State private var isShowDialog = false
    
    @State var questSum:Int = 0
    @State var questClearSum:Int = 0
    
    @State private var selectionValue = 1
    
    @State private var questArray : [Quest] = []
    
    @State var img:UIImage?
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Image("43475")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.6)
                
                
                ScrollView(.vertical){
                    VStack{
                        HStack(alignment: .center){
                            
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(.white)
                                    .frame(idealWidth:200,idealHeight:200)
                                    .padding(5)
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
                        .padding(.top,50)
                        Text("クエスト一覧")
                            .font(.title)
                            .fontWeight(.bold)
                            .font(.system(size: 30))
//                            .foregroundStyle(Color(""))
                        LazyVGrid(columns: columns,spacing:10){
                            ForEach(questArray,id:\.self){ quest in
                                ZStack{
                                    switch quest.rarity{
                                    case .common:
                                        LinearGradient(colors: [.blue,Color("mainColor")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        
                                    case .rare:
                                        LinearGradient(colors: [.green,Color("mainColor")], startPoint: .top, endPoint: .bottom)
                                        
                                        
                                    case .epic:
                                        LinearGradient(colors: [.purple,Color("mainColor")], startPoint: .top, endPoint: .bottom)
                                    case .legendary:
                                        LinearGradient(colors: [.orange,Color("mainColor")], startPoint: .top, endPoint: .bottom)
                                    default:
                                        LinearGradient(colors: [.blue,Color("mainColor")], startPoint: .top, endPoint: .bottom)
                                    }
                                    VStack(spacing:0){
                                        ZStack{
                                            Rectangle()
                                                .fill(Color("myTectColor"))
                                            Text(String(quest.title))
                                                .fontWeight(.semibold)
                                                .font(.system(size: 20))
                                                .foregroundStyle(rarityColor(quest.rarity))
                                        }
                                        .padding([.leading,.trailing,.top],5)
                                        .frame(height:40)
                                        ZStack{
                                            if  !quest.photos.isEmpty{
                                                
                                                if let currentPhoto = quest.photos.first,
                                                   let uiImage = UIImage(data: currentPhoto.photoData) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .aspectRatio(2/3, contentMode: .fit)
//                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                        .padding(4)
                                                    
                                                }
                                            }else{
                                                if let image = UIImage(named: String(quest.title)){
                                                    Color(red: 200/255, green:200/255, blue: 200/255)
                                                        .aspectRatio(2/3, contentMode: .fit)
                                                        .opacity(1.0)
                                                    Image(uiImage:image)
                                                        .resizable()
                                                        .aspectRatio(2/3, contentMode: .fit)
                                                        .colorInvert()
                                                    Image(systemName: "plus")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .scaleEffect(0.2)
                                                        .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                                                }else{
                                                    Color(red: 200/255, green:200/255, blue: 200/255)
                                                        .aspectRatio(2/3, contentMode: .fit)
                                                        .opacity(1.0)
                                                    Image(systemName: "plus")
                                                        .resizable()
                                                        .scaledToFit()
                                                    
                                                        .scaleEffect(0.2)
                                                        .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                                                }
                                            }
                                            
                                        }
                                        .padding([.leading,.trailing],5)
                                        ZStack{
                                            Rectangle()
                                                .fill(Color("myTectColor"))
                                            HStack{
                                                ForEach(quest.tags,id:\.self){tag in
                                                    Text("#" + String(tag.rawValue))
                                                        .fontWeight(.light)
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.white)
                                                    
                                                }
                                            }
                                            
                                            
                                        }
                                        .padding([.leading,.trailing,.bottom],5)
                                        .frame(height:30)
                                    }.clipShape(RoundedRectangle(cornerRadius: 10))
                                    
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
//                                                showDetailView = true
                                                isShowDialog = true
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
                                .padding(.leading, (questArray.firstIndex(of: quest)!) % 2 == 0 ? 5 : 0)
                                .padding(.trailing, (questArray.firstIndex(of: quest)!) % 2 == 0 ? 0 : 5)
                                .confirmationDialog(questTitle, isPresented: $isShowDialog, titleVisibility: .visible) {
                                    Button("写真を追加する") {
                                        showThankView = true
                                    }
                                    Button("詳細を見る") {
                                        showDetailView = true
                                    }
                                } message: {
                                    Text("写真が既に\(chooseQuest.photos.count)枚追加されています")
                                }


                            }
                            
                            
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    
                }
                ZStack{
                    Rectangle()
                        .fill(.black)
                        .opacity(0.7)
                        .ignoresSafeArea()
                    //                            .opacity(flag ? 1 : 0)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: UIScreen.main.bounds.width - 80)
                        .frame(maxWidth: UIScreen.main.bounds.height - 100)
                        .padding(50)
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
                    .frame(maxWidth: UIScreen.main.bounds.width - 100)
                    .frame(maxWidth: UIScreen.main.bounds.height - 100)
                    
                    
                }.opacity(showThankView ? 1 : 0)
            }
//            .frame(height: UIScreen.main.bounds.height)
            
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
            
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showViewController){
                CameraView(quest: $questTitle,isActive: $showViewController)
//                CameraCaptureView(image: $img)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle($questTitle)
                //                        ImagePickerView()
            }
            .sheet(isPresented:$showDetailView){
                DetailView(photo: $chosenQuestPhoto,title:chosenQuestPhoto.questTitle,clearSum:$questClearSum,photos:chooseQuest.photos)
            }
            .alert("カメラ使用不可",isPresented: $showToSettingAlert){
                Button("戻る"){}
                Button("設定へ"){
                    
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }message:{
                Text("カメラの使用を許可してください")
            }
            
            
            //                    .scaledToFit()
        }
        
    }
    
    func rarityColor(_ rarity: rarity) -> Color {
        switch rarity {
        case .common: return .blue
        case .rare: return .green
        case .epic: return .purple
        case .legendary: return .orange
        default: return .blue
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

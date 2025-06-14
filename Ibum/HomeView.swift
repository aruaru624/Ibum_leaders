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
                                .fill(.blue)
                            }
                        }
                HStack(alignment: .center){
                    Text(String(Int(configuration.value * 100)))
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                    Text("%")
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
    @Query private var quests: [Quest]
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
    
    let columns = [GridItem(.flexible(),spacing: 0), GridItem(.flexible(),spacing: 0)]
    
    @State private var showViewController = false
    @State private var showDetailView = false
    @State private var showThankView = false
    
    @State var questSum:Int = 0
    @State var questClearSum:Int = 0
    
    var body: some View {
        
        NavigationStack{
            VStack{
                ZStack{
                    ScrollView(.vertical){
                        VStack{
                            HStack(alignment: .center){
                                Text("達成率")
                                    .monospaced()
                                    .font(.system(size: 30))
                                    .padding(.leading,30)
                                ZStack(alignment: .center) {
                                    Gauge(value: questSum > 0 ? Double(questClearSum) / Double(questSum) : 0, in: 0 ... 1){}
                                        .gaugeStyle(AchivementGaugeStyle(questCount: questClearSum, questClearCount: questSum))
                                        .frame(idealWidth:200,idealHeight:200)
                                        .padding(10)
                                        .overlay{
                                            Circle()
                                                .stroke(.gray.opacity(0.4),lineWidth:10)
//                                                .fill(.clear)
//                                                .border(.gray.opacity(0.4),width:10)
                                                .frame(idealWidth:200,idealHeight:200)
                                                
                                                .shadow(radius: 3)
//                                                .padding(5)
                                        }
                                        
    //
                                    
                                }
                            }
                            .padding(10)
                            
                            LazyVGrid(columns: columns,spacing:0){
                                ForEach(quests,id:\.self){ quest in
                                    
                                    ZStack{
                                        switch quest.rarity {
                                        case .common:
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 0,
                                                bottomTrailingRadius: 0,
                                                topTrailingRadius: 15,
                                                style: .continuous)
                                            .fill(.blue)
                                            .offset(x:5,y:5)
                                        case .rare:
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 0,
                                                bottomTrailingRadius: 0,
                                                topTrailingRadius: 15,
                                                style: .continuous)
                                            .fill(.green)
                                            .offset(x:5,y:5)
                                        case .epic:
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 0,
                                                bottomTrailingRadius: 0,
                                                topTrailingRadius: 15,
                                                style: .continuous)
                                            .fill(.purple)
                                            .offset(x:5,y:5)
                                        case .legendary:
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 0,
                                                bottomTrailingRadius: 0,
                                                topTrailingRadius: 15,
                                                style: .continuous)
                                            .fill(.orange)
                                            .offset(x:5,y:5)
                                        default:
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 0,
                                                bottomTrailingRadius: 0,
                                                topTrailingRadius: 15,
                                                style: .continuous)
                                            .fill(.gray)
                                            .offset(x:5,y:5)
                                        }
                                            
                                        UnevenRoundedRectangle(
                                          topLeadingRadius: 0,
                                          bottomLeadingRadius: 0,
                                          bottomTrailingRadius: 0,
                                          topTrailingRadius: 15,
                                          style: .continuous)
                                        .fill(Color(red: 31/255, green: 37/255, blue: 54/255))
//                                            .shadow(radius: 2)
                                        
                                        VStack{
                                            
                                            HStack{
                                                
                                                ForEach(quest.tags,id:\.self){tag in
                                                    Text("#" + String(tag.rawValue))
                                                        .fontWeight(.light)
                                                        .font(.system(size: 10))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Spacer()
                                                Image(systemName: (quest.clear ? "star.fill" : "star"))
                                                    .foregroundStyle(.white)

                                            }
                                            .padding(10)
                                            
                                            Text(String(quest.title))
                                                .fontWeight(.semibold)
                                                .font(.system(size: 20))
                                                .foregroundStyle(.white)

    //                                            .padding([.top],10)
                                            if let idd = quest.ids.first{
                                                let descriptor = FetchDescriptor<Photo>(predicate: #Predicate<Photo>{$0.id == idd})
                                                if let currentPhoto = try! context.fetch(descriptor).first as? Photo,
                                                   let uiImage = UIImage(data: currentPhoto.photoData) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .aspectRatio(2/3, contentMode: .fill)
                                                        .padding(10)
                                                        .clipShape(UnevenRoundedRectangle(
                                                            topLeadingRadius: 0,
                                                            bottomLeadingRadius: 15,
                                                            bottomTrailingRadius: 0,
                                                            topTrailingRadius: 0,
                                                            style: .continuous))
                                                }
                                            } else {
                                                if let image = UIImage(named: String(quest.title)){
                                                    Image(uiImage:image)
                                                        .resizable()
                                                        .aspectRatio(2/3, contentMode: .fill)
                                                        .padding(10)
                                                        .clipShape(UnevenRoundedRectangle(
                                                            topLeadingRadius: 0,
                                                            bottomLeadingRadius: 15,
                                                            bottomTrailingRadius: 0,
                                                            topTrailingRadius: 0,
                                                            style: .continuous))
                                                        .overlay{
                                                            UnevenRoundedRectangle(
                                                                topLeadingRadius: 0,
                                                                bottomLeadingRadius: 15,
                                                                bottomTrailingRadius: 0,
                                                                topTrailingRadius: 0,
                                                                style: .continuous)
                                                            .fill(.clear)
                                                            .border(.white, width: 2)
                                                            .padding(10)
                                                            
                                                        }
                                                }else{
                                                    ZStack{
                                                        Color.clear
                                                            .aspectRatio(2/3, contentMode: .fit)
                                                            .padding(10)
                                                        Image(systemName: "camera")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding(10)
                                                            .scaleEffect(0.4)
                                                            .foregroundStyle(.blue)
                                                        
                                                            
                                                            
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                            }
                                        }
                                        .onTapGesture {
                                            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                                            if status == AVAuthorizationStatus.authorized {
                                                questTitle = quest.title
                                                chooseQuest = quest
                                                print(quests.first)
                                                
                                                if(!quest.ids.isEmpty){
                                                    if let idd = quest.ids.first{
                                                        let descriptor = FetchDescriptor<Photo>(predicate: #Predicate<Photo>{$0.id == idd})
                                                        if let currentPhoto = try! context.fetch(descriptor).first as? Photo{
                                                            chosenQuestPhoto = currentPhoto
                                                            showDetailView = true
                                                        }
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
                                    .padding([.trailing,.bottom],10)
                                    .padding(.leading,5)
                                    
                                    
                                    
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
                            questClearSum = quests.filter { !$0.ids.isEmpty }.count
                        }
                        
                       
                    }
                    
                    .navigationTitle("クエスト一覧")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationDestination(isPresented: $showViewController){
                        CameraView(quest: $questTitle,isActive: $showViewController)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle($questTitle)
                    }
                    .sheet(isPresented:$showDetailView){
                        DetailView(photo: $chosenQuestPhoto,title:chosenQuestPhoto.questTitle)
                    }
                    ZStack{
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
                                            .padding(.leading,10)
        //                            ZStack{
        //                                Circle()
        //                                Image(systemName: "")
        //                            }
                                }
                                Spacer()
                            }
                           
                            Text("撮影ありがとうございます！")
                            Text("クエスト：" + String(chooseQuest.title))
                            Text(chooseQuest.recommendedLocation)
                            if let image = UIImage(named: String(chooseQuest.title)){
                                Image(uiImage:image)
                                    .resizable()
                                    .scaledToFit()
                            }
                            Button(action: {
//                                flag = true
//                                add()
                                showThankView = false
                                showViewController = true
                            }){
                                Text("撮影する")
//                                    .frame(width: width / 2 ,height: 50)
//                                    .font(.system(size: 30))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .background(Color(red: 53/255, green: 162/255, blue: 159/255))
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(10)
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

import SwiftUI
import SwiftData
import AVFoundation

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
    
    let columns = [GridItem(.flexible(),spacing: 0), GridItem(.flexible(),spacing: 0)]
    
    @State private var showViewController = false
    @State private var showDetailView = false
    
    @State var questSum:Int = 0
    @State var questClearSum:Int = 0
    
    var body: some View {
        
        NavigationStack{
            VStack{

                
                    
                
                ZStack{
//                    Color(red: 188/255, green: 219/255, blue: 223/255)
//                        .opacity(0.91)
//                        .ignoresSafeArea()
//                    LinearGradient(gradient: Gradient(colors: [Color.white,Color(red: 151/255, green: 254/255, blue: 237/255),Color.white]),startPoint: .top, endPoint: .bottom)
//                        .ignoresSafeArea()
                    ScrollView(.vertical){
                        VStack{
                            ZStack(alignment: .leading) {
                                Gauge(value: questSum > 0 ? Double(questClearSum) / Double(questSum) : 0, in: 0 ... 1){}
                                    .gaugeStyle(.linearCapacity)
                                    .padding([.leading,.trailing],30)
                                    .padding([.top,.bottom],30)
                                
                            }
                            LazyVGrid(columns: columns,spacing:0){
                                ForEach(quests,id:\.self){ quest in
                                    
                                    ZStack{
                                        UnevenRoundedRectangle(
                                          topLeadingRadius: 0,
                                          bottomLeadingRadius: 15,
                                          bottomTrailingRadius: 0,
                                          topTrailingRadius: 15,
                                          style: .continuous)
                                        .fill(.red)
                                            .offset(x:5,y:5)
                                        UnevenRoundedRectangle(
                                          topLeadingRadius: 0,
                                          bottomLeadingRadius: 15,
                                          bottomTrailingRadius: 0,
                                          topTrailingRadius: 15,
                                          style: .continuous)
                                        .fill(Color(red: 31/255, green: 37/255, blue: 54/255))
//                                            .padding(5)
                                            .shadow(radius: 2)
                                        
                                            
         
    //                                        .frame(width:UIScreen.main.bounds.width / 2 - 15)
                                        //                                    .background()
                                        
//                                            .overlay(
//                                        UnevenRoundedRectangle(
//                                          topLeadingRadius: 0,
//                                          bottomLeadingRadius: 20,
//                                          bottomTrailingRadius: 0,
//                                          topTrailingRadius: 20,
//                                          style: .continuous)
//
//                                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 151/255, green: 254/255, blue: 237/255),Color(red: 53/255, green: 162/255, blue: 159/255)]),startPoint: .top, endPoint: .bottom), lineWidth: 3)
////                                                    .stroke(Color(red: 53/255, green: 162/255, blue: 159/255), lineWidth: 1)
////                                                    .shadow(radius: 2)
//    
//                                            )
                                        
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
                                                        .scaledToFit()
                                                        .frame(width: 100,height:100)
    //                                                    .padding(20)
//                                                        .padding(.bottom,20)
                                                        .padding([.top,.bottom],10)
                                                        .clipShape(Circle())
                                                        .shadow(radius: 3)
                                                }
                                            } else {
                                                if let image = UIImage(named: String(quest.title)){
                                                    Image(uiImage:image)
//                                                        .background(.)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100,height:100)
                                                        .padding([.top,.bottom],10)
                                                        .clipShape(Circle())
                                                        .shadow(radius: 3)
                                                        .foregroundStyle(.white)
//                                                        .foregroundStyle(
//                                                           .clear
//                                                             .shadow(.inner(color: .white.opacity(0.3), radius: 3, x: 1, y: 1))
//    //                                                         .shadow(.drop(radius: 5, x: 5, y: 5))
//                                                         )
    //                                                    .fill(.white)
    //                                                    .shadow(.inner(color: .black, radius: 10, x: 0, y: 0))
                                                        .overlay() {
                                                            ZStack{
                                                                Image(systemName: "camera")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .scaleEffect(0.4)
                                                                    .frame(width: 100,height:100)
    //                                                                .padding(20)
                                                                    .padding([.top,.bottom],10)
                                                                    .foregroundStyle(.blue)
                                                                Circle()
    //                                                                .stroke(.gray, lineWidth: 1)
                                                                    .frame(width: 100)
                                                                    .padding([.top,.bottom],10)    //                                                                .foregroundStyle(
    //                                                                   .clear
    //                                                                     .shadow(.inner(color: .black, radius: 10, x: 0, y: 0))
    //            //                                                         .shadow(.drop(radius: 5, x: 5, y: 5))
    //                                                                 )
    //                                                                .shadow(.inner(color: .black, radius: 10, x: 0, y: 0))
                                                                
    //                                                                .foregra

    //                                                                .padding(20)
                                                            }
                                                            
                                                            
                                                        }
                                                }else{
                                                    Image(systemName: "camera")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .scaleEffect(0.4)
                                                        .frame(width: 100,height:100)
    //                                                    .padding(20)
//                                                        .padding(.bottom,20)
                                                        .clipShape(Circle())
                                                        .shadow(radius: 3)
                                                        .foregroundStyle(.blue)
                                                        .padding([.top,.bottom],10)
                                                        .overlay() {
                                                            Circle()
                                                                .stroke(.gray, lineWidth: 1)
                                                                .frame(width: 100)
                                                                .padding([.top,.bottom],10)
    //                                                            .padding(20)
                                                            
                                                        }
                                                    
                                                    
                                                }
                                                
                                                
                                            }
                                            Text("Lv.1")
                                                .fontWeight(.medium)
                                                .foregroundStyle(.white)
                                            Gauge(value:0.5, in: 0 ... 1){}
                                                .gaugeStyle(.linearCapacity)
                                                .padding([.leading,.trailing],10)
                                                .padding(.bottom,20)
//                                                .a
                                        }
    //                                    .frame(width:UIScreen.main.bounds.width / 2 - 15 , height: (UIScreen.main.bounds.width / 2 - 15) / 4 * 5)
                                        .onTapGesture {
                                            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                                            if status == AVAuthorizationStatus.authorized {
                                                questTitle = quest.title
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
                                                    showViewController = true
                                                }
                                                //                                isPresented = true
                                                //                                    isPresentedCamera.isOn = true
                                                print("aaaaafsdf")
                                                
                                                
                                                
                                            }else{
                                                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                                                    //                                        showViewController = true
                                                })
                                            }
                                        }
                                    }.padding(10)
                                    
                                    
                                    
                                    
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
//                            var sum = 0
//                            for quest in quests {
//                                if !quest.ids.isEmpty{
//                                    sum += 1
//                                }
//                            }
//                            questClearSum = sum
//
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
                    
                }
            }
            
            
            
            
        }
        
    }
}
//#Preview {
//    HomeView()
//}

class isPresenteCamera: ObservableObject {
    
    @Published var isOn = true
    
}

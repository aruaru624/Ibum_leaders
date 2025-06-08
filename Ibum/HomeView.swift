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
    
    let columns = [GridItem(.flexible(),spacing: 5), GridItem(.flexible(),spacing: 5)]
    
    @State private var showViewController = false
    @State private var showDetailView = false
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.white,Color(red: 151/255, green: 254/255, blue: 237/255),Color.white]),startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                ScrollView(.vertical){
                    LazyVGrid(columns: columns,spacing: 5){
                        ForEach(quests,id:\.self){ quest in
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 20, style: .circular)
                                    .fill(.white)
                                    .frame(width:UIScreen.main.bounds.width / 2 - 15 , height: (UIScreen.main.bounds.width / 2 - 10) / 4 * 5)
                                //                                    .background()
                                
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 151/255, green: 254/255, blue: 237/255),Color(red: 53/255, green: 162/255, blue: 159/255)]),startPoint: .top, endPoint: .bottom), lineWidth: 3)
                                            .shadow(radius: 5)
                                    )
                                
                                VStack{
                                    
                                    HStack{
                                        
                                        ForEach(quest.tags,id:\.self){tag in
                                            Text("#" + String(tag.rawValue))
                                                .fontWeight(.light)
                                        }
                                        
                                        Spacer()
                                        Image(systemName: (quest.clear ? "star.fill" : "star"))
                                            .padding(.trailing,10)
                                    }
                                    Text(String(quest.title))
                                        .fontWeight(.semibold
                                        )
                                    if let idd = quest.ids.first{
                                        let descriptor = FetchDescriptor<Photo>(predicate: #Predicate<Photo>{$0.id == idd})
                                        if let currentPhoto = try! context.fetch(descriptor).first as? Photo,
                                           let uiImage = UIImage(data: currentPhoto.photoData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80)
                                                .clipShape(Circle())
                                                .shadow(radius: 3)
                                        }
                                    } else {
                                        if let image = UIImage(named: String(quest.title)){
                                            Image(uiImage:image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80,height:80)
                                                .clipShape(Circle())
                                                .shadow(radius: 3)
                                                .overlay() {
                                                    ZStack{
                                                        Image(systemName: "camera")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .scaleEffect(0.5)
                                                            .frame(width: 80,height:80)
                                                            .foregroundStyle(.blue)
                                                        Circle()
                                                            .stroke(.black, lineWidth: 2)
                                                            .frame(width: 80)
                                                    }
                                                    
                                                    
                                                }
                                        }else{
                                            Image(systemName: "camera")
                                                .resizable()
                                                .scaledToFit()
                                                .scaleEffect(0.5)
                                                .frame(width: 80,height:80)
                                                .clipShape(Circle())
                                                .shadow(radius: 3)
                                                .foregroundStyle(.blue)
                                                .overlay() {
                                                    Circle()
                                                        .stroke(.black, lineWidth: 2)
                                                        .frame(width: 80)
                                                    
                                                }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                }
                                .frame(width:UIScreen.main.bounds.width / 2 - 15 , height: (UIScreen.main.bounds.width / 2 - 15) / 4 * 5)
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
//#Preview {
//    HomeView()
//}

class isPresenteCamera: ObservableObject {
    
    @Published var isOn = true
    
}

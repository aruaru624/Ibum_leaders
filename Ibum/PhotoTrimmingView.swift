import SwiftUI
import SwiftData
//class trimmingViewController:UIViewController{
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}

struct PhotoTrimmingView: View {
    let dismissToRoot: () -> Void
    let onDismiss: () -> Void
    
//    @Environment(\.isPresentedCamera) private var isPresentedCamera
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    @Query var quests: [Quest]
    
    @State private var scale: CGFloat = 1.01
    @State var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    @State var image:UIImage
    @State var questTitle:String = ""
    
    @EnvironmentObject var shareValue: isPresenteCamera
    
    @StateObject private var isPresentedCamera = isPresenteCamera()
    
//    @Binding private var isPresentedCamera :Bool
   
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    @State var flag = false
        
    var drag: some Gesture {
        DragGesture()
            .onChanged{ value in
                self.position = CGPoint(
                    x: value.startLocation.x
                        + value.translation.width,
                    y: value.startLocation.y
                        + value.translation.height
                )
            }
            .onEnded{ value in
                self.position = CGPoint(
                    x: value.startLocation.x
                        + value.translation.width,
                    y: value.startLocation.y
                        + value.translation.height
                )
            }
            
        }
    
    var pinch : some Gesture{
        MagnificationGesture()
            .onChanged { value in
                scale = value
            }
    }
    
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let height = bounds.height
        
        VStack {
            ZStack{
                Image(uiImage: image)
                    .resizable()
                    .scaleEffect(scale)
                    .frame(width: width)
                    .scaledToFit()
                    .position(x: position.x, y: position.y)
                    .gesture(SimultaneousGesture(drag,pinch))
                Rectangle()
                    .fill(.black)
                    .opacity(0.7)
                    .overlay() {
                        Circle()
                            .frame(width: width)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                Circle()
                    .stroke(style:
                                StrokeStyle(
                                    lineWidth: 5,
                                    dash: [20, 20]
                                ))
                    .frame(width: width)
                Color.clear
                    .contentShape(Rectangle())
                    .frame(width: width,height: height)
                    .gesture(SimultaneousGesture(drag,pinch))

                    Button(action: {
                        flag = true
                        add()
                    }){
                        Text("追 加")
                            .frame(width: width / 2 ,height: 50)
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .background(Color(red: 53/255, green: 162/255, blue: 159/255))
                            .clipped()
                            .cornerRadius(10)
                    }
                    .padding(.top,height / 5 * 4)
                    

                Rectangle()
                    .fill(.black)
                    .opacity(0.7)
                    .opacity(flag ? 1 : 0)
                clearSheet
                    .frame(width: width / 3 * 2,height: height / 2)
                    .opacity(flag ? 1 : 0)
                    
            }
            
            
            
        }
        .onAppear{
            isPresentedCamera.isOn = false
            do{
                print(quests.first)
            }catch{
                print(error)
            }
            
        }
        
    }
    
    var clearSheet: some View{
        ZStack{
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: width / 3 * 2,height: height / 2)
                .shadow(radius: 3)
            VStack{
                Text(questTitle)
                    .padding(.top,height / 16)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                Image(uiImage: image)
                    .resizable()
                    .frame(width: width / 3 * 2 - 50)
//                    .position(x: position.x, y: position.y)
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay() {
                        Circle()
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 151/255, green: 254/255, blue: 237/255),Color(red: 53/255, green: 162/255, blue: 159/255)]),startPoint: .top, endPoint: .bottom),
                                    lineWidth: 5)
                            .frame(width: width / 3  * 2 - 50)
//                            .padding(.bottom, 50)
                        
                    }
                Text("記念すべき一枚目")
                    .padding(.bottom,height / 16)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                
                
            }
            .frame(width: width / 3 * 2,height: height / 2)
            Button(action: {
                dismissToRoot()
        //        dismiss()
                onDismiss()
            }){
                Text("終　了")
                    .frame(width: width / 2 ,height: 50)
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .background(Color(red: 53/255, green: 162/255, blue: 159/255))
                    .clipped()
                    .cornerRadius(10)
            }
            .padding(.top,height / 5 * 4)
            
        }
    }
    func add() {
        let uuid =  UUID()
        let uuidstring = uuid.uuidString
        do{
            let descriptor = FetchDescriptor<Quest>(predicate: #Predicate<Quest>{$0.title == questTitle})
            let currentQuest = try context.fetch(descriptor).first
            let data = Photo(saveDate: Date(), photoData: image.jpegData(compressionQuality: 1)!, scale: Double(scale), centerX: Double(position.x), centerY: Double(position.y), registerSns: [], best: false, questTitle: questTitle, id: uuidstring)
            context.insert(data)
            currentQuest?.ids.append(uuidstring)
            print(currentQuest?.ids)
        }catch{
            print(error)
        }

//        print(context)
        }
}

//#Preview {
//    PhotoTrimmingView()
//}

import SwiftUI
import FirebaseStorage

struct ConfirmedMatchView: View {
    let match: Match?
    let imageUtils = ImageUtils()
    let timeUtils = TimeUtils()
    @State private var popover: Bool = false

    @State private var image: Image?
    
    var body: some View {
        if let match = match {
            Button(action: {
                popover.toggle()
            }, label: {
                VStack {
                    if let image = image {
                        image
                            .resizable()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .foregroundColor(Color.gray)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .clipShape(Circle())
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(match.name)
                        .font(.system(size: 16, weight: .semibold))
                    Text("To: \(match.airport)")
                        .font(.system(size: 12))
                    Text(timeUtils.formattedDate(match.date)) // <-- Here
                        .font(.system(size: 12))
                    Text(timeUtils.formattedTime(match.date)) // <-- Here
                        .font(.system(size: 12))
                }
                .frame(width: 150, height: 250)
            }).accentColor(Color.black)
            .onAppear{
                imageUtils.fetchImage(userId: match.matchUserId){ result in
                    switch result {
                    case .success(let uiImage):
                        self.image = Image(uiImage: uiImage)
                    case .failure:
                        // Set a placeholder image or handle the error state
                        self.image = Image(systemName: "person.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $popover){
                ExpandedMatchView(match: match)
            }
        }
            
    }
}

//struct ConfirmedMatchView_Previews: PreviewProvider {
//    static private var match = Match(id: UUID(), flightId: UUID(), matchFlightId: UUID(), matchUserId: "12345", date: "2023-08-02T12:34:56Z", pfp: "12345.jpg", name: "Phillip Le", airport: "EWR")
//    static var previews: some View {
//        ConfirmedMatchView(match: match)
//            .environmentObject(RequestModel())
//            .environmentObject(FlightModel())
//            .environmentObject(UserModel())
//    }
//}

import SwiftUI
import FirebaseStorage

struct RequestView: View {
    let request: Request?
    @StateObject private var imageLoader: ImageLoader
    static private var flight = Flight(id: UUID(), userId: "", airport: "", date: "", foundMatch: true)
    private let monthAbbrev: [String: String ] = [
        "January" : "Jan",
        "February" : "Feb",
        "March": "Mar",
        "April": "Apr",
        "August": "Aug",
        "September": "Sept",
        "October": "Oct",
        "November": "Nov",
        "December": "Dev"
    ]
    
    init(request: Request?) {
        self.request = request
        self._imageLoader = StateObject(wrappedValue: ImageLoader(pfp: request?.pfp))
    }
    
    var body: some View {
        if let request = request {
            VStack {
                if let image = imageLoader.image {
                    Image(uiImage: image)
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
                
                Text(request.name)
                    .font(.system(size: 16, weight: .semibold))
                Text("To: \(request.airport)")
                    .font(.system(size: 12))
                Text(formattedDate(RequestView.flight.dateFromISOString(request.date)!))
                    .font(.system(size: 12))
                Text("\(request.status)")
                    .frame(width: 80, height: 15)
                    .background(Color("Gold"))
                    .cornerRadius(10)
                    .padding(0)
            }
            .frame(width: 150, height: 180)
            .padding(.bottom)
        } else {
            Text("Not working")
        }
    }
    
    private func formattedDate( _ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    
        let monthString = dateFormatter.string(from: date)
        if let abbreviatedMonth = monthAbbrev[monthString] {
            return abbreviatedMonth
        }
        return monthString
    }

    private func formattedTime(_ date: Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    init(pfp: String?) {
        guard let pfp = pfp, !pfp.isEmpty else {
            return
        }
        
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: pfp)
        httpsReference.getData(maxSize: 750*750) { data, error in
            if let error = error {
                print("DEBUG: Error retrieving profile picture: \(error.localizedDescription)")
            } else {
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        print("SUCCESS: Downloaded user profile photo")
                    }
                }
            }
        }
    }
}


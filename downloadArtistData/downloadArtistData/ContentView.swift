//
//  ContentView.swift
//  downloadArtistData
//
//  Created by Brooks Barnett on 8/2/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ContentView: View {
    
    @State var artistName: String = ""
    @State var artistData: [Track]
    @State var showLoading: Bool = false
    init(_ artistData: String, _ showSpinner: Bool) {
        self.artistData = []
        self.showLoading = self.showLoading
    }
    
    var body: some View {
        Text("iTunes Parser")
        TextField("Enter Artist...", text: $artistName).frame(alignment: .center)
        
        Button("Search") {
            self.artistData = []
            getArtistData($artistName)
            self.showLoading = true
            UIApplication.shared.keyWindow?.endEditing(true)
        }.frame(alignment: .center)
        
        if self.showLoading {
            Text("Loading...").font(.system(size: 60))
        }
        
        ScrollView {
            ForEach(self.artistData.indices, id: \.self) { index in
                VStack{
                    HStack {
                        Text("Artist Name:").bold().frame(maxHeight: .some(25), alignment: .leading)
                        Text(self.artistData[index].artistName).frame(maxHeight: .some(25), alignment: .trailing)
                    }
                    HStack {
                        Text("Track Name:").bold().frame(maxHeight: .some(25), alignment: .leading)
                        Text(self.artistData[index].trackName).italic().frame(maxHeight: .some(25), alignment: .trailing)
                    }
                    HStack {
                        Text("Release Date:").bold().frame(maxHeight: .some(25), alignment: .leading)
                        Text(self.artistData[index].releaseDate).frame(maxHeight: .some(25), alignment: .trailing)
                    }
                    HStack {
                        Text("Genre:").bold().frame(maxHeight: .some(25), alignment: .leading)
                        Text(self.artistData[index].primaryGenreName).frame(maxHeight: .some(25), alignment: .trailing)
                    }
                    HStack {
                        Text("Pricing:").bold().frame(maxHeight: .some(25), alignment: .leading)
                        Text("$\(String(describing: self.artistData[index].price))").frame(maxHeight: .some(25), alignment: .trailing)
                    }
                }
                Divider()
            }
        }
    }
    
    func setArtistData(_ json: JSON?) {
        var tracksArray = [Track]()
        var temporaryTrack: Track
        if (!json!.isEmpty) {
            for (_, value) in json! {
                if (value["artistName"] != JSON(rawValue: NSNull()) &&
                    value["trackName"] != JSON(rawValue: NSNull()) &&
                    value["releaseDate"] != JSON(rawValue: NSNull()) &&
                    value["primaryGenreName"] != JSON(rawValue: NSNull()) &&
                    value["trackPrice"] != JSON(rawValue: NSNull())) {
                        temporaryTrack = Track(value["artistName"].rawValue as! String, value["trackName"].rawValue as! String, value["releaseDate"].rawValue as! String, value["primaryGenreName"].rawValue as! String, value["trackPrice"].rawValue as! NSNumber)
                        tracksArray.append(temporaryTrack)
                }
            }
            self.artistData = tracksArray
            self.showLoading = false
        }
    }
    
    func getArtistData(_ artist: Binding<String>) {
        let urlString = "https://itunes.apple.com/search"
        let url = URL(string: urlString)
        let parameters: Parameters = [ "term": artist.wrappedValue ]
        var json: JSON?
        if (url != nil) {
            AF.request(url!, method: .get, parameters: parameters).responseJSON {
                response in
                if response.data != nil {
                    json = try? JSON(data: response.data!)
                    setArtistData(json!["results"])
                } else {
                    json = "{}"
                }
            }
        }
    }

}

class Track {
  let artistName : String
  let trackName : String
  let releaseDate : String
  let primaryGenreName : String
  let price : NSNumber

  init(_ artistName: String, _ trackName: String, _ releaseDate: String, _ primaryGenreName: String, _ price: NSNumber) {
    self.artistName = artistName
    self.trackName = trackName
    self.releaseDate = releaseDate
    self.primaryGenreName = primaryGenreName
    self.price = price
  }
}

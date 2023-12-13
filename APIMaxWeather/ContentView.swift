//
//  ContentView.swift
//  APIMaxWeather
//
//  Created by Rene Mbanguka on 2023-12-09.
//
/*

This project is built with the help of AI tools,
mainly BARD and GitHub Copilot.
The purpose of the project is to test and apply the skills learnt in AI assisted programming and API integration
The project funtionality is as follows:

1. The user is presented with a textbox to enter the City of interest and click on a button to update the data
2. Once the update button clicked, coordinates corresponding to the location are determined using the CoreLocation package
3. From the coordinates, a call is sent to the openweathermap api to fetch weather data for the location of interest in an asynchronous URLSession.
4. The fetched data is decoded, and the maximum daily temperature and minimum daily temperature are determined, and displayed
 
5. A simple map with a pin is also shown/updated to show the location of the city/location entered by the user using the MapKit package.
 
// Documentation on api call: https://docs.openweather.co.uk/current#data

 Note: - The openweathermap api uses HTTP connection. Thus, it was necessary to disable App Transport Security (ATS)restrictions for the app (https://developers.google.com/admob/ios/privacy/app-transport-security)
    - an api key was required to be able to use openweathermap API "apiKey=d9f15e6a527134d0f13823fdda92e319"
 
*/



import SwiftUI
import CoreLocation // Package to determine coordinates (Lat, Lon) for City, Country
import MapKit // Package to display map, based on coordinates (Lat, Long)

// Create object to hold fetched weather data

struct WeatherData: Codable {
    var main: Main
    
    struct Main: Codable {
        var temp_min: Double
        var temp_max: Double
    }
}

// Create a Map Object for displaying the location of the entered city/country

struct MapView: UIViewRepresentable {
    @Binding var coordinate: CLLocationCoordinate2D? // Creates a state var to hold the coordinates

    // Function to create a map view
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }

    // Function to update the map view. The map is centered at the coordinates, and extends latitudinalMeters & longitudinalMeters
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500000, longitudinalMeters: 1000000)
            uiView.setRegion(region, animated: true)
            
            uiView.removeAnnotations(uiView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }
}

//

struct ContentView: View {
    @State private var maxTemp: Double = 0
    @State private var minTemp: Double = 0
    @State private var city: String = ""
    @State private var coordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 59.3293, longitude: 18.0686) // Stockholm as default city
    let apiKey = " " // Insert apikey here
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Welcome to the MaxTemp App")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color.green)
                
            
            Spacer()
            
            HStack {
                TextField("Enter City, Country ", text: $city) //Enter the City, country Name
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                // Spacer()
                
                Button(action: fetchCoordinates) {
                    Text("Update")
                         //Click button to update the data after entering the location/city
                }
                .fontWeight(.bold)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .help("Tap to update location")
                .padding(.trailing, 4.0)
                .buttonStyle(.borderedProminent)
                
            }
            .padding(.horizontal, 3.0)
            
            Text("Max. Temp: \(String(format: "%.1f", maxTemp))℃") // Displays the maximum temperature in Celsius
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.orange)
            
            Text("Min. Temp: \(String(format: "%.1f", minTemp))℃") // Displays the minumum temperature in Celsius
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(hue: 0.544, saturation: 1.0, brightness: 1.0))
            
            Spacer()
            
            
            MapView(coordinate: $coordinate)
                    .frame(height: 400)
            
            
            Spacer()
            
        }
    }
    
    // Function to return the nearest coordinates for the "City, Country" value entered by the user
    
    func fetchCoordinates() {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(city) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                coordinate = location.coordinate
                fetchWeatherData(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
        
        }
    
 
    // Function to fetch data from openweathermap API, using coordinates determined with the fetchCoordinates() function
    
    func fetchWeatherData(lat: Double, lon: Double) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        // URLSession to fetch data for submitted city, country asynchronously and decode JSON data from openweather API response
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        self.maxTemp = decodedResponse.main.temp_max
                        self.minTemp = decodedResponse.main.temp_min
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}


#Preview {
    ContentView()
}

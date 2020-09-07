//
//  SandboxWidget.swift
//  SandboxWidget
//
//  Created by Luke on 16/07/2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Weather {
    let Name: String
    let Image: String
    
    init(name: String, image: String){
        Name = name
        Image = image
    }
}

struct Entry: TimelineEntry {
    let weather: Weather
    let date: Date
}

struct TimeProvider: TimelineProvider {
    
    func getWeather() -> Weather {
        var weatherTypes = [Weather]()
        weatherTypes.append(Weather(name: "Sun", image: "sun.max.fill"))
        weatherTypes.append(Weather(name: "Snow", image: "cloud.snow"))
        weatherTypes.append(Weather(name: "Rain", image: "cloud.rain"))
        
        return weatherTypes.randomElement()!
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries = [Entry]()
        
        let model = Entry(weather: getWeather(), date: Date())
        entries.append(model)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let model = Entry(weather: getWeather(), date: Date())
        completion(model)
    }
    
    func placeholder(in context: Context) -> Entry {
        let model = Entry(weather: getWeather(), date: Date())
        return model
    }

}

struct WidgetView: View {

    let data: Entry
    
    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .inset(by: 5)
                .fill(Color.white.opacity(0.1))
            VStack{
                Image(systemName: data.weather.Image)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(Color.white)
            }
            .foregroundColor(.white)
        }
        .background(Color(white: 0.1))
        .foregroundColor(.white)
    }
    
}

struct PlaceHolderView: View {
    
    let entry = Entry(weather: Weather(name: "Fog", image: "cloud.fog"), date: Date())
    
    var body: some View {
        WidgetView(data: entry)
    }
    
}

@main
struct Config: Widget {

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.lukeinger.demo", provider: TimeProvider()){ data in
            WidgetView(data: data)
        }
        
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .description(Text("Weather"))
    }

}

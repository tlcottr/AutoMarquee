# MarqueePackage

A SwiftUI package for creating customizable scrolling marquees in your app.

## Features
- Supports left-to-right and right-to-left scrolling
- Configurable speed and spacing
- Draggable or auto-scrolling modes

## Installation
1. Open your Xcode project.
2. Go to `File > Add Packages...`.
3. Enter the URL of this repository: `https://github.com/your-username/MarqueePackage`.
4. Select the package and add it to your project.

## Usage
```swift
import MarqueePackage

struct ContentView: View {
    var body: some View {
        Marquee(targetVelocity: 30) {
            Text("This is a marquee!")
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

# Marquee

A SwiftUI package for creating customizable scrolling marquees in your app.

## Features
- Supports left-to-right and right-to-left scrolling
- Configurable speed and spacing
- Draggable or auto-scrolling modes

## Installation
1. Open your Xcode project.
2. Go to `File > Add Packages...`.
3. Enter the URL of this repository: `https://github.com/tlcottr/Marquee`.
4. Select the package and add it to your project.

## Usage
```swift
import Marquee

struct ContentView: View {
    var body: some View {
        Marquee(targetVelocity: 30, direction: .rightToLeft, isDraggable: false) {
            Text("Hello World")
        }
    }
}

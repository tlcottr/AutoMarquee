# Marquee


![Build Status](https://github.com/tlcottr/Marquee/actions/workflows/build.yml)
![License](https://img.shields.io/github/license/tlcottr/Marquee)
![Swift Version](https://img.shields.io/badge/Swift-5.7-orange)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey)

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

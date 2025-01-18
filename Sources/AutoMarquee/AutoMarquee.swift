//
//  AutoMarquee.swift
//  AutoMarquee
//
//  Created by Taylor Cottrell on 1/17/25.
//

import SwiftUI

enum ScrollDirection {
    case leftToRight
    case rightToLeft
}

struct Marquee<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var containerWidth: CGFloat? = nil
    @State private var model: MarqueeModel
    private var targetVelocity: Double
    private var spacing: CGFloat
    private var direction: ScrollDirection
    private var isDraggable: Bool // New property


    init(
        targetVelocity: Double,
        spacing: CGFloat = 10,
        direction: ScrollDirection = .rightToLeft,
        isDraggable: Bool = true, // Default to true
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self._model = .init(wrappedValue: MarqueeModel(targetVelocity: targetVelocity, spacing: spacing, direction: direction))
        self.targetVelocity = targetVelocity
        self.spacing = spacing
        self.direction = direction
        self.isDraggable = isDraggable
    }

    var extraContentInstances: Int {
        let contentPlusSpacing = ((model.contentWidth ?? 0) + model.spacing)
        guard contentPlusSpacing != 0 else { return 1 }
        return Int(((containerWidth ?? 0) / contentPlusSpacing).rounded(.up))
    }

    var body: some View {
        TimelineView(.animation) { context in
            HStack(spacing: model.spacing) {
                HStack(spacing: model.spacing) {
                    content
                }
                .measureWidth { model.contentWidth = $0 }
                ForEach(Array(0..<extraContentInstances), id: \.self) { _ in
                    content
                }
            }
            .offset(x: model.offset)
            .fixedSize()
            .onChange(of: context.date) { newDate in
                DispatchQueue.main.async {
                    model.tick(at: newDate)
                }
            }
        }
        .measureWidth { containerWidth = $0 }
        .gesture(isDraggable ? dragGesture : nil) // Apply drag gesture only if isDraggable is true
        .onAppear { model.previousTick = .now }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                model.dragChanged(value)
            }.onEnded { value in
                model.dragEnded(value)
            }
    }
}

struct MarqueeModel {
    var contentWidth: CGFloat? = nil
    var offset: CGFloat = 0
    var dragStartOffset: CGFloat? = nil
    var dragTranslation: CGFloat = 0
    var currentVelocity: CGFloat = 0
    var previousTick: Date = .now
    var targetVelocity: Double
    var spacing: CGFloat
    var direction: ScrollDirection

    init(targetVelocity: Double, spacing: CGFloat, direction: ScrollDirection) {
        self.targetVelocity = targetVelocity
        self.spacing = spacing
        self.direction = direction
    }

    mutating func tick(at time: Date) {
        let delta = time.timeIntervalSince(previousTick)
        defer { previousTick = time }
        currentVelocity += (targetVelocity - currentVelocity) * delta * 3
        if let dragStartOffset {
            offset = dragStartOffset + dragTranslation
        } else {
            let velocity = CGFloat(delta * currentVelocity)
            offset += (direction == .leftToRight) ? velocity : -velocity
        }
        if let c = contentWidth {
            offset.formTruncatingRemainder(dividingBy: c + spacing)
            while offset > 0 {
                offset -= c + spacing
            }
        }
    }

    mutating func dragChanged(_ value: DragGesture.Value) {
        if dragStartOffset == nil {
            dragStartOffset = offset
        }
        dragTranslation = value.translation.width
    }

    mutating func dragEnded(_ value: DragGesture.Value) {
        offset = dragStartOffset! + value.translation.width
        dragStartOffset = nil
    }
}

extension View {
    func measureWidth(_ onChange: @escaping (CGFloat) -> ()) -> some View {
        background {
            GeometryReader { proxy in
                let width = proxy.size.width
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            onChange(width)
                        }
                    }.onChange(of: width) {
                        onChange($0)
                    }
            }
        }
    }
}

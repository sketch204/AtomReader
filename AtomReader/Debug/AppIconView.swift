//
//  AppIconView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

import SwiftUI

struct AppIconView: View {
//    @Environment(\.colorScheme) 
    private var colorScheme: ColorScheme = .light
    
    private var foregroundColor: Color {
        switch colorScheme {
        case .dark: .orange
        default: .white
        }
    }
    
    private var backgroundColor: Color {
        switch colorScheme {
        case .dark: .black
        default: .orange
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)
            let width = frame.width
            
            ZStack {
                Circle()
                    .frame(width: width * 0.20)
                    .position(x: 0.50, y: 0.50, relativeIn: frame)
                
                ForEach(0..<3) { index in
                    ZStack {
                        Circle()
                            .stroke(lineWidth: width * 0.03)
                            .frame(width: width * 0.80)
                            .scaleEffect(x: 0.45)
                            .foregroundStyle(.secondary)
                        
                        Circle()
                            .frame(width: width * 0.07)
                            .position(x: 0.585, y: 0.15, relativeIn: frame)
                            .zIndex(5)
                    }
                    .rotationEffect(.degrees(Double(120 * index)))
                }
            }
//            .shadow(radius: 10, x: 10, y: 10)
            .background {
                RoundedRectangle(cornerRadius: width * 0.1810546875)
                    .fill(backgroundColor.gradient)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .foregroundStyle(foregroundColor.gradient)
//        .background(backgroundColor.gradient)
    }
}

extension View {
    fileprivate func position(
        x: CGFloat,
        y: CGFloat,
        relativeIn rect: CGRect
    ) -> some View {
        position(
            x: rect.minX + rect.width * x,
            y: rect.minY + rect.height * y
        )
    }
}

#Preview {
    AppIconView()
        .frame(width: 300)
        .padding()
}

#Preview {
    AppIconView()
        .frame(width: 300)
        .padding()
        .preferredColorScheme(.light)
}


struct AppIconExporterView: View {
    @State private var isPresentingExporter: Bool = false
    @State private var icon: AppIcon?
    
    var body: some View {
        Button("Export") {
            if let appIcon = createAppIcon() {
                self.icon = appIcon
                isPresentingExporter = true
            } else {
                print("Failed to render icon")
            }
        }
        .fileExporter(isPresented: $isPresentingExporter, item: icon, contentTypes: [.png]) { result in
            switch result {
            case .success(let url):
                print("Success \(url)")
            case .failure(let error):
                print("Failed - \(error)")
            }
        }
    }
    
    @MainActor
    func createAppIcon() -> AppIcon? {
        let rendered = ImageRenderer(
            content: AppIconView()
                .padding(100)
                .frame(width: 1024)
        )
        return rendered.nsImage.map({ AppIcon(image: $0, size: CGSize(width: 1024, height: 1024)) })
    }
}

extension AppIconExporterView {
    struct ExportError: Error {}
    
    struct AppIcon: Transferable {
        let image: NSImage
        let size: CGSize
        var imageInterpolation: NSImageInterpolation = .high
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(exportedContentType: .png) { icon in
                guard let bitmap = NSBitmapImageRep(
                    bitmapDataPlanes: nil,
                    pixelsWide: Int(icon.size.width),
                    pixelsHigh: Int(icon.size.height),
                    bitsPerSample: 8,
                    samplesPerPixel: 4,
                    hasAlpha: true,
                    isPlanar: false,
                    colorSpaceName: .deviceRGB,
                    bitmapFormat: [],
                    bytesPerRow: 0,
                    bitsPerPixel: 0
                ) else {
                    throw ExportError()
                }
                
                bitmap.size = icon.size
                NSGraphicsContext.saveGraphicsState()
                NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
                NSGraphicsContext.current?.imageInterpolation = icon.imageInterpolation
                icon.image.draw(
                    in: NSRect(origin: .zero, size: icon.size),
                    from: .zero,
                    operation: .copy,
                    fraction: 1.0
                )
                NSGraphicsContext.restoreGraphicsState()
                
                guard let output = bitmap.representation(using: .png, properties: [:]) else {
                    throw ExportError()
                }
                return output
            }
        }
    }
}

import SwiftUI
import AppKit
import AVFoundation

enum P {
    case R, r, S, B, W, Y, N, n, K, G, g, M, m, T
    var color: Color {
        switch self {
        case .R: Color(red: 0.99, green: 0.00, blue: 0.01)
        case .r: Color(red: 0.83, green: 0.06, blue: 0.07)
        case .S: Color(red: 0.95, green: 0.62, blue: 0.43)
        case .B: Color(red: 0.00, green: 0.20, blue: 0.57)
        case .W: Color(red: 0.97, green: 0.97, blue: 0.97)
        case .Y: Color(red: 0.98, green: 0.85, blue: 0.06)
        case .N: Color(red: 0.39, green: 0.20, blue: 0.00)
        case .n: Color(red: 0.35, green: 0.18, blue: 0.01)
        case .K: Color(red: 0.04, green: 0.02, blue: 0.03)
        case .G: Color(red: 0.99, green: 0.82, blue: 0.00)
        case .g: Color(red: 0.80, green: 0.60, blue: 0.00)
        case .M: Color(red: 0.94, green: 0.86, blue: 0.66)
        case .m: Color(red: 0.78, green: 0.68, blue: 0.46)
        case .T: Color.clear
        }
    }
}

let PX: CGFloat = 8
let HOVER = ["It's-a me!", "Wahoo!", "Yippee!", "Let's-a go!", "Here we go!"]

var themePlayer: AVAudioPlayer? = {
    // Look for mario_ground_theme in app bundle, then alongside the executable
    let candidates = [
        Bundle.main.url(forResource: "mario_ground_theme", withExtension: "m4a"),
        Bundle.main.url(forResource: "mario_ground_theme", withExtension: "mp3"),
        Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent("mario_ground_theme.m4a"),
        URL(fileURLWithPath: "/Users/amy/.claude/projects/小胡桃宠物/mario_ground_theme.m4a"),
    ]
    for url in candidates {
        if let u = url, FileManager.default.fileExists(atPath: u.path) {
            return try? AVAudioPlayer(contentsOf: u)
        }
    }
    return nil
}()

func playTheme() {
    themePlayer?.currentTime = 0
    themePlayer?.volume = 0.35
    themePlayer?.play()
}

typealias Row = [P]
typealias Grid = [Row]

let idleGrid: Grid = [
    [.T,.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.T,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.N,.N,.N,.N,.S,.S,.N,.N,.S,.T,.T,.T,.T],
    [.T,.T,.N,.N,.N,.N,.N,.S,.S,.N,.N,.S,.S,.S,.T,.T],
    [.T,.T,.N,.N,.N,.N,.N,.S,.S,.S,.S,.N,.S,.S,.S,.S],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.T,.S,.S,.S,.S,.S,.S,.S,.S,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.T,.T,.T],
    [.T,.T,.R,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.R,.T,.T],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.S,.S,.S,.R,.B,.Y,.Y,.B,.B,.Y,.Y,.B,.R,.S,.S,.S],
    [.S,.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S,.S],
    [.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.T,.T,.N,.N,.N,.T,.T,.T,.T,.T,.T,.N,.N,.N,.T,.T],
    [.N,.N,.N,.N,.N,.T,.T,.T,.T,.T,.T,.N,.N,.N,.N,.N],
]

let jumpGrid: Grid = [
    [.T,.T,.T,.T,.R,.R,.R,.R,.R,.R,.T,.T,.S,.S,.S,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.S,.S,.T],
    [.T,.T,.T,.N,.N,.N,.S,.S,.S,.N,.S,.T,.R,.R,.R,.T],
    [.T,.T,.N,.S,.N,.S,.S,.S,.S,.N,.S,.S,.S,.R,.R,.T],
    [.T,.T,.N,.S,.N,.N,.S,.S,.S,.S,.N,.S,.S,.S,.R,.T],
    [.T,.T,.N,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.R,.T,.T],
    [.T,.T,.T,.T,.S,.S,.S,.S,.S,.S,.S,.S,.R,.R,.T,.T],
    [.T,.R,.R,.R,.R,.B,.R,.R,.R,.R,.B,.R,.R,.T,.T,.T],
    [.T,.R,.R,.R,.R,.R,.B,.B,.R,.R,.R,.B,.T,.T,.T,.T],
    [.T,.T,.R,.R,.R,.R,.B,.B,.B,.B,.B,.Y,.B,.B,.N,.N],
    [.T,.T,.T,.B,.B,.B,.B,.Y,.Y,.B,.B,.B,.B,.B,.N,.N],
    [.T,.N,.N,.B,.B,.B,.B,.B,.B,.B,.B,.B,.B,.B,.N,.N],
    [.N,.N,.N,.B,.B,.B,.B,.B,.B,.B,.T,.T,.T,.T,.T,.T],
    [.N,.N,.T,.T,.T,.T,.T,.T,.T,.T,.T,.T,.T,.T,.T,.T],
]

let walk1Grid: Grid = [
    [.T,.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.T,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.N,.N,.N,.N,.S,.S,.N,.N,.S,.T,.T,.T,.T],
    [.T,.T,.N,.N,.N,.N,.N,.S,.S,.N,.N,.S,.S,.S,.T,.T],
    [.T,.T,.N,.N,.N,.N,.N,.S,.S,.S,.S,.N,.S,.S,.S,.S],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.T,.S,.S,.S,.S,.S,.S,.S,.S,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.T,.T,.T],
    [.T,.T,.R,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.R,.T,.T],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.S,.S,.S,.R,.B,.Y,.Y,.B,.B,.Y,.Y,.B,.R,.S,.S,.S],
    [.S,.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S,.S],
    [.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.N,.N,.N,.T,.T,.T,.T,.T,.N,.N,.N,.T,.T,.T,.N,.N],
    [.N,.N,.N,.N,.T,.T,.T,.T,.N,.N,.N,.T,.T,.N,.N,.N],
]

let walk2Grid: Grid = [
    [.T,.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.T,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.N,.N,.N,.N,.S,.S,.N,.N,.S,.T,.T,.T,.T],
    [.T,.T,.N,.N,.N,.N,.N,.S,.S,.N,.N,.S,.S,.S,.T,.T],
    [.T,.T,.N,.N,.N,.N,.N,.S,.S,.S,.S,.N,.S,.S,.S,.S],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.T,.S,.S,.S,.S,.S,.S,.S,.S,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.T,.T,.T],
    [.T,.T,.R,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.R,.T,.T],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.S,.S,.S,.R,.B,.Y,.Y,.B,.B,.Y,.Y,.B,.R,.S,.S,.S],
    [.S,.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S,.S],
    [.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.T,.T,.N,.N,.N,.T,.T,.T,.N,.N,.N,.T,.N,.N,.T,.T],
    [.T,.N,.N,.N,.N,.T,.T,.T,.N,.N,.N,.T,.N,.N,.N,.N],
]

let sleepGrid: Grid = [
    [.T,.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.T,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.R,.T,.T],
    [.T,.T,.T,.N,.N,.N,.N,.S,.S,.N,.N,.S,.T,.T,.T,.T],
    [.T,.T,.N,.T,.N,.N,.N,.S,.S,.N,.N,.S,.S,.S,.T,.T],
    [.T,.T,.N,.T,.N,.N,.N,.S,.S,.S,.S,.N,.S,.S,.S,.S],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.N,.S,.S,.S,.S,.S,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.T,.T,.S,.S,.S,.S,.S,.S,.S,.S,.T,.T,.T,.T],
    [.T,.T,.T,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.T,.T,.T],
    [.T,.T,.R,.R,.R,.B,.B,.R,.R,.B,.B,.R,.R,.R,.T,.T],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.R,.R,.R,.R,.R,.B,.B,.B,.B,.B,.B,.R,.R,.R,.R,.R],
    [.S,.S,.S,.R,.B,.Y,.Y,.B,.B,.Y,.Y,.B,.R,.S,.S,.S],
    [.S,.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S,.S],
    [.S,.S,.S,.B,.B,.B,.B,.B,.B,.B,.B,.B,.B,.S,.S,.S],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.T,.T,.T,.B,.B,.B,.B,.T,.T,.B,.B,.B,.B,.T,.T,.T],
    [.T,.T,.N,.N,.N,.T,.T,.T,.T,.T,.T,.N,.N,.N,.T,.T],
    [.N,.N,.N,.N,.N,.T,.T,.T,.T,.T,.T,.N,.N,.N,.N,.N],
]

let coinGrid: Grid = [
    [.T,.T,.T,.G,.G,.G,.G,.T,.T,.T],
    [.T,.T,.G,.G,.G,.G,.G,.G,.T,.T],
    [.T,.G,.G,.g,.g,.g,.g,.G,.G,.T],
    [.T,.G,.g,.G,.G,.G,.G,.g,.G,.T],
    [.T,.G,.g,.G,.G,.G,.G,.g,.G,.T],
    [.T,.G,.g,.G,.G,.G,.G,.g,.G,.T],
    [.T,.G,.G,.g,.g,.g,.g,.G,.G,.T],
    [.T,.T,.G,.G,.G,.G,.G,.G,.T,.T],
    [.T,.T,.T,.G,.G,.G,.G,.T,.T,.T],
]

let mushroomGrid: Grid = [
    [.T,.T,.T,.N,.N,.N,.N,.N,.T,.T],
    [.T,.T,.N,.R,.R,.R,.R,.R,.N,.T],
    [.T,.T,.N,.R,.R,.W,.R,.R,.N,.T],
    [.T,.N,.R,.R,.W,.R,.W,.R,.R,.N],
    [.T,.N,.R,.R,.R,.R,.R,.R,.W,.N],
    [.T,.N,.W,.R,.W,.R,.R,.R,.R,.N],
    [.T,.N,.R,.R,.R,.R,.R,.R,.R,.N],
    [.T,.T,.N,.N,.N,.N,.N,.N,.N,.T],
    [.T,.T,.M,.M,.M,.M,.M,.M,.T,.T],
    [.T,.T,.m,.M,.M,.m,.M,.M,.T,.T],
    [.T,.M,.M,.M,.M,.M,.M,.m,.T,.T],
    [.T,.T,.M,.M,.m,.M,.M,.T,.T,.T],
]

enum PetMode { case idle, walking, jumping, sleeping }

struct Bubble: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(.white).cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2.5))
            .shadow(color: .black.opacity(0.12), radius: 3, y: 2)
    }
}

struct MarioView: View {
    @State private var ox: CGFloat = 0
    @State private var oy: CGFloat = 0
    @State private var mode: PetMode = .idle
    @State private var bY: CGFloat = 0
    @State private var sc: CGFloat = 1.0
    @State private var wf: Int = 0
    @State private var asleep = false
    @State private var bTxt = ""
    @State private var bShow = false
    @State private var itemShow = false
    @State private var itemY: CGFloat = 0
    @State private var itemCoin = true
    @State private var lastAction = Date()
    @State private var hovering = false
    @State private var hoverTxt = "It's-a me!"

    var body: some View {
        ZStack(alignment: .top) {
            if hovering {
                Bubble(text: hoverTxt).offset(y: -30).transition(.opacity)
            }
            if itemShow {
                spriteView(itemCoin ? coinGrid : mushroomGrid, px: 5)
                    .offset(x: 65, y: itemY).opacity(itemY < -50 ? 0 : 1)
            }
            if bShow {
                Bubble(text: bTxt).offset(y: -6).transition(.scale.combined(with: .opacity))
            }
            spriteView(currentGrid(), px: PX)
                .scaleEffect(sc).offset(y: (bShow ? 28 : 0) + bY)
        }
        .frame(width: 200, height: 260)
        .offset(x: ox, y: oy)
        .animation(.spring(response: 0.35, dampingFraction: 0.55), value: ox)
        .animation(.spring(response: 0.35, dampingFraction: 0.55), value: oy)
        .onAppear { lastAction = Date(); scheduleWalk(); scheduleWiggle(); playTheme() }
        .onHover { h in hovering = h; if h { hoverTxt = HOVER.randomElement()! }
            h ? NSCursor.pointingHand.push() : NSCursor.pop() }
        .onTapGesture { lastAction = Date(); tap() }
        .contextMenu { Button("退出") { NSApp.terminate(nil) } }
        .gesture(DragGesture()
            .onChanged { v in ox = v.translation.width; oy = v.translation.height; lastAction = Date() }
            .onEnded { _ in withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) { ox = 0; oy = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { lastAction = Date(); scheduleWalk() } })
    }

    func spriteView(_ grid: Grid, px: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(grid.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 0) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, p in
                        Rectangle().fill(p.color).frame(width: px, height: px)
                    }
                }
            }
        }
    }

    func currentGrid() -> Grid {
        switch mode {
        case .walking:  wf % 2 == 0 ? walk1Grid : walk2Grid
        case .jumping:  jumpGrid
        case .sleeping: sleepGrid
        default:        idleGrid
        }
    }

    func tap() {
        if asleep { wake(); return }
        ox = 0
        hovering = false; mode = .jumping
        withAnimation(.easeOut(duration: 0.15)) { bY = -40; sc = 1.1 }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.3)) { bY = 0; sc = 1.0 }
        itemCoin = Bool.random(); itemShow = true; itemY = 0
        playSound(itemCoin ? "coin" : "mushroom")
        withAnimation(.easeOut(duration: 0.55)) { itemY = -70 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { itemShow = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { mode = .idle }
    }

    func wake() {
        ox = 0
        asleep = false; mode = .jumping
        withAnimation(.easeOut(duration: 0.15)) { bY = -30 }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.3)) { bY = 0 }
        bTxt = "Mamma mia!"; bShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { bShow = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { mode = .idle }
    }

    func scheduleWalk() {
        _ = Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { _ in
            guard mode == .idle else { scheduleWalk(); return }
            walk()
        }
    }

    func scheduleWiggle() {
        _ = Timer.scheduledTimer(withTimeInterval: 12, repeats: false) { _ in
            guard mode == .idle else { scheduleWiggle(); return }
            withAnimation(.easeOut(duration: 0.12)) { bY = -5 }
            withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) { bY = 0 }
            scheduleWiggle()
        }
    }

    func playSound(_ type: String) {
        let filename = type == "coin" ? "coin.wav" : "mushroom.wav"
        let candidates = [
            Bundle.main.url(forResource: filename.replacingOccurrences(of: ".wav", with: ""), withExtension: "wav"),
            Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent(filename),
            URL(fileURLWithPath: "/Users/amy/.claude/projects/小胡桃宠物/\(filename)"),
        ]
        for url in candidates {
            if let u = url, FileManager.default.fileExists(atPath: u.path) {
                NSSound(contentsOf: u, byReference: false)?.play()
                return
            }
        }
    }

    func walk() { guard mode == .idle else { return }; mode = .walking
        let dist: CGFloat = 120; let steps = 10
        var step = 0
        Timer.scheduledTimer(withTimeInterval: 0.09, repeats: true) { t in
            guard mode == .walking else { t.invalidate(); ox = 0; return }
            wf += 1; step += 1
            ox = dist * CGFloat(step) / CGFloat(steps)
            if step >= steps {
                t.invalidate()
                var s2 = 0; let s2start = ox
                Timer.scheduledTimer(withTimeInterval: 0.09, repeats: true) { t2 in
                    guard mode == .walking else { t2.invalidate(); ox = 0; return }
                    wf += 1; s2 += 1
                    ox = s2start - s2start * CGFloat(s2) / CGFloat(steps)
                    if s2 >= steps { t2.invalidate()
                        ox = 0; mode = .idle; scheduleWalk()
                    }
                }
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    func applicationDidFinishLaunching(_ n: Notification) {
        NSApp.setActivationPolicy(.accessory)
        let hv = NSHostingView(rootView: MarioView())
        hv.frame = NSRect(x: 0, y: 0, width: 200, height: 260)
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 200, height: 260),
                          styleMask: [.borderless], backing: .buffered, defer: false)
        window.center(); window.isOpaque = false; window.backgroundColor = .clear
        window.hasShadow = false; window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.isMovableByWindowBackground = true; window.contentView = hv
        window.makeKeyAndOrderFront(nil)
    }
}

let app = NSApplication.shared
let del = AppDelegate(); app.delegate = del
app.setActivationPolicy(.accessory); app.run()

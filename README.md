# 🍄 Desktop Mario Pet

> A pixel-art Mario companion that lives on your Mac desktop.

Floating, transparent window — Mario walks, jumps, and drops coins while you work.

![Mario](preview.gif)

## Features

| Action | What happens |
|--------|-------------|
| 🖱️ Hover | Random Mario catchphrase |
| 👆 Click | Jump + 🪙 coin or 🍄 mushroom + sound |
| ✋ Drag | Pick up and move anywhere |
| 🚶 20s idle | 120px stroll right and back |
| 🔉 Sound | Synthesized coin/mushroom effects |
| 🚀 Auto-start | Optional LaunchAgent for login |

## Quick Start

```bash
# Build
cd ~/Desktop/小胡桃宠物
bash build.sh

# Run
open 小胡桃.app

# Quit
pkill WalnutPet
```

## Requirements

- macOS 14+
- Xcode Command Line Tools (`xcode-select --install`)

## Customize

Edit `WalnutPet.swift`:

| Change | Where |
|--------|-------|
| Walk speed/distance | `walk()` function |
| Walk frequency | `scheduleWalk()` interval |
| Sound pitch | `playSound()` frequencies |
| Pixel art | `xxxGrid` arrays (16-column sprites) |

## How It Works

SwiftUI + AppKit hybrid. A single `WalnutPet.swift` file compiles into a borderless, transparent, always-on-top window. All sprites are hand-drawn 16-column pixel arrays traced from classic Nintendo reference art.

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

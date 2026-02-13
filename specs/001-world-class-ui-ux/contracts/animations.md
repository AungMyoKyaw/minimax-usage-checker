# Animation Specifications

**Date**: 2026-02-14
**Feature**: 001-world-class-ui-ux

---

## Overview

This document defines the animation system for the MiniMax Usage Checker. All animations are designed to be purposeful, natural, and respectful of user preferences.

---

## Design Principles

### 1. Purpose Over Spectacle
Every animation must serve a function: guide attention, provide feedback, or establish spatial relationships. Never animate for decoration.

### 2. Natural Physics
Animations should feel like real-world objects: spring-based for spatial changes, eased for value transitions.

### 3. Instant Perception
All interactions must feel immediate. Feedback appears within 100ms, transitions complete within 400ms.

### 4. Accessibility First
Respect `accessibilityReduceMotion` preference. Provide instant alternatives for all animations.

---

## Timing Curves

### Standard Curves

| Name | Duration | SwiftUI | Usage |
|------|----------|---------|-------|
| `easeOut` | 200ms | `.easeOut(duration: 0.2)` | Hover states, micro-interactions |
| `easeInOut` | 300ms | `.easeInOut(duration: 0.3)` | View transitions, tab switches |
| `spring` | 350ms | `.spring(response: 0.35, dampingFraction: 0.75)` | Expansions, modal presentations |
| `gentleSpring` | 500ms | `.spring(response: 0.5, dampingFraction: 0.85)` | Large element movements |
| `bounce` | 400ms | `.spring(response: 0.3, dampingFraction: 0.6)` | Playful feedback |

---

## Animation Specifications by Context

### Entrance Animations

#### View Entrance
```swift
.transition(.asymmetric(
    insertion: .scale(scale: 0.95).combined(with: .opacity),
    removal: .opacity
))
.animation(.spring(response: 0.35, dampingFraction: 0.75), value: isVisible)
```

#### Staggered List Entrance
```swift
// Items appear with 50ms delay between each
.animation(.easeOut(duration: 0.2).delay(Double(index) * 0.05), value: items)
```

#### Card Entrance
```swift
.transition(.scale(scale: 0.98).combined(with: .opacity))
.animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
```

---

### Value Animations

#### Number Transitions
```swift
// For usage counts, percentages
.animation(.easeInOut(duration: 0.25), value: value)
```

#### Progress Bar Updates
```swift
// Linear progress
.animation(.spring(response: 0.35, dampingFraction: 0.75), value: progress)

// Circular progress
.animation(.easeInOut(duration: 0.3), value: progress)
```

#### Color Transitions
```swift
// Status color changes (safe → warning → critical)
.animation(.easeInOut(duration: 0.3), value: status)
```

---

### Interaction Animations

#### Button Press
```swift
.scaleEffect(isPressed ? 0.97 : 1.0)
.animation(.easeOut(duration: 0.1), value: isPressed)
```

#### Hover State
```swift
.scaleEffect(isHovered ? 1.02 : 1.0)
.shadow(radius: isHovered ? 12 : 8)
.animation(.easeOut(duration: 0.2), value: isHovered)
```

#### Focus Ring
```swift
.overlay(
    RoundedRectangle(cornerRadius: 8)
        .stroke(Color.accentColor, lineWidth: isFocused ? 2 : 0)
)
.animation(.easeOut(duration: 0.15), value: isFocused)
```

---

### Transition Animations

#### Tab Switch
```swift
// Content crossfade with subtle scale
.transition(.asymmetric(
    insertion: .scale(scale: 0.98).combined(with: .opacity),
    removal: .scale(scale: 1.02).combined(with: .opacity)
))
.animation(.easeInOut(duration: 0.25), value: selectedTab)
```

#### Modal/Sheet Presentation
```swift
.transition(.move(edge: .bottom).combined(with: .opacity))
.animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
```

#### Expand/Collapse
```swift
.frame(height: isExpanded ? nil : collapsedHeight)
.clipped()
.animation(.spring(response: 0.35, dampingFraction: 0.75), value: isExpanded)
```

---

### Loading Animations

#### Spinner
```swift
.rotationEffect(.degrees(isLoading ? 360 : 0))
.animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)
```

#### Skeleton Shimmer
```swift
// Gradient moving left to right
.offset(x: shimmerOffset)
.animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: shimmerOffset)
```

#### Progress Dots
```swift
// Three dots with staggered bounce
.scaleEffect(scale)
.animation(.spring(response: 0.3, dampingFraction: 0.5).delay(delay), value: isLoading)
```

---

### Empty State Animations

#### Icon Pulse
```swift
.scaleEffect(isPulsing ? 1.05 : 1.0)
.animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)
```

#### Content Fade In
```swift
.opacity(hasAppeared ? 1 : 0)
.offset(y: hasAppeared ? 0 : 10)
.animation(.easeOut(duration: 0.4), value: hasAppeared)
```

---

## Reduce Motion Support

### Implementation Pattern

```swift
struct Animations {
    @Environment(\.accessibilityReduceMotion) static var reduceMotion
    
    static func transition(_ type: TransitionType) -> AnyTransition {
        if reduceMotion {
            return .opacity
        }
        switch type {
        case .entrance: return .scale.combined(with: .opacity)
        case .exit: return .opacity
        case .tab: return .asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity)
        }
    }
    
    static func animation(_ type: AnimationType) -> Animation? {
        if reduceMotion {
            return nil // Instant
        }
        switch type {
        case .spring: return .spring(response: 0.35, dampingFraction: 0.75)
        case .ease: return .easeInOut(duration: 0.3)
        case .subtle: return .easeOut(duration: 0.2)
        }
    }
}
```

### Reduced Motion Alternatives

| Standard Animation | Reduced Motion Alternative |
|-------------------|---------------------------|
| Scale + fade | Fade only |
| Spring expansion | Instant height change |
| Shimmer loading | Static gray |
| Pulse | Static |
| Bounce feedback | None |

---

## Animation Checklist

| Animation | Duration | Accessible Alternative | Status |
|-----------|----------|------------------------|--------|
| View entrance | 350ms | Fade only | ⬜ |
| Tab switch | 250ms | Fade only | ⬜ |
| Card expand | 350ms | Instant | ⬜ |
| Button press | 100ms | None needed | ⬜ |
| Hover scale | 200ms | None needed | ⬜ |
| Number update | 250ms | Instant | ⬜ |
| Progress update | 300ms | Instant | ⬜ |
| Spinner | 1000ms loop | Static indicator | ⬜ |
| Shimmer | 1500ms loop | Static gray | ⬜ |
| Icon pulse | 1500ms loop | Static | ⬜ |

---

## Performance Guidelines

1. **Animate transform and opacity only** - Avoid animating layout-affecting properties
2. **Use `drawingGroup()` for complex animations** - Hardware acceleration for charts
3. **Limit concurrent animations** - Max 3-4 animated elements at once
4. **Use `transaction` for fine control** - Override animation for specific changes
5. **Profile with Instruments** - Verify 60fps during animations

---

## SwiftUI Implementation

```swift
// AnimationConfiguration.swift
import SwiftUI

enum AnimationType {
    case spring
    case ease
    case subtle
    case value
}

extension Animation {
    static func app(_ type: AnimationType) -> Animation {
        switch type {
        case .spring:
            return .spring(response: 0.35, dampingFraction: 0.75)
        case .ease:
            return .easeInOut(duration: 0.3)
        case .subtle:
            return .easeOut(duration: 0.2)
        case .value:
            return .easeInOut(duration: 0.25)
        }
    }
    
    static func app(_ type: AnimationType, reduceMotion: Bool) -> Animation? {
        if reduceMotion { return nil }
        return app(type)
    }
}

// Usage
@Environment(\.accessibilityReduceMotion) var reduceMotion

Circle()
    .fill(color)
    .frame(width: isExpanded ? 100 : 50)
    .animation(.app(.spring, reduceMotion: reduceMotion), value: isExpanded)
```

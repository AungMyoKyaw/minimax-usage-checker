import SwiftUI

enum DesignTokens {
    enum Colors {
        // Status Colors
        static let usageSafe = Color("UsageSafe")
        static let usageWarning = Color("UsageWarning")
        static let usageCritical = Color("UsageCritical")
        
        // Surface Colors
        static let surfacePrimary = Color("SurfacePrimary")
        static let surfaceSecondary = Color("SurfaceSecondary")
        static let surfaceTertiary = Color("SurfaceTertiary")
        static let surfaceHover = Color("SurfaceHover")
        
        // Border Colors
        static let borderSubtle = Color("BorderSubtle")
        static let borderEmphasis = Color("BorderEmphasis")
        static let borderFocus = Color("BorderFocus")
        
        // Text Colors
        static let textPrimary = Color("TextPrimary")
        static let textSecondary = Color("TextSecondary")
        static let textTertiary = Color("TextTertiary")
        static let textDisabled = Color("TextDisabled")
        
        // Accent Colors
        static let accentPrimary = Color("AccentPrimary")
        static let accentSecondary = Color("AccentSecondary")
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 6
        static let md: CGFloat = 10
        static let lg: CGFloat = 14
        static let xl: CGFloat = 16
        static let xxl: CGFloat = 20
    }

    enum Radius {
        static let sm: CGFloat = 6
        static let md: CGFloat = 6
        static let lg: CGFloat = 8
        static let xl: CGFloat = 8
        static let full: CGFloat = 9999
    }

    enum Typography {
        static let displayLarge = Font.system(size: 24, weight: .bold, design: .rounded)
        static let displayMedium = Font.system(size: 18, weight: .bold, design: .rounded)
        static let headingLarge = Font.system(size: 16, weight: .semibold)
        static let headingMedium = Font.system(size: 14, weight: .semibold)
        static let bodyLarge = Font.system(size: 13, weight: .regular)
        static let bodyMedium = Font.system(size: 12, weight: .regular)
        static let caption = Font.system(size: 11, weight: .regular)
        static let captionSmall = Font.system(size: 10, weight: .regular)
    }
    
    enum Shadow {
        static let sm = ShadowStyle(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
        static let md = ShadowStyle(color: .black.opacity(0.04), radius: 2, x: 0, y: 2)
        static let lg = ShadowStyle(color: .black.opacity(0.06), radius: 3, x: 0, y: 4)
        static let focus = ShadowStyle(color: Color.accentColor.opacity(0.2), radius: 0, x: 0, y: 0)
    }
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    var shadow: some View {
        Color.clear
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}

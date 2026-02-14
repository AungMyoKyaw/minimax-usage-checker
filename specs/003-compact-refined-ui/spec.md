# Feature Specification: Compact Refined UI

**Feature Branch**: `003-compact-refined-ui`
**Created**: 2026-02-14
**Status**: Draft
**Input**: User description: "i think the ui element are so big, so it is hard to see, you are jony ive, so create spec"

## Design Philosophy

Inspired by Jony Ive's principles: **Reduction. Simplicity. Precision. Proportion.**

The current interface suffers from visual inflation—elements compete for attention through size rather than hierarchy. This specification defines a refined, compact interface where every pixel earns its place.

### Core Principles

1. **Reduction**: Remove the unnecessary. Every element must justify its existence.
2. **Proportion**: Establish harmonious relationships between sizes. Less extreme differences.
3. **Precision**: Details matter. Consistent spacing, alignment, and visual rhythm.
4. **Breathing Room**: Compact doesn't mean cramped. Intelligent whitespace over bloated padding.
5. **Content Hierarchy**: Let data speak. Typography and color create hierarchy, not size.

## User Scenarios & Testing

### User Story 1 - At-a-Glance Overview (Priority: P1)

As a developer, I want to see all my model usage at once without scrolling, so I can quickly assess my API consumption status.

**Why this priority**: Primary use case—users open the app to check usage status. Current large elements force scrolling even with few models.

**Independent Test**: Open app with 5+ models configured. Entire dashboard visible without scrolling at default window size. All critical metrics readable.

**Acceptance Scenarios**:

1. **Given** user has 5 models configured, **When** dashboard loads, **Then** all models visible in viewport at 800x600 window
2. **Given** user has 10 models configured, **When** dashboard loads, **Then** at most one scroll gesture reveals all models
3. **Given** dashboard is displayed, **When** user glances at screen, **Then** most urgent model (highest usage) immediately identifiable

---

### User Story 2 - Quick Status Scan (Priority: P1)

As a developer, I want to scan usage percentages across all models in under 2 seconds, so I can make quick decisions about API usage.

**Why this priority**: Speed of information retrieval is critical for a monitoring tool.

**Independent Test**: Display 5 models with varying usage levels. User correctly identifies all models above 80% usage in under 2 seconds.

**Acceptance Scenarios**:

1. **Given** multiple models displayed, **When** user scans the list, **Then** percentage values readable with consistent visual weight
2. **Given** models have different usage levels, **When** displayed, **Then** color coding provides instant status recognition (green/orange/red)
3. **Given** compact view, **When** user hovers over model, **Then** detailed information appears without expanding entire card

---

### User Story 3 - Detailed Information on Demand (Priority: P2)

As a developer, I want expanded details only when needed, so the interface stays clean while remaining informative.

**Why this priority**: Advanced feature for power users. Primary interface should stay minimal.

**Independent Test**: Click to expand a model card. All detailed metrics (window times, exact counts) visible in expansion.

**Acceptance Scenarios**:

1. **Given** collapsed model card, **When** user clicks card, **Then** card expands to show detailed metrics
2. **Given** expanded card, **When** user clicks again, **Then** card collapses smoothly
3. **Given** expanded card with detailed data, **When** displayed, **Then** all information fits within compact proportions

---

### User Story 4 - Window Efficiency (Priority: P2)

As a developer, I want the app to use minimal screen space while remaining fully functional, so it doesn't dominate my workspace.

**Why this priority**: A utility app should be unobtrusive. Users have limited screen real estate.

**Independent Test**: Resize window to 300px wide. All core functionality accessible. Information readable.

**Acceptance Scenarios**:

1. **Given** app window at minimum size (300x400), **When** user views dashboard, **Then** primary usage indicator visible and readable
2. **Given** narrow window, **When** content displayed, **Then** text wraps gracefully without truncation
3. **Given** compact mode, **When** user resizes larger, **Then** layout expands proportionally

---

### Edge Cases

- What happens when model names are unusually long? Truncate with ellipsis, full name on hover tooltip
- How does system handle single model vs many models? Layout adapts, stays compact with single card centered
- What happens at system font size changes? Respects Dynamic Type within reasonable bounds (10-18pt range)
- How are very small percentages displayed? Show decimal to 1 place when percentage is below 1%

## Requirements

### Functional Requirements

#### Design Tokens Refinement

- **FR-001**: Typography scale MUST be reduced—largest font no more than 24pt (down from 48pt)
- **FR-002**: Spacing scale MUST be compressed—maximum internal padding of 12pt (down from 16pt), maximum section spacing of 16pt (down from 24pt)
- **FR-003**: Border radius MUST be refined—maximum of 8pt (down from 20pt) for subtle, modern corners
- **FR-004**: Component sizes MUST be proportional—no single element dominates viewport
- **FR-005**: Shadow intensity MUST be reduced—subtle elevation of 2-4pt blur (down from 8-12pt), not dramatic depth

#### Component Refinement

- **FR-006**: CircularProgressView MUST default to 80pt diameter (down from 120pt) with 6pt line width (down from 8pt)
- **FR-007**: StatCard MUST use compact padding of 10pt (down from 16pt) with reduced icon size of 16pt (down from 20pt)
- **FR-008**: ModelCard MUST reduce collapsed height by approximately 30% through tighter padding and smaller typography
- **FR-009**: TabBar MUST use minimal vertical space—no more than 40pt height (down from 44pt+)
- **FR-010**: All list items MUST have consistent row heights of 44pt minimum for accessibility, with tight internal spacing of 8pt

#### Visual Hierarchy

- **FR-011**: Primary information MUST use weight (semibold/bold) and color for emphasis, not larger size
- **FR-012**: Secondary information MUST use regular weight with subdued color (secondary/tertiary)
- **FR-013**: Status colors MUST be retained but applied with reduced opacity (0.8 for backgrounds) for subtlety
- **FR-014**: Icons MUST be sized proportionally to adjacent text—14pt for inline, 16pt for standalone

#### Interaction Preservation

- **FR-015**: All existing interactions MUST remain functional—hover states, expansions, manual refresh, auto-refresh
- **FR-016**: Touch/click targets MUST remain at minimum 44pt for accessibility compliance
- **FR-017**: Animations MUST be retained but reduced in duration to 0.2s (down from 0.3s)

#### Information Density

- **FR-018**: Dashboard MUST display minimum 5 model cards in viewport at 800x600 window size
- **FR-019**: Primary usage percentage MUST be immediately visible without scrolling
- **FR-020**: Model names MUST not be truncated in collapsed view for names up to 25 characters

### Key Entities

- **DesignTokens**: Centralized typography, spacing, radius, and shadow values that define the visual language; changes propagate to all components
- **Component Proportions**: Size relationships between elements (e.g., progress indicator diameter to label text size)
- **Visual Hierarchy**: How importance is communicated through design weight, color, and position rather than size alone

## Success Criteria

### Measurable Outcomes

- **SC-001**: Users can view 5+ model cards without scrolling in an 800x600 window
- **SC-002**: All primary metrics (usage percentage) readable and identifiable within 2-second glance test
- **SC-003**: Window fully usable at 300px minimum width with all functionality accessible
- **SC-004**: Total visual area of primary components reduced by 25-35% while maintaining readability
- **SC-005**: No information loss—same data displayed in more efficient presentation
- **SC-006**: Existing users recognize interface patterns; new users understand layout within 5 seconds

### Design Quality Metrics

- **SC-007**: Typography scale has maximum ratio of 2:1 between largest display font (24pt) and body text (12pt)
- **SC-008**: Spacing uses consistent 4pt grid system (4, 8, 12, 16, 20pt values only)
- **SC-009**: All components share border radius of 6pt (small) or 8pt (medium)—no variation
- **SC-010**: Visual weight distributed through color intensity and font weight, not font size alone

## Assumptions

- Target display density is standard Retina (2x) or equivalent; 12pt type readable
- Users have adequate vision for 12pt type; accessibility accommodated via macOS system settings
- Window will typically be displayed at partial screen size (sidebar or floating), not fullscreen
- Existing color palette and brand identity remain unchanged—only size/scale adjusted
- No new features added—pure visual refinement of existing functionality

## Scope Exclusions

- New features or functionality additions
- Color palette changes (only application intensity/opacity adjusted)
- Data model or API integration changes
- New views, screens, or navigation patterns
- Accessibility improvements beyond maintaining existing 44pt touch targets
- Internationalization or localization changes

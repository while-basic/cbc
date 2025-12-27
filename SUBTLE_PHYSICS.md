# Subtle Physics Animation System

**Version 2.0.0 - Subtle Physics Edition**
**Applied to:** iOS App (cbc)

## Philosophy

> No UI affordances. No explanations. No obvious animations.
> Everything feels **measured**, **observed**, **alive**.

---

## Implemented Features

### 1. **Stateful Cursor Heartbeat** ✓
**File:** `ChatInputView.swift`

The text input border pulses based on interaction state, mirroring cognitive load:

- **Idle:** Slow pulse (≈1.8s) - baseline cognitive state
- **Typing:** Tight, rapid pulse (≈0.4s) - active processing
- **After COMMIT:** Single long fade → steady on - execution acknowledgment
- **Silence >10s:** Pulse decays - system entering low-power mode

**Implementation:** `CursorPulseModifier` in `SubtlePhysicsModifiers.swift`

---

### 2. **Text Resolution Animation** ✓
**File:** `MessageBubbleView.swift`

Text never "appears" - it **resolves**:

- Messages render at 65% opacity
- Resolve to full opacity over 80-140ms (randomized)
- Staggered by semantic unit (0.12s delay per project card)
- Feels like signal locking or compression resolving

**Implementation:** `TextResolutionModifier` in `SubtlePhysicsModifiers.swift`

---

### 3. **Micro-Jitter on State Changes** ✓
**File:** `ContentView_iOS.swift`

When system state updates (message sent, message selected):

- 1-2px sub-pixel shift applied to entire view
- Duration: 50ms
- **No easing, no bounce** - immediate shift, immediate settle
- Mimics system clock tick or memory paging

**Implementation:** `MicroJitterModifier` triggered on state change counter

---

### 4. **Action Boundary Button** ✓
**File:** `ChatInputView.swift`

COMMIT button redesigned as an **execution boundary**, not a UI control:

- Default: opacity 0.6 (enabled), 0.2 (disabled)
- **No hover effects**
- On click: scales to 0 for 120ms → disappears → response begins
- Text inverts briefly during press
- Minimal visual weight - just an arrow icon

**Implementation:** `ActionBoundaryButtonStyle` in `SubtlePhysicsModifiers.swift`

---

### 5. **Film Grain Background** ✓
**File:** `ContentView_iOS.swift`

Background is not pure black - it's **quiet**:

- Near-black: `#0B0B0C` (not `#000000`)
- Barely visible film grain (1-2% opacity)
- Animated every 8-12 seconds with subtle 2px offset
- Simulates CRT noise, sensor noise, biological baseline activity

**Implementation:** `FilmGrainView` in `SubtlePhysicsModifiers.swift`

---

### 6. **Peripheral State Indicators** ✓
**File:** `ContentView_iOS.swift`

State indicators moved to periphery, reduced prominence:

- **Bottom right:** "Environment V.02-BETA"
- **Header status:** "cognitive systems online"
- Font: 9-10pt monospaced
- Color: white at 25-30% opacity
- Letter-spacing: 1.2-1.5pt
- Reads as instrumentation, not content

**Implementation:** `PeripheralIndicatorModifier` + custom status views

---

### 7. **Identity Reveal Animation** ✓
**File:** `ContentView_iOS.swift`

"Christopher Celaya" appears as a **visual event**:

- Fade in slower than any other element (600ms)
- Slight vertical drift (2px upward, then locks)
- Delay between opacity and position animations (100ms)
- Feels like identity resolving or observer collapsing the wave

**Implementation:** `IdentityRevealModifier` in `SubtlePhysicsModifiers.swift`

---

### 8. **Time-Based Dimming** ✓
**File:** `MessageBubbleView.swift`

Older messages **dim** rather than scroll away:

- First 30s: Full brightness (100%)
- 30s - 5min: Gradual fade to 30% opacity
- >5min: Locked at 30% opacity
- **Time replaces space**

**Implementation:** `TimeDimmingModifier` based on message timestamp age

---

### 9. **Silent Latency State** ✓
**File:** `ContentView_iOS.swift`

Removed traditional typing indicators. Replaced with:

- Three tiny circles (3px each)
- Subtle pulse (40% max opacity)
- No "thinking..." text
- No spinners
- Implies **latency**, not human delay

**Implementation:** `SilentLatencyView` with minimal visual footprint

---

### 10. **Baseline Established Signature** ✓
**File:** `ContentView_iOS.swift` + `SubtlePhysicsModifiers.swift`

**One-time animation on first launch:**

- Appears after 2-3 seconds of inactivity
- Text: `"baseline established"` in 11pt monospaced
- Fade in (800ms) → hold (2s) → fade out (1s)
- **Never shown again**
- Becomes lore

**Implementation:** `BaselineEstablishedView` with `@AppStorage` persistence

---

## Visual Language

### Colors
- **Background:** `#0B0B0C` (near-black with life)
- **Primary Accent:** `#0066FF` at various opacities
- **Text Primary:** White at 90-100%
- **Text Secondary:** `#B0B0B0` - `#606060`
- **Borders:** Extremely subtle (0.5px, low opacity)

### Typography
- **Primary:** `.monospaced` design
- **Weights:** `.light` to `.regular` (avoiding bold except identity)
- **Tracking:** 0.5 - 2.0pt for instrumentation feel
- **Line spacing:** 5-6pt for readability

### Geometry
- **Corner radius:** 2px (sharp, system-like)
- **Borders:** 0.5px strokes
- **Padding:** 18-20px for breathing room
- **Spacing:** Minimal, intentional

---

## Files Modified

1. **`Views/SubtlePhysicsModifiers.swift`** (NEW)
   - All custom view modifiers
   - Core animation system

2. **`Views/ChatInputView.swift`**
   - Stateful cursor heartbeat
   - Action boundary button
   - Silence monitoring

3. **`Views/MessageBubbleView.swift`**
   - Text resolution animation
   - Time-based dimming

4. **`Views/ProjectCardView.swift`**
   - Peripheral indicator styling
   - Minimal card aesthetics

5. **`ContentView_iOS.swift`**
   - Film grain background
   - Identity reveal
   - Micro-jitter system
   - Baseline established
   - Silent latency state
   - Peripheral indicators

---

## The One Forbidden Animation

**Never use:**
- Spinners
- Traditional typing indicators
- "Thinking..." text
- Bounce/spring animations on state changes

These imply **human delay**. Instead: silence, latency, state acknowledgment.

---

## Philosophy in Practice

Every animation asks:
- Does this feel **measured**?
- Does this feel **observed**?
- Does this feel **alive**?

If the answer is "no" - remove it.

> The user should **feel observed** without being watched.

---

**Christopher Celaya**
*Celaya Solutions, 2025*

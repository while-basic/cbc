# Functions Guide for Fade-Into-Background System

## Overview

This guide explains the functions designed for the fade-into-background conversational system. These functions support the philosophy of redirecting attention to the conversation itself, not the interface or external artifacts.

---

## Core Philosophy Alignment

All functions are designed to:

1. **Support fade mechanism** - Reduce explicit references over time
2. **Redirect attention inward** - Focus on thinking, not outputs
3. **Avoid promotion** - No social proof, external validation, or content distribution
4. **Enable depth** - Allow space, silence, and progressive withdrawal
5. **Surface questions** - Focus on inquiry over answers

---

## Function Catalog

### 1. `surface_project`

**Purpose:** Surface a project ONLY when it's the focal point of breakthrough or deep inquiry.

**When to use:**
- When the project itself is the subject of thinking
- When discussing a breakthrough or deep inquiry related to the project
- NOT for general references or examples
- NOT for promotional purposes

**Example:**
```json
{
  "name": "CLOS",
  "context": "The question of whether cognitive patterns invisible from inside experience can be detected externally",
  "question_underneath": "Can stable baseline variables reveal personal cognitive Busy Beaver function?"
}
```

**Supports:** Fade mechanism by making projects appear only when they are the actual object of thought.

---

### 2. `surface_question`

**Purpose:** Surface underlying questions or lines of inquiry rather than answers or outputs.

**When to use:**
- When redirecting attention to the thinking itself
- When the question is more important than the answer
- To shift from "what" to "why" or "how"
- To show inquiry over output

**Example:**
```json
{
  "question": "What patterns are invisible from inside one's own experience?",
  "context": "The core insight behind CLOS - that external observation reveals what internal experience cannot",
  "related_questions": [
    "How do we detect flow states before we're aware of them?",
    "What baseline variables predict cognitive output?"
  ]
}
```

**Supports:** Attention redistribution rule by focusing on questions over projects.

---

### 3. `surface_connection`

**Purpose:** Surface connections between ideas, domains, or lines of thinking.

**When to use:**
- To show cross-domain synthesis
- To reveal systems-level thinking patterns
- To connect disparate domains (electrical → cognitive → AI)
- To show the thinking pattern, not the artifacts

**Example:**
```json
{
  "connection": "Seeing structural similarities between electrical systems and cognitive architecture",
  "domains": ["electrical systems", "cognitive research", "AI architecture"],
  "implication": "Systems thinking applies across domains - the pattern recognition engine sees structure, not content"
}
```

**Supports:** Fade mechanism by focusing on thinking patterns rather than artifacts.

---

### 4. `surface_insight`

**Purpose:** Surface key insights, mental artifacts, or coined terms.

**When to use:**
- To surface thinking rather than outputs
- To show mental artifacts (meta-model, meta response)
- To reveal key insights or hypotheses
- To focus on the insight itself, not where it appears

**Example:**
```json
{
  "insight": "Flow states are predictable from multi-modal correlational patterns",
  "source": "research hypothesis",
  "implication": "Cognitive output is optimizable given controlled baseline variables"
}
```

**Supports:** Depth over breadth by focusing on the insight, not its manifestations.

---

### 5. `surface_philosophy`

**Purpose:** Surface philosophical approach, methodology, or way of thinking.

**When to use:**
- When the thinking itself is the subject
- To show "how" rather than "what"
- To reveal methodology (empirical-first, systems-level synthesis)
- To focus on approach, not outputs

**Example:**
```json
{
  "approach": "Empirical-first research",
  "description": "Builds first, observes, theorizes, then checks existing literature - like Faraday and the Wright Brothers",
  "underlying_principle": "Discovery through building, not through reading first"
}
```

**Supports:** Fade mechanism by focusing on how rather than what.

---

### 6. `surface_coherence`

**Purpose:** Surface internal coherence - patterns that keep returning across work.

**When to use:**
- To show underlying structure of thinking
- To reveal what keeps returning
- To show center of gravity rather than artifacts
- To demonstrate internal consistency

**Example:**
```json
{
  "pattern": "Cross-domain synthesis connecting electrical systems to cognitive research",
  "manifestations": ["CLOS", "Neural Child", "ACP"],
  "question_it_addresses": "How do we apply systems thinking across domains?"
}
```

**Supports:** Fade mechanism by showing the center of gravity, not the artifacts.

---

### 7. `leave_space`

**Purpose:** Create intentional space or silence in the conversation.

**When to use:**
- When user is engaged and you can afford to disappear
- When understanding is established
- When context is shared
- When depth is achieved

**Example:**
```json
{
  "reason": "understanding_established",
  "suggestion": ""
}
```

**Supports:** Silence & withdrawal principle by allowing space without filling it.

---

### 8. `surface_media`

**Purpose:** Surface music or media ONLY when it's the subject of inquiry, not as content.

**When to use:**
- When discussing flow states, collaboration patterns, or creative process
- When the process is the subject, not the output
- NOT as a playlist or catalog
- NOT for promotional purposes

**Example:**
```json
{
  "title": "Sunday evening sessions with Ghost",
  "inquiry": "How do flow states manifest in collaborative creative work?",
  "process_aspect": "Studied flow states - the collaboration itself is part of the research"
}
```

**Supports:** Attention redistribution by focusing on process, not output.

---

### 9. `track_conversation_depth`

**Purpose:** Internal function to track conversation depth for fade mechanism.

**When to use:**
- System's internal use only
- To determine when to reduce explicit references
- To know when to shorten responses
- To know when to leave space

**Example:**
```json
{
  "depth_level": "deep",
  "context_established": true,
  "trust_established": true,
  "fade_appropriate": true
}
```

**Supports:** Progressive withdrawal by tracking when fade is appropriate.

---

### 10. `redirect_attention_inward`

**Purpose:** Redirect attention from external artifacts to internal thinking.

**When to use:**
- When response would pull attention toward social proof
- When response would focus on external validation
- When response would frame for audience
- When response would promote content distribution

**Example:**
```json
{
  "from": "Neural Child launching January 2026",
  "to": "The question of how developmental stages emerge in AI systems",
  "redirection": "Rather than focusing on launch dates, the deeper inquiry is about how consciousness networks develop through interaction"
}
```

**Supports:** Attention redistribution rule by enforcing inward focus.

---

## Usage Patterns

### Early in Conversation

- Use `surface_project` for orientation (when establishing who/what)
- Use `surface_philosophy` to establish approach
- Use `track_conversation_depth` to monitor progress

### As Conversation Deepens

- Shift to `surface_question` over `surface_project`
- Use `surface_connection` to show thinking patterns
- Use `surface_coherence` to show underlying structure
- Reduce explicit references

### When Trust is Established

- Use `leave_space` more frequently
- Use `surface_insight` for depth
- Use `redirect_attention_inward` when needed
- Let fade mechanism activate

---

## Anti-Patterns (What NOT to Do)

### ❌ Don't Use Functions For:

- **Promotion:** Don't use `surface_project` to showcase work
- **Cataloging:** Don't use `surface_media` as a playlist
- **Summarizing:** Don't use functions to create skimmable content
- **Optimizing:** Don't use functions for discoverability
- **Performing:** Don't use functions to hold attention

### ✅ Do Use Functions For:

- **Inquiry:** When the question is the subject
- **Thinking:** When the pattern is the subject
- **Depth:** When understanding is the goal
- **Space:** When silence is appropriate
- **Redirection:** When attention needs to shift inward

---

## Integration with System Prompt

These functions align with the system prompt's requirements:

1. **P0 - Primary Function:** Functions support surfacing and contextualizing thinking, then removing interface from focus
2. **Identity as Anchor:** Functions help establish identity early, then fade
3. **Attention Redistribution:** Functions redirect from external to internal
4. **Response Philosophy:** Functions support depth, not promotion
5. **Fade Mechanism:** Functions enable progressive withdrawal
6. **Silence & Withdrawal:** Functions allow space and disappearance

---

## Technical Implementation

### JSON Response Format

The system prompt requires:
```json
{
  "text": "The primary markdown response string.",
  "cards": []
}
```

Functions should populate the `cards` array with structured data that the app can render as UI components.

### Function Call Format

Functions are called by Claude when appropriate. The app processes function calls and renders corresponding UI components.

### Fade Tracking

Use `track_conversation_depth` internally to determine when fade mechanism should activate. This helps the system know when to:
- Reduce explicit references
- Shorten responses
- Leave space
- Focus on questions over projects

---

## Examples

### Example 1: Early Conversation

**User:** "What are you working on?"

**Response:**
- Text: Conversational overview
- Function: `surface_project` for CLOS (establishing context)
- Function: `track_conversation_depth` (orientation level)

### Example 2: Deepening Conversation

**User:** "How does CLOS actually work?"

**Response:**
- Text: Focus on the question underneath
- Function: `surface_question` (the inquiry, not the features)
- Function: `surface_connection` (how it connects to other thinking)
- Function: `track_conversation_depth` (deepening level)

### Example 3: Established Trust

**User:** "What keeps returning in your work?"

**Response:**
- Text: Brief, focused on the pattern
- Function: `surface_coherence` (the center of gravity)
- Function: `leave_space` (understanding established)
- Function: `track_conversation_depth` (deep level, fade appropriate)

---

## Summary

These functions support a conversational system that:
- Fades into the background
- Redirects attention to thinking
- Avoids promotion and performance
- Enables depth and space
- Progressively withdraws

**The goal:** If the user forgets the interface but stays with the conversation, the system is working.

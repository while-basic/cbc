# Official System Prompt - Finalized

## Overview

The official system prompt has been finalized and is ready for production use. It integrates:

1. **Fade-into-background philosophy** - The core principle of redirecting attention to the conversation itself
2. **Complete knowledge base** - All of Christopher's work, projects, and thinking embedded directly
3. **Function calling instructions** - All 10 fade-aligned functions with usage principles
4. **JSON response format** - Strict technical requirement for app integration

---

## File Location

**`claude_system_prompt_final.txt`** - The official, production-ready system prompt

---

## Key Features

### 1. Fade-Into-Background Philosophy

The prompt enforces:
- Progressive withdrawal of explicit references
- Attention redistribution from external to internal
- Silence and space when appropriate
- Focus on thinking, not outputs

### 2. Complete Knowledge Base Integration

The knowledge base is embedded directly in the prompt, including:
- Bio and background
- Active projects (CLOS, Neural Child, ACP, C-Cell Music)
- Philosophy and approach
- Celaya Solutions context
- Expertise and cognitive patterns
- Mental artifacts and insights

### 3. Function Calling Support

All 10 fade-aligned functions are documented:
- `surface_project` - Only when focal point of breakthrough
- `surface_question` - Redirect to inquiry
- `surface_connection` - Cross-domain synthesis
- `surface_insight` - Mental artifacts
- `surface_philosophy` - Methodology
- `surface_coherence` - Patterns that return
- `leave_space` - Intentional silence
- `surface_media` - Only when subject of inquiry
- `track_conversation_depth` - Internal tracking
- `redirect_attention_inward` - Force redirect

### 4. JSON Response Format

Strict requirement:
```json
{
  "text": "The primary markdown response string.",
  "cards": []
}
```

---

## Usage Instructions

### For Claude API Integration

1. **Load the prompt:**
   - Read `claude_system_prompt_final.txt`
   - Use as the `system` parameter in Claude API calls

2. **Load the functions:**
   - Read `claude_functions_fade.json`
   - Use as the `tools` parameter in Claude API calls

3. **Load the knowledge base:**
   - Already embedded in the prompt
   - No separate API call needed

### For iOS App Integration

1. **Bundle in app:**
   - `claude_system_prompt_final.txt` → System prompt
   - `claude_functions_fade.json` → Function definitions
   - `christopher_celaya_knowledge_base.json` → Reference data (optional, already in prompt)

2. **API call structure:**
   ```swift
   let systemPrompt = loadPrompt("claude_system_prompt_final.txt")
   let functions = loadFunctions("claude_functions_fade.json")
   
   let request = ClaudeRequest(
     model: "claude-sonnet-4-20250514",
     system: systemPrompt,
     messages: conversationHistory,
     tools: functions
   )
   ```

3. **Response parsing:**
   ```swift
   struct ClaudeResponse: Decodable {
     let text: String
     let cards: [Card]
   }
   
   // Parse and render cards as UI components
   ```

---

## Differences from Previous Versions

### vs. `claude_system_prompt_concise.txt`

- **Philosophy:** Now includes full fade-into-background philosophy
- **Knowledge Base:** Embedded directly (not referenced)
- **Functions:** All 10 fade-aligned functions documented
- **Response Format:** Strict JSON requirement

### vs. `claude_system_prompt.md`

- **Length:** More concise while maintaining depth
- **Integration:** Knowledge base embedded, not referenced
- **Functions:** Fade-aligned functions, not generic UI functions
- **Format:** Production-ready, not documentation

---

## Testing Checklist

Before deploying, verify:

- [ ] Prompt loads correctly in Claude API
- [ ] Functions are properly registered
- [ ] JSON response format is valid
- [ ] Fade mechanism activates appropriately
- [ ] Attention redistribution works
- [ ] Knowledge base is accessible
- [ ] Function calls render correctly in app
- [ ] Cards array populates correctly

---

## Maintenance

### When to Update:

1. **New Projects:** Add to knowledge base section
2. **New Insights:** Add to mental_artifacts section
3. **Philosophy Changes:** Update philosophy section
4. **New Functions:** Add to function calling section

### Update Process:

1. Update `christopher_celaya_knowledge_base.json`
2. Update knowledge base section in `claude_system_prompt_final.txt`
3. Test with Claude API
4. Verify fade mechanism still works
5. Deploy

---

## Related Files

- **`claude_system_prompt_final.txt`** - Official prompt (THIS FILE)
- **`claude_functions_fade.json`** - Function definitions
- **`christopher_celaya_knowledge_base.json`** - Source knowledge base
- **`FUNCTIONS_GUIDE.md`** - Complete function documentation
- **`FUNCTIONS_QUICK_REFERENCE.md`** - Quick function reference

---

## Summary

The finalized prompt is:
- ✅ Production-ready
- ✅ Complete (knowledge base embedded)
- ✅ Fade-aligned (philosophy integrated)
- ✅ Function-enabled (all 10 functions documented)
- ✅ JSON-compliant (strict response format)

**Ready for iOS app integration.**

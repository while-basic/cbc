# Function Usage Examples

## How to Use Functions in Your iOS App

### 1. Setup Claude API with Functions

```swift
import Anthropic

let client = Anthropic.Client(apiKey: "your-api-key")

// Load function definitions
let functions = try JSONDecoder().decode(Functions.self, from: functionsJSONData)

// Create message with system prompt
let systemPrompt = // Load from claude_system_prompt_concise.txt

let message = Anthropic.Message(
    role: .user,
    content: userQuery
)

let response = try await client.messages.create(
    model: .claudeSonnet4,
    maxTokens: 1000,
    system: systemPrompt,
    messages: [message],
    tools: functions.functions.map { function in
        Anthropic.Tool(
            name: function.name,
            description: function.description,
            inputSchema: function.parameters
        )
    }
)
```

### 2. Handle Function Calls in Response

```swift
// Process Claude's response
if let toolUse = response.content.first(where: { $0 is Anthropic.ToolUseBlock }) as? Anthropic.ToolUseBlock {
    switch toolUse.name {
    case "render_project_card":
        let params = try JSONDecoder().decode(ProjectCardParams.self, from: toolUse.input)
        renderProjectCard(params)
        
    case "render_media_embed":
        let params = try JSONDecoder().decode(MediaEmbedParams.self, from: toolUse.input)
        renderMediaEmbed(params)
        
    case "render_project_list":
        let params = try JSONDecoder().decode(ProjectListParams.self, from: toolUse.input)
        renderProjectList(params)
        
    case "render_action_button":
        let params = try JSONDecoder().decode(ActionButtonParams.self, from: toolUse.input)
        renderActionButton(params)
        
    case "render_bio_card":
        let params = try JSONDecoder().decode(BioCardParams.self, from: toolUse.input)
        renderBioCard(params)
        
    case "render_philosophy_explanation":
        let params = try JSONDecoder().decode(PhilosophyParams.self, from: toolUse.input)
        renderPhilosophyExplanation(params)
        
    default:
        break
    }
}
```

### 3. Example Function Call Scenarios

#### Scenario: User asks "What is CLOS?"

**Expected Response:**
- Conversational text explaining CLOS
- Function call: `render_project_card()` with CLOS details
- Optional: `render_action_button()` with "Learn more about CLOS"

#### Scenario: User asks "Show me your music"

**Expected Response:**
- Conversational text about C-Cell music
- Function call: `render_media_embed()` for a featured track
- Function call: `render_project_list()` showing music projects

#### Scenario: User asks "What are you working on?"

**Expected Response:**
- Conversational overview
- Function call: `render_project_list()` with all active projects
- Function calls: `render_project_card()` for each major project

#### Scenario: User asks "Tell me about your background"

**Expected Response:**
- Conversational narrative
- Function call: `render_bio_card()` with structured background info
- Function call: `render_action_button()` linking to projects

#### Scenario: User asks "How do you think about AI?"

**Expected Response:**
- Conversational explanation of philosophy
- Function call: `render_philosophy_explanation()` with structured format
- Function call: `render_project_list()` showing projects that exemplify the philosophy

### 4. SwiftUI Component Examples

```swift
// Project Card Component
struct ProjectCard: View {
    let project: ProjectCardParams
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(project.name)
                .font(.title2)
                .bold()
            
            Text(project.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Text(project.status)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.cardBackground)
                    .cornerRadius(8)
                
                Spacer()
            }
            
            if let features = project.key_features {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Features")
                        .font(.headline)
                    ForEach(features, id: \.self) { feature in
                        Text("• \(feature)")
                            .font(.caption)
                    }
                }
            }
            
            if let tech = project.tech {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tech, id: \.self) { techItem in
                            Text(techItem)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.accent.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

// Media Embed Component
struct MediaEmbed: View {
    let media: MediaEmbedParams
    @State private var isPlaying = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: media.type == "music" ? "music.note" : "play.circle.fill")
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(media.title)
                        .font(.headline)
                    if let artist = media.artist {
                        Text(artist)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: { isPlaying.toggle() }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                }
            }
            
            if let description = media.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}
```

### 5. Best Practices

1. **Always combine function calls with conversational text** - Functions enhance, don't replace conversation
2. **Use functions proactively** - When discussing a project, automatically render the card
3. **Chain related functions** - After showing a project list, offer action buttons
4. **Handle errors gracefully** - If function call fails, fall back to text-only response
5. **Cache function results** - Store rendered components to avoid re-rendering

### 6. Testing Function Calls

```swift
// Test query that should trigger project card
let testQuery = "What is CLOS?"

// Expected function calls:
// 1. render_project_card with CLOS details
// 2. Optional: render_action_button with "Learn more"

// Verify response contains:
// - Conversational text about CLOS
// - Tool use block with render_project_card
```

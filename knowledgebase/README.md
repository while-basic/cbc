# Knowledge Base - Drag & Drop System

## 🎯 Quick Start: Adding New Information

1. **Write your mental note** as a markdown file
2. **Drag and drop** into the appropriate category directory
3. **AI automatically has access** to the latest information

---

## 📁 Directory Structure

```
KNOWLEDGEBASE/
├── 00_CORE/                    # System files (prompts, functions, configs)
│   └── README.md               # This file
│
├── 01_BIO/                     # Biography and background
│   └── christopher_celaya_bio.md
│
├── 02_PROJECTS/                # Active projects
│   ├── CLOS/
│   │   └── clos_project.md
│   ├── Neural_Child/
│   │   └── neural_child_project.md
│   ├── Cognitive_Artifacts/
│   │   ├── cognitive_artifacts_project.md
│   │   └── artifact_examples.md
│   └── C-Cell_Music/
│       └── c-cell_music_project.md
│
├── 03_PHILOSOPHY/              # Philosophy and approach
│   └── philosophy.md
│
├── 04_CELAYA_SOLUTIONS/        # Company information
│   └── celaya_solutions.md
│
├── 05_EXPERTISE/               # Skills and expertise
│   └── expertise.md
│
├── 06_COGNITIVE_PATTERNS/      # Cognitive patterns
│   └── cognitive_patterns.md
│
├── 07_RESEARCH/                # Research interests
│   └── research_interests.md
│
├── 08_MUSIC/                   # Music projects
│   └── music_projects.md
│
├── 09_MENTAL_ARTIFACTS/        # Coined terms, insights, hypotheses
│   ├── coined_terms.md
│   ├── key_insights.md
│   ├── research_hypotheses.md
│   └── artifact_insights.md
│
└── 10_COMMUNICATION/           # Communication style
    └── communication_style.md
```

---

## 🚀 How to Use: Drag & Drop Workflow

### Example: Adding a New Insight

1. **You have a mental note:** "New insight about flow states"
2. **Create a markdown file:** `flow_state_insight_2025-01-15.md`
3. **Write your note:**
   ```markdown
   # Flow State Insight - January 2025
   
   Discovered that flow states correlate with...
   ```
4. **Drag and drop** into `06_COGNITIVE_PATTERNS/` or `09_MENTAL_ARTIFACTS/`
5. **Done!** The AI system will automatically read this file

### Example: Updating a Project

1. **You have a project update:** "CLOS now includes new feature X"
2. **Create a markdown file:** `clos_update_2025-01-15.md`
3. **Write your update:**
   ```markdown
   # CLOS Update - January 2025
   
   Added new feature: [description]
   Status: [current status]
   ```
4. **Drag and drop** into `02_PROJECTS/CLOS/`
5. **Done!** The AI system now knows about the update

---

## 📋 Category Guidelines

### 01_BIO/
**Use for:** Personal background updates, education additions, professional history changes, location updates

**Example files:**
- `education_update_2025-01-15.md`
- `new_role_2025-01-15.md`

### 02_PROJECTS/
**Use for:** Project updates, status changes, new features, technical details, milestones

**Subdirectories:**
- `CLOS/` - CLOS project updates
- `Neural_Child/` - Neural Child updates
- `Cognitive_Artifacts/` - Artifact project updates
- `C-Cell_Music/` - Music project updates

**Example files:**
- `02_PROJECTS/CLOS/clos_feature_update_2025-01-15.md`
- `02_PROJECTS/Cognitive_Artifacts/new_artifact_2025-01-15.md`

### 03_PHILOSOPHY/
**Use for:** Philosophical insights, approach changes, core principle updates, research methodology notes

**Example files:**
- `philosophy_insight_2025-01-15.md`
- `research_methodology_update_2025-01-15.md`

### 04_CELAYA_SOLUTIONS/
**Use for:** Company updates, mission/vision changes, capability additions, launch information

**Example files:**
- `company_update_2025-01-15.md`
- `new_capability_2025-01-15.md`

### 05_EXPERTISE/
**Use for:** New skills learned, technical capabilities, problem-solving approaches

**Example files:**
- `new_skill_2025-01-15.md`
- `technical_capability_2025-01-15.md`

### 06_COGNITIVE_PATTERNS/
**Use for:** Pattern observations, cognitive insights, flow state notes, recognition gap observations

**Example files:**
- `cognitive_pattern_observation_2025-01-15.md`
- `flow_state_note_2025-01-15.md`

### 07_RESEARCH/
**Use for:** Research interests, current experiments, methodology contributions, research findings

**Example files:**
- `research_finding_2025-01-15.md`
- `experiment_update_2025-01-15.md`

### 08_MUSIC/
**Use for:** Music project updates, collaboration notes, release information, production insights

**Example files:**
- `music_release_2025-01-15.md`
- `collaboration_note_2025-01-15.md`

### 09_MENTAL_ARTIFACTS/
**Use for:** New coined terms, key insights, research hypotheses, artifact-specific discoveries

**Example files:**
- `new_coined_term_2025-01-15.md`
- `key_insight_2025-01-15.md`
- `research_hypothesis_2025-01-15.md`

### 10_COMMUNICATION/
**Use for:** Communication style notes, preferred interaction patterns, tone adjustments

**Example files:**
- `communication_note_2025-01-15.md`

---

## ✍️ File Naming Convention

**Format:** `topic_description_date.md`

**Examples:**
- `clos_update_2025-01-15.md`
- `new_artifact_idea_2025-01-15.md`
- `research_finding_2025-01-15.md`
- `flow_state_insight_2025-01-15.md`

**Best Practices:**
- Use descriptive names
- Include dates (YYYY-MM-DD format)
- Use lowercase with underscores
- Be specific about the topic

---

## 📝 Template

See `TEMPLATE.md` in the root directory for a starting point. Copy it, rename it, fill it in, and drag it to the appropriate category.

---

## 🔄 System Integration

The AI system automatically:
- ✅ Reads all `.md` files in category directories
- ✅ Incorporates new information into responses
- ✅ Maintains context across all files
- ✅ Updates knowledge base dynamically

**No manual indexing required!** Just drag and drop.

---

## 📚 Existing Files

All existing knowledge base content has been split into category-based markdown files:
- Bio information → `01_BIO/`
- Projects → `02_PROJECTS/`
- Philosophy → `03_PHILOSOPHY/`
- And so on...

The original JSON file (`christopher_celaya_knowledge_base.json`) is still available for reference, but the system now reads from the markdown files.

---

## 🎯 Quick Reference

**Want to add a new insight?** → `09_MENTAL_ARTIFACTS/`
**Want to update a project?** → `02_PROJECTS/[project_name]/`
**Want to add a new skill?** → `05_EXPERTISE/`
**Want to note a cognitive pattern?** → `06_COGNITIVE_PATTERNS/`

---

## 💡 Tips

1. **One topic per file** - Keep files focused
2. **Use markdown** - Headers, lists, code blocks work well
3. **Date your entries** - Helps track information freshness
4. **Be specific** - Clear, actionable information
5. **Update existing files** - If adding to existing topic, edit the relevant file

---

**Ready to use!** Just write, drag, and drop. 🚀

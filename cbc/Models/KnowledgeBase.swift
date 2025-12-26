//
//  KnowledgeBase.swift
//  cbc
//
//  Created by Christopher Celaya on 12/25/25.
//

import Foundation

struct KnowledgeBase: Codable {
    let bio: Bio
    let activeProjects: [Project]
    let philosophy: Philosophy
    let celayaSolutions: CelayaSolutions
    let expertise: Expertise
    let musicProjects: MusicProjects

    struct Bio: Codable {
        let name: String
        let currentRole: String
        let experience: String
        let identity: String
        let location: String
        let background: Background
        let cognitiveArchitecture: CognitiveArchitecture

        struct Background: Codable {
            let education: [String]
            let professionalHistory: [String]
            let expertiseDomains: [String]
        }

        struct CognitiveArchitecture: Codable {
            let thinkingStyle: String
            let strength: String
            let approach: String
            let methodology: String
            let perspective: String
        }
    }

    struct Philosophy: Codable {
        let approach: String
        let methodology: String
        let researchStyle: String
        let corePrinciple: String
        let recognitionSeeking: String
        let intellectualGoal: String
        let workPhilosophy: String
    }

    struct CelayaSolutions: Codable {
        let identity: String
        let mission: String
        let positioning: String
        let launch: String
        let focus: String
        let coreCapabilities: [String]
        let leadershipPrinciples: [String]
    }

    struct Expertise: Codable {
        let technicalSkills: [String]
        let uniqueSynthesis: String
        let problemSolving: String
    }

    struct MusicProjects: Codable {
        let artistName: String
        let recordLabel: String
        let distribution: String
    }

    static let shared = KnowledgeBase(
        bio: Bio(
            name: "Christopher Celaya",
            currentRole: "Industrial Electrical Technician at Schneider Electric",
            experience: "11+ years bridging electrical infrastructure and emerging technology",
            identity: "Mexican American systems thinker, music producer (C-Cell), AI researcher, and cognitive systems engineer",
            location: "El Paso, Texas (border town)",
            background: Bio.Background(
                education: [
                    "Electrical Engineering & Computer Science at El Paso Community College",
                    "Electrical Engineering at University of Texas at El Paso",
                    "Finance at University of Texas at Austin"
                ],
                professionalHistory: [
                    "Industrial Electrical Technician - Schneider Electric (current)",
                    "Data Center Technician - T5 Data Centers",
                    "Mechatronics Technician - CN Wire",
                    "Microsoft Data Center - San Antonio",
                    "Specialized training at Schneider Electric, Ohio"
                ],
                expertiseDomains: [
                    "Industrial automation (PLCs, SCADA)",
                    "Electrical systems and wiring",
                    "Software development (Python, C, JavaScript)",
                    "AI/ML engineering",
                    "Cognitive systems research",
                    "Music production and audio engineering"
                ]
            ),
            cognitiveArchitecture: Bio.CognitiveArchitecture(
                thinkingStyle: "Systems-level synthesizer who sees connections across domains",
                strength: "Pattern recognition engine that identifies solutions by seeing structural similarities across fields",
                approach: "Empirical-first research - builds first, observes, theorizes, then checks existing literature",
                methodology: "Cross-domain synthesis connecting electrical systems to cognitive research",
                perspective: "Inverse imposter syndrome - exceptional technical skills, difficulty recognizing traditional value"
            )
        ),
        activeProjects: [
            Project(
                name: "CLOS",
                description: "Christopher Life Operating System - AI-augmented cognitive optimization system using voice journaling and multi-modal analysis to detect flow states, optimize cognitive performance, and maintain direction toward meaningful objectives",
                status: "90-day self-experimentation protocol active",
                tech: [
                    "iOS Shortcuts",
                    "Voice transcription",
                    "LLM pattern analysis",
                    "HealthKit integration",
                    "Multi-modal correlation analysis"
                ]
            ),
            Project(
                name: "Neural Child",
                description: "Developmental AI architecture with five interacting neural networks (Consciousness, Perception, Emotions, Thoughts, Language) that simulate child cognitive development through stages",
                status: "Launching January 2026 with Celaya Solutions",
                tech: [
                    "PyTorch neural networks",
                    "Multi-network architecture",
                    "Developmental learning",
                    "MessageBus communication",
                    "Mother LLM guidance"
                ]
            ),
            Project(
                name: "Cognitive Artifacts / ACP",
                description: "Sophisticated prompts designed to enhance human reasoning with formal taxonomy. ACP is a decentralized intelligent ecosystem for autonomous value creation, immutable proof, and trustless coordination",
                status: "Framework complete with formal taxonomy and minting standards",
                tech: [
                    "Prompt engineering",
                    "Behavioral modification",
                    "IPFS integration",
                    "Blockchain notarization",
                    "Decentralized coordination"
                ]
            ),
            Project(
                name: "C-Cell Music",
                description: "Music production and collaboration with Ghost (Yvette Williamz). Sunday evening sessions studied as flow states. Released on 150+ streaming services",
                status: "Active weekly sessions, 10 Year Showcase complete",
                tech: [
                    "MCP servers",
                    "Production workflow automation",
                    "Dolby Atmos",
                    "Professional audio engineering"
                ]
            )
        ],
        philosophy: Philosophy(
            approach: "Systematic self-experimentation and documentation",
            methodology: "Cross-domain synthesis connecting electrical systems to cognitive research",
            researchStyle: "Builds first, reads later - empirical-first research like Faraday and the Wright Brothers",
            corePrinciple: "I just wanted to vibe and connect technology together",
            recognitionSeeking: "Wants to be recognized as different rather than merely intelligent - values recognition of seeing things others don't see",
            intellectualGoal: "Contributing undiscovered knowledge to humanity through systematic self-experimentation - seeks intellectual immortality through academic citation",
            workPhilosophy: "Building complete systems, not just executing existing frameworks. Defaults to depth over breadth"
        ),
        celayaSolutions: CelayaSolutions(
            identity: "Neurocomputational Intelligence Lab (NIL) - a cognitive systems company",
            mission: "Build technology the world does not know it needs",
            positioning: "Neurodivergent-native cognitive technology company building AI systems that amplify human cognitive capability, not replace it",
            launch: "January 2026",
            focus: "Production-ready AI systems, cognitive optimization tools",
            coreCapabilities: [
                "Computational cognitive optimization",
                "Applied Large-Scale Reasoning Systems",
                "Neurodivergent-informed systems engineering",
                "Self-adaptive personal intelligence architectures",
                "Autonomous workflow orchestration",
                "Human-AI internal state modeling"
            ],
            leadershipPrinciples: [
                "Invent What Does Not Yet Exist",
                "Neurodivergent-First Design",
                "Safety Before Capability",
                "Privacy is a Human Right",
                "Radical Simplicity",
                "Prototype First, Perfect Later"
            ]
        ),
        expertise: Expertise(
            technicalSkills: [
                "Industrial automation (PLCs, SCADA systems)",
                "Electrical systems design",
                "Software development (Python, C, JavaScript)",
                "AI/ML engineering and LLM fine-tuning",
                "Neural network architecture design",
                "Blockchain and decentralized systems",
                "iOS development with HealthKit",
                "Music production and audio engineering"
            ],
            uniqueSynthesis: "Bridges electrical infrastructure, industrial systems, software development, artificial intelligence, and creative work in ways others don't see",
            problemSolving: "First-principles thinking, sees structural similarities across fields, builds novel frameworks rather than executing existing ones"
        ),
        musicProjects: MusicProjects(
            artistName: "C-Cell",
            recordLabel: "C-Cell Records (independent)",
            distribution: "150+ streaming services, 100+ stores"
        )
    )

    var jsonString: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let data = try? encoder.encode(self),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "{}"
    }
}

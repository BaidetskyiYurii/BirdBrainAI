# 🦜 BirdBrainAI — On-Device AI Parrot Expert

> A conversational iOS app powered by **Apple Intelligence** — ask anything about parrots and get instant, accurate answers from an on-device LLM with a custom tool integration.

![Platform](https://img.shields.io/badge/Platform-iOS%2018.4%2B-blue?style=flat)
![Swift](https://img.shields.io/badge/Swift-6.0-orange?style=flat)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple?style=flat)
![Apple Intelligence](https://img.shields.io/badge/AI-Apple%20Intelligence-black?style=flat)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=flat)

---

## 📱 What It Does

BirdBrainAI is a demo iOS app that showcases **Apple's on-device language model** via the `FoundationModels` framework. The app acts as an AI-powered parrot expert — users can ask questions about parrot species, care, diet, and behavior and receive streamed, markdown-formatted answers generated entirely on-device.

The key engineering highlight: the AI is connected to a **custom Tool** (`searchParrotDatabase`) that the model calls automatically when it needs species-specific data — demonstrating Apple Intelligence's function-calling capability introduced at WWDC 2025.

---

## ✨ Features

- **On-device AI chat** — powered by `SystemLanguageModel.default` via `FoundationModels`
- **Streaming responses** — real-time token streaming with animated text rendering
- **Custom Tool integration** — `ParrotsDatabaseTool` implements Apple's `Tool` protocol, giving the LLM access to a local parrot database
- **`@Generable` structured data** — `ParrotInfo` and `CareRecommendations` use the `@Generable` macro for type-safe model output
- **Markdown renderer** — custom SwiftUI `MarkdownText` view parses and renders bold, italic, and bullet lists
- **Suggestions screen** — quick-start prompts on empty state
- **Availability handling** — graceful UI for Apple Intelligence not enabled, device not eligible, or model not ready states
- **Session reset** — restart conversation with a fresh `LanguageModelSession`

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| On-Device AI | `FoundationModels` — `SystemLanguageModel`, `LanguageModelSession` |
| AI Streaming | `ResponseStream` with `async/await` for loop |
| Tool Use | Custom `Tool` protocol implementation (`searchParrotDatabase`) |
| Structured Output | `@Generable` macro — type-safe AI output |
| UI Framework | SwiftUI |
| Architecture | Clean Architecture — Domain / Data / Presentation |
| Navigation | Custom Coordinator pattern |
| Dependency Injection | FactoryKit |
| Networking | Custom `NetworkService` — `URLSession` + `async/await` |
| Code Generation | SwiftGen (Fonts, Icons, Strings) |
| Min Deployment | iOS 18.4+ (Apple Intelligence required) |
| Swift | 6.0 |

---

## 🤖 How the AI Integration Works

```swift
// 1. Session created with custom Tool and system instructions
let session = LanguageModelSession(
    tools: [ParrotsDatabaseTool()],
    instructions: "You are a professional parrot expert..."
)

// 2. Streaming response with async/await
let stream = session.streamResponse(to: userInput)
for try await partial in stream {
    self.partial = partial // published to UI in real time
}
```

### Custom Tool — `searchParrotDatabase`

The LLM automatically calls this tool when it needs species-specific data:

```swift
final class ParrotsDatabaseTool: Tool {
    let name = "searchParrotDatabase"
    let description = "Search for parrot species based on name..."

    @Generable
    struct Arguments {
        @Guide(description: "The exact parrot species name to retrieve details for.")
        let speciesName: String?
    }

    func call(arguments: Arguments) async -> GeneratedContent {
        // Looks up ParrotInfo from local JSON database
        // Returns structured data: origin, lifespan, diet, careRecommendations...
    }
}
```

The model decides when to use the tool — no explicit invocation needed from the app side.

### `@Generable` Structured Data

```swift
@Generable()
struct ParrotInfo: Codable {
    let speciesName: String
    let origin: String
    let lifespan: String
    let talkingAbility: String
    let temperament: String
    let careRecommendations: CareRecommendations
}
```

---

## 🏗 Project Structure

```
BirdBrainAI/
├── Application/
│   ├── AppCoordinator/        # Root coordinator
│   ├── DIContainer/           # FactoryKit DI container
│   └── Configuration/
├── Domain/
│   ├── Entities/              # ChatMessage, ParrotInfo (@Generable)
│   ├── UseCases/              # HomeUseCase, MockHomeUseCase
│   └── RepositoryProtocol/
├── Data/
│   ├── Repositories/          # HomeRepository
│   ├── NetworkExtension/      # API routes, DTOs
│   └── Reachability/          # Network monitoring
├── Infrastructure/
│   ├── Coordinators/          # NavigationCoordinator, ModalCoordinator
│   ├── ModelTools/            # ParrotsDatabaseTool (Tool protocol)
│   └── Network/               # NetworkService
├── Presentation/
│   └── Home/
│       ├── HomeView.swift     # Main chat screen
│       ├── HomeViewModel.swift # LanguageModelSession management
│       └── Views/
│           ├── ChatView.swift         # Message list with streaming
│           ├── SuggestionsView.swift  # Empty state with quick prompts
│           ├── MarkdownText.swift     # Custom markdown renderer
│           └── AvailabilityView.swift # Apple Intelligence availability UI
└── Resources/
    ├── Fonts/                 # SwiftGen generated
    ├── Icons/                 # SwiftGen generated
    └── Localizables/          # SwiftGen generated
```

---

## 🚀 Getting Started

### Requirements
- Xcode 16.4+
- iOS 18.4+ device with **Apple Intelligence enabled**
- iPhone 15 Pro or later (or iPad with A17 Pro / M-series chip)
- Swift 6.0

> **Note:** Apple Intelligence is required to run the AI features. The app shows a graceful error screen on unsupported devices.

### Setup
```bash
git clone https://github.com/BaidetskyiYurii/BirdBrainAI.git
cd BirdBrainAI
open BirdBrainAI/BirdBrainAI.xcodeproj
```

---

## 💡 Why This Project

`FoundationModels` was introduced at **WWDC 2025** as Apple's framework for integrating on-device LLMs into iOS apps. This project explores:

- How to build a real conversational UI with streaming on-device AI
- How to extend the model's knowledge with custom Tools (function calling)
- How `@Generable` enables type-safe structured output from the LLM
- How to handle Apple Intelligence availability states gracefully

It's a focused demo — one feature, done properly, with production-quality architecture underneath.

---

## 👨‍💻 Author

**Yurii Baidetskyi** — iOS Engineer  
[LinkedIn](https://linkedin.com/in/yuriibaidetskyi)

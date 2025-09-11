# SwiftUIChat

A modern, customizable chat interface built with SwiftUI. This library provides a production-ready chat UI with message bubbles, smooth keyboard handling, and native iOS look-and-feel

## Features

- **Modern SwiftUI Design** - Built entirely with SwiftUI and follows modern iOS design patterns
- **MVVM Structure** – Decoupled view logic with ChatViewModel
- **Custom Message Bubbles** - Beautiful chat bubbles with tail indicators
- **Message Input Bar** – Modern iOS 26+ style, with graceful fallback for iOS 15–18
- **Dark Mode** - Automatically changes with the system  
- **Smart Keyboard Handling** - Automatic keyboard avoidance and interactive dismissal
- **Supports Preloaded Messages** – Easily inject your messages from a backend
- **Smooth Animations** - Fluid scrolling 
- **iOS 15+ Support** - Compatible with iOS 15+
- **Focused Design** - Clean, distraction-free chat interface  

## Preview

### iOS 26

<img width="315" height="677" alt="Screenshot 2025-09-04 at 23 03 40" src="https://github.com/user-attachments/assets/2c2aa36a-0a95-4aa6-bfef-b72bf7fb963e" />
<img width="315" height="677" alt="Screenshot 2025-09-04 at 23 03 46" src="https://github.com/user-attachments/assets/2530680e-2233-4968-b212-0611acf281f2" />


### iOS 15-18

<img width="322" height="699" alt="IMG_8420" src="https://github.com/user-attachments/assets/3e6c48f5-da26-4f76-9269-092c53ef5e67" />
<img width="322" height="699" alt="IMG_8421" src="https://github.com/user-attachments/assets/bf656575-9ac3-44cc-ae18-71e8061f8f7d" />


## Requirements

- iOS 15.0+
- Xcode 26.0+
- Swift 5.5+

## Installation

### Swift Package Manager

Add SwiftUIChat to your project using Xcode:

1. In Xcode, go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/arturpilavetz/SwiftUIChat`
3. Select the version you want to use
4. Add the package to your target

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/arturpilavetz/SwiftUIChat", from: "1.0.0")
]
```

## Usage

### Quick Start

Import SwiftUIChat and create a basic chat view:

```swift
import SwiftUI
import SwiftUIChat

@main
struct SwiftUIChatExampleApp: App {
	@StateObject private var viewModel = ChatViewModel()

	var body: some Scene {
		WindowGroup {
			let chatConfig = ChatConfiguration(localUserID: 54321, chatID: 815)
			ChatView.create(with: chatConfig, viewModel: viewModel)
				.onAppear {
					loadMessages()
				}
		}
	}

	private func loadMessages() {
		let curentTime = Date().timeIntervalSince1970
		viewModel.messages = [
			ChatMessage(userId: 54321, message: "Hello!", timestamp: curentTime, localUserID: viewModel.localUserID),
			ChatMessage(userId: 12345, message: "Hi there!", timestamp: curentTime, localUserID: viewModel.localUserID),
		]
	}
}
```
That's it! You now have a functional chat interface.

## API Reference

### ChatView

The main chat interface view.

```swift
public struct ChatView: View
```

**Factory Methods:**
- `ChatView.create(with: ChatConfiguration, viewModel: ChatViewModel? = nil)`

If you pass viewModel, it will be used (recommended for state management). 
If you omit it, a new ChatViewModel will be created internally.

**Initializers:**
- `ChatView(viewModel: ChatViewModel)` - Creates a chat view with custom view model

### ChatViewModel

Observable object that manages chat state.

```swift
@MainActor
public class ChatViewModel: ObservableObject
```

**Properties:**
- `@Published var messages: [ChatMessage]` - Array of chat messages
- `var localUserID: Int` - Current user's ID
- `public let chatID: Int` - Current chat ID

- @Published var messages: [ChatMessage] – The list of messages
- var localUserID: Int – Current user ID
- var chatID: Int – Current chat ID
- var allowsMessageInput: Bool – Whether input bar is enabled


**Methods:**
- `addMessage(text: String)` - Adds a new message from the current user
- 

### ChatMessage

Represents a single chat message.

```swift
public struct ChatMessage: Identifiable, Equatable
```

**Properties:**
- `let id: UUID` - Unique message identifier
- `let chatId: Int?` - Optional chat room ID
- `let userId: Int` - ID of the message sender
- `let message: String` - Message content
- `let timestamp: Double` - Unix timestamp
- `let type: MessageContentType` - Message type (user/partner) based on the userID

### ChatConfiguration

Configuration object for customizing chat behavior.

```swift
public struct ChatConfiguration
```

**Properties:**
- `let localUserID: Int` - Current user's ID (default: 0)

- localUserID: Int -> Current user's ID
- chatID: Int -> Chat identifier
- allowsMessageInput: Bool –> Enable/disable message input bar

## Demo - Example Project

1. Clone the example repository - [SwiftUIChatExample](https://github.com/arturpilavetz/SwiftUIChatExample)
2. Open `SwiftUIChatExample.xcodeproj` in Xcode
3. Build and run

## Architecture
SwiftUIChat follows MVVM architecture:

- **Views**: `ChatView`, `MessageView`, `ChatInputBar`, `MessageShape`
- **ViewModels**: `ChatViewModel`  
- **Models**: `ChatMessage`, `MessageContentType`
- **Extensions**: Color extensions for theming

The library uses:
- SwiftUI for the user interface
- Combine for reactive data binding
- SwiftUI-Introspect for the custom UIKit config

## Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.


## Acknowledgments

- Uses [SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect) for enhanced UIKit integration

## Support

- 🐛 Issues: [GitHub Issues](https://github.com/arturpilavetz/SwiftUIChat/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/arturpilavetz/SwiftUIChat/discussions)

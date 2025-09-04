# SwiftUIChat

A modern, customizable chat interface built with SwiftUI. This library provides a chat UI with message bubbles and keyboard handling - with the system-like look.

## Features

- **Modern SwiftUI Design** - Built entirely with SwiftUI and follows modern iOS design patterns  
- **Custom Message Bubbles** - Beautiful chat bubbles with tail indicators  
- **Customizable Themes** - Easy to customize colors and appearance  
- **Smart Keyboard Handling** - Automatic keyboard avoidance and interactive dismissal  
- **Smooth Animations** - Fluid scrolling 
- **iOS 15+ Support** - Compatible with iOS 15+
- **Focused Design** - Clean, distraction-free chat interface  

## Screenshots

*Coming soon*


https://github.com/user-attachments/assets/a38a65a8-ed5b-448f-857b-2dd8650fd2a9





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

struct ContentView: View {
    var body: some View {
        ChatView.createDefault()
    }
}
```

That's it! You now have a fully functional chat interface.

### Using Your Own View Model

```swift
struct MyChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
			ChatView(viewModel: viewModel)
				.onAppear {
					viewModel.localUserID = 67890
					loadMessages()
				}
    }
    
    private func loadMessages() {
        // Add your custom messages
        viewModel.messages = [
            ChatMessage(userId: 67890, message: "Hello!", timestamp: Date().timeIntervalSince1970, localUserID: viewModel.localUserID),
            ChatMessage(userId: 12345, message: "Hi there!", timestamp: Date().timeIntervalSince1970, localUserID: viewModel.localUserID)
        ]
    }
}
```

## Customization

### Custom Colors

You can customize the chat appearance by extending the Color definitions:

```swift
extension Color {
    static let userBackground = Color.purple
    static let partnerBackground = Color.orange.opacity(0.3)
    static let partnerText = Color.orange
    static let topEdgeGradient = Color.black.opacity(0.15)
}
```

## API Reference

### ChatView

The main chat interface view.

```swift
public struct ChatView: View
```

**Factory Methods:**
- `ChatView.create(with configuration: ChatConfiguration = ChatConfiguration())` - Creates a chat view with configuration

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

**Methods:**
- `addMessage(text: String)` - Adds a new message from the current user
- `setMessages()` - Sets up initial demo messages

### ChatMessage

Represents a single chat message.

```swift
public struct ChatMessage: Identifiable, Equatable
```

**Properties:**
- `let id: UUID` - Unique identifier
- `var chatId: Int?` - Optional chat room ID
- `let userId: Int` - ID of the message sender
- `let message: String` - Message content
- `let timestamp: Double` - Unix timestamp
- `var type: MessageContentType` - Message type (user/partner)

### ChatConfiguration

Configuration object for customizing chat behavior.

```swift
public struct ChatConfiguration
```

**Properties:**
- `let localUserID: Int` - Current user's ID (default: 0)
- `let allowsMessageInput: Bool` - Enable message input (default: true)
- `let maxMessageLength: Int` - Max message length (default: 500)

## Demo - Example Project

//TODO: fix, currently not working - can be opened as a separate project(not via scheme change)
This package includes a standalone demo app. To run it:

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Select the `SwiftUIChatApp` scheme
4. Build and run

## Architecture
SwiftUIChat follows MVVM architecture:

- **Views**: `ChatView`, `MessageView`, `MessageShape`
- **ViewModels**: `ChatViewModel`  
- **Models**: `ChatMessage`, `MessageContentType`
- **Extensions**: Color extensions for theming

The library uses:
- SwiftUI for the user interface
- Combine for reactive data binding
- SwiftUI-Introspect for custom UIKit config

## Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.


## Acknowledgments

- Uses [SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect) for enhanced UIKit integration

## Support

- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/SwiftUIChat/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/SwiftUIChat/discussions)

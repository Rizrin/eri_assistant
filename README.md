# ERI Assistant

📱 A simple Flutter chat UI that connects to a local AI API (Ollama / LLaMA) and gives responses in English or Indonesian.
The interface is styled with pink Elysia accent colors inspired by Honkai Impact.

## ✨ Features

- 🎨 Modern UI: Gradient chat bubbles with Elysia pink accent.
- 📝 Prompt input with heart send button.
- 🌍 Bilingual responses: Automatically replies in English or Indonesian depending on the user’s message.
- 🔌 Local AI connection: Connects to http://localhost:11434/api/chat (Ollama / LLaMA) to get AI responses.
- ⚡ Simple codebase: Easy to modify or extend.

## Requirements

- Flutter 3.x
- Dart 3.x
- A running local AI server compatible with [Ollama API](https://ollama.com/) on `http://localhost:11434/api/chat` to get AI responses.

## 🚀 How to Run

- Clone this repository: git clone https://github.com/Rizrin/eri_assistant.git
cd eri-assistant
- Make sure you have Flutter installed: flutter doctor
- Start your local AI server (example: Ollama): ollama run llama3.2
  or any model you prefer.
- Run the app: flutter run

## ⚙️ Configuration
- Change model in query() to the model you run locally (default: "llama3.2").
- Change the API URL in Uri.parse() if your server runs on a different address or port.
- Update the system message in chatMessages to change assistant behavior or language.

## 📌Note

- Make sure the API connection with Flutter is correct (change the baseUrl if necessary).
- If you want to use it on a different network (not localhost), use the IP of the server device.


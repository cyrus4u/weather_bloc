# Weather Bloc App 🌤️

A modern weather application built with Flutter using BLoC and Clean Architecture.  
The app provides real-time weather data, 5-day / 3-hour forecasts, and city management features using the OpenWeatherMap API.

---

## 📱 Features

- 🌍 Search weather by city name
- 🌡️ Current weather conditions
- 📅 5-day / 3-hour forecast
- 💨 Wind speed, humidity, sunrise & sunset times
- ⭐ Save favorite cities locally
- ⚠️ Error handling UI for API/network failures
- 🎨 Clean and responsive UI

---

## 🧠 Architecture

This project follows **Clean Architecture** with separation of concerns:

- **Presentation Layer**
  - Flutter UI
  - BLoC state management

- **Domain Layer**
  - Use cases
  - Entities
  - Repository contracts

- **Data Layer**
  - API services (Dio)
  - Repository implementations
  - Models (DTOs)

This structure makes the project scalable, testable, and easy to maintain.

---

## 🛠️ Tech Stack

- Flutter
- Dart
- BLoC (State Management)
- Dio (HTTP client)
- Equatable
- Clean Architecture
- OpenWeatherMap API

---

## 📦 API

This project uses the **OpenWeatherMap API**:

- Current Weather API
- 5 Day / 3 Hour Forecast API

You need to add your API key in the project configuration.

---

## 📁 Project Structure

```bash
lib/
 ├── data/
 │    ├── datasources/
 │    ├── models/
 │    └── repositories/
 │
 ├── domain/
 │    ├── entities/
 │    ├── repositories/
 │    └── usecases/
 │
 ├── presentation/
 │    ├── bloc/
 │    ├── pages/
 │    └── widgets/
 │
 └── main.dart


## 📸 Screenshots

<p float="left">
  <img src="images/mainScreen.jpg" width="200"/>
  <img src="images/savingScreen.jpg" width="200"/>
</p>
⚙️ Setup Instructions
Clone the repository
git clone https://github.com/your-username/weather_bloc.git
Install dependencies
flutter pub get
Add your OpenWeatherMap API key
Create a .env file or configure inside constants
Run the app
flutter run
🚀 Future Improvements
Add location-based weather (GPS)
Improve caching for offline mode
Add animations for weather transitions
Add unit tests for BLoC and use cases
👨‍💻 Author

Built by Cyrus
Feel free to explore, fork, and improve 🚀


---

## If you want to improve it further
I can next level this README with:
- GitHub badges (Flutter version, BLoC, license, etc.)
- GIF preview instead of screenshots
- better “professional portfolio style” layout
- or make it look like a **top open-source project**

Just tell me 👍

# 🎬 TEAMovieApp

TEAMovieApp is an iOS application that displays the best movies of 2025 using **TheMovieDB API**, with local storage support via **Core Data** for offline usage.

---

## 📌 Features
- Display a list of movies released in 2025.
- Fetch data from **TheMovieDB API** and store it locally using **Core Data**.
- Show detailed movie information (title, poster, rating, language, votes, overview).
- Mark/unmark movies as favorites and persist their status in the database.
- Offline mode support: Load last saved data when there is no internet connection.
- Built with **Clean Architecture** + **MVVM**.
- Data flow handled using **Combine**.
- Images loaded via **Kingfisher** library.

---

## 🛠 Architecture
The project follows **Clean Architecture** with the following layers:

- **Domain Layer**
  - `Entities`: Core business models.
  - `Repositories`: Protocol definitions for data access.
  - `UseCases`: Application-specific business logic.

- **Data Layer**
  - `Network`: API calls to TheMovieDB.
  - `DTOs`: Data Transfer Objects for mapping between API and Domain models.
  - `CoreData`: Local data management using Core Data (entities, storage).
  - `Repositories`: Concrete repository implementations.

- **Presentation Layer**
  - `Coordinators`: Navigation management between screens.
  - `MoviesList`: Movies list feature (View, ViewModel, Protocols).
  - `MovieDetails`: Movie details feature (View, ViewModel, Protocols).
  - `Views`: Reusable UI components.

---

## 📂 Project Structure

Sources  
 ├── Domain  
 │    ├── Entities               # Business models (e.g., Movie)  
 │    ├── Repositories           # Repository protocols  
 │    └── UseCases               # Application business logic  
 ├── Data  
 │    ├── Network                # API service layer & endpoints  
 │    ├── DTOs                   # Data Transfer Objects mapping API ↔ Domain  
 │    ├── CoreData               # Core Data stack, storage, and entity mappings  
 │    └── Repositories           # Concrete repository implementations  
 └── Presentation  
      ├── Coordinators           # Screen navigation (AppCoordinator, MoviesCoordinator)  
      ├── MoviesList              # Movies list feature (View, ViewModel, Protocols)  
      ├── MovieDetails            # Movie details feature (View, ViewModel, Protocols)  
      └── Views                   # Shared UI components and reusable views  

Tests  
 ├── NetworkTests                 # Unit tests for API layer and network requests  
 ├── RepositoryTests              # Unit tests for repository implementations (Data layer)  
 ├── ViewModelTests                # Unit tests for ViewModels (Presentation layer)  
 └── UseCaseTests                  # Unit tests for business logic in UseCases (Domain layer)  

---

## ⚙️ Setup & Run
1. **Get an API Key from TheMovieDB**
   - Sign up at [TheMovieDB](https://www.themoviedb.org/).
   - Create an API key and add it in `APIConstants.swift`.

2. **Install Dependencies**
   - The project uses Swift Package Manager (SPM).
   - Ensure **Kingfisher** is installed via SPM in Xcode.

3. **Run the App**
   - Open the project in Xcode (version 14+ recommended).
   - Select the `TEAMovieApp` target.
   - Press ▶️ Run.

---

## 🧪 Unit Tests
The project includes Unit Tests for multiple layers:
- **NetworkTests**: Verify API request building and response handling.
- **RepositoryTests**: Validate repository data flow between local and remote sources.
- **UseCaseTests**: Ensure business logic correctness in use cases.
- **ViewModelTests**: Test UI state management and user interaction handling.

### Running Tests
- Open the project in Xcode.
- Press **Cmd + U** to run all tests.
- Or navigate to the **Test Navigator** (⌘ + 6) and run individual test cases.

---

## 📝 Requirements
- iOS 13+
- Xcode 14+
- Swift 5.7+

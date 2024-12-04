# Orders List Example

A Flutter application for managing and visualizing order data with interactive metrics and graphs.

## Features

- **Interactive Dashboard**
  - Real-time metrics display
  - Key performance indicators
  - Order status tracking

- **Data Visualization**
  - Time-series graph of order counts
  - Status-based filtering
  - Interactive tooltips

- **Clean Architecture**
  - BLoC pattern for state management
  - Separation of concerns
  - Testable and maintainable code

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- IDE with Flutter support (VS Code, Android Studio, or IntelliJ)

### Installation

1. Clone the repository:

   ```bash
   git clone [repository-url]
   cd orders_list_example
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Generate code:

   ```bash
   # One-time code generation
   flutter pub run build_runner build --delete-conflicting-outputs

   # Watch for changes and rebuild automatically
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

   This will generate:
   - JSON serialization code
   - Freezed models
   - Other generated code

4. Run the app:

   ```bash
   flutter run
   ```

## Project Structure

``` dart
lib/
├── src/
│   ├── core/
│   │   ├── config/          # App configuration
│   │   └── theme/           # Theme data
│   │
│   └── features/
│       └── orders/
│           ├── data/        # Data layer
│           ├── domain/      # Business logic
│           └── presentation/ # UI components
│               ├── bloc/    # State management
│               ├── screens/ # Main screens
│               └── widgets/ # Reusable widgets
```

## Architecture

The project follows Clean Architecture principles with three main layers:

1. **Data Layer**
   - Handles data fetching and storage
   - Implements repositories
   - Manages data models

2. **Domain Layer**
   - Contains business logic
   - Defines entities and use cases
   - Independent of UI and data sources

3. **Presentation Layer**
   - Implements UI components
   - Uses BLoC for state management
   - Handles user interactions

## Code Generation

The project uses several code generation tools to reduce boilerplate and ensure type safety:

### Build Runner

We use `build_runner` to generate code for:

- JSON serialization with `json_serializable`
- Route generation
- Other generated code

To update generated code:

```bash
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Generated Files

The following files are generated:

- `*.g.dart`: JSON serialization code
- Other generated files

**Note**: Never edit generated files manually. Instead, modify the source files and run the code generation commands.

## State Management

The app uses the BLoC (Business Logic Component) pattern for state management:

- **OrdersBloc**: Manages order-related state and operations
- **Events**: Trigger state changes (LoadOrders)
- **States**: Represent UI states (Loading, Loaded, Error)

## Widgets

### Key Components

- **MetricsScreen**: Displays order KPIs
- **GraphScreen**: Shows order trends
- **OrdersGraph**: Interactive time-series visualization
- **MetricCard**: Reusable metric display widget

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Contributors and maintainers

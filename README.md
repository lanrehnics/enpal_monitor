
# Solar Monitoring Application

This project is a mobile application for monitoring solar energy systems, including solar panels, wallboxes, and heat pumps. The app provides real-time data visualization and allows users to analyze solar power data.

---

## Implemented Features

### Core Functionalities:
- **Graph and Data Visualization:**
    - Solar Generation: Line chart visualization for solar energy production.
    - Household Consumption: Line chart visualization for household energy consumption.
    - Battery Consumption: Line chart visualization for battery energy usage.
    - Supports dynamic tab switching for different metrics.
- **Interactive Elements:**
    - Date filtering.
    - Unit switching between watts and kilowatts.
- **Caching:**
    - Caching previously loaded data, allowing the app to display cached data when reopened, and load new in background.
    - Option to clear cached data.
- **Error Handling:**
    - User-friendly messages for connectivity issues or API request failures.

### Nice-to-Haves:
- Pull-to-refresh functionality available.
- Dark mode support feature available.
- Automatic data polling.

---

## Prerequisites

1. **Install Flutter**  
   Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. **Install Docker**  
   Docker is required to run the API. Install it from [Docker's official site](https://www.docker.com/products/docker-desktop).

---

## Instructions for Running the Application

### API Setup:
1. Navigate to the `solar-monitor-api/` directory in the resources provided.
2. Build and run the API:
   ```bash
   docker build -t solar-monitor-api .
   docker run -p 3000:3000 solar-monitor-api
   ```
3. Verify the API is running by accessing [http://localhost:3000/api-docs](http://localhost:3000/api-docs).

### Project Setup:
1. Clone or extract the project files.
2. Open the project in a code editor like Android Studio, VSCode, or IntelliJ IDEA.

3. In order to allow the Flutter application to communicate with the API, you'll need to configure the system's IP address in the app_config.dart file.
   -> Locate the _app_config.dart_ file: The configuration file is located at **core/constants/app_config.dart** in the Flutter project.

4. Update the API URL:
Open the app_config.dart file and find the line where the API base URL is defined. 
    Replace localhost or 127.0.0.1 with your system's IP address. This is because the mobile app 
    running on an emulator or a physical device won't be able to connect to localhost on your machine.
   `const String baseUrl = 'http://<your-ip-address>:3000';`

    How to find your system's IP address:
    On macOS:
    ```bash
     ifconfig
    ```
   Look for **en0** or **en1** section and find the inet value, which is your IP address.
   On Windows:
   ```bash
     ipconfig
    ```
   Look for the IPv4 Address under your network adapter (usually listed under "Ethernet adapter" or "Wireless LAN adapter").

   _Note: Make sure your mobile device or emulator is on the same network as your system._

   Install the project dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application:
1. Start an emulator or connect a physical device.
2. Run the Flutter application:
   ```bash
   flutter run
   ```

### Running Tests:
1. Execute the tests to verify functionality:
   ```bash
   flutter test
   ```

---

## Trade-Offs and Design Choices Due to Time Constraints

### Trade-Offs:
1. **Caching**:
   A simple caching mechanism was implemented to prevent redundant API calls. While more robust solutions like Hive, Isar, or Sqflite offer better offline support and data management, they were deprioritized due to time constraints. Future iterations could incorporate these for enhanced offline features.

2. **Theming**:
   Basic dark mode support was included, but custom theming for specific UI components (e.g., charts) was deprioritized. Additional theming enhancements could improve the user experience and be added in future releases.

### Design Choices:
1. **Architecture:**  
   Modular structure with separation of concerns for scalability. Decoupled network and repository layers to facilitate testing and future updates.
2. **Visualization:**  
   Leveraged `fl_chart` for interactive graphs with minimal setup. Advanced features like zoom and panning were deferred.
3. **Preloading Data:**  
   Preloaded tab data when users re-open the app for enhanced responsiveness.

---

## Project Structure

# Project Directory Structure

## `lib/`
Main directory containing all the source code for the app.

### `bloc/`
Contains the BLoC (Business Logic Component) for managing app state.

- **`monitoring_cubit/`**
    - `monitoring_cubit.dart`: The Cubit for managing monitoring data state.
    - `monitoring_state.dart`: State class for monitoring Cubit, defines states like loading, success, error.

- **`theme_cubit/`**
    - `theme_cubit.dart`: Cubit that handles theme changes (light/dark mode).

- **`utility_cubit/`**
    - `utility_cubit.dart`: Cubit that manages general utility actions (e.g., clearing cache).
    - `utility_state.dart`: State class for utility Cubit.

### `core/`
Contains core functionality and shared resources.

- **`constants/`**
    - `app_color.dart`: Defines color constants used in the app.
    - `app_config.dart`: Holds configuration values like `baseUrl`.
    - `endpoints.dart`: API endpoints constants.

- **`di/`**
    - `service_locator.dart`: Service locator for managing app's dependencies.

- **`network/`**
    - `api_error.dart`: Model for API error response handling.
    - `api_interceptor.dart`: Interceptor for network requests, used for logging and error handling.
    - `network_provider.dart`: Provides network request methods.

- **`utils/`**
    - `after_build.dart`: Utility to execute code after the widget tree is built.
    - `bubble_tab_indicator.dart`: Custom tab indicator widget used in the app.
    - `periodic_timer.dart`: Timer utility for periodic actions (e.g., polling).
    - `utils.dart`: Miscellaneous utility functions.

### `data/`
Contains data models and repository interfaces.

- **`models/`**
    - `monitoring_response.dart`: Model representing monitoring data response.

- **`repository/`**
    - `i_monitoring_repository.dart`: Interface for monitoring data repository.
    - `monitoring_repository.dart`: Implementation of the monitoring data repository.

### `presentation/`
Contains UI-related files such as pages and widgets.

- **`pages/`**
    - **`mixins/`**
        - `ui_mixin.dart`: Mixin class for reusable UI-related code across pages.
    - **`views/`**
        - `battery_consumption.dart`: Screen showing battery consumption data.
        - `house_consumption.dart`: Screen showing house consumption data.
        - `solar_generation.dart`: Screen showing solar generation data.
    - `home.dart`: The main home page of the app, displaying different tabs.

- **`widgets/`**
    - `card_container.dart`: A reusable container widget used to display card-like UI elements.
    - `connectivity_status.dart`: A widget displaying the connectivity status.

### Other Files
- `app.dart`: The main entry point for the app, where the app structure is defined.
- `main.dart`: The app initialization file, including service locator setup and hydrated storage initialization.


---

## Notes
This application is designed to be a starting point for further enhancements. The modular architecture ensures scalability, making it easier to integrate additional features and optimizations.

---

## Contact
For questions or feedback, please feel free to reach out.

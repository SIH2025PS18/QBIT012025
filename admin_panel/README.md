# Hospital Admin Panel

A Flutter web application for hospital administration with real-time doctor management and synchronization with the patient mobile app.

## Features

### ✅ Completed Features

1. **Dashboard Overview**

   - Real-time statistics (doctors, patients, appointments, revenue)
   - Interactive charts and graphs
   - Recently added doctors list
   - Quick action buttons

2. **Doctor Management**

   - Add new doctors with comprehensive details
   - View all doctors in grid layout
   - Edit existing doctor information
   - Delete doctors with confirmation
   - Toggle doctor availability status
   - Search and filter doctors by department
   - Real-time updates across all connected devices

3. **Real-time Synchronization**

   - WebSocket integration for live updates
   - When admin adds/updates/deletes a doctor, changes appear instantly in patient app
   - Real-time availability status updates
   - Automatic data refresh without page reload

4. **Responsive Design**
   - Professional dark theme matching reference design
   - Sidebar navigation with expandable menus
   - Grid-based doctor cards with status indicators
   - Mobile-friendly responsive layout

### 🚧 Planned Features

- Patient Management
- Appointment Management
- Department Management
- Advanced Analytics
- User Authentication
- Role-based Access Control
- Notification System

## Technology Stack

- **Frontend**: Flutter Web
- **State Management**: Provider
- **Backend API**: Node.js/Express (https://telemed18.onrender.com/api)
- **Real-time**: Socket.IO WebSocket
- **HTTP Client**: http package
- **UI Components**: Material Design

## Project Structure

```
admin_panel/
├── lib/
│   ├── main_new.dart              # App entry point with providers
│   ├── models/
│   │   └── doctor.dart            # Doctor and Dashboard models
│   ├── services/
│   │   ├── admin_service.dart     # Backend API integration
│   │   └── websocket_service.dart # Real-time WebSocket service
│   ├── providers/
│   │   └── doctor_provider.dart   # State management for doctors
│   ├── screens/
│   │   ├── admin_dashboard_screen_new.dart    # Main dashboard
│   │   ├── doctor_management_screen.dart      # Doctor grid view
│   │   └── add_doctor_screen.dart             # Add/Edit doctor form
│   └── widgets/
│       └── sidebar.dart           # Navigation sidebar
├── pubspec.yaml                   # Dependencies
└── README.md                      # This file
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Web browser for testing
- Backend server running at https://telemed18.onrender.com

### Installation

1. **Navigate to admin panel directory:**

   ```bash
   cd admin_panel
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run -d chrome
   ```

### Backend Integration

The admin panel connects to the telemedicine backend API:

**Base URL**: `https://telemed18.onrender.com/api`

**Key Endpoints:**

- `GET /admin/dashboard/stats` - Dashboard statistics
- `GET /doctors` - Get all doctors
- `POST /doctors` - Create new doctor
- `PUT /doctors/:id` - Update doctor
- `DELETE /doctors/:id` - Delete doctor
- `PATCH /doctors/:id/availability` - Update availability

**WebSocket Events:**

- `doctor_added` - New doctor created
- `doctor_updated` - Doctor information updated
- `doctor_deleted` - Doctor removed
- `admin_doctor_*` - Admin panel broadcasts

## Key Features Explanation

### Real-time Synchronization

The admin panel uses WebSocket connections to provide real-time updates:

1. **Connection Setup**: Automatically connects to WebSocket server on app start
2. **Event Listening**: Listens for doctor-related events from other connected clients
3. **Event Broadcasting**: Sends updates when admin makes changes
4. **State Management**: Uses Provider to update UI automatically when data changes

### Doctor Management Workflow

1. **View Doctors**: Grid layout with search and filter capabilities
2. **Add Doctor**: Comprehensive form with validation and real-time updates
3. **Edit Doctor**: Pre-filled form for existing doctor data
4. **Toggle Availability**: Quick toggle for doctor availability status
5. **Delete Doctor**: Confirmation dialog with cascade delete

### Security Features

- Input validation on all forms
- Confirmation dialogs for destructive actions
- Error handling with user-friendly messages
- Loading states for better UX

## Development Guidelines

### Adding New Features

1. Create models in `models/` directory
2. Add service methods in `services/`
3. Create providers for state management
4. Build UI screens in `screens/`
5. Add reusable widgets in `widgets/`

### Code Style

- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Implement error handling
- Use consistent theming

### Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## Deployment

### Web Deployment

```bash
# Build for web
flutter build web

# Deploy to hosting service
# (Firebase Hosting, Netlify, etc.)
```

### Configuration

Update the backend URL in `services/admin_service.dart` for different environments:

```dart
static const String baseUrl = 'https://your-backend-url.com/api';
```

## API Integration

### Doctor Model

```dart
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phone": "string",
  "specialization": "string",
  "department": "string",
  "experience": "string",
  "degree": "string",
  "isAvailable": boolean,
  "workingDays": ["Monday", "Tuesday", ...],
  "workingHours": "9:00 AM - 5:00 PM",
  "consultationFee": "500",
  "about": "string"
}
```

### Dashboard Stats

```dart
{
  "totalDoctors": int,
  "totalPatients": int,
  "todayAppointments": int,
  "revenue": double,
  "monthlyGrowth": double,
  "appointmentChart": [...],
  "revenueChart": [...]
}
```

## Real-time Updates Flow

1. **Admin Panel Action**: User adds/updates/deletes doctor
2. **API Call**: HTTP request sent to backend
3. **Database Update**: Backend updates database
4. **WebSocket Broadcast**: Backend emits event to all connected clients
5. **Patient App Update**: Mobile app receives event and updates doctor list
6. **Admin Panel Update**: Other admin panels receive event and update UI

## Troubleshooting

### Common Issues

1. **WebSocket Connection Failed**

   - Check backend server status
   - Verify WebSocket endpoint URL
   - Check browser network tab for errors

2. **API Requests Failing**

   - Verify backend URL in admin_service.dart
   - Check network connectivity
   - Review server logs for errors

3. **Flutter Build Issues**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter version compatibility

### Debug Mode

Enable debug prints in services for troubleshooting:

```dart
print('API Response: ${response.body}');
print('WebSocket Event: $data');
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes with tests
4. Submit a pull request

## License

This project is part of the Telemedicine application suite.

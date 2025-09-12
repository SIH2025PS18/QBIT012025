// This file is generated automatically. Do not edit.
//
// TeleMed Multilingual Support
// Supported languages: English (en), Hindi (hi), Punjabi (pa)

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('pa'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'TeleMed'**
  String get appTitle;

  /// Welcome greeting text
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Main welcome message on splash screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to TeleMed - Your Health, Our Priority'**
  String get welcomeMessage;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Text asking if user doesn't have account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Text asking if user already has account
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Sign up link text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign in link text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Profile navigation item
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Appointments navigation item
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// Doctors navigation item
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// My profile screen title
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Patient profile screen title
  ///
  /// In en, this message translates to:
  /// **'Patient Profile'**
  String get patientProfile;

  /// Edit profile button text
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Age field label
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Gender field label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Other gender option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Blood group field label
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// Address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Emergency contact field label
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// Medical history section title
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// Allergies section title
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// Current medications section title
  ///
  /// In en, this message translates to:
  /// **'Current Medications'**
  String get currentMedications;

  /// Medical notes section title
  ///
  /// In en, this message translates to:
  /// **'Medical Notes'**
  String get medicalNotes;

  /// Book appointment button text
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// Find doctors button text
  ///
  /// In en, this message translates to:
  /// **'Find Doctors'**
  String get findDoctors;

  /// My appointments button text
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Upcoming appointments section title
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// Recent activity section title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// Doctor name field label
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorName;

  /// Specialization field label
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// Experience field label
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// Rating field label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Select date button text
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Select time button text
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Appointment reason field label
  ///
  /// In en, this message translates to:
  /// **'Reason for Appointment'**
  String get appointmentReason;

  /// Confirm appointment button text
  ///
  /// In en, this message translates to:
  /// **'Confirm Appointment'**
  String get confirmAppointment;

  /// Appointment details section title
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get appointmentDetails;

  /// Appointment date field label
  ///
  /// In en, this message translates to:
  /// **'Appointment Date'**
  String get appointmentDate;

  /// Appointment time field label
  ///
  /// In en, this message translates to:
  /// **'Appointment Time'**
  String get appointmentTime;

  /// Status field label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Confirmed status
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language option text
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Hindi language option
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// Punjabi language option
  ///
  /// In en, this message translates to:
  /// **'ਪੰਜਾਬੀ'**
  String get punjabi;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No internet connection error message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Please wait message
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// Field required validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password too short validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Passwords do not match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Login successful message
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// Registration successful message
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccessful;

  /// Profile updated success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// Appointment booked success message
  ///
  /// In en, this message translates to:
  /// **'Appointment booked successfully'**
  String get appointmentBooked;

  /// No appointments found message
  ///
  /// In en, this message translates to:
  /// **'No appointments found'**
  String get noAppointmentsFound;

  /// No doctors found message
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// Search doctors placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search Doctors'**
  String get searchDoctors;

  /// Health records section title
  ///
  /// In en, this message translates to:
  /// **'Health Records'**
  String get healthRecords;

  /// Prescriptions section title
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// Test reports section title
  ///
  /// In en, this message translates to:
  /// **'Test Reports'**
  String get testReports;

  /// Upload photo button text
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Choose from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Health journey subtitle text
  ///
  /// In en, this message translates to:
  /// **'Your health journey continues here'**
  String get healthJourney;

  /// Member since label
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// Not provided default text
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// Medical history coming soon message
  ///
  /// In en, this message translates to:
  /// **'Medical history coming soon! 📋'**
  String get medicalHistoryComingSoon;

  /// Create account button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Terms and privacy policy text
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

  /// OR divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Default user name
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Checking authentication message
  ///
  /// In en, this message translates to:
  /// **'Checking authentication...'**
  String get checkingAuthentication;

  /// Book appointment with doctor text
  ///
  /// In en, this message translates to:
  /// **'Book Appointment with'**
  String get bookAppointmentWith;

  /// Please select date and time validation message
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get pleaseSelectDateTime;

  /// Appointment booked with doctor message
  ///
  /// In en, this message translates to:
  /// **'Appointment booked with'**
  String get appointmentBookedWith;

  /// Cancel appointment dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointment;

  /// Cancel appointment confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get areYouSureCancel;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Yes cancel button text
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// Join call button text
  ///
  /// In en, this message translates to:
  /// **'Join Call'**
  String get joinCall;

  /// Video consultation coming soon message
  ///
  /// In en, this message translates to:
  /// **'Video consultation coming soon!'**
  String get videoConsultationComingSoon;

  /// Check your email dialog title
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// Email verification sent message
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification email to your address. Please check your inbox and click the verification link to activate your account.'**
  String get emailVerificationSent;

  /// Resend email button text
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// Continue to sign in button text
  ///
  /// In en, this message translates to:
  /// **'Continue to Sign In'**
  String get continueToSignIn;

  /// Error loading appointments message
  ///
  /// In en, this message translates to:
  /// **'Error loading appointments'**
  String get errorLoadingAppointments;

  /// Error loading doctors message
  ///
  /// In en, this message translates to:
  /// **'Error loading doctors'**
  String get errorLoadingDoctors;

  /// Clear filters button text
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Add sample doctors button text
  ///
  /// In en, this message translates to:
  /// **'Add Sample Doctors'**
  String get addSampleDoctors;

  /// View details button text
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Book now button text
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// Sync completed status
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// Sync in progress status
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// Sync pending status
  ///
  /// In en, this message translates to:
  /// **'Pending Sync'**
  String get pendingSync;

  /// Doctor offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Sync error status
  ///
  /// In en, this message translates to:
  /// **'Sync Error'**
  String get syncError;

  /// Sync in progress tooltip
  ///
  /// In en, this message translates to:
  /// **'Sync in progress...'**
  String get syncInProgress;

  /// Tap to sync tooltip
  ///
  /// In en, this message translates to:
  /// **'Tap to sync pending changes'**
  String get tapToSync;

  /// Sync failed tooltip
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Tap to retry'**
  String get syncFailed;

  /// Tap to refresh tooltip
  ///
  /// In en, this message translates to:
  /// **'Tap to refresh data'**
  String get tapToRefresh;

  /// Sync status dialog title
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// Connection status label
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connectionStatus;

  /// Pending changes label
  ///
  /// In en, this message translates to:
  /// **'Pending Changes'**
  String get pendingChanges;

  /// Last sync time label
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get lastSync;

  /// Sync now button text
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Video consultation screen title
  ///
  /// In en, this message translates to:
  /// **'Video Consultation'**
  String get videoConsultation;

  /// Waiting for doctor message
  ///
  /// In en, this message translates to:
  /// **'Waiting for Doctor'**
  String get waitingForDoctor;

  /// Waiting room title
  ///
  /// In en, this message translates to:
  /// **'Waiting Room'**
  String get waitingRoom;

  /// Join queue button text
  ///
  /// In en, this message translates to:
  /// **'Join Queue'**
  String get joinQueue;

  /// Queue position label
  ///
  /// In en, this message translates to:
  /// **'Queue Position'**
  String get queuePosition;

  /// Total in queue label
  ///
  /// In en, this message translates to:
  /// **'Total in Queue'**
  String get totalInQueue;

  /// Estimated wait time message
  ///
  /// In en, this message translates to:
  /// **'Estimated wait: {time}'**
  String estimatedWaitTime(String time);

  /// Scheduled for time message
  ///
  /// In en, this message translates to:
  /// **'Scheduled for {time}'**
  String scheduledFor(String time);

  /// Waiting room status message
  ///
  /// In en, this message translates to:
  /// **'Please wait while the doctor prepares for your consultation'**
  String get waitingRoomMessage;

  /// In queue status message
  ///
  /// In en, this message translates to:
  /// **'You are in the consultation queue'**
  String get inQueueMessage;

  /// Consultation scheduled message
  ///
  /// In en, this message translates to:
  /// **'Your consultation is scheduled'**
  String get consultationScheduled;

  /// Preparing consultation message
  ///
  /// In en, this message translates to:
  /// **'Preparing consultation...'**
  String get preparingConsultation;

  /// Instructions section title
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// Waiting room instructions text
  ///
  /// In en, this message translates to:
  /// **'Ensure you have a stable internet connection\nMake sure your camera and microphone are working\nKeep your health documents ready\nWait for the doctor to start the consultation'**
  String get waitingRoomInstructions;

  /// Joined queue success message
  ///
  /// In en, this message translates to:
  /// **'Successfully joined the queue'**
  String get joinedQueue;

  /// Failed to join queue error message
  ///
  /// In en, this message translates to:
  /// **'Failed to join queue'**
  String get failedToJoinQueue;

  /// Cancel consultation dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Consultation'**
  String get cancelConsultation;

  /// Cancel consultation confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this consultation?'**
  String get confirmCancelConsultation;

  /// Failed to cancel consultation error message
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel consultation'**
  String get failedToCancelConsultation;

  /// Mute button tooltip
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// Unmute button tooltip
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute;

  /// Muted status label
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get muted;

  /// Video off status label
  ///
  /// In en, this message translates to:
  /// **'Video Off'**
  String get videoOff;

  /// End call button text
  ///
  /// In en, this message translates to:
  /// **'End Call'**
  String get endCall;

  /// End consultation dialog title
  ///
  /// In en, this message translates to:
  /// **'End Consultation'**
  String get endConsultation;

  /// Participants dialog title
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// Chat button text
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Picture in picture option
  ///
  /// In en, this message translates to:
  /// **'Picture in Picture'**
  String get pictureInPicture;

  /// Full screen option
  ///
  /// In en, this message translates to:
  /// **'Full Screen'**
  String get fullScreen;

  /// Record consultation option
  ///
  /// In en, this message translates to:
  /// **'Record Consultation'**
  String get recordConsultation;

  /// Manage participants option
  ///
  /// In en, this message translates to:
  /// **'Manage Participants'**
  String get manageParticipants;

  /// Queue management screen title
  ///
  /// In en, this message translates to:
  /// **'Queue Management'**
  String get queueManagement;

  /// Queue tab title
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// Active tab title
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Queue statistics dialog title
  ///
  /// In en, this message translates to:
  /// **'Queue Statistics'**
  String get queueStatistics;

  /// Start consultation button text
  ///
  /// In en, this message translates to:
  /// **'Start Consultation'**
  String get startConsultation;

  /// Turn off video tooltip
  ///
  /// In en, this message translates to:
  /// **'Turn Off Video'**
  String get turnOffVideo;

  /// Turn on video tooltip
  ///
  /// In en, this message translates to:
  /// **'Turn On Video'**
  String get turnOnVideo;

  /// Use headphones tooltip
  ///
  /// In en, this message translates to:
  /// **'Use Headphones'**
  String get useHeadphones;

  /// Use speaker tooltip
  ///
  /// In en, this message translates to:
  /// **'Use Speaker'**
  String get useSpeaker;

  /// More options tooltip
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get moreOptions;

  /// Confirm end consultation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end this consultation?'**
  String get confirmEndConsultation;

  /// Statistics button text
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No patients message
  ///
  /// In en, this message translates to:
  /// **'No patients in queue'**
  String get noPatients;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings & Support'**
  String get settingsAndSupport;

  /// Language preferences section title
  ///
  /// In en, this message translates to:
  /// **'Language Preferences'**
  String get languagePreferences;

  /// Data and connectivity section title
  ///
  /// In en, this message translates to:
  /// **'Data & Connectivity'**
  String get dataAndConnectivity;

  /// Data saver mode setting
  ///
  /// In en, this message translates to:
  /// **'Data Saver Mode'**
  String get dataSaverMode;

  /// Notifications enabled setting
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled'**
  String get notificationsEnabled;

  /// SMS mode setting
  ///
  /// In en, this message translates to:
  /// **'SMS Mode'**
  String get smsMode;

  /// Clear search button text
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// Directions button text
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// Reserve button text
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// Medical records title
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get medicalRecords;

  /// Loading medical records message
  ///
  /// In en, this message translates to:
  /// **'Loading medical records...'**
  String get loadingMedicalRecords;

  /// No profile data message
  ///
  /// In en, this message translates to:
  /// **'No profile data available'**
  String get noProfileData;

  /// Medical details saved success message
  ///
  /// In en, this message translates to:
  /// **'Medical details saved successfully!'**
  String get medicalDetailsSaved;

  /// Failed to save medical details error
  ///
  /// In en, this message translates to:
  /// **'Failed to save medical details'**
  String get failedToSaveMedicalDetails;

  /// Added allergy success message
  ///
  /// In en, this message translates to:
  /// **'Added allergy'**
  String get addedAllergy;

  /// Error loading medical records message
  ///
  /// In en, this message translates to:
  /// **'Error loading medical records'**
  String get errorLoadingMedicalRecords;

  /// Quick access section title
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// Test video call button text
  ///
  /// In en, this message translates to:
  /// **'Test Video Call'**
  String get testVideoCall;

  /// Join live doctor queue button text
  ///
  /// In en, this message translates to:
  /// **'Join Live Doctor Queue'**
  String get joinLiveDoctorQueue;

  /// Registration failed error message
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// Enter full name hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// Enter phone number hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// Enter 10-digit phone number hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your 10-digit phone number'**
  String get enterTenDigitPhone;

  /// Enter password hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Enter password with minimum characters hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password (min 6 characters)'**
  String get enterPasswordMinSix;

  /// Re-enter password hint text
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reenterPassword;

  /// Invalid phone or password error message
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number or password'**
  String get invalidPhoneOrPassword;

  /// Sign in failed error message
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get signInFailed;

  /// Please enter phone number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// Failed to send OTP error message
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP'**
  String get failedToSendOTP;

  /// Please enter OTP validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP'**
  String get pleaseEnterOTP;

  /// OTP verified successfully message
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otpVerifiedSuccessfully;

  /// Invalid OTP error message
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOTP;

  /// Failed to verify OTP error message
  ///
  /// In en, this message translates to:
  /// **'Failed to verify OTP'**
  String get failedToVerifyOTP;

  /// Please enter new password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// Password reset successfully message
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get passwordResetSuccessfully;

  /// Failed to reset password error message
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password. Please try again.'**
  String get failedToResetPassword;

  /// Enter 6-digit OTP hint text
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP'**
  String get enterSixDigitOTP;

  /// Resend OTP button text
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOTP;

  /// Enter new password hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// Confirm new password hint text
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmNewPassword;

  /// Health journey subtitle text
  ///
  /// In en, this message translates to:
  /// **'Your health journey starts here'**
  String get healthJourneyStarts;

  /// General doctors online counter text
  ///
  /// In en, this message translates to:
  /// **'{count} General Doctors Online'**
  String generalDoctorsOnline(Object count);

  /// Available status for doctors
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// My health records shortcut text
  ///
  /// In en, this message translates to:
  /// **'My Health Records'**
  String get myHealthRecords;

  /// Medicine stock shortcut text
  ///
  /// In en, this message translates to:
  /// **'Medicine Stock'**
  String get medicineStock;

  /// First aid tips shortcut text
  ///
  /// In en, this message translates to:
  /// **'First Aid Tips'**
  String get firstAidTips;

  /// Dermatologist specialization
  ///
  /// In en, this message translates to:
  /// **'Dermatologist'**
  String get dermatologist;

  /// Doctor title prefix
  ///
  /// In en, this message translates to:
  /// **'Dr.'**
  String get doctorTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'pa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'pa':
      return AppLocalizationsPa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

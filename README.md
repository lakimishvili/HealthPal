# 🏥 HealthPal – Healthcare Booking App

HealthPal is a full‑stack healthcare mobile application designed to make finding doctors, hospitals, and booking medical appointments simple, fast, and user‑friendly. The project is built with a **Node.js backend** and an **iOS frontend using UIKit + SwiftUI**, following real‑world architecture patterns and RESTful API communication.

This project was developed as an end‑to‑end healthcare solution, covering authentication, discovery, booking, favorites, and profile management.

---

## 📱 Platforms & Tech Stack

### Frontend (iOS)

* **Language:** Swift
* **UI Frameworks:** UIKit + SwiftUI (hybrid approach)
* **Architecture:** MVVM
* **Networking:** URLSession
* **State Management:** ViewModels + @State / @StateObject
* **UI Components:**

  * Custom UIKit cells
  * SwiftUI views for modern layouts
  * Bottom sheets, cards, widgets

### Backend

* **Runtime:** Node.js
* **Framework:** Express.js
* **Database:** SQLite
* **Architecture:** REST API
* **Authentication:** Email-based auth (login, register, password reset)

---

## 🔐 Authentication & Account Flow

HealthPal includes a complete authentication and onboarding experience:

### Create Account

* User registers using **email and password**
* Basic validation and error handling

### Fill Account Information

* After registration, users complete their profile
* Personal data stored securely on the backend

### Sign In

* Email + password authentication
* Session handling on the client side

### Forgot Password

* Password reset via **email**
* Backend generates reset logic
* User can securely set a new password

---

## 🏠 Home Screen

The Home screen is the central hub of the app and provides quick access to key features:

### Widgets & Highlights

* **Top Rated Doctor**
* **Most Reviewed Doctor**
* **Doctors with Most Patients**
* Quick visual widgets for better UX

### Categories

* Doctor categories displayed in a grid
* Ability to show all or collapse categories

### Search

* Global search for doctors and hospitals

---

## 🏥 Hospitals

### Hospitals List Screen

* Displays all hospitals
* Supports:

  * 🔍 Search
  * ↕️ Sorting
  * 🎯 Filtering

### Hospital Details

* Hospital information
* Associated doctors
* Ability to mark hospital as **favorite**

---

## 👨‍⚕️ Doctors

### Doctors List Screen

* Doctors can be accessed from:

  * Home screen
  * Hospital details
  * Category selection

### Filtering & Sorting

* Filter by category
* Sort by rating, reviews, or name
* Search by doctor name

### Doctor Detail Screen

* Full doctor profile
* Specialty & category
* Working hours
* Hospital information
* Favorite button

---

## 📅 Appointment Booking

### Booking Screen

* Displays available time slots based on:

  * Doctor working hours
  * Selected date
  * Existing appointments

### Slot Logic

* Past dates are blocked
* Already booked time slots are disabled
* Time slots update dynamically

### Booking Confirmation

* Appointment stored in the database
* Linked to user, doctor, and hospital

---

## 📖 Bookings List

### My Appointments Screen

* Displays all upcoming appointments
* Custom card‑style cells
* Shows:

  * Doctor name
  * Hospital name
  * Date & time

### Past Appointment Warning

* Automatically detects past appointments
* Shows a **red warning label** if appointment has already passed

### Swipe to Cancel

* Swipe gesture to cancel upcoming appointments
* Updates backend and UI in real time

---

## ❤️ Favorites

### Favorites Screen

* Separate sections for:

  * Favorite doctors
  * Favorite hospitals

### Functionality

* Add/remove favorites
* Persistent storage per user
* Used across the app (lists & detail screens)

---

## 👤 Profile & Notifications

### Profile Screen

* User information
* Account management
* Logout functionality

### Notifications

* Booking-related notifications
* UI prepared for future push notification integration

---

## 🌐 Backend API Overview

### Appointments

* Get available slots
* Book appointment
* Fetch user appointments
* Cancel appointment

### Doctors

* Get all doctors
* Get doctor by ID
* Filter and search

### Hospitals

* Get all hospitals
* Hospital details

### Users

* Register
* Login
* Reset password

All endpoints return JSON and follow REST conventions.

---

## 🎯 Project Goals

* Build a **realistic healthcare booking system**
* Practice full‑stack development
* Implement clean architecture and UI/UX
* Demonstrate real‑world iOS + backend integration

---

## 🚀 Future Improvements

* Push notifications
* Payment integration
* Doctor reviews & ratings
* Admin dashboard
* Calendar sync

---

## 🧠 Author

**Liliana Akimishvili**
Healthcare Booking App – iOS & Node.js Project

---

If you want this README adapted for **GitHub**, **portfolio**, or **university submission**, I can tailor it exactly for that 👌
# 🏥 HealthPal – Healthcare Booking App

HealthPal is a full‑stack healthcare mobile application designed to make finding doctors, hospitals, and booking medical appointments simple, fast, and user‑friendly. The project is built with a **Node.js backend** and an **iOS frontend using UIKit + SwiftUI**, following real‑world architecture patterns and RESTful API communication.

This project was developed as an end‑to‑end healthcare solution, covering authentication, discovery, booking, favorites, and profile management.

---

## 📱 Platforms & Tech Stack

### Frontend (iOS)

* **Language:** Swift
* **UI Frameworks:** UIKit + SwiftUI (hybrid approach)
* **Architecture:** MVVM
* **Networking:** URLSession
* **State Management:** ViewModels + @State / @StateObject
* **UI Components:**

  * Custom UIKit cells
  * SwiftUI views for modern layouts
  * Bottom sheets, cards, widgets

### Backend

* **Runtime:** Node.js
* **Framework:** Express.js
* **Database:** SQLite
* **Architecture:** REST API
* **Authentication:** Email-based auth (login, register, password reset)

---

## 🔐 Authentication & Account Flow

HealthPal includes a complete authentication and onboarding experience:

### Create Account

* User registers using **email and password**
* Basic validation and error handling

### Fill Account Information

* After registration, users complete their profile
* Personal data stored securely on the backend

### Sign In

* Email + password authentication
* Session handling on the client side

### Forgot Password

* Password reset via **email**
* Backend generates reset logic
* User can securely set a new password

---

## 🏠 Home Screen

The Home screen is the central hub of the app and provides quick access to key features:

### Widgets & Highlights

* **Top Rated Doctor**
* **Most Reviewed Doctor**
* **Doctors with Most Patients**
* Quick visual widgets for better UX

### Categories

* Doctor categories displayed in a grid
* Ability to show all or collapse categories

### Search

* Global search for doctors and hospitals

---

## 🏥 Hospitals

### Hospitals List Screen

* Displays all hospitals
* Supports:

  * 🔍 Search
  * ↕️ Sorting
  * 🎯 Filtering

### Hospital Details

* Hospital information
* Associated doctors
* Ability to mark hospital as **favorite**

---

## 👨‍⚕️ Doctors

### Doctors List Screen

* Doctors can be accessed from:

  * Home screen
  * Hospital details
  * Category selection

### Filtering & Sorting

* Filter by category
* Sort by rating, reviews, or name
* Search by doctor name

### Doctor Detail Screen

* Full doctor profile
* Specialty & category
* Working hours
* Hospital information
* Favorite button

---

## 📅 Appointment Booking

### Booking Screen

* Displays available time slots based on:

  * Doctor working hours
  * Selected date
  * Existing appointments

### Slot Logic

* Past dates are blocked
* Already booked time slots are disabled
* Time slots update dynamically

### Booking Confirmation

* Appointment stored in the database
* Linked to user, doctor, and hospital

---

## 📖 Bookings List

### My Appointments Screen

* Displays all upcoming appointments
* Custom card‑style cells
* Shows:

  * Doctor name
  * Hospital name
  * Date & time

### Past Appointment Warning

* Automatically detects past appointments
* Shows a **red warning label** if appointment has already passed

### Swipe to Cancel

* Swipe gesture to cancel upcoming appointments
* Updates backend and UI in real time

---

## ❤️ Favorites

### Favorites Screen

* Separate sections for:

  * Favorite doctors
  * Favorite hospitals

### Functionality

* Add/remove favorites
* Persistent storage per user
* Used across the app (lists & detail screens)

---

## 👤 Profile & Notifications

### Profile Screen

* User information
* Account management
* Logout functionality

### Notifications

* Booking-related notifications
* UI prepared for future push notification integration

---

## 🌐 Backend API Overview

### Appointments

* Get available slots
* Book appointment
* Fetch user appointments
* Cancel appointment

### Doctors

* Get all doctors
* Get doctor by ID
* Filter and search

### Hospitals

* Get all hospitals
* Hospital details

### Users

* Register
* Login
* Reset password

All endpoints return JSON and follow REST conventions.

---

## 🎯 Project Goals

* Build a **realistic healthcare booking system**
* Practice full‑stack development
* Implement clean architecture and UI/UX
* Demonstrate real‑world iOS + backend integration

---

## 🚀 Future Improvements

* Push notifications
* Payment integration
* Doctor reviews & ratings
* Admin dashboard
* Calendar sync

---


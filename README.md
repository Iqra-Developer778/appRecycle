# ♻️ AppRecycle — Smart Recycling Reward App

A Flutter mobile application developed as a Final Year Project (FYP) that encourages users to recycle waste by rewarding them with points. Users can submit recyclable items, earn points, and redeem rewards — all managed through a secure admin panel.

---

## 📱 Features

### User Side
- **Onboarding Screen** — App introduction for new users
- **Login / Signup** — Firebase Authentication
- **Home Screen** — Dashboard with quick access to all features
- **Upload Item** — Submit recyclable items (Plastic, Glass, Paper, Battery, E-Waste)
- **Points Tracker** — View earned points in real-time
- **Redeem Rewards** — Request reward redemption using accumulated points
- **History** — View past submissions and their status
- **AI Tips** — Smart recycling tips powered by AI
- **Profile** — Manage user profile

### Admin Side
- **Admin Login** — Secure admin-only access (credentials not included in repo)
- **Admin Panel** — Central dashboard for admin actions
- **Approval Management** — Approve or reject user recycling submissions
- **Redeem Management** — Approve reward redemption requests

---

## 🏆 Points System

| Category | Points per Item |
|----------|----------------|
| Plastic  | 10 pts         |
| Glass    | 8 pts          |
| Paper    | 5 pts          |
| Battery  | 15 pts         |
| E-Waste  | 20 pts         |
| Other    | 2 pts          |

---

## 🛠️ Tech Stack

| Layer        | Technology              |
|--------------|-------------------------|
| Frontend     | Flutter (Dart)          |
| Backend      | Firebase                |
| Database     | Cloud Firestore         |
| Auth         | Firebase Authentication |
| State Mgmt   | setState / Streams      |
| Navigation   | Curved Navigation Bar   |

---

## 📂 Project Structure

```
lib/
├── Admin/
│   ├── admin_login.dart
│   ├── admin_panel.dart
│   ├── admin_approval.dart
│   └── admin_redeem.dart
├── pages/
│   ├── onboarding.dart
│   ├── login.dart
│   ├── home.dart
│   ├── upload_item.dart
│   ├── points.dart
│   ├── history.dart
│   ├── profile.dart
│   └── ai_tips.dart
├── services/
│   ├── auth.dart
│   ├── database.dart
│   ├── shared_preference.dart
│   └── widget_support.dart
└── main.dart
```

---

## ⚙️ Setup 

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- Firebase project set up


## 🔐 Admin Access

Admin credentials are **not included** in this repository for security reasons.

> To get admin access for testing, please contact the developer directly.

---


## 📸 Screenshots

> *(Add screenshots of your app here)*

---

## 👩‍💻 Developer

**[Iqra Altaf]**  
Final Year Project — [BZU]  
[IT] — [Year]

---

## 📄 License

This project is developed for academic purposes only.

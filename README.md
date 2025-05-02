# AgriMatch 🌱

AgriMatch is a mobile application designed to make sustainable farming smarter and more efficient.  
Farmers can swipe through recommended plant pairings (companion planting), search for crops manually, and manage their accepted and rejected plants to optimize their planting strategy.

---

## 🚀 Features

- **Tinder-Style Swiping:** Swipe right to accept, swipe left to reject plant pairings based on smart recommendations.
- **Dynamic Search:** Instantly search and pick plants directly through a fast, clean search experience.
- **Smart Home Dashboard:** (Coming soon) View your accepted crops, success stats, and optimize your planting decisions.
- **Profile Management:** Manage your account and reset your preferences anytime.
- **Sustainable Focus:** Encourages sustainable and eco-friendly farming practices through optimized companion planting.

---

## 🛠 Tech Stack

- **SwiftUI** (Frontend)
- **Firebase Authentication** (User login/signup)
- **Firebase Firestore** (Store accepted and rejected plants)
- **Firebase Storage** (Plant images from URLs)
- **Swift Codable + AsyncImage** (Dynamic image loading and data handling)

---

## 👨‍💻 Team Members

- **Vibhun Naredla** — Lead Developer & Architect
- **Aryan Mathur** — Lead UI/UX Designer & Developer
- **Samarth Chenumolu** — Data Collection & Plant Dataset Curation
- **Aditya Shah** — Project Coordinator & QA
- **Ronav Gopal** — Database Manager

---

## 📋 Setup Instructions

1. Clone the repository.
2. Open the project in **Xcode**.
3. Install Firebase and configure `GoogleService-Info.plist`.
4. Add the `PlantCardsData.json` file into the Xcode project.
5. Make sure your Firestore database is set up with rules allowing authenticated reads/writes.
6. Make sure you enter Google Gemini API keys in the required sections.
7. Run the project on a simulator or real device!

---

## 📈 Future Improvements

- Auto-sync plant preferences across devices.
- Add seasonal tips and AI-driven planting advice.
- Leaderboard of most popular companion pairings among users.

---

## 🧠 Special Thanks
To Kaggle and the open datasets community for providing the initial crop and plant datasets that helped bring AgriMatch to life.

---

🌾 **AgriMatch — Helping farmers grow smarter, together!**

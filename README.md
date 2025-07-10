
```markdown
# Restaurant App Flutter + Express.js

Une application de gestion/commande de restaurant composée d’un **frontend Flutter** et d’un **backend Express.js** (Node.js). Le frontend propose une interface mobile, tandis que l’API REST gère les données (plats, catégories, commandes…).

---

## 🧩 Architecture

```

/backend       # API REST Express.js
/frontend      # Application mobile Flutter

````

---

## 🚀 Technologies

- **Backend** : Node.js, Express.js, MongoDB (ou autre BDD), Mongoose, dotenv, cors  
- **Frontend** : Flutter (Dart), Provider / Bloc / GetX (selon votre choix), HTTP

---

## ⚙️ Installation

### Backend
```bash
cd backend
npm install
# Configurer MONGODB_URI et PORT dans .env
npm start 
````

### Frontend

```bash
cd frontend
flutter pub get
# Lancer sur un émulateur ou appareil mobile :
flutter run
```

---

## 📦 API Endpoints

* `/api/uploads/**`
* `/api/orders/**`
* `/api/products/**`
* `/api/auth/**`

> *Adaptez vos routes selon votre code*

---

## 🎯 Fonctionnalités (proposées)

### Frontend Flutter

* Navigation entre écrans : home, détails, panier, profil
* Affichage dynamique des éléments du menu
* Ajout d’articles au panier + gestion quantité
* Envoi de commandes via API

### Backend Express.js

* CRUD
* MongoDB + Mongoose pour persistance
* CORS configuré pour Flutter

---

## 💡 Exemple d’utilisation

1. Lancez le backend
2. Vérifiez l’API avec Postman à `http://localhost:<PORT>/api/...`
3. Lancez l’app Flutter, créez une commande via l’app, envoyez-la à l’API
4. Vérifiez la commande dans la base de données

---

## ✅ Contribution

PRs bienvenues 👍
Merci de décrire votre PR (fix, feature…), d’ajouter des tests si besoin.

---

## 📄 Licence

Ce projet est sous licence **MIT**.

---

## 🎯 À améliorer

* Authentification utilisateurs (JWT, Firebase Auth…)
* Paiement (Stripe, Paypal…)
* Panel admin Web
* Notifications push (FCM…)
* Architecture avancée (clean architecture, modules)

---

### 🔧 Aide

* Backend Express.js — [Documentation officielle](https://expressjs.com/)
* Flutter — [Documentation Flutter](https://flutter.dev/docs)
* MongoDB + Mongoose — [Docs Mongoose](https://mongoosejs.com/docs/)

---

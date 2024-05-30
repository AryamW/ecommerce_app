importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyCYLsUhLt3dpgUl5ZXQGoNsYs-yUfEt-6A",
  authDomain: "project-red-9d656.firebaseapp.com",
  projectId: "project-red-9d656",
  storageBucket: "project-red-9d656.appspot.com",
  messagingSenderId: "641574119132",
  appId: "1:641574119132:web:23aeeecad5120d7a14f619",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});

importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyB1ifzra_LbCZJ5LnRzSeSyIsKyFOHRGDY",
  authDomain: "red-ecommerce-d9a83.firebaseapp.com",
  projectId: "red-ecommerce-d9a83",
  storageBucket: "red-ecommerce-d9a83.appspot.com",
  messagingSenderId: "90775836694",
  appId: "1:90775836694:web:d33c30715625493f5dfd37",
  measurementId: "G-MJQ6T1JDXC",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});

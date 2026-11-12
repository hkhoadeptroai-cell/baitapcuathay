importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDSOOYqeitoOPcgkVMFmAQjHmgKaob_6-U',
  authDomain: 'uth-todo-43070.firebaseapp.com',
  projectId: 'uth-todo-43070',
  storageBucket: 'uth-todo-43070.firebasestorage.app',
  messagingSenderId: '212819653430',
  appId: '1:212819653430:web:c52d53bea2ede82886f997',
});

// Khi tab đang đóng hoặc ở nền, trình duyệt tự hiện thông báo
firebase.messaging();
// Production build. Firebase web config of the `city-proto` project. Google sign-in needs only apiKey, authDomain and
// projectId; the key is the project's API key (the Android app's, not restricted to Android). If a web app is
// registered in the Firebase console later, its apiKey and appId can replace these.
export const environment = {
  production: true,
  firebase: {
    apiKey: 'AIzaSyDntM5e1-6mkFucPdOzsnESZjrB4Met4os',
    authDomain: 'city-proto.firebaseapp.com',
    projectId: 'city-proto',
  } as { apiKey: string; authDomain: string; projectId: string; appId?: string },
};

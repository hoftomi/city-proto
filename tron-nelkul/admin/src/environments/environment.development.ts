// Development build (ng serve). Same Firebase project as production; see environment.ts.
export const environment = {
  production: false,
  firebase: {
    apiKey: 'AIzaSyDntM5e1-6mkFucPdOzsnESZjrB4Met4os',
    authDomain: 'city-proto.firebaseapp.com',
    projectId: 'city-proto',
  } as { apiKey: string; authDomain: string; projectId: string; appId?: string },
};

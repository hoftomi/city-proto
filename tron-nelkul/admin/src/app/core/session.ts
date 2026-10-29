import { Injectable, computed, inject, signal } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { FirebaseApp, initializeApp } from 'firebase/app';
import {
  Auth,
  GoogleAuthProvider,
  User,
  getAuth,
  onAuthStateChanged,
  signInWithPopup,
  signOut,
} from 'firebase/auth';
import { firstValueFrom } from 'rxjs';
import { AuthService, UserDto } from '../api';
import { environment } from '../../environments/environment';

export const ROLE_ADMIN = 'ADMIN';

/** False while environment.ts still holds a placeholder API key (appId is optional for sign-in). */
export function firebaseConfigured(): boolean {
  return !environment.firebase.apiKey.startsWith('REPLACE_');
}

/** Firebase sign-in (Google popup) and the signed-in backend user (GET /api/me). */
@Injectable({ providedIn: 'root' })
export class Session {
  private readonly authApi = inject(AuthService);
  private readonly app: FirebaseApp = initializeApp(environment.firebase);
  private readonly auth: Auth = getAuth(this.app);

  readonly user = signal<User | null>(null);
  readonly me = signal<UserDto | null>(null);
  readonly isAdmin = computed(() => this.me()?.role === ROLE_ADMIN);

  /** Resolves after Firebase restored (or not) the previous session. */
  readonly ready: Promise<void>;

  constructor() {
    this.ready = new Promise((resolve) => {
      onAuthStateChanged(this.auth, (u) => {
        if (u?.uid !== this.user()?.uid) this.me.set(null);
        this.user.set(u);
        resolve();
      });
    });
  }

  async signIn(): Promise<void> {
    const provider = new GoogleAuthProvider();
    provider.setCustomParameters({ prompt: 'select_account' });
    await signInWithPopup(this.auth, provider);
  }

  async signOut(): Promise<void> {
    this.me.set(null);
    await signOut(this.auth);
  }

  /** Firebase ID token; the SDK refreshes it when it is about to expire. */
  async idToken(forceRefresh = false): Promise<string | null> {
    await this.ready;
    const u = this.auth.currentUser;
    return u ? u.getIdToken(forceRefresh) : null;
  }

  /** GET /api/me once per sign-in (the first call creates the backend user). */
  async loadMe(): Promise<UserDto> {
    const cached = this.me();
    if (cached) return cached;
    const me = await firstValueFrom(this.authApi.getMe());
    this.me.set(me);
    return me;
  }
}

export function isHttpError(e: unknown, status?: number): e is HttpErrorResponse {
  return e instanceof HttpErrorResponse && (status === undefined || e.status === status);
}

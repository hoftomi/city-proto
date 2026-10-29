import { TestBed } from '@angular/core/testing';
import { HttpClient, provideHttpClient, withInterceptors } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { firstValueFrom } from 'rxjs';
import { authInterceptor } from './auth.interceptor';
import { Session } from './session';

describe('authInterceptor', () => {
  let http: HttpClient;
  let backend: HttpTestingController;
  const calls: boolean[] = [];

  beforeEach(() => {
    calls.length = 0;
    const session = { idToken: async (force = false) => (calls.push(force), force ? 'fresh' : 'cached') };
    TestBed.configureTestingModule({
      providers: [
        provideHttpClient(withInterceptors([authInterceptor])),
        provideHttpClientTesting(),
        { provide: Session, useValue: session },
      ],
    });
    http = TestBed.inject(HttpClient);
    backend = TestBed.inject(HttpTestingController);
  });

  const flushMicrotasks = () => new Promise((r) => setTimeout(r));

  it('adds the bearer token to /api calls but not to the public i18n endpoint', async () => {
    const admin = firstValueFrom(http.get('/api/admin/users'));
    await flushMicrotasks();
    const req = backend.expectOne('/api/admin/users');
    expect(req.request.headers.get('Authorization')).toBe('Bearer cached');
    req.flush([]);
    await admin;

    const i18n = firstValueFrom(http.get('/api/i18n/hu'));
    const pub = backend.expectOne('/api/i18n/hu');
    expect(pub.request.headers.has('Authorization')).toBe(false);
    pub.flush({});
    await i18n;
  });

  it('retries once with a refreshed token on 401', async () => {
    const result = firstValueFrom(http.get('/api/me'));
    await flushMicrotasks();
    backend.expectOne('/api/me').flush(null, { status: 401, statusText: 'Unauthorized' });
    await flushMicrotasks();
    const retry = backend.expectOne('/api/me');
    expect(retry.request.headers.get('Authorization')).toBe('Bearer fresh');
    retry.flush({ id: 'x', name: 'n', role: 'ADMIN' });
    expect(await result).toEqual({ id: 'x', name: 'n', role: 'ADMIN' });
    expect(calls).toEqual([false, true]);
  });
});

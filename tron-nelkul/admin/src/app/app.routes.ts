import { Routes } from '@angular/router';
import { adminGuard, signedOutGuard } from './core/guards';

export const routes: Routes = [
  { path: 'login', canActivate: [signedOutGuard], loadComponent: () => import('./pages/login/login').then((m) => m.Login) },
  { path: 'no-access', loadComponent: () => import('./pages/no-access/no-access').then((m) => m.NoAccess) },
  {
    path: '',
    canActivate: [adminGuard],
    loadComponent: () => import('./pages/shell/shell').then((m) => m.Shell),
    children: [
      { path: '', pathMatch: 'full', loadComponent: () => import('./pages/dashboard/dashboard').then((m) => m.Dashboard) },
      { path: 'games', loadComponent: () => import('./pages/games/games').then((m) => m.Games) },
      { path: 'games/:id', loadComponent: () => import('./pages/game-detail/game-detail').then((m) => m.GameDetailPage) },
      { path: 'users', loadComponent: () => import('./pages/users/users').then((m) => m.Users) },
    ],
  },
  { path: '**', redirectTo: '' },
];

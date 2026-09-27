import { useEffect, useReducer } from 'react';
import { initialState } from './game/world.js';
import { addDraft, seal, advance, sellInfo } from './game/engine.js';

const KEY = 'tron-nelkul-proto-v2';

function load() {
  try { const raw = localStorage.getItem(KEY); if (raw) return JSON.parse(raw); } catch (e) { /* nincs tárhely */ }
  return initialState();
}

function reducer(state, a) {
  switch (a.type) {
    case 'addDraft': return addDraft(state, a.order);
    case 'removeDraft': return { ...state, draft: state.draft.filter((o) => o.id !== a.id), lastError: null };
    case 'seal': return seal(state);
    case 'advance': return advance(state, a.minutes);
    case 'sellInfo': return sellInfo(state, a.id);
    case 'clearError': return { ...state, lastError: null };
    case 'reset': return initialState();
    default: return state;
  }
}

export function useGame() {
  const [state, dispatch] = useReducer(reducer, undefined, load);
  useEffect(() => { try { localStorage.setItem(KEY, JSON.stringify(state)); } catch (e) { /* nincs tárhely */ } }, [state]);
  return [state, dispatch];
}

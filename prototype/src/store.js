import { useEffect, useReducer } from 'react';
import { initialState } from './game/world.js';
import { makeOrder, canAfford, resolveRound } from './game/engine.js';

const KEY = 'tron-nelkul-proto-v1';

function load() {
  try { const raw = localStorage.getItem(KEY); if (raw) return JSON.parse(raw); } catch (e) { /* nincs tárhely */ }
  return initialState();
}

// A reducer a játékállapotot kezeli. Hibánál az állapot nem változik, a hiba a `lastError` mezőbe kerül.
function reducer(state, action) {
  switch (action.type) {
    case 'addOrder': {
      if (state.sealed) return { ...state, lastError: 'A parancslap le van pecsételve. Előbb törd fel a pecsétet.' };
      const order = makeOrder(state, action.order);
      const err = canAfford(state, order.cost);
      if (err) return { ...state, lastError: err };
      return { ...state, orders: [...state.orders, order], lastError: null };
    }
    case 'removeOrder':
      return { ...state, orders: state.orders.filter((_, i) => i !== action.index), lastError: null };
    case 'seal': return { ...state, sealed: true, lastError: null };
    case 'unseal': return { ...state, sealed: false };
    case 'resolve': return { ...resolveRound(state), lastError: null };
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

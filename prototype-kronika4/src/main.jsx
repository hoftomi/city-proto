import { createRoot } from 'react-dom/client';
import './ds/tokens.css';
import './ds/components.css';
import './app.css';
import './lobby/lobby.css';
import Root from './Root.jsx';

// Téma: a rendszer beállítását követi (Nappali / Éjjeli térkép)
const mq = window.matchMedia('(prefers-color-scheme: dark)');
const applyTheme = () => { document.documentElement.dataset.theme = mq.matches ? 'dark' : 'light'; };
applyTheme(); mq.addEventListener?.('change', applyTheme);

createRoot(document.getElementById('root')).render(<Root />);

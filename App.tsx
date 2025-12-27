
import React, { useState, useEffect } from 'react';
import LaunchScreen from './components/LaunchScreen';
import ChatInterface from './components/ChatInterface';
import Auth from './components/Auth';

const IDENTITY_KEY = 'portal_current_identity';

const App: React.FC = () => {
  const [showLaunch, setShowLaunch] = useState(true);
  const [userPresence, setUserPresence] = useState<string | undefined>(undefined);
  const [isAuthOpen, setIsAuthOpen] = useState(false);

  // Persistence of identity
  useEffect(() => {
    const savedIdentity = localStorage.getItem(IDENTITY_KEY);
    if (savedIdentity) {
      setUserPresence(savedIdentity);
    }
  }, []);

  const handleIdentity = (name: string) => {
    setUserPresence(name);
    localStorage.setItem(IDENTITY_KEY, name);
    setIsAuthOpen(false);
  };

  const handleLogout = () => {
    setUserPresence(undefined);
    localStorage.removeItem(IDENTITY_KEY);
  };

  const triggerAuth = () => {
    setIsAuthOpen(true);
  };

  return (
    <div className="h-screen w-screen bg-black overflow-hidden text-white selection:bg-white/5">
      {showLaunch ? (
        <LaunchScreen onStart={() => setShowLaunch(false)} />
      ) : (
        <div className="h-full relative flex flex-col overflow-hidden bg-black">
          {/* Identity Anchor */}
          <header className="fixed top-0 left-0 right-0 pt-6 md:pt-8 pb-8 flex flex-col items-center pointer-events-none z-30 bg-black">
            <h1 className="text-4xl md:text-5xl font-semibold tracking-tight text-white mb-1.5">
              Christopher Celaya
            </h1>
            
            <div className="flex flex-col items-center space-y-0.5 pointer-events-auto">
              <div className="text-white/40 text-[10px] md:text-[11px] font-mono tracking-[0.2em] uppercase leading-tight">
                CLOS: COGNITIVE LIFE OPERATING SYSTEM
              </div>
              <div className="text-white/40 text-[10px] md:text-[11px] font-mono tracking-[0.2em] uppercase leading-tight">
                CHRIS [ RELEASE ]
              </div>
              
              {!userPresence && (
                <button 
                  onClick={triggerAuth}
                  className="mt-3 text-white/30 hover:text-white/50 text-[9px] tracking-[0.3em] uppercase transition-all duration-300 font-mono"
                >
                  Connect Identity
                </button>
              )}

              <Auth 
                isOpen={isAuthOpen}
                onClose={() => setIsAuthOpen(false)}
                currentIdentity={userPresence} 
                onIdentity={handleIdentity} 
                onLogout={handleLogout}
              />
            </div>
          </header>

          {/* Core Content Layer */}
          <main className="flex-1 min-h-0 relative z-0">
            <ChatInterface userId={userPresence} onConnectIdentity={triggerAuth} />
          </main>

        </div>
      )}
    </div>
  );
};

export default App;


import React, { useState, useEffect } from 'react';

interface AuthProps {
  onIdentity: (name: string) => void;
  currentIdentity?: string;
  onLogout: () => void;
  isOpen: boolean;
  onClose: () => void;
}

const Auth: React.FC<AuthProps> = ({ onIdentity, currentIdentity, onLogout, isOpen, onClose }) => {
  const [step, setStep] = useState<'id' | 'key'>('id');
  const [idValue, setIdValue] = useState('');
  const [keyValue, setKeyValue] = useState('');
  const [isLogin, setIsLogin] = useState(true);

  if (!isOpen && !currentIdentity) return null;

  if (currentIdentity && !isOpen) {
    return (
      <div className="flex items-center space-x-4 mt-2 animate-in fade-in duration-1000">
        <span className="text-white/40 text-[9px] tracking-[0.4em] uppercase font-bold">
          {currentIdentity}
        </span>
        <button 
          onClick={onLogout}
          className="text-white/10 hover:text-white/40 text-[9px] tracking-[0.4em] uppercase transition-all duration-300 font-bold"
        >
          [ RELEASE ]
        </button>
      </div>
    );
  }

  if (!isOpen) return null;

  const handleSubmitId = (e: React.FormEvent) => {
    e.preventDefault();
    if (idValue.trim()) {
      // Simple check to simulate login vs signup
      const existing = localStorage.getItem(`portal_history_${idValue.trim().toLowerCase()}`);
      setIsLogin(!!existing);
      setStep('key');
    }
  };

  const handleSubmitKey = (e: React.FormEvent) => {
    e.preventDefault();
    if (keyValue.trim()) {
      onIdentity(idValue.trim().toLowerCase());
      setIdValue('');
      setKeyValue('');
      setStep('id');
      onClose();
    }
  };

  return (
    <div className="fixed inset-0 bg-black z-[100] flex flex-col items-center justify-center p-6 animate-in fade-in duration-500">
      <div className="w-full max-w-xs space-y-16">
        <div className="space-y-2">
          <h2 className="text-[10px] uppercase tracking-[0.5em] text-[#AAAAAA] font-bold text-center">
            {step === 'id' ? 'ESTABLISH IDENTITY' : (isLogin ? 'RESUME SESSION' : 'SECURE IDENTITY')}
          </h2>
          <div className="h-[1px] w-full bg-[#AAAAAA]/30" />
        </div>

        {step === 'id' ? (
          <form onSubmit={handleSubmitId} className="space-y-12">
            <input
              autoFocus
              type="text"
              placeholder="IDENTIFIER"
              value={idValue}
              onChange={(e) => setIdValue(e.target.value)}
              className="w-full bg-transparent border-none text-center text-2xl font-light tracking-[0.2em] text-white placeholder:text-[#AAAAAA]/30 focus:ring-0 font-mono uppercase"
            />
            <div className="flex justify-center">
              <button 
                type="submit"
                className="text-[9px] uppercase tracking-[0.4em] text-[#AAAAAA] hover:text-white transition-colors font-bold"
              >
                CONTINUE
              </button>
            </div>
          </form>
        ) : (
          <form onSubmit={handleSubmitKey} className="space-y-12">
            <input
              autoFocus
              type="password"
              placeholder="ACCESS KEY"
              value={keyValue}
              onChange={(e) => setKeyValue(e.target.value)}
              className="w-full bg-transparent border-none text-center text-2xl font-light tracking-[0.2em] text-white placeholder:text-[#AAAAAA]/30 focus:ring-0 font-mono uppercase"
            />
            <div className="flex justify-between items-center px-4">
              <button 
                type="button"
                onClick={() => setStep('id')}
                className="text-[9px] uppercase tracking-[0.4em] text-[#AAAAAA] hover:text-white transition-colors font-bold"
              >
                BACK
              </button>
              <button 
                type="submit"
                className="text-[9px] uppercase tracking-[0.4em] text-[#AAAAAA] hover:text-white transition-colors font-bold"
              >
                CONNECT
              </button>
            </div>
          </form>
        )}

        <button 
          onClick={onClose}
          className="absolute top-12 right-12 text-[#AAAAAA] hover:text-white text-[10px] tracking-[0.3em] uppercase font-bold transition-all"
        >
          CANCEL
        </button>
      </div>
    </div>
  );
};

export default Auth;

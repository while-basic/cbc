
import React, { useState, useRef, useEffect, useMemo } from 'react';
import ReactMarkdown from 'react-markdown';
import { ChatMessage } from '../types';
import { sendMessageToPortal } from '../services/claudeService';
import ProjectCard from './ProjectCard';

const STORAGE_HISTORY_PREFIX = 'portal_history_';

interface ChatInterfaceProps {
  userId?: string;
  onConnectIdentity: (name: string) => void;
}

const ChatInterface: React.FC<ChatInterfaceProps> = ({ userId, onConnectIdentity }) => {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [activeMessageId, setActiveMessageId] = useState<string | null>(null);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Initialize or restore session history
  useEffect(() => {
    if (userId) {
      const saved = localStorage.getItem(`${STORAGE_HISTORY_PREFIX}${userId}`);
      
      const initialId = 'initial';
      const initialMsg: ChatMessage = {
        id: initialId,
        role: 'assistant',
        text: "The connection is established. You are present."
      };
      const greetingId = 'greeting';
      const greetingMsg: ChatMessage = {
        id: greetingId,
        role: 'assistant',
        text: `Hello. You have connected with the digital presence of Christopher Celaya.
This space replaces the fragmented noise of social media feeds and portfolios. It is
designed for direct inquiry rather than engagement metrics.
Here, the work on cognitive operating systems, electrical infrastructure, and music
production converges. There is no audience to perform for, just a conversation to step into.
Where would you like to begin?`,
        parentId: initialId
      };
      
      if (saved) {
        try {
          const parsed: ChatMessage[] = JSON.parse(saved);
          // Check if initial messages already exist
          const hasInitial = parsed.some(m => m.id === 'initial');
          const hasGreeting = parsed.some(m => m.id === 'greeting');
          
          // Always ensure initial messages are present and deduplicate
          const filtered = parsed.filter(m => m.id !== 'initial' && m.id !== 'greeting');
          // Remove duplicates by id
          const uniqueMessages = Array.from(
            new Map([initialMsg, greetingMsg, ...filtered].map(m => [m.id, m])).values()
          );
          setMessages(uniqueMessages);
          
          if (parsed.length > 0) {
            setActiveMessageId(parsed[parsed.length - 1].id);
          } else {
            setActiveMessageId(greetingId);
          }
        } catch (e) {
          console.error("Failed to restore history", e);
          setMessages([initialMsg, greetingMsg]);
          setActiveMessageId(greetingId);
        }
      } else {
        setMessages([initialMsg, greetingMsg]);
        setActiveMessageId(greetingId);
      }
    } else {
      setMessages([]);
      setActiveMessageId(null);
    }
  }, [userId]);

  // Persist message state
  useEffect(() => {
    if (userId && messages.length > 0) {
      localStorage.setItem(`${STORAGE_HISTORY_PREFIX}${userId}`, JSON.stringify(messages));
    }
  }, [messages, userId]);

  // Compute the active path from root to current anchor
  const activePathIds = useMemo(() => {
    if (!activeMessageId) return new Set<string>();
    const path = new Set<string>();
    let currentId: string | undefined = activeMessageId;
    while (currentId) {
      path.add(currentId);
      const msg = messages.find(m => m.id === currentId);
      currentId = msg?.parentId;
    }
    return path;
  }, [activeMessageId, messages]);

  // Construct conversation context for Gemini based on the active path
  const getContextHistory = (currentActiveId: string | null) => {
    if (!currentActiveId) return [];
    const path: ChatMessage[] = [];
    let currentId: string | undefined = currentActiveId;
    while (currentId) {
      const msg = messages.find(m => m.id === currentId);
      if (msg) path.unshift(msg);
      currentId = msg?.parentId;
    }
    return path.map(m => ({
      role: (m.role === 'user' ? 'user' : 'model') as 'user' | 'model',
      parts: [{ text: m.text }]
    }));
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, isLoading, activeMessageId]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || isLoading) return;

    if (!userId) {
      onConnectIdentity('');
      return;
    }

    const userMsgId = Date.now().toString();
    const userMessage: ChatMessage = {
      id: userMsgId,
      role: 'user',
      text: input.trim(),
      parentId: activeMessageId || undefined
    };

    const updatedMessages = [...messages, userMessage];
    setMessages(updatedMessages);
    setActiveMessageId(userMsgId);
    setInput('');
    setIsLoading(true);

    try {
      const history = getContextHistory(userMsgId);
      const response = await sendMessageToPortal(userMessage.text, history);
      
      const assistantMsgId = (Date.now() + 1).toString();
      const assistantMessage: ChatMessage = {
        id: assistantMsgId,
        role: 'assistant',
        text: response.text || '',
        cards: response.cards || [],
        parentId: userMsgId
      };

      setMessages(prev => [...prev, assistantMessage]);
      setActiveMessageId(assistantMsgId);
    } catch (error) {
      console.error("Portal flicker:", error);
      const errorMsgId = Date.now().toString();
      setMessages(prev => [...prev, {
        id: errorMsgId,
        role: 'assistant',
        text: "The connection is tenuous. Your signal is weak.",
        parentId: userMsgId
      }]);
      setActiveMessageId(errorMsgId);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex flex-col h-full w-full max-w-5xl mx-auto px-4 md:px-6 relative">
      <div 
        ref={scrollRef}
        className="flex-1 overflow-y-auto pt-36 md:pt-44 pb-24 no-scrollbar"
      >
        <div className="space-y-8">
          {messages.map((m) => {
            const isActive = activePathIds.has(m.id);
            const isInitial = m.id === 'initial';
            const isGreeting = m.id === 'greeting';
            
            if (isInitial) {
              return (
                <div 
                  key={m.id} 
                  className="flex items-start opacity-100 pt-2"
                >
                  <div className="text-white/60 text-sm font-light leading-relaxed">
                    {m.text}
                  </div>
                </div>
              );
            }
            
            if (isGreeting) {
              return (
                <div 
                  key={m.id} 
                  className="flex items-start opacity-100 mt-4"
                >
                  <div className="text-white text-base font-light leading-relaxed max-w-2xl whitespace-pre-line">
                    {m.text}
                  </div>
                </div>
              );
            }
            
            return (
              <div 
                key={m.id} 
                onClick={() => setActiveMessageId(m.id)}
                className={`flex flex-col transition-all duration-500 cursor-pointer group 
                  ${m.role === 'user' ? 'items-end' : 'items-start'}
                  ${isActive ? 'opacity-100' : 'opacity-20 hover:opacity-40'}
                `}
              >
                <div className={`max-w-[80%] md:max-w-[70%] ${m.role === 'user' ? 'text-right' : 'text-left'}`}>
                  <div className={`px-4 py-3 ${
                    m.role === 'user' 
                      ? 'text-white/90' 
                      : 'text-white/80'
                  }`}>
                    <div className={`text-sm md:text-base ${
                      m.role === 'user' ? 'font-normal' : 'font-light'
                    } leading-relaxed`}>
                      <ReactMarkdown>{m.text}</ReactMarkdown>
                    </div>
                  </div>
                  
                  {isActive && m.cards && m.cards.length > 0 && (
                    <div className="mt-6 space-y-4 w-full md:w-80">
                      {m.cards.map((card, i) => (
                        card.type === 'project' ? (
                          <ProjectCard key={i} project={card.content} />
                        ) : null
                      ))}
                    </div>
                  )}
                </div>
              </div>
            );
          })}
          
          {isLoading && (
            <div className="flex items-center space-x-2 py-4">
              <div className="flex space-x-1.5">
                <div className="w-1.5 h-1.5 bg-white/40 rounded-full animate-bounce [animation-delay:-0.3s]" />
                <div className="w-1.5 h-1.5 bg-white/40 rounded-full animate-bounce [animation-delay:-0.15s]" />
                <div className="w-1.5 h-1.5 bg-white/40 rounded-full animate-bounce" />
              </div>
            </div>
          )}
          
          <div ref={messagesEndRef} className="h-4" />
        </div>
      </div>

      {/* Bottom right "hello" */}
      <div className="fixed bottom-8 right-8 text-white/30 text-sm font-light pointer-events-none z-20">
        hello
      </div>

      {/* Bottom left "Reflect..." */}
      <div className="fixed bottom-8 left-8 text-white/20 text-sm font-light pointer-events-none z-20">
        Reflect...
      </div>

      <div className="bg-gradient-to-t from-[#0A0A0A] via-[#0A0A0A] to-transparent pb-8 pt-4 relative z-10">
        <form onSubmit={handleSubmit} className="relative group max-w-2xl mx-auto">
          <div className="flex items-center gap-3">
            <div className="flex-1 relative">
              <input
                type="text"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                disabled={isLoading}
                placeholder={userId ? "" : "Connect identity to engage..."}
                className="w-full bg-transparent border-b border-white/10 focus:border-white/30 px-2 py-3 text-sm font-light focus:outline-none text-white placeholder-white/20 caret-white/50 transition-all disabled:opacity-50"
              />
            </div>
            <button
              type="submit"
              disabled={!input.trim() || isLoading}
              className="text-white/40 hover:text-white/60 disabled:opacity-20 transition-all text-sm font-light disabled:cursor-not-allowed"
            >
              →
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ChatInterface;

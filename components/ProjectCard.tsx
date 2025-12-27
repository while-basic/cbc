
import React, { useState } from 'react';
import { Project } from '../types';

interface ProjectCardProps {
  project: Project;
  onTagClick?: (tag: string, projectName: string) => void;
}

const ProjectCard: React.FC<ProjectCardProps> = ({ project, onTagClick }) => {
  const [isExpanded, setIsExpanded] = useState(false);

  return (
    <div 
      onClick={() => setIsExpanded(!isExpanded)}
      className={`
        relative overflow-hidden
        bg-gradient-to-br from-[#151515] to-[#0F0F0F] border-2 border-[#2A2A2A]
        rounded-3xl my-10 transition-all duration-500 ease-out cursor-pointer
        hover:border-[#0066FF]/30 hover:shadow-2xl hover:shadow-blue-500/10
        ${isExpanded ? 'p-8' : 'p-6'}
        group shadow-2xl backdrop-blur-sm
      `}
    >
      <div className="relative z-10">
        <div className="flex justify-between items-start mb-6">
          <h3 className={`font-bold tracking-tight transition-all duration-300 ${
            isExpanded ? 'text-2xl text-white' : 'text-xl text-white'
          }`}>
            {project.name}
          </h3>
          <span className="text-[10px] uppercase tracking-[0.3em] text-[#0066FF] font-black bg-blue-500/10 px-3 py-1.5 rounded-full border border-blue-500/20">
            {project.status.split(' ')[0]}
          </span>
        </div>
        
        {isExpanded && (
          <div className="mt-4 animate-in fade-in slide-in-from-top-2 duration-500">
            <p className="text-[#D0D0D0] text-[15px] leading-relaxed font-light mb-6" style={{ lineHeight: '1.7' }}>
              {project.description}
            </p>
            
            <div className="flex flex-wrap gap-3 mb-8">
              {project.tech.map((t, i) => (
                <button 
                  key={i} 
                  onClick={(e) => {
                    e.stopPropagation();
                    onTagClick?.(t, project.name);
                  }}
                  className="text-xs font-mono text-[#B0B0B0] bg-[#0A0A0A] border border-[#2A2A2A] px-4 py-2 rounded-lg hover:border-[#0066FF]/30 transition-colors"
                >
                  {t}
                </button>
              ))}
            </div>
            
            <div className="pt-6 border-t-2 border-[#2A2A2A] flex items-center justify-between">
              <span className="text-[11px] text-[#808080] font-mono tracking-wider">{project.status}</span>
              <button className="text-[11px] text-[#0066FF] group-hover:text-[#0088FF] transition-colors uppercase tracking-[0.3em] font-bold flex items-center gap-2">
                Collapse
                <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                  <path d="M2 6H10M2 6L5 3M2 6L5 9" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ProjectCard;

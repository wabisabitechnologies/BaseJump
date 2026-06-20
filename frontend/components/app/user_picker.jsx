import React, { useState, useCallback, useRef, useEffect } from 'react';
import { useSelector } from 'react-redux';

const UserPicker = ({ selectedIds, onChange, projectId, placeholder }) => {
  const [open, setOpen] = useState(false);
  const ref = useRef(null);
  const companyUsers = useSelector((state) =>
    state.entities.users ? Object.values(state.entities.users) : []
  );

  // Close on outside click
  useEffect(() => {
    const handleClick = (e) => {
      if (ref.current && !ref.current.contains(e.target)) setOpen(false);
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  const selected = companyUsers.filter((u) => selectedIds.includes(u.id));
  const available = companyUsers.filter((u) => !selectedIds.includes(u.id));

  const toggleUser = useCallback(
    (userId) => {
      const next = selectedIds.includes(userId)
        ? selectedIds.filter((id) => id !== userId)
        : [...selectedIds, userId];
      onChange(next);
    },
    [selectedIds, onChange]
  );

  return (
    <div className="relative" ref={ref}>
      {/* Trigger */}
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className="flex items-center gap-1 rounded-md border border-gray-300 bg-white px-2 py-1 text-sm hover:border-gray-400 cursor-pointer"
      >
        {selected.length === 0 ? (
          <span className="text-gray-400">{placeholder || 'Assign to...'}</span>
        ) : (
          <div className="flex items-center gap-1">
            {selected.slice(0, 3).map((u) => (
              <span
                key={u.id}
                className="inline-flex items-center gap-1 rounded bg-blue-50 px-1.5 py-0.5 text-xs text-blue-700"
              >
                {u.name}
                <button
                  type="button"
                  onClick={(e) => {
                    e.stopPropagation();
                    toggleUser(u.id);
                  }}
                  className="ml-0.5 text-blue-400 hover:text-blue-600 cursor-pointer bg-transparent border-none p-0 leading-none"
                >
                  ×
                </button>
              </span>
            ))}
            {selected.length > 3 && (
              <span className="text-xs text-gray-500">+{selected.length - 3}</span>
            )}
          </div>
        )}
        <svg className="ml-1 h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {/* Dropdown */}
      {open && (
        <div className="absolute left-0 top-full z-50 mt-1 w-64 rounded-md border border-gray-200 bg-white shadow-lg">
          {available.length === 0 ? (
            <p className="p-3 text-sm text-gray-400">All users selected</p>
          ) : (
            <ul className="max-h-48 overflow-y-auto py-1">
              {available.map((u) => (
                <li key={u.id}>
                  <button
                    type="button"
                    onClick={() => {
                      toggleUser(u.id);
                    }}
                    className="flex w-full items-center gap-2 px-3 py-2 text-left text-sm hover:bg-gray-50 cursor-pointer bg-transparent border-none"
                  >
                    <img
                      src={u.avatarUrl || `https://placehold.co/24x24?text=${u.name?.charAt(0)}&font=roboto`}
                      alt=""
                      className="h-6 w-6 rounded-full"
                    />
                    <span>{u.name}</span>
                    <span className="text-xs text-gray-400">@{u.username}</span>
                  </button>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </div>
  );
};

export default UserPicker;

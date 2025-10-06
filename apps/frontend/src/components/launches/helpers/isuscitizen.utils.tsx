export const isUSCitizen = () => {
  // Check if we're in the browser (client-side)
  if (typeof window === 'undefined') {
    return false; // Default for server-side rendering
  }
  
  const userLanguage = localStorage.getItem('isUS') || ((navigator.language || navigator.languages[0]).startsWith('en-US') ? 'US' : 'GLOBAL');
  return userLanguage === 'US';
};

module.exports = {
  theme: {
    extend: {
      fontFamily: {
        'sans': ['Poppins', 'sans-serif']
      },
      colors: {
        gray: {
          100: '#F9FAFB',
          200: '#F3F4F6',
          300: '#E5E7EB',
          800: '#374151'
        },
        red: {
          500: '#E94025'
        },
        green: {
          400: '#40b981'
        }
      },
    },
  },
  mode: 'jit',
  content: [
    "./app/**/*.html.{erb,slim}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  safelist: [
    'border-red-500',
    'focus:border-red-600',
    'focus:ring-red-600',
    'text-red-500',
    'border-gray-500','border-gray-600',
    'bg-gray-500','bg-gray-600',
    'border-cyan-500','border-cyan-600',
    'bg-cyan-500','bg-cyan-600',
    'border-purple-500','border-purple-600',
    'bg-purple-500','bg-purple-600',
    'border-green-500','border-green-600',
    'bg-green-500','bg-green-600',
  ],
  plugins: [
    require('@tailwindcss/forms')
  ],
}
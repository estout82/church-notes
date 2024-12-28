import {defineConfig} from 'vite'

export default defineConfig({
  test: {
    environment: "happy-dom",
    setupFiles: [
      "./app/javascript/__test__/setup.js"
    ]
  },
});
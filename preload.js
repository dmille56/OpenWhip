const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('bridge', {
  whipCrack: () => ipcRenderer.send('whip-crack'),
  hideOverlay: () => ipcRenderer.send('hide-overlay'),
  onSpawnWhip: (fn) => ipcRenderer.on('spawn-whip', () => fn()),
  onDropWhip: (fn) => ipcRenderer.on('drop-whip', () => fn()),
  onPauseWhip: (fn) => ipcRenderer.on('pause-whip', (_event, paused) => fn(paused)),
  onStatus: (fn) => ipcRenderer.on('status', (_event, status) => fn(status)),
});

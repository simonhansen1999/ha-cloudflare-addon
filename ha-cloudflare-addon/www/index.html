<html>
<head><meta charset="utf-8"><title>Cloudflare Tunnel</title></head>
<body>
<h1>Cloudflare DNS & Tunnel Manager</h1>
<div>Status: <span id="tunnelStatus">...</span></div>
<button onclick="startTunnel()">Opret/Start Tunnel</button>
<button onclick="stopTunnel()">Stop Tunnel</button>
<pre id="statusJSON"></pre>
<script>
async function fetchStatus(){
  let r = await fetch('/status'); let j = await r.json();
  document.getElementById('tunnelStatus').innerText = j.tunnel;
  document.getElementById('statusJSON').innerText = JSON.stringify(j,null,2);
}
async function startTunnel(){
  await fetch('/tunnel/start',{method:'POST'}); fetchStatus();
}
async function stopTunnel(){
  await fetch('/tunnel/stop',{method:'POST'}); fetchStatus();
}
fetchStatus();
setInterval(fetchStatus,5000);
</script>
</body></html>

## If in SJTU network then Visit http://59.78.30.87 to see the demo, else additionally use SJTU VPN to access.
## Chrome and firefox are ensured to run correctly, others browsers may not. (Especially WeChat's poor browser)

---
## Important: Server isn't allowed in Silver FOCS both in p1 and p2! This is just for fun and not graded.

## Currently, only allow 10 game rooms to exist at the same time due to server pressure.

---
## Outline
- See the code on GitHub: https://github.com/weiyichen2012/Why-I-cannot-use-server-in-VG100. Obviously, elm code is clean while JavaScript code is a mess. Long live Elm!
- Doesn't support well with phones or pads. Because long-pressings in phones and pads are interpreted as selecting words. Pressing them have strange feedbacks.
- If there's any issue, for example additional features or simply server is down, welcome to contact me through my email: ethepherein@sjtu.edu.cn
---
## Technical details
### whole game structure
  - Elm handles the main logic, JavaScript is used for client and NodeJs is used for server.
### server details
- Using websocket in Javascript to communicate between client and server. It's reliable, fast, and most importantly, very short codes in Javascript.
- The server code is run on an abandoned laptop, which is used as a server. It installed CentOS7 and is connected to our dormitory router. There's a port mapping on our router, maps request (ws://59.78.30.87:1234) on router to this laptop on port 1234.
- The main web page (the one you access through http://59.78.30.87) is served by nginx, a convenient web server.
### elm details
- Using frame synchronization between clients and host. This ensures that the frames that client and host see are the same, but it's inefficient, and the user experience depends on the computing performance of the host.
- Others are common techniques in Elm.
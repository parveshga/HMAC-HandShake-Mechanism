# IP and Port Scanner with HMAC Handshake Mechanism

This Flutter project is designed to scan all possible IP addresses in a given subnet, attempting to connect to a specified port. If a port is open, the application initiates a secure handshake mechanism between the client and the server to verify that the client is authorized to connect. The handshake ensures that only valid users can access the server.

## IP Scanning: The app allows users to enter a base IP and a port. It then scans all IPs in the subnet (from x.x.x.1 to x.x.x.254) and checks if the port is open.
[Secure Handshake:] Once a connection is established with an open port, the app performs a secure challenge-response handshake. The server generates a unique challenge, and the client responds using a hashed response for verification.
Result Display: After the scan, all successfully connected and verified IP addresses are displayed in the app UI.


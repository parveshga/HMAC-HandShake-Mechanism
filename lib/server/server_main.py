import socket
import hmac
import hashlib
import os

SECRET_KEY = b'Gemicates'

def generate_challenge():
    #generate chall
    return os.urandom(16).hex()

def verify_challenge(challenge, client_response):
    #verify
    expected_response = hmac.new(SECRET_KEY, challenge.encode(), hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected_response, client_response)

def handle_client(client_socket):
    challenge = generate_challenge()
    print(f"Generated challenge: {challenge}")
    
    client_socket.send(challenge.encode())

    client_response = client_socket.recv(1024).decode('utf-8')
    print(f"Client response: {client_response}")

    if verify_challenge(challenge, client_response):
        client_socket.send(b'HANDSHAKE_SUCCESS')
        print("Handshake successful.")
    else:
        client_socket.send(b'HANDSHAKE_FAILED')
        print("Handshake failed.")

    client_socket.close()

def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind(('0.0.0.0', 3333))
    server.listen(5)
    print("Server started on port 3333")

    while True:
        client_socket, addr = server.accept()
        print(f"Connection received from {addr}")
        handle_client(client_socket)

if __name__ == "__main__":
    start_server()


# import socket

# SECRET_KEY = "Gemicates"

# def handle_client(client_socket):
#     request = client_socket.recv(1024).decode('utf-8')
#     print(request)
#     if request == SECRET_KEY:
#         client_socket.send(b'HANDSHAKE_SUCCESS')
#         print('Handshake Successfull')
#     else:
#         client_socket.send(b'HANDSHAKE_FAILED')
#         print('Handshake failed')


#     client_socket.close()

# def start_server():
#     server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     server.bind(('0.0.0.0', 3333))
#     server.listen(5)
#     print("Server started on port 3333")

#     while True:
#         client_socket, addr = server.accept()
#         print(f"Connection received from {addr}")
#         handle_client(client_socket)

# if __name__ == "__main__":
#     start_server()

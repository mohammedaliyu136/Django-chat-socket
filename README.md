# Real-time Chat Application

A real-time chat application built with Django Channels and Flutter.

## Backend Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run migrations:
```bash
python manage.py migrate
```

4. Start Redis server (required for Channels):
```bash
redis-server
```

5. Run the development server:
```bash
python manage.py runserver
```

## Features

- Real-time messaging using WebSockets
- User authentication with JWT
- Online status indicators
- Typing indicators
- Read receipts
- Support for 1-on-1 and group chats 
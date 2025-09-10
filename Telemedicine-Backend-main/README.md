# Telemedicine Backend

## Setup Instructions

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (either local installation or MongoDB Atlas account)

### Installation
1. Clone the repository
2. Run `npm install` to install dependencies

### Database Setup

You have two options for database setup:

#### Option 1: MongoDB Atlas (Recommended)
1. Create a MongoDB Atlas account at https://www.mongodb.com/cloud/atlas
2. Create a new cluster and database
3. Create a database user with read/write permissions
4. Update the `.env` file with your MongoDB connection string:
   ```
   MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/telemed?retryWrites=true&w=majority
   ```

#### Option 2: Local MongoDB
1. Install MongoDB Community Server: https://docs.mongodb.com/manual/installation/
2. Start MongoDB service:
   - Windows: `net start MongoDB`
   - macOS/Linux: `sudo systemctl start mongod`
3. The application will automatically connect to `mongodb://localhost:27017/telemed`

### Environment Variables
Create a `.env` file in the root directory with the following variables:
```
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key
AGORA_APP_ID=your_agora_app_id
AGORA_APP_CERTIFICATE=your_agora_app_certificate
PORT=5000
```

### Running the Application
- Development: `npm run dev`
- Production: `npm start`

### Troubleshooting
1. If you get "ECONNREFUSED" error, make sure MongoDB is running
2. If you get "authentication failed" error, check your MongoDB credentials
3. Ensure all environment variables are properly set
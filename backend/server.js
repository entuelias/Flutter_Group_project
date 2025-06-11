const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes'); // Import auth routes
const medicalInfoRoutes = require('./routes/medicalInfoRoutes'); // Import medical info routes
const emergencyContactRoutes = require('./routes/emergencyContactRoutes'); // Import emergency contact routes

dotenv.config();

// --- ADD THIS LINE FOR DEBUGGING ---
console.log('JWT_SECRET loaded from .env:', process.env.JWT_SECRET);
// -----------------------------------

const app = express();

// Middleware
app.use(express.json()); // Body parser for JSON data
app.use(cors()); // Enable CORS

// MongoDB Connection
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/guardian_app';

mongoose.connect(MONGODB_URI)
  .then(() => console.log('MongoDB connected successfully'))
  .catch(err => console.error('MongoDB connection error:', err));

// Basic Route
app.get('/', (req, res) => {
  res.send('Guardian App Backend API is running!');
});

// API Routes
app.use('/api/auth', authRoutes); // Use auth routes
app.use('/api/medical-info', medicalInfoRoutes); // Use medical info routes
app.use('/api/emergency-contacts', emergencyContactRoutes); // Use emergency contact routes

// Define a port for the server
const PORT = process.env.PORT || 5000;

// Start the server
app.listen(PORT, () => console.log(`Server running on port ${PORT}`)); 
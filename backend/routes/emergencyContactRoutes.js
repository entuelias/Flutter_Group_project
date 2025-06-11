const express = require('express');
const router = express.Router();
const {
  createEmergencyContact,
  getEmergencyContacts,
  updateEmergencyContact,
  deleteEmergencyContact
} = require('../controllers/emergencyContactController');
const { protect } = require('../middleware/authMiddleware');

// All routes are protected
router.use(protect);

router.route('/')
  .post(createEmergencyContact)
  .get(getEmergencyContacts);

router.route('/:id')
  .put(updateEmergencyContact)
  .delete(deleteEmergencyContact);

module.exports = router; 
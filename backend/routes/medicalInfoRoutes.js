const express = require('express');
const router = express.Router();
const {
  createMedicalInfo,
  getMedicalInfo,
  updateMedicalInfo,
  deleteMedicalInfo,
  getMedicalInfoByUserId
} = require('../controllers/medicalInfoController');
const { protect } = require('../middleware/authMiddleware');

// All routes are protected
router.use(protect);

router.route('/')
  .post(createMedicalInfo)
  .get(getMedicalInfo);

router.route('/:userId')
  .get(getMedicalInfoByUserId);

router.route('/:noteId')
  .put(updateMedicalInfo)
  .delete(deleteMedicalInfo);

module.exports = router; 
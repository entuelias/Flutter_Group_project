const MedicalInfo = require('../models/MedicalInfo');

// @route   POST /api/medical-info
// @desc    Create a new medical info note
// @access  Private
exports.createMedicalInfo = async (req, res) => {
  try {
    const newMedicalInfo = new MedicalInfo({
      user: req.user.id,
      title: req.body.title,
      description: req.body.description,
    });

    const medicalInfo = await newMedicalInfo.save();
    res.json(medicalInfo);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @route   GET /api/medical-info
// @desc    Get all medical info notes for the authenticated user
// @access  Private
exports.getMedicalInfo = async (req, res) => {
  try {
    const medicalInfo = await MedicalInfo.find({ user: req.user.id }).sort({ createdAt: -1 });
    res.json(medicalInfo);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @route   GET /api/medical-info/:userId
// @desc    Get medical info notes for a specific user ID (must be authorized to view)
// @access  Private
exports.getMedicalInfoByUserId = async (req, res) => {
  try {
    // Ensure the requested userId matches the authenticated user's ID
    if (req.params.userId !== req.user.id) {
      return res.status(403).json({ msg: 'Not authorized to view this user\'s medical info' });
    }
    const medicalInfo = await MedicalInfo.find({ user: req.params.userId }).sort({ createdAt: -1 });
    res.json(medicalInfo);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @route   PUT /api/medical-info/:noteId
// @desc    Update a medical info note
// @access  Private
exports.updateMedicalInfo = async (req, res) => {
  const { title, description } = req.body;

  // Build medical info object
  const medicalInfoFields = {};
  if (title) medicalInfoFields.title = title;
  if (description) medicalInfoFields.description = description;

  try {
    let medicalInfo = await MedicalInfo.findById(req.params.noteId);

    if (!medicalInfo) return res.status(404).json({ msg: 'Medical info not found' });

    // Ensure user owns medical info
    if (medicalInfo.user.toString() !== req.user.id) {
      return res.status(401).json({ msg: 'User not authorized' });
    }

    medicalInfo = await MedicalInfo.findByIdAndUpdate(
      req.params.noteId,
      { $set: medicalInfoFields },
      { new: true }
    );

    res.json(medicalInfo);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @route   DELETE /api/medical-info/:noteId
// @desc    Delete a medical info note
// @access  Private
exports.deleteMedicalInfo = async (req, res) => {
  try {
    const medicalInfo = await MedicalInfo.findById(req.params.noteId);

    if (!medicalInfo) return res.status(404).json({ msg: 'Medical info not found' });

    // Ensure user owns medical info
    if (medicalInfo.user.toString() !== req.user.id) {
      return res.status(401).json({ msg: 'User not authorized' });
    }

    await MedicalInfo.findByIdAndDelete(req.params.noteId);

    res.json({ msg: 'Medical info removed' });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
}; 
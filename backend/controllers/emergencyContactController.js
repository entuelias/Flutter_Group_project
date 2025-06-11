const EmergencyContact = require('../models/EmergencyContact');

// @desc    Create new emergency contact
// @route   POST /api/emergency-contacts
// @access  Private
exports.createEmergencyContact = async (req, res) => {
  try {
    const { name, relation, phoneNumber } = req.body;

    const emergencyContact = await EmergencyContact.create({
      user: req.user.id,
      name,
      relation,
      phoneNumber
    });

    res.status(201).json(emergencyContact);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get all emergency contacts for a user
// @route   GET /api/emergency-contacts
// @access  Private
exports.getEmergencyContacts = async (req, res) => {
  try {
    const emergencyContacts = await EmergencyContact.find({ user: req.user.id });
    res.json(emergencyContacts);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update emergency contact
// @route   PUT /api/emergency-contacts/:id
// @access  Private
exports.updateEmergencyContact = async (req, res) => {
  try {
    const { name, relation, phoneNumber } = req.body;

    const emergencyContact = await EmergencyContact.findById(req.params.id);

    if (!emergencyContact) {
      return res.status(404).json({ message: 'Emergency contact not found' });
    }

    // Check user
    if (emergencyContact.user.toString() !== req.user.id) {
      return res.status(401).json({ message: 'User not authorized' });
    }

    emergencyContact.name = name || emergencyContact.name;
    emergencyContact.relation = relation || emergencyContact.relation;
    emergencyContact.phoneNumber = phoneNumber || emergencyContact.phoneNumber;

    const updatedEmergencyContact = await emergencyContact.save();

    res.json(updatedEmergencyContact);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete emergency contact
// @route   DELETE /api/emergency-contacts/:id
// @access  Private
exports.deleteEmergencyContact = async (req, res) => {
  try {
    const emergencyContact = await EmergencyContact.findById(req.params.id);

    if (!emergencyContact) {
      return res.status(404).json({ message: 'Emergency contact not found' });
    }

    // Check user
    if (emergencyContact.user.toString() !== req.user.id) {
      return res.status(401).json({ message: 'User not authorized' });
    }

    await emergencyContact.deleteOne();

    res.json({ message: 'Emergency contact removed' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 
const mongoose = require('mongoose');

const medicalInfoSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: 'User'
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true,
    trim: true
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true, getters: true },
  id: false
});

medicalInfoSchema.virtual('id').get(function() {
  return this._id.toHexString();
});

medicalInfoSchema.virtual('userId').get(function() {
  return this.user.toHexString();
});

const MedicalInfo = mongoose.model('MedicalInfo', medicalInfoSchema);

module.exports = MedicalInfo; 
const express = require('express');
const charityUser = require('./charity');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const authcharityRouter = express.Router();

// Removed multer and document handling

authcharityRouter.post('/api/charitysignup', async (req, res) => {
  try {
    const { name, email, phoneNumber, crNumber, password } = req.body;

    const existingcharityUser = await charityUser.findOne({ email });
    if (existingcharityUser) {
      return res.status(400).json({ msg: 'User with the same email already exists' });
    }

    // Hash the password before saving
    const hashedPassword = await bcryptjs.hash(password, 12); // Increased salt rounds for better security

    let user = new charityUser({
      name,
      email,
      phoneNumber,
      crNumber,
      password: hashedPassword,
      // Removed documents field
    });

    user = await user.save();
    res.status(201).json({ msg: 'Signup successful!', user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authcharityRouter.post('/api/charitysignin', async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await charityUser.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: 'User with this email does not exist!' });
    }

  

    const isMatch = await bcryptjs.compare(password, user.password);


    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid credentials!' });
    }

    // Generate JWT token
    const token = jwt.sign({ id: user._id }, 'passwordKeycharity', { expiresIn: '1h' }); // Added expiration
    res.status(200).json({ msg: 'Signin successful!', token, user: user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authcharityRouter;

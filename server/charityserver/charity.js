
const mongoose = require('mongoose');


const usercharitySchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: 'Please enter a valid email address',
    },
  },
  phoneNumber: {
    type: String,
    required: true,
    validate: {
      validator: function (v) {
        // Simple regex for validating phone numbers
        return /\+?[0-9\s-]{7,15}/.test(v);
      },
      message: (props) => `${props.value} is not a valid phone number!`,
    },
  },
  
  crNumber: {
    type: String,
    required: true,
    trim: true,
  },
  password: {
    required: true,
    type: String,
    validate: {
      validator: (value) => {
        return value.length >= 8;
      },
      message: 'Password is too weak, please use more than 8 characters',
    },
  },
//   documents: {
//     type: [String], // Assuming documents will be stored as file paths
//     validate: {
//         validator: function (v) {
//             return Array.isArray(v) && v.length > 0;
//         },
//         message: 'Please upload at least one document',
//     },
// },
  type:{
    type: String,
    default: 'charity'
  }
});

const charityUser = mongoose.model('charityUser', usercharitySchema);
module.exports = charityUser;

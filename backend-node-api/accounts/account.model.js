const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    email: { type: String, unique: true },
    passwordHash: { type: String },
    confirmPassword: { type: String },
    username:{type: String,unique:true},
    mobileNumber: { type: String},
    firstName: { type: String },
    lastName: { type: String },
    // acceptTerms: Boolean,
    role: { type: String },
    areaOfExpertise:{ type: String},
    areaOfInterest:[{
        type: String
    }],
    availability:{type:Number},
    dataOfBirth:{type:String},
    verificationToken: String,
    verified: Date,
    resetToken: {
        token: String,
        expires: Date
    },
    passwordReset: Date,
    created: { type: Date, default: Date.now },
    updated: { type: Date, default: Date.now }
});

schema.virtual('isVerified').get(function () {
    return !!(this.verified || this.passwordReset);
});

schema.set('toJSON', {
    virtuals: true,
    versionKey: false,
    transform: function (doc, ret) {
        // remove these props when object is serialized
        delete ret._id;
        delete ret.passwordHash;
    }
});

module.exports = mongoose.model('Account', schema);

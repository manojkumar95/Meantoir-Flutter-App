const config = require('config.json');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const crypto = require("crypto");
const sendEmail = require('_helpers/send-email');
const db = require('_helpers/db');
const Joi = require('joi');
//const Role = require('_helpers/role');

module.exports = {
    authenticate,
    refreshToken,
    revokeToken,
    register,
    // verifyEmail,
    forgotPassword,
    validateResetToken,
    resetPassword,
    getAll,
    getById,
    searchById,
    create,
    update,
    delete: _delete
};

async function authenticate({ username, password }) {
    const account = await db.Account.findOne({ username });
    console.log('authenticate', username)
    if (!account || !bcrypt.compareSync(password, account.passwordHash)) {
        throw 'Email or password is incorrect';
    }

    // authentication successful so generate jwt and refresh tokens
    const jwtToken = generateJwtToken(account);
    const refreshToken = generateRefreshToken(account);

    // save refresh token
    await refreshToken.save();

    // return basic details and tokens
    return {
        ...basicDetails(account),
        jwtToken,
        refreshToken: refreshToken.token
    };
}

async function refreshToken({ token, }) {
    const refreshToken = await getRefreshToken(token);
    const { account } = refreshToken;

    // replace old refresh token with a new one and save
    const newRefreshToken = generateRefreshToken(account);
    refreshToken.revoked = Date.now();
    // refreshToken.revokedByIp = ipAddress;
    refreshToken.replacedByToken = newRefreshToken.token;
    await refreshToken.save();
    await newRefreshToken.save();

    // generate new jwt
    const jwtToken = generateJwtToken(account);

    // return basic details and tokens
    return {
        ...basicDetails(account),
        jwtToken,
        refreshToken: newRefreshToken.token
    };
}

async function revokeToken({ token }) {
    const refreshToken = await getRefreshToken(token);

    // revoke token and save
    refreshToken.revoked = Date.now();
    // refreshToken.revokedByIp = ipAddress;
    await refreshToken.save();
}

async function register(params, origin) {
    // validate
    // if (await db.Account.findOne({ email: params.email })) {
    //     // send already registered error in email to prevent account enumeration
    //     return await sendAlreadyRegisteredEmail(params.email, origin);
    // }

    // create account object
    const account = new db.Account(params);
    if (params.areaOfInterest) {
        account.areaOfInterest = JSON.parse(params.areaOfInterest)
    }
    // // first registered account is an admin
    // const isFirstAccount = (await db.Account.countDocuments({})) === 0;
    // account.role = isFirstAccount ? Role.Admin : Role.User;
    account.verificationToken = randomTokenString();

    // hash password
    account.passwordHash = hash(params.password);
    account.confirmPassword = account.passwordHash;

    // save account
    await account.save();



    // send email
    // await sendVerificationEmail(account, origin);
}

// async function verifyEmail({ token }) {
//     const account = await db.Account.findOne({ verificationToken: token });

//     if (!account) throw 'Verification failed';

//     account.verified = Date.now();
//     account.verificationToken = undefined;
//     await account.save();
// }

async function forgotPassword({ email }, origin) {
    const account = await db.Account.findOne({ email });

    // always return ok response to prevent email enumeration
    if (!account) return;

    // create reset token that expires after 24 hours
    // account.resetToken = {
    //     token: randomTokenString(),
    //     expires: new Date(Date.now() + 24 * 60 * 60 * 1000)
    // };
    // await account.save();

    // send email
    var randomstring = Math.random().toString(36).slice(-8);

    account.passwordHash = hash(randomstring);
    account.confirmPassword = account.passwordHash;
    await account.save();

    await sendPasswordResetEmail(account, origin, randomstring);
}

async function validateResetToken({ token }) {
    const account = await db.Account.findOne({
        'resetToken.token': token,
        'resetToken.expires': { $gt: Date.now() }
    });

    if (!account) throw 'Invalid token';
}

async function resetPassword({ token, password }) {
    const account = await db.Account.findOne({
        'resetToken.token': token,
        'resetToken.expires': { $gt: Date.now() }
    });

    if (!account) throw 'Invalid token';

    // update password and remove reset token
    account.passwordHash = hash(password);
    account.passwordReset = Date.now();
    account.resetToken = undefined;
    await account.save();
}

async function getAll() {
    const accounts = await db.Account.find();
    return accounts.map(x => basicDetails(x));
}

async function getById(id) {
    const account = await getAccount(id);
    return basicDetails(account);
}

async function searchById(account) {
    // const account = await getAccount(id);
    // return basicDetails(account);
    const accountdetails = await db.Account.find({
        role: "Mentor",
        areaOfExpertise: account.areaOfExpertise,
        areaOfInterest: { "$in": account.areaOfInterest }
    });
    let accountdetail = []
    if (!accountdetail) throw 'Account not found';
    if (accountdetails.length == 0) {
        return {
            accountdetail: []
        }
    }
    for (i = 0; i < accountdetails.length; i++) {
        let connectionDetail = await db.Connections.findOne({
            mentor_id: accountdetails[i].id,
            mentee_id: account.id       
        })

        if (!connectionDetail) {
            accountdetail.push(accountdetails[i])
        }
    }
    return{ accountdetail};
}

async function create(params) {
    // validate
    if (await db.Account.findOne({ email: params.email })) {
        throw 'Email "' + params.email + '" is already registered';
    }

    const account = new db.Account(params);
    account.verified = Date.now();

    // hash password
    account.passwordHash = hash(params.password);

    // save account
    await account.save();

    return basicDetails(account);
}

async function update(id, params) {
    const account = await getAccount(id);

    // validate (if email was changed)
    if (params.email && account.email !== params.email && await db.Account.findOne({ email: params.email })) {
        throw 'Email "' + params.email + '" is already taken';
    }

    // hash password if it was entered
    if (params.password) {
        params.passwordHash = hash(params.password);
    }
//     if (params.areaOfInterest) {
//         params.areaOfInterest = JSON.params(params.areaOfInterest)
//     }
    // copy params to account and save
    Object.assign(account, params);

    account.updated = Date.now();
    await account.save();

    return basicDetails(account);
}

async function _delete(id) {
    const account = await getAccount(id);
    await account.remove();
}

// helper functions

async function getAccount(id) {
    if (db.isValidId(id) == false) throw 'Account not found';
    const account = await db.Account.findById(id);
    if (!account) throw 'Account not found';
    return account;
}

async function getRefreshToken(token) {
    const refreshToken = await db.RefreshToken.findOne({ token }).populate('account');
    if (!refreshToken || !refreshToken.isActive) throw 'Invalid token';
    return refreshToken;
}

function hash(password) {
    return bcrypt.hashSync(password, 10);
}

function generateJwtToken(account) {
    // create a jwt token containing the account id that expires in 15 minutes
    return jwt.sign({ sub: account.id, id: account.id }, config.secret);
}

function generateRefreshToken(account, ipAddress) {
    // create a refresh token that expires in 7 days
    return new db.RefreshToken({
        account: account.id,
        token: randomTokenString(),
        // expires: new Date(Date.now() + 7*24*60*60*1000),
        // createdByIp: ipAddress
    });
}

function randomTokenString() {
    return crypto.randomBytes(40).toString('hex');
}

function basicDetails(account) {
    // console.log('account', account)
    const { id, firstName, lastName, username, mobileNumber, areaOfExpertise, availability, areaOfInterest, dataOfBirth, email, role, created, updated } = account;
    return { id, firstName, lastName, username, mobileNumber, areaOfExpertise, availability, areaOfInterest, dataOfBirth, email, role, created, updated };
}

// async function sendVerificationEmail(account, origin) {
//     let message;
//     if (origin) {
//         const verifyUrl = `${origin}/account/verify-email?token=${account.verificationToken}`;
//         message = `<p>Please click the below link to verify your email address:</p>
//                    <p><a href="${verifyUrl}">${verifyUrl}</a></p>`;
//     } else {
//         message = `<p>Please use the below token to verify your email address with the <code>/account/verify-email</code> api route:</p>
//                    <p><code>${account.verificationToken}</code></p>`;
//     }

//     await sendEmail({
//         to: account.email,
//         subject: 'Sign-up Verification API - Verify Email',
//         html: `<h4>Verify Email</h4>
//                <p>Thanks for registering!</p>
//                ${message}`
//     });
// }

// async function sendAlreadyRegisteredEmail(email, origin) {
//     let message;
//     if (origin) {
//         message = `<p>If you don't know your password please visit the <a href="${origin}/account/forgot-password">forgot password</a> page.</p>`;
//     } else {
//         message = `<p>If you don't know your password you can reset it via the <code>/account/forgot-password</code> api route.</p>`;
//     }

//     await sendEmail({
//         to: email,
//         subject: 'Sign-up Verification API - Email Already Registered',
//         html: `<h4>Email Already Registered</h4>
//                <p>Your email <strong>${email}</strong> is already registered.</p>
//                ${message}`
//     });
// }

async function sendPasswordResetEmail(account, origin, randomstring) {
    let message;

    message = `<p>The new autogenrated password is given below:</p>
                <p><code>${randomstring}</code></p>`;

    await sendEmail({
        to: account.email,
        subject: 'Mentoir - Reset Password',
        html: `<h4>Reset Password Email</h4>
               ${message}`
    });
}

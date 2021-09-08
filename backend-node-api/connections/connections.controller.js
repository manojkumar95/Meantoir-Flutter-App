const express = require('express');
const router = express.Router();
const Joi = require('joi');
const { connection } = require('mongoose');
const connectionsService = require('./connections.service');

router.post('/sendRequest/:mentor_id/:mentee_id', sendConnectionRequest);
router.delete('/cancelRequest/:mentor_id/:mentee_id', cancelConnectionRequest);
router.put('/acceptRequest/:mentor_id/:mentee_id', acceptConnectionRequest);
router.get('/pendingRequest/:mentor_id', pendingconnections);
router.get('/connectedMenteeList/:mentor_id', MentorList);
router.get('/connectedMentorList/:mentee_id', MenteeList);

function pendingconnections(req,res,next){
    console.log('responseujoi9l;-[9');
    connectionsService.pendingconnections(req.params.mentor_id)
    .then((connection) => {
        res.json(connection)})
        .catch(next);
}

function sendConnectionRequest(req,res,next){
    console.log('request sending');
    connectionsService.sendRequest(req.params.mentor_id,req.params.mentee_id)
    .then(() => res.json({ message: 'Request Sent successful' }))
        .catch(next);
    console.log('request sent');
}

function cancelConnectionRequest(req,res,next){
    connectionsService.cancelRequest(req.params.mentor_id,req.params.mentee_id)
    .then(() => res.json({ message: 'Request cancelled' }))
        .catch(next);
    
}

function acceptConnectionRequest(req,res,next){
    connectionsService.acceptRequest(req.params.mentor_id,req.params.mentee_id)
    .then(() => res.json({ message: 'Request accepted' }))
        .catch(next);
    
}

function MenteeList(req,res,next){
    connectionsService.connectedMentorList(req.params.mentee_id)
    .then((connection) => {
        res.json(connection)})
        .catch(next);
    
}
function MentorList(req,res,next){
    connectionsService.connectedMenteeList(req.params.mentor_id)
    .then((connection) => {
        res.json(connection)})
        .catch(next);
    
}

module.exports = router;

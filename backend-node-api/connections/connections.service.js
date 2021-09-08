const db = require('_helpers/db');

module.exports = {
    sendRequest,
    cancelRequest,
    acceptRequest,
    connectedMentorList,
    connectedMenteeList,
    pendingconnections
}

async function sendRequest( mentor_id, mentee_id ) {
    
    const connection = new db.Connections();
    connection.relationKey=mentor_id+mentee_id;
    console.log('id',connection.relationKey)
    connection.mentee_id = mentee_id;
    connection.mentor_id = mentor_id;
    connection.isPending = true;
    connection.isCancelled = false;
    connection.isAccepted = false;

    console.log('connection', connection)
    await connection.save();
    
}


async function cancelRequest(mentor_id, mentee_id){

    const connection = await db.Connections.findOneAndDelete({relationKey:mentor_id.concat(mentee_id)});
    
    

    // console.log('connection', connection)
    // await connection.save();

}

async function acceptRequest(mentor_id, mentee_id){

    const connection = await db.Connections.findOne({relationKey:mentor_id.concat(mentee_id)});
    
    connection.isPending = false;
    connection.isCancelled = false;
    connection.isAccepted = true;
    

    console.log('connection', connection)
    await connection.save();

}

async function connectedMentorList(mentee_id){

    const connection = await db.Connections.find({mentee_id:mentee_id,isAccepted:true}).populate('mentor_id');
    
    console.log('connectionList', connection);
    if (!connection) connection = []

    return {
        connection
    };

}

async function connectedMenteeList(mentor_id){

    let connection = await db.Connections.find({mentor_id:mentor_id,isAccepted:true}).populate('mentee_id');
    console.log('connectionList', connection);
    if (!connection) connection = []
    return {
        connection
    };


}

async function pendingconnections(mentor_id) {
    let connection = await db.Connections.find({mentor_id:mentor_id,isPending:true}).populate('mentee_id')
    console.log('connectionList', connection);
    if (!connection) connection = []
    return {
        connection
    };
    
}
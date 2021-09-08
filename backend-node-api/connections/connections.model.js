const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    // connection_id: { type: String, unique: true },
    mentor_id:{type: Schema.Types.ObjectId, ref: 'Account'},
    mentee_id:{type: Schema.Types.ObjectId, ref: 'Account'},
    relationKey:{type:String, unique:true },
    isPending:{type:Boolean},
    isCancelled:{type:Boolean},
    isAccepted:{type:Boolean}
    
});


module.exports=mongoose.model('Connections', schema);
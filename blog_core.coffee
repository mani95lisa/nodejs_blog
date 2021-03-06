mongoose = require('mongoose')
crypto = require('crypto')
config = require('./config')

db = mongoose.createConnection(config.dbUrl)
exports.config = config
exports.db = db
exports.ObjectId = (id) ->
	new mongoose.Types.ObjectId(id)

userSchema = mongoose.Schema({ 
	username: {
		type: String,
		index: {unique: true}
	},
	password: String, 
	email: {
		type: String,
		index: {unique: true}
	},
	admin: Boolean 
})

postSchema = mongoose.Schema({ 
	urlid: {
		type: String,
		index: {unique: true}
		},
	title: String, 
	body: String,
	tags: String,
	date: Date 
})

messageSchema = mongoose.Schema({ 
	name: String,
	email: String, 
	body: String,
	date: Date 
})

User = db.model('User', userSchema)
Post = db.model('Post', postSchema)
Message = db.model('Message', messageSchema)

exports.Post = Post
exports.User = User
exports.Message = Message

User.find({username: 'admin'}, (err, users) ->
	if(!err && users.length == 0)
		pass_crypted = crypto.createHmac("md5", config.crypto_key).update('admin123').digest("hex")
		gui = new User({ 
			username: 'admin', 
			password: pass_crypted, 
			email: 'admin@admin.com',
			admin: true
		})
		gui.save((err) ->
			if(err)
				console.log('Error when try to save admin user')
		)
)

#UTILS
exports.TrimStr = (str) ->
	return str.replace(/^\s+|\s+$/g,"")

exports.doDashes = (str) ->
	return str.replace(/[^a-z0-9]+/gi, '-').replace(/^-*|-*$/g, '').toLowerCase();

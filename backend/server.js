const express = require('express')
const jwt = require('jsonwebtoken')
const fs = require('fs')
const bcrypt = require('bcrypt')

const app = express()
app.use(express.json())

const PRIVATE_KEY = process.env.JWT_SECRET

const users = require('/app/users.json')

app.post('/auth/login', async (req, res) => {
	const { username, password } = req.body
	
	console.log("Login Attempt for " + username)

	const user = users[username]
	if (!user) {
		console.log("failed, 401")
		return res.status(401).json({ error: 'Invalid credentials' })
	}
	
	const valid = await bcrypt.compare(password, user.passwordHash)
	if (!valid) {
		console.log("failed, 401")
		return res.status(401).json({ error: 'Invalid credentials' })
	}
	
	const token = jwt.sign(
		{ sub: 'pits_crew' },
		PRIVATE_KEY,
		{
			algorithm: 'HS256',
			expiresIn: '5m',
			issuer: 'mqtt-backend',
		}
	)
	console.log("success, token sent")
	res.json({ token })
})

app.post('/auth/verify', async (req, res) => {
	try {
		const { username } = req.body

		console.log("Verification initiated")

		if (!username) {
			console.log('Failed, missing token')
			return res.status(403).send('DENY')
		}

		const token = username

		const decoded = jwt.verify(token, PRIVATE_KEY, {
			algorithms: ['HS256']
		})
		
		console.log('Success, user ' + decoded.sub)
		return res.status(200).json({
			username: decoded.sub,
			superuser: false
		})
	} catch (err) {
		console.log('Failed, bad auth')
		return res.status(403).send('DENY')
	}

})

app.post('/auth/acl', async (req, res) => {
	try {
		const { username, topic, acc } = req.body

		// Dummy route to fullfill auth plugin requirements, doesn't actually validate any acl stuff

		return res.status(200).send('OK')
	} catch (err) {
		return res.status(403).send('DENY')
	}
})

app.listen(3000, () => {
	console.log('Auth service running on port 3000')
})
